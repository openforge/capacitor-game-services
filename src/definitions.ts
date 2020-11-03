declare module "@capacitor/core" {
  interface PluginRegistry {
    GameServices: GameServicesPlugin;
  }
}

export interface GameServicesPlugin {
  signIn(): Promise<{
    response: {
      player_name: any,
      player_id: any,
      error?: any
    }
  }>;
  signOut(): Promise<any>;
  showLeaderboard(options: { leaderboardId: string }): Promise<any>;
  submitScore(options: {
    leaderboardId: string,
    /**
     * expects type integer, TODO: math floor in ios and android plugins
     * what does getInt do in capacitor plugin if a double or other is supplied
     */
    score: number
  }): Promise<any>;

  showAchievements(): Promise<any>;


  /**
   * Unlock Achievement
   */
  unlockAchievement(options: {
    /**
     * The id of the achievement to unlock.
     */
    achievementId: string;
  }): Promise<any>;
  /**
   * Can only increment achievements across platforms with percentages!
   * set number of steps to maximum in playstore and make 100.00 and 10,000/100 equivalent
   * the native ui only shows percentages on android, so any percentages need to be calculated
   * before passing that result to incrementAchievement
   * would be able to go backwards on ios, but difficult to go backwards on android, would require a reset
   */
  progressAchievement(options: {
    achievementId: string;
    percentComplete: number; // double between 0 and 100?
  }): Promise<any>;

  /**
   * reset achievement
   * debugging use case primarily
   */
  resetAllAchievementProgress(): Promise<any>;

  /**
   * Reveal an achievement if its hidden, should only hide achievements with spoilers, refer to google guide for achievements.
   */
  revealAchievement(): Promise<any>;
}
