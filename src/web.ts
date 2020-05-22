import { WebPlugin } from '@capacitor/core';
import { GameServicesPlugin } from './definitions';

export class GameServicesWeb extends WebPlugin implements GameServicesPlugin {
  constructor() {
    super({
      name: 'GameServices',
      platforms: ['web']
    });
  }

  signIn(): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  signOut(): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  showLeaderboard(_: { leaderboardId: string; }): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  submitScore(_: {
    leaderboardId: string;
    score: number;
  }): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  showAchievements(): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  unlockAchievement(_: {
    achievementId: string;
  }): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  progressAchievement(_: {
    achievementId: string; percentComplete: number;
  }): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  resetAllAchievementProgress(): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
  revealAchievement(): Promise<any> {
    console.warn('GameServices does not have web implementation.');
    return Promise.resolve();
  }
}

const GameServices = new GameServicesWeb();

export { GameServices };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(GameServices);
