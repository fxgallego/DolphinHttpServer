"Filed out from Dolphin Smallalk"!

HttpServerObject subclass: #HttpServerResponse
	instanceVariableNames: 'request statusCode reason contentType content headers'
	classVariableNames: ''
	poolDictionaries: 'WinHttpServerConsts'
	classInstanceVariableNames: ''!
HttpServerResponse guid: (GUID fromString: '{03858539-95a9-4195-93d3-5ee4c3dabed2}')!
HttpServerResponse comment: ''!
!HttpServerResponse categoriesForClass!Unclassified! !
!HttpServerResponse methodsFor!

addCookie: cookie
	self headers headerAt: 'Set-Cookie' put: cookie asString!

attachFile: aHttpServerFile
	self
		statusCode: 200;
		reason: 'OK';
		content: aHttpServerFile contents;
		contentType: (aHttpServerFile contentType ifNil: ['application/octect-stream']);
		headerAt: 'Content-Disposition' put: 'attachment; filename=' , aHttpServerFile fileName!

content
	^content!

content: anObject
	content := anObject!

contentType
	^self headerAt: 'Content-Type'!

contentType: type
	self headerAt: 'Content-Type' put: type!

headerAt: name
	^headers headerAt: name ifAbsent: []!

headerAt: name put: stringValue
	^headers headerAt: name put: stringValue!

headers
	^headers!

headers: anObject
	headers := anObject!

initialize
	statusCode := 0.
	reason := ''.
	contentType := ''.
	content := ''.
	headers := HttpServerHeaders new!

initializeOn: httpApiRequest
	request := httpApiRequest!

reason
	^reason!

reason: anObject
	reason := anObject!

request
	^request!

send
	"This should not be considered an error because are received when there is a problem in client side.
	16r40 error when the user closes,  or stops the download before the server ends sending.
	16r4CD: An operation was attempted on a nonexistent network connection.
	16r3E3: The I/O operation has been aborted because of either a thread exit or an application request.
	16r79: The semaphore timeout period has expired."

	| response |
	response := HTTP_RESPONSE new.
	response
		StatusCode: self statusCode;
		pReason: self reason.
	self content notEmpty ifTrue: [response content: self content].
	headers write: response.
	
	[self lib
		sendResponse: response
		queue: request queueHandle
		id: request id] on: Win32Error
			do: [:ex | (#(16r40 16r4CD 16r3E3 16r79) includes: ex statusCode) ifFalse: [ex pass]]!

statusCode
	^statusCode!

statusCode: anObject
	statusCode := anObject! !
!HttpServerResponse categoriesFor: #addCookie:!accessing!public! !
!HttpServerResponse categoriesFor: #attachFile:!public! !
!HttpServerResponse categoriesFor: #content!accessing!public! !
!HttpServerResponse categoriesFor: #content:!accessing!public! !
!HttpServerResponse categoriesFor: #contentType!accessing!public! !
!HttpServerResponse categoriesFor: #contentType:!accessing!public! !
!HttpServerResponse categoriesFor: #headerAt:!public! !
!HttpServerResponse categoriesFor: #headerAt:put:!public! !
!HttpServerResponse categoriesFor: #headers!public! !
!HttpServerResponse categoriesFor: #headers:!accessing!public! !
!HttpServerResponse categoriesFor: #initialize!private! !
!HttpServerResponse categoriesFor: #initializeOn:!private! !
!HttpServerResponse categoriesFor: #reason!accessing!public! !
!HttpServerResponse categoriesFor: #reason:!accessing!public! !
!HttpServerResponse categoriesFor: #request!accessing!public! !
!HttpServerResponse categoriesFor: #send!public! !
!HttpServerResponse categoriesFor: #statusCode!accessing!public! !
!HttpServerResponse categoriesFor: #statusCode:!accessing!public! !

!HttpServerResponse class methodsFor!

badRequest
	^self new
		statusCode: 400;
		yourself!

basicAuthRealm: realmString
	^self unauthorized
		headerAt: 'WWW-Authenticate' put: ('Basic realm="<1d>"' expandMacrosWith: realmString);
		yourself!

for: httpApiRequest
	^self new initializeOn: httpApiRequest!

forbidden
	^self new
		statusCode: 403;
		yourself!

internalServerError
	^self new
		statusCode: 500;
		yourself!

notFound
	^self new
		statusCode: 404;
		yourself!

ok
	^self new
		statusCode: 200;
		yourself!

unauthorized
	^self new
		statusCode: 401;
		yourself! !
!HttpServerResponse class categoriesFor: #badRequest!public! !
!HttpServerResponse class categoriesFor: #basicAuthRealm:!public! !
!HttpServerResponse class categoriesFor: #for:!public! !
!HttpServerResponse class categoriesFor: #forbidden!public! !
!HttpServerResponse class categoriesFor: #internalServerError!public! !
!HttpServerResponse class categoriesFor: #notFound!public! !
!HttpServerResponse class categoriesFor: #ok!public! !
!HttpServerResponse class categoriesFor: #unauthorized!public! !

