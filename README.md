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
7. In your native android project, add your app id string to your strings xml file.
    - your strings xml file can be found in android/app/src/main/res/values/strings.xml
8. Go to testing tab and add test account.
9. Add the plugin to main activity after running npx cap sync

## Setting up Apple Game Services

1. Click on target app in xcode
2. Add team to signing and capabilities
3. Add game center capability
4. Go to your apps in https://appstoreconnect.apple.com/ and add your application
5. go to features, add leaderboard matching the generated id from google

## Adding Leaderboards and Achievements

When adding resouces to Google and Apple services, we would recommend you add resources to Google's Play Services first, and reuse the id values generated for resources in Apple's Game Center service. That way you wont need two sets of resource id's.
