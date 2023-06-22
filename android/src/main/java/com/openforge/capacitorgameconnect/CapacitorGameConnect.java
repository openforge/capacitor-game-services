package com.openforge.capacitorgameconnect;

import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;

import com.getcapacitor.PluginCall;
import com.google.android.gms.games.GamesSignInClient;
import com.google.android.gms.games.PlayGames;

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

        gamesSignInClient.isAuthenticated().addOnCompleteListener(isAuthenticatedTask -> {
            boolean isAuthenticated =
                    (isAuthenticatedTask.isSuccessful() &&
                            isAuthenticatedTask.getResult().isAuthenticated());

            if (isAuthenticated) {
                Log.i(TAG, "User is already authenticated");
                call.resolve();
            } else {
                gamesSignInClient.signIn().addOnCompleteListener(data -> {
                   Log.i(TAG, "Sign-in completed successful");
                    call.resolve();
                });
            }
        });
    }
}
