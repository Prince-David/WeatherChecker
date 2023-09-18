# WeatherChecker
Configuration
To get the app up and running on your local machine, you'll need to add a configuration file with your OpenWeather API key. Follow these steps:

Obtain an API Key:
If you don't have an OpenWeather API key yet, you can get one by:
Visiting OpenWeatherMap's API page.
Sign in or create a free account.
Generate your API key.

Add Config.plist:
In the project directory, create a new Property List file named Config.plist.
Open Config.plist in Xcode or your preferred Plist editor.
Add a new entry with a key named OpenWeatherAPIKey.
Set the value of the OpenWeatherAPIKey entry to your API key obtained from OpenWeatherMap.

⚠️ Important: Do not commit Config.plist to any public repository. This file contains your private API key. The .gitignore file in this repository has already been set up to ignore Config.plist to prevent accidental commits.
