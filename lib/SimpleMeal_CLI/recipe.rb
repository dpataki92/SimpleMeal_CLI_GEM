class Recipe
    # readers and writers for the recipe instances
    attr_accessor :name, :diet, :cook_time, :ingredients, :directions, :url, :course

    # stores the recipe objects
    @@all = []

    # stores recipe objects checked but not saved by the user 
    @@lookups = []

    # reader for all recipes
    def self.all
        @@all.sort_by {|el| el.name}
    end

    # saves basic recipe object to all array
    def save
        @@all << self 
    end

    # prints out lists in a numbered order
    def self.print_list(list)
        puts ""
        list.each.with_index(1) {|recipe, i| puts "#{i}. #{recipe.name}"}
    end

    # finder method for selecting recipes from the all array based on their course category
    def self.find_by_course(course)
        if course == "all"
            self.all
        elsif course == "breakfast"
            self.all.select {|recipe| recipe.course == "breakfast"}
        elsif course == "lunch"
            self.all.select {|recipe| recipe.course == "lunch"}
        elsif course == "dinner"
            self.all.select {|recipe| recipe.course == "dinner"}
        end
    end

    # finder method for selecting only vegetarian or only glute-free meals from an array
    def self.find_by_diet(list, input)
        if input == "v"
            list.select {|dish| dish.diet.include?("vegetarian")}
        elsif input == "g"
            list.select {|dish| dish.diet.include?("gluten-free")}
        end  
    end

    # outputs data of a recipe instance in a formatted way
    def self.format_recipe(obj)
        puts ""
        puts "*** #{obj.name} ***"
        puts ""
        puts "Average cook time is: #{obj.cook_time}" if obj.cook_time
        puts "Categories: #{obj.diet}" if obj.diet
        puts ""
        puts "INGREDIENTS:"
        obj.ingredients.each {|ing| puts "- #{ing}"}
        puts ""
        puts "DIRECTIONS:"
        obj.directions.each {|dir| puts "- #{dir}"}
        puts ""
        puts "If you want to know more, check out this: #{obj.url}"
        puts ""
        puts "Bon Appetit!"
        puts ""
    end

    # returns a recipe in a formatted way based on number input and saves it to lookups if it hasn't already been saved
    def self.return_recipe(list, input)
            obj = list[input.to_i - 1]
            if @@lookups.include?(obj)
                self.format_recipe(@@lookups[@@lookups.index(obj)])
            else
                self.format_recipe(Scraper.scrape_extra_data(obj))
                @@lookups << obj
            end
    end

    # handles logic for options after listing recipes based on course type: filter them or return - if filtered, select recipe or return - if selected, save it or return
    def self.filter_and_select(course_list)
        puts ""
        puts "- Type the number of the recipe you want to check out!"
        puts "- Type 'v' if you want to see only the vegetarian options!"
        puts "- Type 'g' if you want to see only the gluten-free options!"
        puts "- Type 'm' if you want to return to the menu!"
        
        input = gets.strip

        if input == "v" || input == "g"
            self.select_from_filtered_list(course_list, input)
        elsif input.match?(/\A-?\d+\Z/) && input.to_i <= course_list.length
            recipe = course_list[input.to_i-1] 
            self.return_recipe(course_list, input)
            self.save_or_return(recipe, course_list)
        elsif input == "m"
            CLI.list_options
        else
            puts ""
            puts "Please provide a valid input!"
            sleep(2)
            self.select_recipe(course_list)
        end

    end

    # handles logic for options after a list is filtered based on diet - if no meals from the selected diet, inform user - otherwise print filtered list and return selected recipe
    def self.select_from_filtered_list(course_list, input)
        diet_filter = self.find_by_diet(course_list, input)
            if diet_filter.empty?
                puts ""
                puts "Sorry, this list does not contain any meals from the selected category :("
                sleep(2)
                self.filter_and_select(course_list)
            else
                self.print_list(diet_filter)
                puts ""
                puts "- Type the number of the recipe you want to check out!"
                puts "- Type 'm' if you want to return to the menu!"
                response = gets.strip
                if response == "m"
                    CLI.list_options
                elsif response.match?(/\A-?\d+\Z/) && response.to_i <= diet_filter.length
                    self.return_recipe(diet_filter, response)
                    self.save_or_return(diet_filter[response.to_i-1], diet_filter)
                else
                    puts ""
                    puts "Please provide valid input!"
                    sleep(2)
                    self.select_from_filtered_list(course_list, input)
                end
            end
    end

    # saves the recipe or return to the previous list or main menu
    def self.save_or_return(recipe, list)
        puts "- Did you like this recipe? Type 'save' to save it to your favorites!"
        puts "- Do you want to return to the list? Type 'r'!"
        puts "- Do you want to go back to the menu? Type 'm'!"
        response = gets.strip
        if response == "save"
            User.save_favorite(Scraper.scrape_extra_data(recipe))
            puts ""
            puts "It is saved!"
            puts ""
            sleep(1)
            self.select_recipe(list)
        elsif response == "r"
            self.select_recipe(list)
        elsif response == "m"
            CLI.list_options
        else
            puts ""
            puts "Please type valid input!"
            sleep(2)
            self.select_recipe(list)
        end
    end

    # handles full logic of selecting a specific recipe: creating list based on course type - filter list based on diet - return recipe and save it if user chooses to
    def self.select_recipe(course_list)
        self.print_list(course_list)
        self.filter_and_select(course_list)
    end

    # randomly selects a meal from all recipes and returns the recipe
    def self.meal_of_the_day
        arr = self.all
        i = rand(0...arr.length)
        puts ""
        puts "We recommend you to try out this recipe! Have fun!"
        self.format_recipe(Scraper.scrape_extra_data(arr[i]))
        self.save_or_return(arr[i], arr)
    end

    # generates a daily menu with breakfast, lunch and dinner recipes
    def self.menu_of_the_day
        breakfast = self.find_by_course("breakfast").sample(1)[0]
        lunch = self.find_by_course("lunch").sample(1)[0]
        dinner = self.find_by_course("dinner").sample(1)[0]

        menu = [breakfast, lunch, dinner]

        puts ""
        puts "Here is your menu for the day! Try out all of them!"
        self.select_recipe(menu)
    end



end