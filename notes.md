CLI project - SimpleMeal CLI // Flatiron School - Portfolio Project 1

Application summary

As my first portfolio project, I built a CLI that allows users to quickly find simple yet delicious breakfast, lunch, and dinner recipes. My typical user likes to cook and try out new things but she is busy and doesn’t have time to wade through the plethora of cooking websites.

The application has the following main functionalities:
- it gets the most popular breakfast, lunch and dinner recipes from the simplerecipes website
- recipes can be listed based on course category
- all lists can be further filtered to get only vegetarian or gluten-free recipes
- users can save their favorite recipes and return to them later, also delete certain recipes from favorites or even the whole list
- if the user wants to challenge herself or she struggles with choosing between recipes, the program can recommend a single recipe or even a daily menu which can also be further filtered

The structure of the application

In the program, 4 classes collaborate with each other: CLI, Scraper, Recipe, User.
- The CLI class is responsible for handling the logic and flow of the application.
- The Scraper class is responsible for scraping data from simplerecipes.com and collaborating with the Recipe class to create recipe objects based on the data from the website.
- The Recipe class is responsible for everything that relates to storing, listing, selecting, saving, formatting and returning recipe objects.
- The User class is responsible for storing the user’s name and saving, returning and deleting her favorites.

The flow chart below visualizes the basic structure and key functions of the application:
Right after you start the program, it runs the scraper methods and creates the recipe objects with the basic data needed to list and filter the recipes. Additional data is only scraped and formatted when the user selects a specific recipe.

All recipes can be saved as favorite but the program also saves all the other viewed recipes in another array so that the program can return that recipe faster without scraping again, in case the user selects the same recipe again.

The program makes sure that every time we are done reading a recipe or we saved one, we can return to the previous list (even the one filtered by diet preference) so that we do not have to come back from the main menu again if we want to continue the search in the previous list. The program also uses a few types of input validation, such as indicating if you entered an invalid list number or used a letter with no function associated with it. It also makes sure that there won’t be any duplication in favorites, in case the user saves a recipe twice.