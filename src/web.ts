import { WebPlugin } from '@capacitor/core';

import type { CapacitorGameConnectPlugin } from './definitions';

export class CapacitorGameConnectWeb
  extends WebPlugin
  implements CapacitorGameConnectPlugin
{
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
