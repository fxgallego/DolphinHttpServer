"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServer
	instanceVariableNames: 'session listeners state'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServer guid: (GUID fromString: '{3ab54ad2-8e20-408b-8120-3b9418540c51}')!
HttpServer comment: ''!
!HttpServer categoriesForClass!Unclassified! !
!HttpServer methodsFor!

addListener: listenerName at: urlPrefix handler: handler
	| listener |
	listener := self listeners add: (HttpServerListener
						name: listenerName
						url: urlPrefix
						handler: handler).
	self isRunning ifTrue: [listener startInSession: self session].
	^listener!

createServerSession
	session := HttpServerSession new!

free
	self stop.
	SessionManager current removeEventsTriggeredFor: self!

initialize
	state := #stopped.
	listeners := OrderedCollection new.
	self registerSessionManagerEvents.
	self beFinalizable!

isRunning
	^state == #running!

listeners
	^listeners!

onImageSaveCompleted
	self startIfPaused!

onImageSaveStarting
	self isRunning
		ifTrue: 
			[state := #paused.
			self stopListenersAndCloseSession]!

onSessionStarted
	self startIfPaused!

onSessionStopped
	self stop!

registerSessionManagerEvents
	SessionManager current
		when: #imageSaveStarting
			send: #onImageSaveStarting
			to: self;
		when: #imageSaveCompleted
			send: #onImageSaveCompleted
			to: self;
		when: #sessionStopped
			send: #onSessionStopped
			to: self;
		when: #sessionStarted
			send: #onSessionStarted
			to: self!

removeListener: identifier
	self listeners removeAllSuchThat: 
			[:listener |
			listener name = identifier
				ifTrue: 
					[listener stop.
					true]
				ifFalse: [false]]!

session
	session ifNil: [self createServerSession].
	^session!

start
	self isRunning ifTrue: [self stop; start].
	state := #running.
	self listeners do: [:each | each startInSession: self session]!

startIfPaused
	state == #paused ifTrue: [self start]!

stop
	state := #stopped.
	self stopListenersAndCloseSession!

stopListenersAndCloseSession
	self listeners do: [:each | each stop].
	session ifNotNil: [session close].
	session := nil! !
!HttpServer categoriesFor: #addListener:at:handler:!public! !
!HttpServer categoriesFor: #createServerSession!private! !
!HttpServer categoriesFor: #free!public! !
!HttpServer categoriesFor: #initialize!private! !
!HttpServer categoriesFor: #isRunning!public! !
!HttpServer categoriesFor: #listeners!public! !
!HttpServer categoriesFor: #onImageSaveCompleted!private! !
!HttpServer categoriesFor: #onImageSaveStarting!private! !
!HttpServer categoriesFor: #onSessionStarted!private! !
!HttpServer categoriesFor: #onSessionStopped!private! !
!HttpServer categoriesFor: #registerSessionManagerEvents!private! !
!HttpServer categoriesFor: #removeListener:!public! !
!HttpServer categoriesFor: #session!public! !
!HttpServer categoriesFor: #start!public! !
!HttpServer categoriesFor: #startIfPaused!private! !
!HttpServer categoriesFor: #stop!public! !
!HttpServer categoriesFor: #stopListenersAndCloseSession!private! !

!HttpServer class methodsFor!

httpStatusCodes
	^##(LookupTable new
		at: 100 put: 'Continue';
		at: 101 put: 'Switching Protocols';
		at: 200 put: 'OK';
		at: 201 put: 'Created';
		at: 202 put: 'Accepted';
		at: 203 put: 'Non-Authoritative Information';
		at: 204 put: 'No Content';
		at: 205 put: 'Reset Content';
		at: 206 put: 'Partial Content';
		at: 300 put: 'Multiple Choices';
		at: 301 put: 'Moved Permanently';
		at: 302 put: 'Found';
		at: 303 put: 'See Other';
		at: 304 put: 'Not Modified';
		at: 305 put: 'Use Proxy';
		at: 307 put: 'Temporary Redirect';
		at: 400 put: 'Bad Request';
		at: 401 put: 'Unauthorized';
		at: 402 put: 'Payment Required';
		at: 403 put: 'Forbidden';
		at: 404 put: 'Not Found';
		at: 405 put: 'Method Not Allowed';
		at: 406 put: 'Not Acceptable';
		at: 407 put: 'Proxy Authentication Required';
		at: 408 put: 'Request Time-out';
		at: 409 put: 'Conflict';
		at: 410 put: 'Gone';
		at: 411 put: 'Length Required';
		at: 412 put: 'Precondition Failed';
		at: 413 put: 'Request Entity Too Large';
		at: 414 put: 'Request-URI Too Large';
		at: 415 put: 'Unsupported Media Type';
		at: 416 put: 'Requested range not satisfiable';
		at: 417 put: 'Expectation Failed';
		at: 500 put: 'Internal Server Error';
		at: 501 put: 'Not Implemented';
		at: 502 put: 'Bad Gateway';
		at: 503 put: 'Service Unavailable';
		at: 504 put: 'Gateway Time-out';
		at: 505 put: 'HTTP Version not supported';
		yourself)! !
!HttpServer class categoriesFor: #httpStatusCodes!public! !

