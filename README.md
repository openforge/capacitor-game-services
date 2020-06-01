## Required

1. Google Developer Account
2. Apple Developer Account

## Setting up Google Play Services

1. Go to [Google Play Console](https://play.google.com/apps/publish).
2. Click New Game button and fill out name and category fields.
3. Click Linked apps tab in side menu, and click the Android button.
4. Enter your appId, should be found in your capacitor.config.json file.
5. Click Save and Continue, then click "authorize your app now" button.
6. Enter your sha-1 and confirm
7. [Add manifest configuration](https://developers.google.com/games/services/android/quickstart#step_3_modify_your_code)
   TODO: add to plugin instead?
8. Go to testing tab and add test account.
9. Go to leaderboards and add a leaderboard, copying the id value.
10. Add the plugin to main activity after running npx cap sync

## Setting up Apple Game Services

1. Click on target app in xcode
2. Add team to signing and capabilities
3. Add game center capability
4. https://appstoreconnect.apple.com/
5. add app, probably should use bundle id as sku
6. go to features, add leaderboard matching the generated id from google
