Fabricator(:garage) do
	name "Leslie's Garage"
	user { Fabricate(:user) }
end