class mapping
	# Our internal key/value store
	store = Object.create null
	
	# The api
	get:    (key)        -> store["~#{key}"]
	set:    (key, value) -> store["~#{key}"] = value
	delete: (key)        -> delete store["~#{key}"]
	
module.exports = mapping