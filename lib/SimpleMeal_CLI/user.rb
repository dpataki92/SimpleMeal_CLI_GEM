class User
    @name = ""
    @favorites = []
    
    # creates readers and writers for class instance variables
    class << self
       attr_accessor :name, :favorites
    end
 
    # saves a recipe instance to the favorites array if it is not already saved
    def self.save_favorite(obj)
       self.favorites << obj if !self.favorites.include?(obj)
    end
 
    # based on input, deletes recipes from favorites or clear the whole array
    def self.delete_favorites
       Recipe.print_list(self.favorites)
       puts ""
       
       puts "- Type the number of the meal you want to delete"
       puts "- Type 'clear' if you want to delete all your favorites"
       response = gets.strip
 
       if response == "clear"
          self.favorites.clear
          puts ""
          puts "All meals are removed from favorites!"
          sleep(2)
          puts ""
          CLI.list_options
       elsif response.match?(/\A-?\d+\Z/) && response.to_i <= self.favorites.length
          puts ""
          puts "The meal '#{User.favorites[response.to_i-1].name}' has been removed from favorites!"
          puts ""
          self.favorites.delete_at(response.to_i-1)
          sleep(2)
          CLI.list_options
       else
          puts ""
          puts "Please provide valid input!"
          self.delete_favorites
       end
    end
 
    # handles full logic for returning and deleting favorite recipes
    def self.access_favorites
      if self.favorites.empty?
          puts ""
          puts "Sorry #{self.name}, you have not saved any recipes so far!"
      else
          puts ""
          puts "Here are your favorites! Great choices, #{self.name}! :)"
          Recipe.select_recipe(self.favorites)
          puts ""
          puts "Do you want to keep your favorites?(y/n)"
          input = gets.strip
          if input == "n"
             self.delete_favorites
          elsif input == "y"
             CLI.list_options
          else
             puts ""
             puts "Please provide valid input!"
             self.access_favorites
          end
      end
      
    end
 
 end