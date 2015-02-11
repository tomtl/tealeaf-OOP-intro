class MyCar
  attr_accessor :color
  attr_reader :year
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
  end
  
  def speed_up(speed)
    @current_speed.self += speed
    puts "You accelerate to #{current_speed} mph."
  end
  
  def brake(number)
    @current_speed -= number
    puts "You decelerate to #{current_speed} mph."
  end

  def shut_down
    @current_speed = 0
    puts "You have stopped the car."
  end
  
  def spray_paint(color)
    @color = color
    puts "The car has been painted #{color}."
  end
  
end