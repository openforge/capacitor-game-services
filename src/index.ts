import { registerPlugin } from '@capacitor/core';

import { GameServices } from './definitions';

const GameServices = registerPlugin<GameServices>('GameServices', {
  web: () => import('./web').then((m) => new m.GameServicesWeb()),
});

export * from './definitions';
export { GameServices };
