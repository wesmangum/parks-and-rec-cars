Fabricator(:car) do
	make 'Ford'
	model 'Explorer Sports Trak'
	year 2015,
	garage { Fabricate(:garage) }
end