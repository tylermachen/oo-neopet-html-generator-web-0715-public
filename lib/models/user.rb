class User
  attr_accessor :neopoints
  attr_reader :name, :items, :neopets

  PET_NAMES = ["Angel", "Baby", "Bailey", "Bandit", "Bella", "Buddy",
               "Charlie", "Chloe", "Coco", "Daisy", "Lily", "Lucy",
               "Maggie", "Max", "Molly", "Oliver", "Rocky", "Shadow",
               "Sophie", "Sunny", "Tiger"]

  def initialize(name)
    @name = name
    @neopoints = 2500
    @items = []
    @neopets = []
  end

  def select_pet_name
    PET_NAMES.sample
  end

  def make_file_name_for_index_page
    @name.downcase.gsub(' ', '-')
  end

  def buy_item
    cost = 150
    if @neopoints >= cost
      item = Item.new
      @items << item
      @neopoints -= cost
      "You have purchased a #{item.type}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end

  def find_item_by_type(type)
    @items.find { |item| item.type == type }
  end

  def buy_neopet
    cost = 250
    if @neopoints >= cost
      pet = Neopet.new(select_pet_name)
      @neopets << pet
      @neopoints -= cost
      "You have purchased a #{pet.species} named #{pet.name}."
    else
      "Sorry, you do not have enough Neopoints."
    end
  end

  def find_neopet_by_name(name)
    @neopets.find { |pet| pet.name == name }
  end

  def sell_neopet_by_name(name)
    sell_price = 200
    pet = find_neopet_by_name(name)
    if pet
      @neopoints += sell_price
      @neopets.delete_if { |obj| obj.name == pet.name }
      "You have sold #{pet.name}. You now have #{neopoints} neopoints."
    else
      "Sorry, there are no pets named #{name}."
    end
  end

  def feed_neopet_by_name(name)
    pet = find_neopet_by_name(name)
    if pet.happiness < 10
      case
        when pet.happiness < 9 then pet.happiness += 2
        when pet.happiness == 9 then pet.happiness += 1
      end
      "After feeding, #{pet.name} is #{pet.mood}."
    else
      "Sorry, feeding was unsuccessful as #{pet.name} is already #{pet.mood}."
    end
  end

  def give_present(item_type, pet_name)
    item = find_item_by_type(item_type)
    pet = find_neopet_by_name(pet_name)
    if item && pet
      @items.delete_if { |obj| obj.type == item.type }
      pet.items << item
      pet.happiness += 5
      pet.happiness = 10 if pet.happiness > 10
      "You have given a #{item.type} to #{pet.name}, who is now #{pet.mood}."
    else
      "Sorry, an error occurred. Please double check the item type and neopet name."
    end
  end

  def make_index_page
    # INTRODUCING THE UGLIEST WAY TO GENERATE AN HTML PAGE WITH RUBY WITHOUT ERB
    name = make_file_name_for_index_page
    f = File.open("views/users/#{name}.html", "w+")
    f.write("<!DOCTYPE html>")
    f.write("<html>")
      f.write("<head>")
        f.write("<link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css\">")
        f.write("<link rel=\"stylesheet\" href=\"http://getbootstrap.com/examples/jumbotron-narrow/jumbotron-narrow.css\">")
        f.write("<title>#{@name}</title>")
      f.write("</head>")
      f.write("<body>")
        f.write("<div class=\"container\">")

        f.write("<!-- begin jumbotron -->")
        f.write("<div class=\"jumbotron\">")
          f.write("<h1>#{@name}</h1>")
          f.write("<h3><strong>Neopoints:</strong> #{neopoints}</h3>")
        f.write("</div>")
        f.write("<!-- end jumbotron -->")

        f.write("<div class=\"row marketing\">")

          f.write("<!-- begin listing neopets -->")
          f.write("<div class=\"col-lg-6\">")
            f.write("<h3>Neopets</h3>")
            f.write("<!-- first neopet -->")
            @neopets.each do |pet|
            f.write("<ul>")
              f.write("<li><img src=\"../../public/img/neopets/#{pet.species}.jpg\"></li>")
              f.write("<ul>")
                f.write("<li><strong>Name:</strong> #{pet.name}</li>")
                f.write("<li><strong>Mood:</strong> #{pet.mood}</li>")
                f.write("<li><strong>Species:</strong> #{pet.species}</li>")
                f.write("<li><strong>Strength:</strong> #{pet.strength}</li>")
                f.write("<li><strong>Defence:</strong> #{pet.defence}</li>")
                f.write("<li><strong>Movement:</strong> #{pet.movement}</li>")
                f.write("<li><strong>Items:</strong></li>")
                f.write("<ul>")
                f.write("<!-- begin neopet's items -->")
                    pet.items.each do |item|
                      f.write("<li><img src=\"../../public/img/items/#{item.type}.jpg\"></li>")
                      f.write("<ul>")
                        f.write("<li><strong>Type:</strong> #{item.format_type}</li>")
                      f.write("</ul>")
                    end
                f.write("</ul>")
              f.write("</ul>")
            f.write("</ul>")
            end
            f.write("</div>")
            f.write("<!-- end listing pets -->")

            f.write("<!-- begin listing items -->")
            f.write("<div class=\"col-lg-6\">")
              f.write("<h3>Items</h3>")
              f.write("<ul>")
              items.each do |item|
                f.write("<li><img src=\"../../public/img/items/#{item.type}.jpg\"></li>")
                f.write("<ul>")
                  f.write("<li><strong>Type:</strong> #{item.formatted_type}</li>")
                f.write("</ul>")
              end
              f.write("</ul>")
            f.write("</div>")
            f.write("<!-- end listing items -->")

          f.write("</div><!-- end row marketing -->")
        f.write("</div><!-- end container -->")
      f.write("</body>")
    f.write("</html>")
    f.close
  end
end
