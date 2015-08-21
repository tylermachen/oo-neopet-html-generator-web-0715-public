class Item
  attr_reader :type

  def initialize
    @type = get_type
  end

  def get_type
    Dir["public/img/items/*.jpg"].map do |f|
      f.gsub(/public\/img\/items\/|.jpg/, '')
    end.sample
  end

  def format_type
    type.split('_').map { |w| w.capitalize }.join(' ')
  end

  def formatted_type
    type.downcase.gsub(' ', '-')
  end
end
