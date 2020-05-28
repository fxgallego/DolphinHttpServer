"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #SmalltalkParamsStyleTest
	instanceVariableNames: '_style'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkParamsStyleTest guid: (GUID fromString: '{eb8f4dcc-a810-42d1-a336-656ab5400c6a}')!
SmalltalkParamsStyleTest comment: ''!
!SmalltalkParamsStyleTest categoriesForClass!SUnit! !
!SmalltalkParamsStyleTest methodsFor!

setUp
	_style := HttpServerRequest paramsStyle.
	HttpServerRequest paramsStyle: #smalltalk!

tearDown
	HttpServerRequest paramsStyle: _style!

testNestedParams1
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'x[][z]=2&x[][z]=4'.
	self assert: (params isKindOf: MultiValueDictionary).
	self assert: params size = 1.
	self assert: (params at: 'x') size = 2.
	self assert: (params at: 'x') first = '2'.
	self assert: (params at: 'x') second = '4'!

testNestedParams4
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'param1[]=a&param2[]=a&param1[]=b'.
	self assert: (params isKindOf: MultiValueDictionary).
	self assert: params size = 2.
	self assert: (params at: 'param1') size = 2.
	self assert: (params at: 'param2') size = 1.
	self assert: ((params at: 'param1') includes: 'a').
	self assert: ((params at: 'param1') includes: 'b').
	self assert: (params at: 'param2') = 'a'!

testOnlyOneParamParsesToKeyWithEmptyString
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'param1'.
	self assert: (params isKindOf: MultiValueDictionary).
	self assert: params size = 1.
	self assert: (params at: 'param1') = ''!

testOnlyOneParamWithEmptyValueParsesToParamWithEmptyString
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'param1='.
	self assert: (params isKindOf: MultiValueDictionary).
	self assert: params size = 1.
	self assert: (params at: 'param1') = ''! !
!SmalltalkParamsStyleTest categoriesFor: #setUp!public! !
!SmalltalkParamsStyleTest categoriesFor: #tearDown!public! !
!SmalltalkParamsStyleTest categoriesFor: #testNestedParams1!public! !
!SmalltalkParamsStyleTest categoriesFor: #testNestedParams4!public! !
!SmalltalkParamsStyleTest categoriesFor: #testOnlyOneParamParsesToKeyWithEmptyString!public! !
!SmalltalkParamsStyleTest categoriesFor: #testOnlyOneParamWithEmptyValueParsesToParamWithEmptyString!public! !

