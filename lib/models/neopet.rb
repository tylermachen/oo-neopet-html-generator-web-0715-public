class Neopet
  attr_accessor :happiness, :items
  attr_reader :name, :strength, :defence, :movement, :species

  def initialize(name)
    @name = name
    @strength = get_points
    @defence = get_points
    @movement = get_points
    @happiness = get_points
    @species = get_species
    @items = []
  end

  def get_points
    rand(1..10)
  end

  def get_species
    Dir["public/img/neopets/*.jpg"].map do |f|
      f.gsub(/public\/img\/neopets\/|.jpg/, '')
    end.sample
  end

  def mood
    case happiness
      when 1..2  then 'depressed'
      when 3..4  then 'sad'
      when 5..6  then 'meh'
      when 7..8  then 'happy'
      when 9..10 then 'ecstatic'
    end
  end
end
