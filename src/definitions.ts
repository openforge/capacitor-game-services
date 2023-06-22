export interface CapacitorGameConnectPlugin {
  /**
   * * Method to sign-in a user to Google Play Services
   *
   *
   */
  signIn(): Promise<void>;

  /**
   * * Method to display the Leaderboards view from Google Play Services SDK
   * 
   * @param leaderboardID as string
   */
  showLeaderboard(leaderboardID: string): Promise<void>;
}
