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
* [`submitScore()`](#submitscore)
* [`showAchievements()`](#showachievements)
* [`unlockAchievement()`](#unlockachievement)
* [`incrementAchievementProgress()`](#incrementachievementprogress)

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
showLeaderboard(leaderboardID: string) => Promise<void>
```

* Method to display the Leaderboards

| Param               | Type                | Description |
| ------------------- | ------------------- | ----------- |
| **`leaderboardID`** | <code>string</code> | as string   |

--------------------


### submitScore()

```typescript
submitScore() => Promise<void>
```

* Method to submit a score to the Google Play Services SDK

--------------------


### showAchievements()

```typescript
showAchievements() => Promise<void>
```

* Method to display the Achievements view

--------------------


### unlockAchievement()

```typescript
unlockAchievement() => Promise<void>
```

* Method to unlock an achievement

--------------------


### incrementAchievementProgress()

```typescript
incrementAchievementProgress() => Promise<void>
```

* Method to increment the progress of an achievement

--------------------

</docgen-api>
