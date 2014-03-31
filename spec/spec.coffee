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
		
	it "has a forEach() method that lets us do something for each key/value pair", ->
		m = new mapping
		m.set "a", "b"
		m.set "c", "d"
		
		result = ""
		m.forEach (key, value) -> result += key + value
		result.should.equal "abcd"
	
describe "the extra security", ->
	it "should not let us change the prototype of the internal keystore", ->
		m = new mapping
		
		m.set "__proto__", {"foo": "bar"}
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		m.set "hasOwnProperty", 123
		
		m.get("foo").should.equal "bar"