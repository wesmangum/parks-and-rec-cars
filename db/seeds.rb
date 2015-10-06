# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
garage_1 =  Garage.create(name: "Leslie's Garage")
garage_2 = Garage.create(name: "Andy's Garage")

Car.create( make: 'Ford', model: 'Pinto', year: 1971, garage_id: garage_1.id)
Car.create( make: 'Toyota', model: 'Prius', year: 2015, garage_id: garage_2.id)