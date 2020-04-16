
# CLI controller
class CLI

    # controller method
    def self.call
     Scraper.scrape_recipes_from_index_page
     self.greeting
     self.list_options
     self.menu
     puts ""
     puts "Thanks for using SimpleMeal!"
    end

    # greets user, saves name and provides summary
    def self.greeting
        puts "******************************"
        puts "WELCOME TO THE SIMPLEMEAL CLI!"
        puts "******************************"
        puts ""
        puts "What's your name?"
        User.name = gets.strip
        puts ""
        puts "Hello #{User.name}! With SimpleMeal, you can:"
        puts ""
        puts "  -check out our most popular breakfast, lunch and dinner recipes"
        puts "  -search for vegetarian and gluten-free options"
        puts "  -ask us to recommend you a meal or even a full menu for the day"
        puts "  -save your favorite recipes and get back to them later"
        puts ""
        puts "Ready?(y/n)"
        input = gets.strip.downcase
        if input == 'y'
            puts ""
            puts "Cool! We got you the most popular simple recipes for #{Time.new.strftime("%d/%m/%Y")}"
            puts ""
        else
            puts ""
            puts "Hmmm, it seems you did not type 'y'. If you are not in the mood, just type 'exit'!"
            puts ""
        end
    end


    # prints menu
    def self.list_options
        puts "1. All recipes"
        puts "2. Breakfast recipes"
        puts "3. Lunch recipes"
        puts "4. Dinner recipes"
        puts "5. Favorites"
        puts "6. Meal of the day"
        puts "7. Menu of the day"
    end
 
    # handles logic for different menu options
    def self.menu
        input = nil
        while input != "exit"
            puts ""
            puts "Enter a number from the menu or type exit!"
            input = gets.strip.downcase
            case input
            when "1"
            Recipe.select_recipe(:return_all)
            when "2"
            Recipe.select_recipe(:all_breakfast)
            when "3"
            Recipe.select_recipe(:all_lunch)
            when "4"
            Recipe.select_recipe(:all_dinner)
            when "5"
            User.access_favorites
            when "6"
            Recipe.meal_of_the_day
            when "7"
            Recipe.menu_of_the_day
            end
        end
    end

end 