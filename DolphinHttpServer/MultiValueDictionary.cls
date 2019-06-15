"Filed out from Dolphin Smalltalk 7"!

Dictionary variableSubclass: #MultiValueDictionary
	instanceVariableNames: 'limit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MultiValueDictionary guid: (GUID fromString: '{710baa25-9e3c-445d-b117-a5109ed23a50}')!
MultiValueDictionary comment: 'This is a port of the ZnMultiValueDictionary class from Pharo 6.1 Zinc Http Components.

Original class comment:

I am ZnMultiValueDictionary. 
I am a Dictionary.

I offer an #at:add: method to transparently create Array valued multi entries when needed.
My #keysAndValuesDo: is overwritten to transparently deal with multi entries.
To merge two instance preserving multiple values you can use #addAllMulti:
I normally limit the number of entries to protect me from resource abuse.

Note that most other methods will show the actual value.

Part of Zinc HTTP Components.'!
!MultiValueDictionary categoriesForClass!Collections-Unordered! !
!MultiValueDictionary methodsFor!

add: anAssociation
	self checkLimitForKey: anAssociation key.
	^super add: anAssociation!

addAllMulti: keyedCollection
	"Note that we use #at:add:"

	keyedCollection keysAndValuesDo: [:key :value | self at: key add: value]!

at: key add: value
	"Store value under key. If key already exists, store multiple values as Array"

	| existingValue newValue |
	existingValue := self at: key ifAbsent: [nil].
	newValue := existingValue isNil
				ifTrue: [value]
				ifFalse: 
					[(existingValue isKindOf: Array) ifTrue: [existingValue copyWith: value] ifFalse: [{existingValue. value}]].
	^self at: key put: newValue!

at: key put: anObject
	self checkLimitForKey: key.
	^super at: key put: anObject!

checkLimitForKey: aKey
	"Private - Signal an exception when the limit, if present, is exceeded."

	(self limit notNil and: [self size >= self limit and: [(self includesKey: aKey) not]])
		ifTrue: 
			[self
				error: ('Too many entries for MultiValueDictionary. Limit is <1d>.' expandMacrosWith: self limit)]!

initialize
	super initialize.
	limit := self class defaultLimit!

keysAndValuesDo: block
	"Execute a two argument (key, value) block for each header.
	Multi-valued headers are handled transparently."

	super keysAndValuesDo: 
			[:key :value |
			(value isKindOf: Array)
				ifTrue: [value do: [:each | block value: key value: each]]
				ifFalse: [block value: key value: value]]!

limit
	^limit!

limit: numberOfEntries
	limit := numberOfEntries!

unlimited
	self limit: nil! !
!MultiValueDictionary categoriesFor: #add:!public! !
!MultiValueDictionary categoriesFor: #addAllMulti:!public! !
!MultiValueDictionary categoriesFor: #at:add:!public! !
!MultiValueDictionary categoriesFor: #at:put:!public! !
!MultiValueDictionary categoriesFor: #checkLimitForKey:!private! !
!MultiValueDictionary categoriesFor: #initialize!private! !
!MultiValueDictionary categoriesFor: #keysAndValuesDo:!public! !
!MultiValueDictionary categoriesFor: #limit!accessing!private! !
!MultiValueDictionary categoriesFor: #limit:!accessing!private! !
!MultiValueDictionary categoriesFor: #unlimited!public! !

!MultiValueDictionary class methodsFor!

defaultLimit
	"Return the maximum number dictionary entries to accept.
	Used by ZnMultiValueDictionary and thus for reading headers, 
	url query and application form url encoded entity fields.
	This helps to protect us from malicious content."

	^256! !
!MultiValueDictionary class categoriesFor: #defaultLimit!public! !

