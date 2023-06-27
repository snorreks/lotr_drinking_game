# Drinking Game designed around LotR

Based upon [this article](https://psycatgames.com/magazine/party-games/the-lord-of-the-rings/) by [PsyCat Games](https://psycatgames.com/), the team created the idea of having an application which would allow every player to pick a character, and manage their rules along with the rules available for everyone. Developed in Flutter so it can be available for everyone 😼

## Use it now

You can already access the application [here](https://lotr-drinking-game.web.app/). Create a session and invite your friends to join.

## Features

*   Unique character for each player
*   Navigation of rules
*   Compare how much you have had to drink with the rest of the group
*   Call-out players for ignoring rules!
*   idk more soon

### Coming features

*   Blood-alcohol percentage calculator (based on standard ABV of 4.7%)
*   Rules modifications
*   Admin rights
*   Regular "status" check-ups & other Safety features
*   Create your own drinking game!

## Build and host it yourself (?)

Fork this and make it work homie, we used firebase and it sure as hell is working well.

## DISCLAIMER

We do not condone the use of ælkis, this is just made for fun. Stay aware of how much you drink and take care of eachother if you decide to brave upon this drinking game, since it's pretty damn potent. The characters used are only referred to, and we are not using the likeness of the characters from the series in a copyright infringing matter.

## Notes

*   To update generated files, run `dart run build_runner build` in the root directory of the project.

*   To update logo, run `flutter pub run flutter_launcher_icons` in the root directory of the project.

*   To deploy new version to firebase app distribution for android run `flutter build appbundle` and then `firebase appdistribution:distribute ./build/app/outputs/bundle/release/app-release.aab --app 1:1048576:android:0a0b6b0b0a0b0a0b0a0b0b --release-notes "New version" --groups "internal-testers"` in the root directory of the project.
