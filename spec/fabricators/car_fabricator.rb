Fabricator(:car) do
	make 'Ford'
	model 'Explorer Sports Trak'
	year 2015,
	garage { Fabriacte(:garage) }
end