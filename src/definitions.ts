export interface CapacitorGameConnectPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;

  signIn(): Promise<void>;
}
