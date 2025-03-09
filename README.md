# GameCrate

Welcome to GameCrate! This project is built using Godot with Mono support. It's a mobile app to manage your board game collection, and plan game sessions with your friends. GameCrate uses Firebase for real time updates.

## Table of Contents

- [Setup Instructions](#setup-instructions)
- [Running the Project](#running-the-project)
- [Project Structure](#project-structure)


## Setup Instructions

Follow these steps to set up the project:

1. **Download Godot Mono 4.4:**
   - Visit the [official Godot website](https://godotengine.org/download/windows/) and download the latest Godot **.NET** version (4.4).

2. **Extract the Files:**
   - Extract the downloaded Godot Mono .exe to a folder of your choice.

3. **Place the GodotSharp Folder:**
   - Ensure that the `GodotSharp` folder is extracted into the **same folder** as the Godot executable. This is necessary for the Mono functionalities to work correctly.

4. **Run Godot:**
   - Launch the Godot executable from the folder. The project should now load with the required C# support.

## Running the Project

After completing the setup, follow these steps to run the project:

1. Open Godot and load the project by selecting the project directory.
2. Once the project is open, press the **Play** button in the Godot editor to run the project.
3. Enjoy developing or testing the app!

## Project Structure

Here's a brief overview of the project structure:

- **`project.godot`**: The main project file.
- **`addons/`**: The external addons used by the project.
- **`asset/`**: Contains images, fonts, and other resources.
- **`resource/`**: Contains saved Godot `.tres` files such as the theme, styles etc.
- **`scenes/`**: Contains all the scene files for the game and their directly related scripts.
- **`script/`**: Holds the generic scripts for business logic.


Happy coding!
