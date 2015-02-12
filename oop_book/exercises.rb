module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  @@number_of_vehicles = 0
  
  attr_accessor :color
  attr_reader :year, :model
  
  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas."
  end

  def self.number_of_vehicles
    @@number_of_vehicles
  end
  
  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @current_speed = 0
    @@number_of_vehicles += 1
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
  
  def age
    puts "This #{model} is #{years_old} years old."
  end
  
  private
    
    def years_old
      Time.now.year - year.to_i
    end

end


class MyCar < Vehicle

  NUMBER_OF_DOORS = 4
  
  def to_s
    "My car is a #{color} #{year} #{model}."
  end
end


class MyTruck < Vehicle
  include Towable
  
  def to_s
    "My truck is a #{color} #{year} #{model}."
  end
end

my_car = MyCar.new("2010", "silver", "Ford Focus")
puts my_car
my_truck = MyTruck.new("1987", "Green", "Unimog")
puts my_truck
puts Vehicle.number_of_vehicles
puts my_truck.can_tow?(3000)

puts my_truck.age