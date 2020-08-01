"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerCredentials
	instanceVariableNames: 'fieldValue userid password'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerCredentials guid: (GUID fromString: '{d3262b70-600b-4c1c-8b83-100f7f8f3050}')!
HttpServerCredentials comment: ''!
!HttpServerCredentials categoriesForClass!Unclassified! !
!HttpServerCredentials methodsFor!

initializeFieldValue: aString
	fieldValue := aString.
	self parseUserPass!

parseUserPass
	"See https://tools.ietf.org/html/rfc7617 "

	| encodedCredentials credentials stream |
	"Remove 'Basic ' "
	encodedCredentials := (Character space split: fieldValue) last.
	credentials := Utf8String fromByteArray: (ByteArray fromBase64String: encodedCredentials).
	stream := credentials readStream.
	userid := stream upTo: $:.
	password := stream upToEnd!

password
	^password!

userid
	^userid! !
!HttpServerCredentials categoriesFor: #initializeFieldValue:!private! !
!HttpServerCredentials categoriesFor: #parseUserPass!private! !
!HttpServerCredentials categoriesFor: #password!public! !
!HttpServerCredentials categoriesFor: #userid!public! !

!HttpServerCredentials class methodsFor!

fromFieldValue: aString
	^self new
		initializeFieldValue: aString;
		yourself! !
!HttpServerCredentials class categoriesFor: #fromFieldValue:!accessing!public! !

