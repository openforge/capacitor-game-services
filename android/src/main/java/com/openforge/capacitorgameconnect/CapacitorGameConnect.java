package com.openforge.capacitorgameconnect;

import android.content.Intent;
import android.util.Log;
import androidx.activity.result.ActivityResultLauncher;
import androidx.appcompat.app.AppCompatActivity;
import com.getcapacitor.PluginCall;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;
import com.google.android.gms.tasks.OnSuccessListener;

public class CapacitorGameConnect {

    private AppCompatActivity activity;
    private static final String TAG = "CapacitorGameConnect";

    public CapacitorGameConnect(AppCompatActivity activity) {
        this.activity = activity;
    }

    /**
     * * Method to sign-in a user to Google Play Services
     *
     * @param call as PluginCall
     */
    public void signIn(PluginCall call) {
        Log.i(TAG, "SignIn method called");
        GamesSignInClient gamesSignInClient = PlayGames.getGamesSignInClient(this.activity);

        gamesSignInClient
            .isAuthenticated()
            .addOnCompleteListener(
                isAuthenticatedTask -> {
                    boolean isAuthenticated = (isAuthenticatedTask.isSuccessful() && isAuthenticatedTask.getResult().isAuthenticated());

                    if (isAuthenticated) {
                        Log.i(TAG, "User is already authenticated");
                        call.resolve();
                    } else {
                        gamesSignInClient
                            .signIn()
                            .addOnCompleteListener(
                                data -> {
                                    Log.i(TAG, "Sign-in completed successful");
                                    call.resolve();
                                }
                            );
                    }
                }
            );
    }

    /**
     * * Method to display the Leaderboards view from Google Play Services SDK
     *
     * @param call as PluginCall
     * @param startActivityIntent as ActivityResultLauncher<Intent>
     */
    public void showLeaderboard(PluginCall call, ActivityResultLauncher<Intent> startActivityIntent) {
        Log.i(TAG, "showLeaderboard " + call.getString("leaderboardID"));
        PlayGames
            .getLeaderboardsClient(this.activity)
            .getLeaderboardIntent("CgkI_b7OpKUXEAIQAA")
            .addOnSuccessListener(
                new OnSuccessListener<Intent>() {
                    @Override
                    public void onSuccess(Intent intent) {
                        startActivityIntent.launch(intent);
                    }
                }
            );
    }

    /**
     * * Method to submit a score to the Google Play Services SDK
     *
     * @param call as PluginCall
     */
    public void submitScore(PluginCall call) {
        Log.i(TAG, "submitScore has been called");
        PlayGames.getLeaderboardsClient(this.activity).submitScore("CgkI_b7OpKUXEAIQAA", 1000);
    }

    /**
     * * Method to display the Achievements view from Google Play SDK
     *
     * @param startActivityIntent as ActivityResultLauncher<Intent>
     */
    public void showAchievements(ActivityResultLauncher<Intent> startActivityIntent) {
        Log.i(TAG, "showAchievements has been called");
        PlayGames
            .getAchievementsClient(this.activity)
            .getAchievementsIntent()
            .addOnSuccessListener(
                new OnSuccessListener<Intent>() {
                    @Override
                    public void onSuccess(Intent intent) {
                        startActivityIntent.launch(intent);
                    }
                }
            );
    }
}
