# CS50_final_project: Asteroids Game
### Video Demo: https://youtu.be/7OazW6KgRD8
### Short Description:
This is the final project of the Harvard's online course CS50. It is a simple asteroids game in Love and Lua.

It was developed with the help of freeCodeCamp love and lua full course, with some changes made to turn this game into an unique one.

Hope you enjoy!

### Explaining the files

#### Components folder:
    button: This is a function to simplify making the buttons in the menu, with some parameters set to dynamically make buttons;
    SFX: This function is simply to control the sound and the sound effects of the game;
    text: This function was made to help with text managment in the game. It has a lot of built in tools that help making different types of text appear on the screen.

#### Libs folder:
    This file was made to allocate the lunajson library. It is an external lib that helps with handling json files in the game, used to record score and high score.

#### Objects folder:
    All three files in the folder are made to control an specific part of the game.
    The asteroids file control the algoritm of making, moving and destroying asteroids in the game. It has a lot of math for making polygons and deciding what to do when they get hit.
    The laser file controls how the laser shot moves and what it will do when hitting an asteroid;
    And, finally, the player file creates and control the player on the screen, the amount of lives shown and what to do when hit.

#### Sprites folder:
    This folder is only to allocate the spaceship file, a PNG made with AI.

#### Src folder:
    In this folder all of the files for sounds and the save file are stored.

#### States folder:
    The states folder cointain two files. In game.lua the code is written to define when the game starts and ends, in addition to drawing score and high score on the screen when game is running.
    In menu.lua, as the filename says, the buttons and their actions are drawed on the screen.

#### main folder
    In the main folder or the project is where the three pilars of the game are kept. The first one, conf.lua is the set the window name and it's size. Globals.lua, in the other hand, is used in almost every file of the project and is designed to hold the main variables and functions of the game. And finally, main.lua joins all the files together, defining the three main functions of love and lua projects: love.load(), love.update(dt) and love.draw(). These three functions are responsible for loading the main data we will need, updating every function per frame and drawing what we see on the screen, respectively.

As already said, this game was developed with the help of freeCodeCamp online course, and changes like how the player moves and shoots and how the game is rendered where made to make this game unique.

