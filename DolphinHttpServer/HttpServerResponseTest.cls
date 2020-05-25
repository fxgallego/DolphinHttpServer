"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HttpServerResponseTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerResponseTest guid: (GUID fromString: '{fc7918e5-99cf-4559-889e-6322773a11f7}')!
HttpServerResponseTest comment: ''!
!HttpServerResponseTest categoriesForClass!SUnit! !
!HttpServerResponseTest methodsFor!

testBadRequest
	self assert: HttpServerResponse badRequest statusCode equals: 400!

testBasicAuthRealm
	| response |
	response := HttpServerResponse basicAuthRealm: 'test'.
	self assert: (response headerAt: 'WWW-Authenticate') equals: 'Basic realm="test"' !

testForbidden
	self assert: HttpServerResponse forbidden statusCode equals: 403!

testInternalServerError
	self assert: HttpServerResponse internalServerError statusCode equals: 500!

testNotFound
	self assert: HttpServerResponse notFound statusCode equals: 404!

testOk
	self assert: HttpServerResponse ok statusCode equals: 200!

testUnauthorized
	self assert: HttpServerResponse unauthorized statusCode equals: 401! !
!HttpServerResponseTest categoriesFor: #testBadRequest!public! !
!HttpServerResponseTest categoriesFor: #testBasicAuthRealm!public! !
!HttpServerResponseTest categoriesFor: #testForbidden!public! !
!HttpServerResponseTest categoriesFor: #testInternalServerError!public! !
!HttpServerResponseTest categoriesFor: #testNotFound!public! !
!HttpServerResponseTest categoriesFor: #testOk!public! !
!HttpServerResponseTest categoriesFor: #testUnauthorized!public! !

