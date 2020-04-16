class Scraper

    # scrapes data from the given course's page and creates recipe objects with basic attributes
    def self.scrape_recipes_from_course_page(link)
        doc = Nokogiri::HTML(open("#{link}"))
        arr = doc.css(".grd-tile-detail").collect do |node|
            recipe = Recipe.new
            recipe.name = node.css(".grd-title-link a span").text.strip
            recipe.diet = node.css(".sum-item.sum-food-type").text.downcase.strip
            recipe.url = node.css(".grd-title-link a")[0]["href"]
            recipe
        end

        if link.include?("breakfast")
            Recipe.all[:breakfast] = arr
        elsif link.include?("lunch")
            Recipe.all[:lunch] = arr
        elsif link.include?("dinner")
            Recipe.all[:dinner] = arr
        end

    end

    # scrapes data from index page and creates recipe objects from the breafast - lunch - dinner pages using scrape_recipes_from_course_page method
    def self.scrape_recipes_from_index_page
        doc = Nokogiri::HTML(open("https://www.simplyrecipes.com/index/"))
        links = doc.css("a").select {|a| a.text.tr("0-9", "") == "Breakfast and Brunch " || a.text.tr("0-9", "") == "Lunch " || a.text.tr("0-9", "") == "Dinner "}.collect {|n| n["href"]}
        links.each {|link| self.scrape_recipes_from_course_page(link)}
    end

    # scrapes additional data from a specific recipe's page and includes data in the recipe object
    def self.scrape_extra_data(recipe)
        doc = Nokogiri::HTML(open("#{recipe.url}"))
        recipe.cook_time = doc.css(".cooktime").text.strip
        recipe.ingredients = doc.css(".ingredient").collect {|ingredient| ingredient.text.strip}.reject {|el| el.empty?}
        recipe.directions = doc.css(".entry-details.recipe-method.instructions div p").collect {|p| p.text.strip}.reject {|el| el.empty?}
        recipe
    end

end