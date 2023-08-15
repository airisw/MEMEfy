# MEMEfy

## Description

MEMEfy is a fun iOS party game to play online with your friends.

Each round has a random prompt and a random judge. Players should submit their most creative and funniest GIFs that match the prompt. Judge picks their favorite combo, and points are scored to the winner. Wash, rinse, and repeat. Perfect game for friends who love memes.

## Features
 - Join an existing game room or share a unique room code to play with your friends
 - Synchronized timer shows how much time is left in each round
 - Personalized prompts catered to you and your friends to make the game more unique
 - Submit creative GIFs from the GIPHY library to describe current prompt
 - Judge chooses the funniest GIF according to the prompt
 - Scoreboard to keep track of your and your friends' points

## Instructions

1. Clone this project:
```
git clone https://github.com/airisw/memefy.git
```
2. Download Xcode
3. Open the project and run the simulator in <i>Product > Run</i>

## Dependencies

MEMEfy is integrated with the GIPHY iOS SDK so players can search for GIFs. 

Save your iOS SDK key in the root project root as a `apiKey.plist` file with the following structure:
```
<key>apiKey</key>
<string>Your API key</string>
```

This project is currently connected to Google Firebase as an iOS app for data storage. Add the configuration file `GoogleService-Info.plist` to the root of the project.

## Future Implementations

- Minimum requirement of 3 players to start the game
- Custom prompts only available in your own game room
- Custom prompts will be deleted once game ends
