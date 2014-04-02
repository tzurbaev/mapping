expect  = require "should"
mapping = require "../src/mapping"	

describe "require 'mapping'", ->
	it "should return a function", ->
		(typeof mapping).should.equal "function"

describe "the API", ->
	it "has get(), set() and delete() methods that work as you would expect", ->
		m = new mapping
		n = new mapping
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		(m.get "foo").should.equal "bar"
		((n.get "foo")?).should.be.false
		
		m.delete "foo"
		((m.get "foo")?).should.be.false
	
	it "has an empty() method that empties the mapping", ->
		m = new mapping
		m.set "foo", 123
		m.set "bar", 456
			
		m.size().should.equal 2
		
		do m.empty
		m.size().should.equal 0
		
	it "has a size() method that returns the number of keys in the mapping", ->
		m = new mapping
		m.size().should.equal 0
	
		m.set "foo", "bar"
		m.size().should.equal 1
		
		m.delete "foo"
		m.size().should.equal 0
		
	it "has a keys() method that returns the keys of the mapping", ->
		m = new mapping
		m.keys().length.should.equal 0
	
		m.set "foo", 123
		m.set "bar", 456
		
		m.keys().length.should.equal 2
		
		# Note that order shouldn't matter here
		m.keys().indexOf("foo").should.not.equal -1
		m.keys().indexOf("bar").should.not.equal -1
		
	it "has a values() method that returns the values of the mapping", ->
		m = new mapping
		m.values().length.should.equal 0
	
		m.set "foo", 123
		m.set "bar", 456
		
		m.values().length.should.equal 2
		
		# Note that order shouldn't matter here
		m.values().indexOf(123).should.not.equal -1
		m.values().indexOf(456).should.not.equal -1
		
	it "has a hasKey() method that tells us if a given key is present", ->
		m = new mapping
		
		m.hasKey("foo").should.be.false
	
		m.set "foo", "bar"
		m.hasKey("foo").should.be.true
		
	it "has a hasValue() method that tells us if a given value is present", ->
		m = new mapping
		
		m.hasValue("foo").should.be.false
	
		m.set "foo", "bar"
		m.hasValue("bar").should.be.true
		
	it "has a map() method that lets us map each key/value pair onto another set", ->
		m = new mapping
		m.set "a", "b"
		m.set "c", "d"
		
		result = m.map (key, value) -> key + value
		result.indexOf("ab").should.not.equal -1
		result.indexOf("cd").should.not.equal -1
		result.indexOf("ef").should.equal -1
		
	it "has a filter() method returns a subset of this mapping as a new mapping", ->
		m = new mapping
		m.set "a", 1
		m.set "b", 2
		m.set "c", 3
		
		filtered = m.filter (key, value) -> key == "a"
		filtered.get("a").should.equal 1
		(filtered.get("b")?).should.be.false
		(filtered.get("c")?).should.be.false
		
		filtered = m.filter (key, value) -> value == 3
		(filtered.get("a")?).should.be.false
		(filtered.get("b")?).should.be.false
		filtered.get("c").should.equal 3
		
		filtered = m.filter (key, value) -> no
		(filtered.get("a")?).should.be.false
		(filtered.get("b")?).should.be.false
		(filtered.get("c")?).should.be.false
		
		# The original mapping shouldn't be modified
		m.get("a").should.equal 1
		m.get("b").should.equal 2
		m.get("c").should.equal 3
	
	it "has a some() method, that tells uf is a given condition
	    is satisfied for some key/value pair in the mapping", ->
		m = new mapping
		m.set "a", 1
		m.set "b", 2
		m.set "c", 1
		
		(m.some (key, value) -> key is "a").should.be.true
		(m.some (key, value) -> key is "d").should.be.false
		(m.some (key, value) -> value is 1).should.be.true
		
	
describe "the extra security", ->
	it "should not let us change the prototype of the internal keystore", ->
		m = new mapping
		
		m.set "__proto__", {"foo": "bar"}
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		m.set "hasOwnProperty", 123
		
		m.get("foo").should.equal "bar"