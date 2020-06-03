package io.openforge.gameservices;

import android.content.Intent;
import android.util.Log;
import android.webkit.WebView;

import com.getcapacitor.JSObject;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.auth.api.signin.GoogleSignIn;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInClient;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesClient;
import com.google.android.gms.tasks.Task;

/**
 * GameServices plugin
 */
@NativePlugin(requestCodes = { GameServices.RC_SIGN_IN, GameServices.RC_LEADERBOARD_UI,
        GameServices.RC_ACHIEVEMENT_UI })
public class GameServices extends Plugin {
    static final int RC_SIGN_IN = 1;
    static final int RC_LEADERBOARD_UI = 9004;
    static final int RC_ACHIEVEMENT_UI = 9003;

    private String TAG = "GameServices";
    private GoogleSignInOptions mGoogleSignInOptions;

    // MARK: Plugin Overrides
    @Override
    public void load() {
        super.load();
        Log.d(TAG, "lifecycle load called");

        mGoogleSignInOptions = new GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_GAMES_SIGN_IN).build();
    }

    @Override
    protected void handleOnActivityResult(int requestCode, int resultCode, Intent data) {
        super.handleOnActivityResult(requestCode, resultCode, data);
        Log.d(TAG, "handleOnActivityResult called");

        PluginCall savedCall = getSavedCall();

        if (requestCode == RC_SIGN_IN) {
            Log.d(TAG, "starting handler for rc sign in");
            GoogleSignInResult result = Auth.GoogleSignInApi.getSignInResultFromIntent(data);
            if (result.isSuccess()) {
                GoogleSignInAccount signInAccount = result.getSignInAccount();
                this.registerPopupView(signInAccount);
                savedCall.resolve();
            } else {
                String message = result.getStatus().getStatusMessage();
                if (message == null || message.isEmpty()) {
                    message = "Some Other Error....";
                }
                Log.e(TAG, "signInWithIntent:failure " + message);
                if (savedCall != null) {
                    savedCall.reject(message);
                }

            }
        }
    }

    // MARK: Plugin Methods
    @PluginMethod()
    public void signIn(PluginCall call) {
        saveCall(call);
        startSilentSignIn();
    }

    @PluginMethod()
    public void signOut(PluginCall call) {
        GoogleSignInClient signInClient = GoogleSignIn.getClient(getContext(), mGoogleSignInOptions);
        signInClient.signOut().addOnCompleteListener(getActivity(), task -> {
            if (task.isSuccessful()) {
                call.resolve(new JSObject().put("response", "signOut:success"));
            } else {
                call.reject("signOut:error");
            }
        });
    }

    /**
     * TODO: if no leaderboardId (show ios default leaderboard if set, show android
     * all leaderboards)
     * 
     * @param call
     */
    @PluginMethod()
    public void showLeaderboard(PluginCall call) {
        String leaderboardId = call.getString("leaderboardId");
        if (leaderboardId == null) {
            Log.w(TAG, "showLeaderboard called without providing leaderboardId");
            return;
        }
        Log.d(TAG, "showLeaderboard called with id: " + leaderboardId);

        GoogleSignInAccount mGoogleSignInAccount = GoogleSignIn.getLastSignedInAccount(getContext());
        Games.getLeaderboardsClient(getContext(), mGoogleSignInAccount).getLeaderboardIntent(leaderboardId)
                .addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        Log.d(TAG, "showLeaderboard:getIntent:success");
                        saveCall(call);
                        startActivityForResult(call, task.getResult(), RC_LEADERBOARD_UI);
                    } else {
                        Log.e(TAG, "showLeaderboard:getIntent:error");
                        call.reject("showLeaderboard:getIntent:error");
                    }
                });
    }

    /**
     * TODO: test and handle/throw errors for non integer values passed to score,
     * not to mention, score can be non-integer values depending on game store and
     * leaderboard settings.
     * 
     * @param call
     */
    @PluginMethod()
    public void submitScore(PluginCall call) {
        String leaderboardId = call.getString("leaderboardId", "");
        int score = call.getInt("score", 0);
        Log.d(TAG, String.format("submitScore:leaderboardId:%s:score:%d", leaderboardId, score));

        Games.getLeaderboardsClient(getContext(), GoogleSignIn.getLastSignedInAccount(getContext()))
                .submitScoreImmediate(leaderboardId, score).addOnSuccessListener(scoreSubmissionData -> {
                    Log.d(TAG, "submitScore:success");
                    call.resolve(new JSObject().put("result", "submitScore:success"));
                }).addOnFailureListener(error -> {
                    Log.e(TAG, String.format("submitScore:error:%s", error.getMessage()));
                    call.reject(String.format("submitScore:error:%s", error.getMessage()));
                });
    }

    @PluginMethod()
    public void showAchievements(PluginCall call) {
        Log.d(TAG, "showAchievements:called");

        Games.getAchievementsClient(getContext(), GoogleSignIn.getLastSignedInAccount(getContext()))
                .getAchievementsIntent().addOnSuccessListener(intent -> {
                    saveCall(call);
                    Log.d(TAG, "showAchievements:success");
                    startActivityForResult(call, intent, RC_ACHIEVEMENT_UI);
                }).addOnFailureListener(error -> {
                    Log.e(TAG, "showAchievements:error:" + error.getMessage());
                    call.reject("showAchievements:error:" + error.getMessage());
                });
    }

    /**
     * Fails when trying to unlock a incremental achievement TODO: needs to respond
     * to all available errors in error responses
     * 
     * @param call
     */
    @PluginMethod()
    public void unlockAchievement(PluginCall call) {
        String achievementId = call.getString("achievementId", "");
        Log.d(TAG, String.format("unlockAchievement:%s", achievementId));

        Games.getAchievementsClient(getContext(), GoogleSignIn.getLastSignedInAccount(getContext()))
                .unlockImmediate(achievementId).addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        Log.d(TAG, "unlockAchievement:success");
                        call.resolve(new JSObject().put("response", "unlockAchievement:success"));
                    } else {
                        Log.e(TAG, "unlockAchievement:failure" + task.getException());
                        call.reject("unlockAchievement:failure");
                    }
                });
    }

    @PluginMethod()
    public void progressAchievement(PluginCall call) {
        String achievementId = call.getString("achievementId");
        if (achievementId == null) {
            call.reject("progressAchievement:error: achievementId not provided");
            return;
        }
        // TODO: does this need error handling when a number that looks like an integer
        // is passed, how
        // does capacitor number conversion work here?
        double percentComplete = call.getDouble("achievementId", 100.0);
        int stepsComplete = (int) Math.floor(percentComplete);
        Log.d(TAG, String.format("progressAchievement:%s:percentage:%s", achievementId, stepsComplete));

        // TODO: do math to get desired increment
        Games.getAchievementsClient(getContext(), GoogleSignIn.getLastSignedInAccount(getContext()))
                .setStepsImmediate(achievementId, stepsComplete).addOnCompleteListener(task -> {
                    if (task.isSuccessful()) {
                        String successMessage = task.getResult() ? "progressAchievement:success:unlocked"
                                : "progressAchievement:success";
                        Log.d(TAG, successMessage);
                        call.resolve(new JSObject().put("result", successMessage));
                    } else {
                        Log.e(TAG, "progressAchievement:error" + task.getException().getMessage());
                        call.reject("progressAchievement:error");
                    }
                });
    }

    @PluginMethod()
    public void resetAllAchievementProgress(PluginCall call) {
        Log.w(TAG, "iOS only method, reset achievements in play services console for Android.");
        call.resolve();
    }

    // MARK: Private Methods

    private void startSilentSignIn() {
        GoogleSignInOptions signInOptions = mGoogleSignInOptions;
        GoogleSignInClient signInClient = GoogleSignIn.getClient(getContext(), signInOptions);
        PluginCall savedCall = getSavedCall();

        signInClient.silentSignIn().addOnCompleteListener(getActivity(), (Task<GoogleSignInAccount> task) -> {
            if (task.isSuccessful()) {
                GoogleSignInAccount signedInAccount = task.getResult();
                this.registerPopupView(signedInAccount);
                savedCall.resolve();
            } else {
                startSignInIntent();
            }
        });

    }

    private void startSignInIntent() {
        Log.d(TAG, "startSignInIntent:called");
        GoogleSignInClient signInClient = GoogleSignIn.getClient(getContext(), mGoogleSignInOptions);
        Intent intent = signInClient.getSignInIntent();
        startActivityForResult(null, intent, RC_SIGN_IN);
    }

    private void registerPopupView(GoogleSignInAccount signInAccount) {
        GamesClient gamesClient = Games.getGamesClient(this.getContext(), signInAccount);
        WebView webView = this.getBridge().getWebView();
        gamesClient.setViewForPopups(webView);
    }
}