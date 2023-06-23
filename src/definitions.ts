export interface CapacitorGameConnectPlugin {
  /**
   * * Method to sign-in a user
   *
   *
   */
  signIn(): Promise<void>;

  /**
   * * Method to display the Leaderboards
   * 
   * @param leaderboardID as string
   */
  showLeaderboard(leaderboardID: string): Promise<void>;

  /**
   * * Method to submit a score to the Google Play Services SDK
   * 
   */
  submitScore(): Promise<void>;

  /**
   * * Method to display the Achievements view
   * 
   */
  showAchievements(): Promise<void>;

  /**
   * * Method to unlock an achievement
   * 
   */
  unlockAchievement(): Promise<void>;
}
