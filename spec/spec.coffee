expect  = require "should"
mapping = require "../src/mapping"	

describe "require 'mapping'", ->
	it "should return a function", ->
		(typeof mapping).should.equal "function"

describe "the basic mapping functionality", ->
	it "has get(), set() and delete() methods that work as you would expect", ->
		m = new mapping
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		(m.get "foo").should.equal "bar"
		
		m.delete "foo"
		((m.get "foo")?).should.be.false
	
describe "the extra security", ->
	it "should not let us change the prototype of the internal keystore", ->
		m = new mapping
		
		m.set "__proto__", {"foo": "bar"}
		((m.get "foo")?).should.be.false
		
		m.set "foo", "bar"
		m.set "hasOwnProperty", 123
		
		m.get("foo").should.equal "bar"