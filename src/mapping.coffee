mapping = ->
	# Our internal key/value store
	store = Object.create null
	
	# The api
	get:    (key)        -> store["~#{key}"]
	set:    (key, value) -> store["~#{key}"] = value
	delete: (key)        -> delete store["~#{key}"]
	empty:               -> @delete key for key in @keys()
	
	keys:             -> key[1..] for key, value of store
	values:           -> value    for key, value of store
	hasKey:   (key)   -> key   in @keys()
	hasValue: (value) -> value in @values()	
	size:             -> @keys().length
	
	map:    (f) -> f key[1..], value for key, value of store
	
	filter: (f) ->
		results = new mapping
		for key, value of store
			results.set key[1..], value if f(key[1..], value)
		return results
	
	some: (f) ->
		for key, value of store
			return yes if f(key[1..], value) 
		return no
	
	one: (f) ->
		filtered = @filter(f)
		return no if filtered.size() isnt 1
		return filtered.keys()[0]
	
	all: (f) -> @filter(f).size() is @size()
	
		
module.exports = mapping
	