## Setup for Android
Follow this guide to configure correctly your Google Play Console to be able to use the Capacitor Game Connect plugin:

1. Go to your [Google Play Console](https://play.google.com/console)
2. If you don't have an app created, create one as a Game.
3. Go to Play Games Services under Grow section.
    * Cick Configuration
    * Select the option 'No, my game doesn’t use Google APIs', set a name and click Create.
4. Let's create a OAuth consent screen in Google Cloud Platform:
    * Go to your [Google Cloud Platform](https://console.cloud.google.com/). Make sure you have selected the correct app you want to create the OAuth consent screen.
    * Go to APIs & Services section, then in the sidebar click on OAuth consent screen
    * Choose your User Type (External or Internal) and click Create.
    * Fill the App Informationn required filds and then click on Save and Continue button at the bottom.
    * On the Scopes tab, click on Add or remove scopes and in the Search box type the following:
        * `auth/games` and click enter.
        * Select the two options that appears. `.../auth/games` and `./auth/games_lite`
        * Then start a new search and type `drive.appdata` and select the option showed.
        * Click the Update button.
        * Click Save and Continue button at the bottom.
    * Let's add your Test Users. ** This will be super important because your Google Play Services will only work with these users while is not into Production
        * Click Add Users button and type your users email.
        * Click Add.
        * Click Save and Continue button.
    * And that's all! Click on Back to Dashboard button and then click on Publish App button to finish creating your OAuth consent screen.
    * If you want to modify you information there, simple click on Back To Testing button and then click on Edit App at the top.
5. Back to your Google Play Console
6. In the Credentials section, click on Add Credential
    * Select the Type "Android"
    * Fill the other options
    * On the Authorization section, click Create OAuth client.
        * In the Popup that has been displayed, click on the `Create OAuth Client ID` link attached. This will be open a new window redirecting to the Google Cloud Platform Credentials section.
        * Select the Application Type. Should be Android.
        * Name your OAuth 2.0 client
        * Type your package name of your application.
        * Run the following command in your terminal:
            * `keytool -keystore path-to-debug-or-production-keystore -list -v`
            * If you don't have your keystore created yet, you can follow [this link](https://developer.android.com/studio/publish/app-signing#generate-key) to create it.
            * Once you get your SHA-1 certificate fingerprint, copy and paste it into the required field.
            * Click Create and then back to your Google Play Console.
    * Now that you have completed created your Credential ID, click in the dropdown option and select the one you have created.
    * Click Save Changes button at the bottom.
7. Back to your configurations and click Review and Publish button at the top.
    * Review if there are Actions Required to complete and fill them.

## Creating Achievements on Android
Before use the `Achievement Methods` of the plugin, you need to setup your Achievements in your Google Play Console following the next steps:

# capacitor-game-connect

A native capacitor plugin to connect to Game Services for iOS and Android

## Install

```bash
npm install capacitor-game-connect
npx cap sync
```

## API

<docgen-index>

* [`signIn()`](#signin)
* [`showLeaderboard(...)`](#showleaderboard)
* [`submitScore(...)`](#submitscore)
* [`showAchievements()`](#showachievements)
* [`unlockAchievement(...)`](#unlockachievement)
* [`incrementAchievementProgress(...)`](#incrementachievementprogress)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### signIn()

```typescript
signIn() => Promise<void>
```

* Method to sign-in a user

--------------------


### showLeaderboard(...)

```typescript
showLeaderboard(options: { leaderboardID: string; }) => Promise<void>
```

* Method to display the Leaderboards

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ leaderboardID: string; }</code> |

--------------------


### submitScore(...)

```typescript
submitScore(options: { leaderboardID: string; totalScoreAmount: number; }) => Promise<void>
```

* Method to submit a score to the Google Play Services SDK

| Param         | Type                                                              |
| ------------- | ----------------------------------------------------------------- |
| **`options`** | <code>{ leaderboardID: string; totalScoreAmount: number; }</code> |

--------------------


### showAchievements()

```typescript
showAchievements() => Promise<void>
```

* Method to display the Achievements view

--------------------


### unlockAchievement(...)

```typescript
unlockAchievement(options: { achievementID: string; }) => Promise<void>
```

* Method to unlock an achievement

| Param         | Type                                    |
| ------------- | --------------------------------------- |
| **`options`** | <code>{ achievementID: string; }</code> |

--------------------


### incrementAchievementProgress(...)

```typescript
incrementAchievementProgress(options: { achievementID: string; pointsToIncrement: number; }) => Promise<void>
```

* Method to increment the progress of an achievement

| Param         | Type                                                               |
| ------------- | ------------------------------------------------------------------ |
| **`options`** | <code>{ achievementID: string; pointsToIncrement: number; }</code> |

--------------------

</docgen-api>
