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

# OpenForge

The OpenForge Community is composed of team members and public contributors banded together for a common goal of leading by example.  We are experts in applying UI/UX and Software Architecture principles towards enhancing businesses nation (and world!) wide.

In addition to providing services for our clients; it is our belief that we should also focus on benefiting the community that surrounds us. For this reason; all OpenForge initiatives (that are not client related) are Open Sourced; including our design and business consulting resources which can be found on our Website at [www.openforge.io](http://openforge.io). 

If you are a community member who would like to take part of our paid (yes, we said PAID!) Open Source contributions please reach out to us via our [opportunities page](http://www.openforge.io/opportunities).   We also always encourage anyone to contribute to anything we are doing, and we hope to contribute to your projects as well!

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
