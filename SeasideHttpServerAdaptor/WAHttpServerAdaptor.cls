"Filed out from Dolphin Smalltalk 7"!

WAServerAdaptor subclass: #WAHttpServerAdaptor
	instanceVariableNames: 'server'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WAHttpServerAdaptor guid: (GUID fromString: '{c5ebca7e-578b-4d00-bc0a-f9258174c9ee}')!
WAHttpServerAdaptor comment: ''!
!WAHttpServerAdaptor categoriesForClass!Unclassified! !
!WAHttpServerAdaptor methodsFor!

basicStart
	server
		addListener: self class name
		at: 'http://localhost:' , self port displayString , '/'
		handler: self.
	server start!

basicStop
	server stop.
	server removeListener: self class name!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream
		nextPut: $[ ;
		nextPutAll: self port displayString;
		nextPut: $] ;
		space;
		nextPutAll: self class name asString!

icon
	"Answer the icon of the receiver."

	^self isRunning ifTrue: [SeasideIcons start] ifFalse: [SeasideIcons stop]!

initialize
	codec := self defaultCodec.
	server := HttpServer new.
	port := 8080!

isRunning
	^server isRunning!

isStarting
	^ false!

isStopped
	^self isRunning not!

isStopping
	^ false!

postFieldsOf: aNativeRequest into: aRequestFields
	aNativeRequest postFields keysAndValuesDo: 
			[:key :postData |
			| value |
			value := (postData isKindOf: HttpServerFile)
						ifTrue: 
							[WAFile new
								fileName: postData fileName;
								contentType: postData contentType seasideMimeType;
								contents: postData contents asByteArray;
								yourself]
						ifFalse: [postData].
			aRequestFields at: key add: value]!

requestAddressFor: aNativeRequest
	^aNativeRequest peer
!

requestBodyFor: aNativeRequest
	"This only works for POST and PUT requests... LAME!!"

	aNativeRequest isPost ifTrue: [^aNativeRequest body].
	aNativeRequest isPut ifTrue: [^aNativeRequest putData].
	^nil!

requestCookiesFor: aNativeRequest
	^ WARequestCookie fromString: aNativeRequest cookie codec: self codec!

requestFieldsFor: aNativeRequest
	| fields |
	fields := WARequestFields new.
	aNativeRequest isPost
		ifTrue: [ self postFieldsOf: aNativeRequest into: fields ].
	^ fields!

requestHeadersFor: aNativeRequest
	^aNativeRequest headers allHeaders!

requestMethodFor: aNativeRequest
	^ aNativeRequest verb!

requestUrlFor: aNativeRequest
	| url |
	url := ((WAUrl absolute: aNativeRequest fullUrl)
		decodedWith: self codec).
	aNativeRequest isEncrypted
		ifTrue: [ url scheme: 'https' ].
	^ url!

requestVersionFor: aNativeRequest
	| array |
	array := aNativeRequest httpVersion.
	^ WAHttpVersion major: array first minor: array second!

responseFrom: aRequestContext
	| response |
	response := HttpServerResponse new.
	aRequestContext response headers
		keysAndValuesDo: [:key :value | response headerAt: key put: value greaseString].
	aRequestContext response cookies do: [:each | response addCookie: each oldNetscapeString].
	response
		statusCode: aRequestContext response status asNumber;
		reason: aRequestContext response message;
		content: aRequestContext response contents.
	^response!

shutDown
	server stop!

startUp
	server start!

value: req value: res
	| response |
	response := self process: req.
	res
		statusCode: response statusCode;
		reason: response reason;
		content: response content;
		headers: response headers! !
!WAHttpServerAdaptor categoriesFor: #basicStart!private! !
!WAHttpServerAdaptor categoriesFor: #basicStop!private! !
!WAHttpServerAdaptor categoriesFor: #displayOn:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #icon!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #initialize!public! !
!WAHttpServerAdaptor categoriesFor: #isRunning!public!testing! !
!WAHttpServerAdaptor categoriesFor: #isStarting!public!testing! !
!WAHttpServerAdaptor categoriesFor: #isStopped!public!testing! !
!WAHttpServerAdaptor categoriesFor: #isStopping!public!testing! !
!WAHttpServerAdaptor categoriesFor: #postFieldsOf:into:!private! !
!WAHttpServerAdaptor categoriesFor: #requestAddressFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestBodyFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestCookiesFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestFieldsFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestHeadersFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestMethodFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestUrlFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #requestVersionFor:!converting-request!public! !
!WAHttpServerAdaptor categoriesFor: #responseFrom:!converting!public! !
!WAHttpServerAdaptor categoriesFor: #shutDown!private! !
!WAHttpServerAdaptor categoriesFor: #startUp!private! !
!WAHttpServerAdaptor categoriesFor: #value:value:!public! !

