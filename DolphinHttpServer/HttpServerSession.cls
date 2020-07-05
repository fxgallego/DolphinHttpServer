"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerSession
	instanceVariableNames: 'id'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerSession guid: (GUID fromString: '{77c3d5a1-f791-4f39-9cce-04d18e62994d}')!
HttpServerSession comment: ''!
!HttpServerSession categoriesForClass!Unclassified! !
!HttpServerSession methodsFor!

close
	self beUnfinalizable.
	self lib httpCloseServerSession: self id!

free
	self close!

id
	^id!

initialize
	id := self lib createServerSession.
	self beFinalizable! !
!HttpServerSession categoriesFor: #close!public! !
!HttpServerSession categoriesFor: #free!private! !
!HttpServerSession categoriesFor: #id!public! !
!HttpServerSession categoriesFor: #initialize!private! !

