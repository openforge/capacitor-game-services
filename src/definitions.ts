export interface CapacitorGameConnectPlugin {
  /**
   * * Method to sign-in a user to Google Play Services
   *
   *
   */
  signIn(): Promise<void>;
}
