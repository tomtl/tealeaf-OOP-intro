class Vehicle
  attr_accessor :speed, :heading
  def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end
  
  def range
    @fuel_capacity * @fuel_efficiency
  end
end

class WheeledVehicle < Vehicle
  def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
    @tires = tire_array
    @fuel_efficiency = km_traveled_per_liter
    @fuel_capacity = liters_of_fuel_capacity
  end

  def tire_pressure(tire_index)
    @tires[tire_index]
  end

  def inflate_tire(tire_index, pressure)
    @tires[tire_index] = pressure
  end
end

class WaterVehicle < Vehicle
  def range
    (@fuel_capacity * @fuel_efficiency) + 10
  end
end

class Auto < WheeledVehicle
  def initialize
    # 4 tires are various tire pressures
    super([30,30,32,32], 50, 25.0)
  end
end

class Motorcycle < WheeledVehicle
  def initialize
    # 2 tires are various tire pressures along with 
    super([20,20], 80, 8.0)
  end
end

class Catamaran < WaterVehicle
  attr_accessor :propeller_count, :hull_count, :speed, :heading, :range
  def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
    @propeller_count = num_propellers
    @hull_count = num_hulls
    @km_traveled_per_liter = km_traveled_per_liter
    @liters_of_fuel_capacity = liters_of_fuel_capacity
  end
end

class Motorboat < WaterVehicle
end