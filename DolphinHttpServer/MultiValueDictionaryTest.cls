"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #MultiValueDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiValueDictionaryTest guid: (GUID fromString: '{45b03c17-0505-47b1-bdc3-4d66aba08652}')!
MultiValueDictionaryTest comment: ''!
!MultiValueDictionaryTest categoriesForClass!SUnit! !
!MultiValueDictionaryTest methodsFor!

testDynamicLimit
	| dictionary |
	dictionary := MultiValueDictionary new.
	self assert: dictionary limit equals: MultiValueDictionary defaultLimit.
	1 to: dictionary limit do: [:each | dictionary at: each put: each].
	self should: [dictionary at: MultiValueDictionary defaultLimit + 1 put: MultiValueDictionary defaultLimit + 1] raise: Error!

testMultiValues
	| dictionary values keys |
	dictionary := MultiValueDictionary new.
	dictionary at: 'foo' add: 1; at: 'foo' add: 2.
	self assert: (dictionary at: 'foo') = #(1 2).
	self assert: dictionary keys asArray = #('foo').
	values := OrderedCollection new.
	keys := OrderedCollection new.
	dictionary keysAndValuesDo: [ :key :value | keys add: key. values add: value ].
	self assert: values = (OrderedCollection with: 1 with: 2).
	self assert: keys = (OrderedCollection with: 'foo' with: 'foo')
	! !
!MultiValueDictionaryTest categoriesFor: #testDynamicLimit!public! !
!MultiValueDictionaryTest categoriesFor: #testMultiValues!public! !

