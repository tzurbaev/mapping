## tl;dr
Using vanilla javascript objects as mappings is a bad idea, especially when
the key/value pairs are user generated. Don't do it.

## Installation
	npm install mapping

If you like nyan cats and testing (who doesn't?), `npm test` will run the test suite.

## Usage
Put this with your `require`s:

	var mapping = require("mapping");	

Use the `new` keyword to make your mappings:

	var store = new mapping;

### API
+	get(_key_)

	Get the value associated with _key_ in the mapping. Returns `undefined` if the
	key isn't present.
	
+	set(_key_, _value_)

	Store the given key/value pair in the mapping. If _key_ is already set, this
	overrides the previous value. Returns `undefined`.
	
+	delete(_key_)

	Delete the specified key from the mapping. Does nothing if the key isn't present.
	Returns `undefined`.

+	empty(_key_)

	Empty the mapping, i.e. remove all key/value pairs.
	
+	size()

	Returns the number of keys in the mapping.
	
+	keys()

	Returns the keys of the mapping in an array. An empty array is returned if no
	keys have been set.
	
+	values()

	Returns the values of the mapping in an array. An empty array is returned if no
	values have been set.

+	hasKey(_key_)

	Returns true if the given key exists, false otherwise.
	
+	hasValue(_value_)

	Returns true if the given value exists, false otherwise.
	
+	map(_fn_)

	Maps each of the key/value pairs in the mapping onto an array of elements
	defined by fn. _fn_ is called as `fn(key, value)` for each pair. There is no
	way to break out of this (not even if you're Michael Scofield).
	
+	filter(_fn_)

	For each of the key/value pairs in the mapping, `fn(key, value)` is called.
	All key/value pairs for which fn returns _true_ are added to a new mapping,
	which is returned. The original mapping is never modified.
	
+	some(_fn_)

	Returns true if `fn(key, value)` returns true for at least one of the
	key/value pairs in the mapping. Returns false otherwise.
	
+	one(_fn_)

	If `fn(key, value)` returns true for exactly one of the key/value pairs in
	the mapping, that key is returned. Returns false otherwise.
	
+	all(_fn_)

	Returns true if `fn(key, value)` returns true for all the key/value pairs
	in the mapping. Returns false otherwise.

## Wait, I can't do this with POJOs?
You can, but you don't want to. Here are a few reasons:

### Basic key/value storage is a _lot_ harder than it should be
You have users. They have data. So, you decide to store it in an object literal:

	var users = {
		"c00ki3m0nst3r" : {
			email: "karljohan@mailinator.com",
			password: "foo123"
		},
		"jack-sparrow" : {
			email: "captainjack@mailinator.com",
			password: "jacksparrow92"
		}
	};

Which is all great, until you decide to check if a given string represents a
valid username:

	(users["c00ki3m0nst3r"] !== undefined) // true, user exists
	(users["jack-sparrow"]  !== undefined) // true, user exists
	(users["toString"]      !== undefined) // true, user exi... wait what?

Or, maybe the Stallmanites decided all of your objects should be under the
GPL since, hey, you're using their library:

	/* rms.js, one of your dependencies */
	Object.prototype.copyright = "GPLv3 or higher";
	Object.freeze(Object.prototype); // Just in case.
	Object.freeze(Object);           // Eh, what the hell.

Now, looping over your mapping like so:

	for (var username in users) {
		console.log(username);
	}

Yields:

	c00ki3m0nst3r
	jack-sparrow
	copyright

Oops. But hey, no probs, you just use the `hasOwnProperty` method. Problem
solved, right? Well, yes. But that means that

	users.c00ki3m0nst3r

becomes

	users.hasOwnProperty("c00ki3m0nst3r")

and

	for (var username in users) {
		// Super secret implementation
	}
 
becomes

	for (var username in users) {
		if (users.hasOwnProperty(username)) {
			// Super secret implementation
		}
	}

and by this time, you're either thinking about quitting software development
for a career in eco-farming or trying to convince your boss to let you write
your application in assembler.

### Working with stored data is a _lot_ harder than it should be
POJOs give us a nice interface for storing and accessing key/value pairs,
but not much more. I could rant on forever about this, but it suffices to
look at the equivliant of `.size()`:

	var length = 0;
	for (var key in obj) {
		if (obj.hasOwnProperty(key)) {
			length++;
		}
	}

### Oh, and you can never, _ever_ trust user data
Say you have your users in an object, like before:

	var users = {
		"c00ki3m0nst3r" : {
			email: "karljohan@mailinator.com",
			password: "foo123"
		},
		"jack-sparrow" : {
			email: "captainjack@mailinator.com",
			password: "jacksparrow92"
		}
	};

You've gotten this far, so you know to use `hasOwnProperty` when interacting
with your data. You don't mind the non-existent API since, hey, you wouldn't
be doing this if you didn't like writing code, right? So we're cool, right?

No. One does not simply store user generated data in POJOs without _bad_
things happening. Lets start dynamically adding users, shall we?

	var username = getUsername();
	var email    = getEmail();
	var password = getPassword();
	
	users[username] = {
		email: email,
		password: password
	};

Now, what happens if this user calls themself `__proto__`? Or `toString`? Or
`hasOwnProperty`?

	users["__hasOwnProperty__"] = {
		email: "himom@mailinator.com",
		password: "foo12345"
	};

So, is c00ki3m0nst3r still a user?

	users.hasOwnProperty("c00ki3m0nst3r"); // TypeError: Property 'hasOwnProperty' of object #<Object> is not a function

I hope you're feeling convinced by now.

## Further reading
+	There's a somewhat heated discussion [here](https://groups.google.com/forum/#!topic/nodejs/HvwsNAuAN2Q)
	about the potential dangers of `__proto__` being exposed when using POJOs as
	key/value stores.
+	[Domenic Denicola](https://github.com/domenic) has made a lighter-weight [module](https://github.com/domenic/dict)
	that solves most of the above problems, with a minimal API. Check it out!