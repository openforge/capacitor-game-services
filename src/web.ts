import { WebPlugin } from '@capacitor/core';

import type { CapacitorGameConnectPlugin } from './definitions';

export class CapacitorGameConnectWeb
  extends WebPlugin
  implements CapacitorGameConnectPlugin
{
  /**
   * * Method to sign-in a user to Google Play Services
   *
   */
  async signIn(): Promise<void> {
    return Promise.resolve();
  }

  /**
   * Method to display the Leaderboards view from Google Play Services SDK
   *
   * @param leaderboardID as string
   */
  async showLeaderboard(leaderboardID: string): Promise<void> {
    console.info(
      'showLeaderboard function has started with ID: ',
      leaderboardID,
    );
    return Promise.resolve();
  }

  /**
   * * Method to submit a score to the Google Play Services SDK
   *
   * @returns Promise
   */
  async submitScore(): Promise<void> {
    return Promise.resolve();
  }

  /**
   * * Method to display the Achievements view from Google Play SDK
   *
   * @returns Promise
   */
  async showAchievements(): Promise<void> {
    return Promise.resolve();
  }
}
