"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #HttpServerRequestTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerRequestTest guid: (GUID fromString: '{c7798413-1a60-4de5-953a-de74bb96badd}')!
HttpServerRequestTest comment: ''!
!HttpServerRequestTest categoriesForClass!SUnit! !
!HttpServerRequestTest methodsFor!

testDecodeUrlEncodedArrayParams
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'foo[]=bar&foo[]=barz'.
	self assert: params size = 1.
	self assert: ((params at: 'foo') isKindOf: Array).
	self assert: (params at: 'foo') size = 2.
	self assert: ((params at: 'foo') includes: 'bar').
	self assert: ((params at: 'foo') includes: 'barz').!

testDecodeUrlEncodedSingleAndRepeatedParams
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'foo=bar&foo=barz'.
	self assert: params size = 1.
	self assert: ((params at: 'foo') isKindOf: Array).
	self assert: ((params at: 'foo') includes: 'bar').
	self assert: ((params at: 'foo') includes: 'barz').!

testDecodeUrlEncodedSingleParams
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'foo=bar&fooz=barz'.
	self assert: params size = 2.
	self assert: (params at: 'foo') = 'bar'.
	self assert: (params at: 'fooz') = 'barz'.!

testDecodeUrlEncodedWithUnicodeKeysAndValues
	| params |
	params := HttpServerRequest decodeUrlEncoded: '🐬=bar🐬&🐬🐬[]=bar&🐬🐬[]=barz'.
	self assert: params size = 2.
	self assert: (params at: '🐬') = 'bar🐬'.
	self assert: ((params at: '🐬🐬') isKindOf: Array).
	self assert: ((params at: '🐬🐬') includes: 'bar').
	self assert: ((params at: '🐬🐬') includes: 'barz').!

testHttpServerCredentials
	| credentials |
	credentials := HttpServerCredentials fromFieldValue: 'Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ=='.
	self assert: credentials userid equals: 'Aladdin'.
	self assert: credentials password equals: 'open sesame'! !
!HttpServerRequestTest categoriesFor: #testDecodeUrlEncodedArrayParams!public! !
!HttpServerRequestTest categoriesFor: #testDecodeUrlEncodedSingleAndRepeatedParams!public! !
!HttpServerRequestTest categoriesFor: #testDecodeUrlEncodedSingleParams!public! !
!HttpServerRequestTest categoriesFor: #testDecodeUrlEncodedWithUnicodeKeysAndValues!public! !
!HttpServerRequestTest categoriesFor: #testHttpServerCredentials!public! !

