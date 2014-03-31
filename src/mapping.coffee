module.exports = ->
	# Our internal key/value store
	store = Object.create null
	
	# The api
	get:    (key)        -> store["~#{key}"]
	set:    (key, value) -> store["~#{key}"] = value
	delete: (key)        -> delete store["~#{key}"]
	
	size: -> Object.keys(store).length
	
	hasKey:   (key)   -> Object.keys(store).indexOf("~#{key}") isnt -1
	hasValue: (value) ->
		for key, val of store
			return yes if val is value 
		return false