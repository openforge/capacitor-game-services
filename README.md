<p align="center">
  <img src="https://github.com/openforge/main-website/blob/master/src/assets/logo-openforge.png?raw=true"/>
</p>
<p align="center">
  <a href="http://www.openforge.io/">Official Website</a> |
  <a href="http://www.openforge.io/opportunities">Opportunities</a> |
  <a href="https://www.facebook.com/openforgemobile/">Facebook</a>
</p>

<h3 align="center">
  Leading By Example.
</h3>

<p align="center">
  Working with the latest technologies, designing the best products, and sharing our knowledge with the world wide community.
</p>

# Introduction
Capacitor plugin for connecting and using services by Apple Game Center and Google Play Game Services. Features included are access to Sign-In, Leaderboard, and Achievements.

---

| Capacitor Version | Support Status |
| ----------- | :----: |
| Capacitor v5   | 🚧       |
| Capacitor v4   | ✅       |
| Capacitor v3   | ✅       |
| Capacitor v2   | 🚧       |
| Capacitor v1   | 🚧       |


✅ - Supported
🚧 - WIP Support
❌ - No plans to support

## Maintainers

| Maintainer | Github |
| ---------- | :----: |
| Ricardo   | @Ricardo385 |


## Example Projects
Checkout these existing Ionic/Angular/Capacitor mobile game with the plugin installed and integrated:
- [Rock The Steps](https://github.com/openforge/rock-the-steps-app)
- [OpenFarm](https://github.com/openforge/openfarm-puzzle-game)


# Getting Started

## Installation
```bash
npm install capacitor-game-connect
npx cap sync
```
## Required Accounts

1. Google Play Developer Account
2. Apple Developer Account

## Setup On Google Play Services

1. Go to [Google Play Console](https://play.google.com/apps/publish).
2. Click 'New Game' button and fill out name and category fields.
3. Click Linked Apps tab in side-menu, then click the Android button.
4. Enter your appId, this will be found in your capacitor.config.json file.
5. Click 'Save and Continue', then click "Authorize Your App Now" button.
6. Enter your sha-1 and confirm.
7. In your native android project, add your app id string to your strings xml file.
    - Your strings xml file can be found in android/app/src/main/res/values/strings.xml
8. Go to Testing tab and a add test account.
9. Add the plugin to main activity after running npx cap sync

## Setup On Apple Game Services

1. Click on Target App in xcode
2. Add team to Signing and Capabilities
3. Add Game Center Capability
4. Go to your Apps in https://appstoreconnect.apple.com/ and add your application
5. Go to features, add leaderboard matching the generated id from google

## Additional Code Setup

In order to use the plugin, you need to make sure to include these meta tag tags in the main manifest this steps:

```xml
<meta-data android:name="com.google.android.gms.games.APP_ID" android:value="@string/app_id" />
<meta-data android:name="com.google.android.gms.version" android:value="@integer/google_play_services_version"/>
```

- Add on build gradle (app):

```any
implementation 'com.google.android.gms:play-services-auth:17.0.0'
implementation 'com.google.android.gms:play-services-games:19.0.0'
```

- On the Main Activy add:

```android
import io.openforge.gameservices.GameServices;
...
add(GameServices.class);
...
```

## Creating Achievements
- [Configure Achievements on AppStoreConnect](https://developer.apple.com/help/app-store-connect/configure-game-center/configure-achievements/)
- [Creating Achievements on Google Play Developer Console](https://developers.google.com/games/services/common/concepts/achievements#creating_an_achievement)

## Creating Leaderboard
- [Creating Classic or Recurring Leaderboard on AppStoreConnect](https://developer.apple.com/help/app-store-connect/configure-game-center/configure-leaderboards/)
- [Creating Leaderboard on Google Play Developer Console](https://developers.google.com/games/services/common/concepts/leaderboards#create_a_leaderboard)

## Recommendation When Adding Leaderboards and Achievements

When adding resouces to Google and Apple Services, we would recommend you add resources to Google Play Services first and then reuse the ID values generated for resources in Apples Game Center service, that way you wont need two sets of resource IDs.

# API

| Method                           | Description                                          |
| -------------------------------- | ---------------------------------------------------- |
| signIn                           | Method to sign in a user to Game Services            |
| showLeaderboard                  | Method to open Leaderboard view from Game Services   |
| showAchievements                 | Method to open Achievements view from Game Services  |
| submitScore                      | Method to submit a score to the leaderboards table   |
| unlockAchievement                | Method to submit a score to the leaderboards table   |
| progressAchievement              | Method to set some progress to an achievement        |
| resetAllAchievementProgress      | Method to set some reset all achievements            |

<docgen-index>

* [`echo(...)`](#echo)
* [`signIn()`](#signin)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### signIn()

```typescript
signIn() => Promise<void>
```

--------------------

</docgen-api>

# Testing Limitations

### Android
In order to fully test the integrated functionality it is required to have a physical Android device. Trying to connect to these specific Google Play Services through Android Studio Emulator/Simulator will not work.

## Contribution Guidelines
Coming Soon
