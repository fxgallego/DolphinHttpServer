"Filed out from Dolphin Smalltalk 7"!

HttpServerObject subclass: #HttpServerRequest
	instanceVariableNames: 'queue httpRequest headers body postFields queryFields params dateAndTime'
	classVariableNames: 'MAX_PAYLOAD'
	poolDictionaries: ''
	classInstanceVariableNames: 'ParamsStyle'!
HttpServerRequest guid: (GUID fromString: '{14fd8fd4-f15d-4b17-a47d-a6942bc0d04b}')!
HttpServerRequest comment: ''!
!HttpServerRequest categoriesForClass!Unclassified! !
!HttpServerRequest methodsFor!

accept
	^self headerAt: 'Accept' ifAbsent: ['']!

body
	body ifNil: [body := Utf8String fromByteArray: self receiveBody].
	^body!

cancel
	self lib
		httpCancelHttpRequest: self queueHandle
		requestId: self id
		overlapped: nil!

contentLength
	"Note: Don't using #asNumber here to avoid interpret strings using Smalltalk syntax."

	^Integer readPositiveFrom: (self headerAt: 'Content-Length' ifAbsent: ['0']) readStream radix: 10!

contentType
	^self headerAt: 'Content-Type' ifAbsent: ['']!

cookie
	^self headerAt: 'Cookie' ifAbsent: []!

credentials
	"Returns a HttpServerCredentials object if the Authorization header is present or nil if none."

	^(self headerAt: 'Authorization') ifNotNil: [:value | HttpServerCredentials fromFieldValue: value]!

dateAndTime
	^dateAndTime!

fullUrl
	^httpRequest CookedUrl pFullUrl asString!

headerAt: name
	^self headerAt: name ifAbsent: []!

headerAt: name ifAbsent: aBlock
	^self headers headerAt: name ifAbsent: aBlock!

headerAt: name ifPresent: operation
	^self headers headerAt: name ifPresent: operation!

headerAt: name put: stringValue
	^self headers headerAt: name put: stringValue!

headers
	headers ifNil: [self initializeHeaders].
	^headers!

host
	^self headerAt: 'Host' ifAbsent: ['']!

httpVersion
	^Array with: httpRequest Version MajorVersion with: httpRequest Version MinorVersion!

id
	^httpRequest RequestId!

initializeHeaders
	headers := HttpServerHeaders new.
	headers read: httpRequest!

initializeOn: httpApiQueue
	queue := httpApiQueue.
	httpRequest := self lib receiveRequest: queue handle flags: 0.
	dateAndTime := DateAndTime now!

isDelete
	^self verb = 'DELETE'!

isEncrypted
	^httpRequest pSslInfo notNil!

isFormUrlEncoded
	^self contentType beginsWith: 'application/x-www-form-urlencoded'!

isGet
	^self verb = 'GET'!

isHead
	^self verb = 'HEAD'!

isMultipart
	^self contentType beginsWith: 'multipart/form-data'!

isOptions
	^self verb = 'OPTIONS'!

isPatch
	^self verb = 'PATCH'!

isPost
	^self verb = 'POST'!

isPut
	^self verb = 'PUT'!

multipartBoundary
	| header |
	header := self contentType ifNil: [^nil].
	(header beginsWith: 'multipart/form-data') ifFalse:[^nil].
	^(header copyFrom: (header findString: 'boundary=') + 9 to: header size)!

origin
	^self headerAt: 'Origin' ifAbsent: ['']!

paramAt: name
	^self paramAt: name ifAbsent: []!

paramAt: name ifAbsent: operation
	^self params at: name ifAbsent: operation!

paramAt: name ifPresent: operation
	^self params at: name ifPresent: operation!

params
	"Answer all params: postFields + queryFields.
	queryFields are given preference over postFields."

	params ifNil: [params := self postFields copy addAllMulti: self queryFields].
	^params!

parsePostFields
	self isFormUrlEncoded ifTrue: [^self class decodeUrlEncoded: self body].
	self isMultipart ifTrue: [^self class decodeMultipart: self body boundary: self multipartBoundary].
	^MultiValueDictionary new!

parseQueryFields
	^self class decodeUrlEncoded: self queryString!

path
	^httpRequest CookedUrl pAbsPath asString!

peer
	^(httpRequest Address at: 1) displayString!

postFieldAt: name
	^self postFields at: name ifAbsent: []!

postFields
	postFields ifNil: [postFields := self parsePostFields].
	^postFields!

queryFieldAt: name
	^self queryFields at: name ifAbsent: []!

queryFields
	queryFields ifNil: [queryFields := self parseQueryFields].
	^queryFields!

queryString
	| query |
	query := httpRequest CookedUrl pQueryString ?? ''.
	query isEmpty ifTrue: [^query].
	^query first = $? ifTrue: [query allButFirst] ifFalse: [query]!

queueHandle
	^queue handle!

receiveBody
	self contentLength > self class maxPayload
		ifTrue: 
			[HttpServerError payloadTooLarge
				signal: 'The maximum content length allowed is ' , self class maxPayload displayString , ' bytes'].
	^self lib receiveRequestEntityBody: self queueHandle requestId: self id!

userAgent
	^self headerAt: 'User-Agent' ifAbsent: ['']!

verb
	^httpRequest verb!

xRequestedWith
	^self headerAt: 'X-Requested-With' ifAbsent: ['']! !
!HttpServerRequest categoriesFor: #accept!public! !
!HttpServerRequest categoriesFor: #body!public! !
!HttpServerRequest categoriesFor: #cancel!public! !
!HttpServerRequest categoriesFor: #contentLength!public! !
!HttpServerRequest categoriesFor: #contentType!public! !
!HttpServerRequest categoriesFor: #cookie!public! !
!HttpServerRequest categoriesFor: #credentials!public! !
!HttpServerRequest categoriesFor: #dateAndTime!public! !
!HttpServerRequest categoriesFor: #fullUrl!public! !
!HttpServerRequest categoriesFor: #headerAt:!public! !
!HttpServerRequest categoriesFor: #headerAt:ifAbsent:!public! !
!HttpServerRequest categoriesFor: #headerAt:ifPresent:!public! !
!HttpServerRequest categoriesFor: #headerAt:put:!public! !
!HttpServerRequest categoriesFor: #headers!public! !
!HttpServerRequest categoriesFor: #host!public! !
!HttpServerRequest categoriesFor: #httpVersion!public! !
!HttpServerRequest categoriesFor: #id!accessing!public! !
!HttpServerRequest categoriesFor: #initializeHeaders!private! !
!HttpServerRequest categoriesFor: #initializeOn:!private! !
!HttpServerRequest categoriesFor: #isDelete!public! !
!HttpServerRequest categoriesFor: #isEncrypted!public! !
!HttpServerRequest categoriesFor: #isFormUrlEncoded!public! !
!HttpServerRequest categoriesFor: #isGet!public! !
!HttpServerRequest categoriesFor: #isHead!public! !
!HttpServerRequest categoriesFor: #isMultipart!public! !
!HttpServerRequest categoriesFor: #isOptions!public! !
!HttpServerRequest categoriesFor: #isPatch!public! !
!HttpServerRequest categoriesFor: #isPost!public! !
!HttpServerRequest categoriesFor: #isPut!public! !
!HttpServerRequest categoriesFor: #multipartBoundary!private! !
!HttpServerRequest categoriesFor: #origin!public! !
!HttpServerRequest categoriesFor: #paramAt:!public! !
!HttpServerRequest categoriesFor: #paramAt:ifAbsent:!public! !
!HttpServerRequest categoriesFor: #paramAt:ifPresent:!public! !
!HttpServerRequest categoriesFor: #params!public! !
!HttpServerRequest categoriesFor: #parsePostFields!private! !
!HttpServerRequest categoriesFor: #parseQueryFields!private! !
!HttpServerRequest categoriesFor: #path!public! !
!HttpServerRequest categoriesFor: #peer!public! !
!HttpServerRequest categoriesFor: #postFieldAt:!public! !
!HttpServerRequest categoriesFor: #postFields!public! !
!HttpServerRequest categoriesFor: #queryFieldAt:!public! !
!HttpServerRequest categoriesFor: #queryFields!public! !
!HttpServerRequest categoriesFor: #queryString!public! !
!HttpServerRequest categoriesFor: #queueHandle!accessing!public! !
!HttpServerRequest categoriesFor: #receiveBody!private! !
!HttpServerRequest categoriesFor: #userAgent!public! !
!HttpServerRequest categoriesFor: #verb!public! !
!HttpServerRequest categoriesFor: #xRequestedWith!public! !

!HttpServerRequest class methodsFor!

decodeMultipart: aString boundary: boundary
	| fields |
	fields := MultiValueDictionary new.
	self
		decodeMultipart: aString readStream
		boundary: boundary
		do: 
			[:headers :params :content |
			params at: 'name'
				ifPresent: 
					[:fieldName |
					| value |
					value := content.
					params at: 'filename'
						ifPresent: 
							[:filename |
							value := HttpServerFile new.
							value fileName: filename.
							value contents: content.
							value contentType: (headers at: 'content-type' ifAbsent: ['text/html'])].
					self
						normalizeParams: fields
						key: fieldName
						value: value]].
	^fields!

decodeMultipart: aStream boundary: boundary do: aBlock
	| skip headers content disposition index params |
	aStream upToAll: '--' , boundary.
	[aStream atEnd or: [(skip := aStream next: 2) = '--']] whileFalse: 
			[skip = String lineDelimiter ifFalse: [self error: 'Error decoding multipart/form-data fields'].
			headers := LookupTable new.
			(self readPartHeadersFrom: aStream) do: [:hdr | headers add: hdr].
			content := aStream upToAll: String lineDelimiter , '--' , boundary.
			params := LookupTable new.
			disposition := headers at: 'content-disposition' ifAbsent: [''].
			#('name' 'filename') do: 
					[:arg |
					| len val |
					len := arg size + 2.
					index := disposition findString: arg , '='.
					index > 0
						ifTrue: 
							[val := disposition copyFrom: index + len to: (disposition indexOf: $" startingAt: index + len) - 1.
							params at: arg put: val]].
			aBlock
				value: headers
				value: params
				value: content]!

decodeUrlEncoded: aString
	^self decodeUrlEncoded: aString fieldSeparators: {$&}!

decodeUrlEncoded: aString fieldSeparators: aCharacterArray
	| fields |
	fields := MultiValueDictionary new.
	self
		decodeUrlEncoded: aString
		fieldSeparators: aCharacterArray
		do: 
			[:key :value |
			self
				normalizeParams: fields
				key: key
				value: value].
	^fields!

decodeUrlEncoded: aString fieldSeparators: aCharacterArray do: aBlock
	(aCharacterArray split: aString) do: 
			[:eachParam |
			| readStream key value hasValue |
			hasValue := eachParam includes: $=.
			readStream := eachParam readStream.
			key := readStream upTo: $=.
			value := readStream upToEnd.
			aBlock value: key trimBlanks urlDecoded value: (hasValue ifTrue: [value urlDecoded])]!

match: string with: pattern
	| input regex matches results |
	input := string asUtf16String.
	regex := IRegExp2 pattern: pattern.
	matches := regex execute: input.
	results := OrderedCollection new.
	matches do: [:each | results add: each subMatches first].
	results add: (matches isEmpty
				ifTrue: ['']
				ifFalse: 
					[| range |
					range := matches last range.
					input copyFrom: range stop + 1 to: input size]).
	regex free.
	^results asArray!

maxPayload
	MAX_PAYLOAD ifNil: [MAX_PAYLOAD := 100 * 1024 * 1024 "100MB"].
	^MAX_PAYLOAD!

maxPayload: size
	MAX_PAYLOAD := size!

normalizeParams: params key: key value: value
	
	self paramsStyle == #smalltalk ifTrue: [^self smalltalkNormalizeParams: params key: key value: value ].
	self paramsStyle == #rubyRack ifTrue: [^self rubyRackNormalizeParams: params key: key value: value ].
	self error: 'Unrecognized params style. Should be one of #smalltalk or #rubyRack.'!

on: httpApiQueue
	^self new initializeOn: httpApiQueue!

paramsStyle
	ParamsStyle ifNil: [ParamsStyle := #smalltalk].
	^ParamsStyle!

paramsStyle: aSymbol
	ParamsStyle := aSymbol!

readPartHeadersFrom: aStream
	| headers nextLine existing |
	headers := OrderedCollection new.
	
	[nextLine := aStream nextLine readStream.
	nextLine atEnd] whileFalse: 
				[nextLine peek isSeparator
					ifTrue: 
						["Continuation as per HTTP 1.1 spec"
						existing := headers last.
						existing value: existing value , ' ' , nextLine contents trimBlanks]
					ifFalse: 
						["Regular header"
						headers add: (nextLine upTo: $:) asLowercase -> nextLine upToEnd trimBlanks]].
	^headers!

rubyRackNormalizeParams: params key: key value: value
	"Private - This code was translated from Ruby to Smalltalk."

	| matches k after childKey |
	matches := self match: key with: '^[\[\]]*([^\[\]]+)\]*'.
	k := matches at: 1 ifAbsent: [''].
	after := matches isEmpty ifTrue: [''] ifFalse: [matches last].
	k isEmpty ifTrue: [^self].
	after isEmpty
		ifTrue: [params at: k put: value]
		ifFalse: 
			[after = '['
				ifTrue: [params at: key put: value]
				ifFalse: 
					[after = '[]'
						ifTrue: 
							[params at: k ifAbsentPut: [OrderedCollection new].
							(params at: k) add: value]
						ifFalse: 
							[((matches := self match: after with: '^\[\]\[([^\[\]]+)\]$') first notEmpty
								or: [(matches := self match: after with: '^\[\](.+)$') first notEmpty])
									ifTrue: 
										[childKey := matches first.
										params at: k ifAbsentPut: [OrderedCollection new].
										((params at: k) notEmpty and: 
												[((params at: k) last isKindOf: Dictionary) and: [((params at: k) last includesKey: childKey) not]])
											ifTrue: 
												[self
													rubyRackNormalizeParams: (params at: k) last
													key: childKey
													value: value]
											ifFalse: 
												[(params at: k) add: (self
															rubyRackNormalizeParams: Dictionary new
															key: childKey
															value: value)]]
									ifFalse: 
										[params at: k ifAbsentPut: [Dictionary new].
										params at: k
											put: (self
													rubyRackNormalizeParams: (params at: k)
													key: after
													value: value)]]]].
	^params!

smalltalkNormalizeParams: params key: key value: value
	"Private - This corresponds to the Smalltalk implementation as in Squeak."

	params at: (key upTo: $[) add: (value ifNil: ['']).
	^params! !
!HttpServerRequest class categoriesFor: #decodeMultipart:boundary:!public! !
!HttpServerRequest class categoriesFor: #decodeMultipart:boundary:do:!public! !
!HttpServerRequest class categoriesFor: #decodeUrlEncoded:!public! !
!HttpServerRequest class categoriesFor: #decodeUrlEncoded:fieldSeparators:!public! !
!HttpServerRequest class categoriesFor: #decodeUrlEncoded:fieldSeparators:do:!public! !
!HttpServerRequest class categoriesFor: #match:with:!private! !
!HttpServerRequest class categoriesFor: #maxPayload!public! !
!HttpServerRequest class categoriesFor: #maxPayload:!public! !
!HttpServerRequest class categoriesFor: #normalizeParams:key:value:!private! !
!HttpServerRequest class categoriesFor: #on:!public! !
!HttpServerRequest class categoriesFor: #paramsStyle!public! !
!HttpServerRequest class categoriesFor: #paramsStyle:!public! !
!HttpServerRequest class categoriesFor: #readPartHeadersFrom:!private! !
!HttpServerRequest class categoriesFor: #rubyRackNormalizeParams:key:value:!private! !
!HttpServerRequest class categoriesFor: #smalltalkNormalizeParams:key:value:!private! !

