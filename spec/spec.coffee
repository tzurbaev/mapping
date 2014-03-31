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
		m.size().should.equal(0)
	
		m.set "foo", "bar"
		m.size().should.equal(1)
		
		m.delete "foo"
		m.size().should.equal(0)
		
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
	
describe "the extra security", ->
	it "should not let us change the prototype of the internal keystore", ->
		m = new mapping
		
		m.set "__proto__", {"foo": "bar"}
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		m.set "hasOwnProperty", 123
		
		m.get("foo").should.equal "bar"