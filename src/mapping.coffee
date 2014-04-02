module.exports = ->
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
	
	map: (f) -> f(key[1..], value) for key, value of store
	