"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #RubyRackParamsStyleTest
	instanceVariableNames: '_style'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RubyRackParamsStyleTest guid: (GUID fromString: '{1c58ccab-7c68-4e1e-9b08-ca53d05d4a47}')!
RubyRackParamsStyleTest comment: ''!
!RubyRackParamsStyleTest categoriesForClass!SUnit! !
!RubyRackParamsStyleTest methodsFor!

setUp
	_style := HttpServerRequest paramsStyle.
	HttpServerRequest paramsStyle: #rubyRack!

tearDown
	HttpServerRequest paramsStyle: _style!

testMatchString
	self assert: (HttpServerRequest match: 'This is a 🐬 PC1 test' with: '(^.*)') equals: {'This is a 🐬 PC1 test'. ''}.
	self assert: (HttpServerRequest match: 'This is a 🐬[][x]' with: '^[\[\]]*([^\[\]]+)\]*') equals: {'This is a 🐬'. '[][x]'}.
	self assert: (HttpServerRequest match: 'param1[][x]' with: '^[\[\]]*([^\[\]]+)\]*') equals: {'param1'. '[][x]'}!

testNestedParams1
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'x[][z]=2&x[][z]=4'.
	self assert: (params isKindOf: Dictionary).
	self assert: params size = 1.
	self assert: (params at: 'x') size = 2.
	self assert: ((params at: 'x') first at: 'z') = '2'.
	self assert: ((params at: 'x') second at: 'z') = '4'.!

testNestedParams2
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'x[][y][w]=1&x[][z]=2&x[][y][w]=3&x[][z]=4'.
	self assert: (params isKindOf: Dictionary).
	self assert: params size = 1.
	self assert: (params at: 'x') size = 2.
	self assert: ((params at: 'x') first size = 2).
	self assert: (((params at: 'x') first at: 'y') isKindOf: Dictionary).
	self assert: (((params at: 'x') first at: 'y') size = 1).
	self assert: (((params at: 'x') first at: 'y') at: 'w') = '3'.
	self assert: ((params at: 'x') first at: 'z') = '2'.
	self assert: ((params at: 'x') second size = 1).
	self assert: ((params at: 'x') second at: 'z') = '4'.!

testNestedParams3
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'x[][z][w]=1&x[][z][j]=2&x[][y][w]=3&x[][b]=4'.
	self assert: (params isKindOf: Dictionary).
	self assert: params size = 1.
	self assert: (params at: 'x') size = 1.
	self assert: (params at: 'x') first size = 3.
	self assert: (((params at: 'x') first at: 'z') isKindOf: Dictionary).
	self assert: ((params at: 'x') first at: 'z') size = 2.
	self assert: (((params at: 'x') first at: 'z') at: 'w') = '1'.
	self assert: (((params at: 'x') first at: 'z') at: 'j') = '2'.
	self assert: ((params at: 'x') first at: 'y') size = 1.
	self assert: (((params at: 'x') first at: 'y') at: 'w') = '3'.
	self assert: ((params at: 'x') first at: 'b') = '4'!

testNestedParams4
	| params |
	params := HttpServerRequest decodeUrlEncoded: 'param1[]=a&param2[]=a&param1[]=b'.
	self assert: (params isKindOf: Dictionary).
	self assert: params size = 2.
	self assert: (params at: 'param1') size = 2.
	self assert: (params at: 'param2') size = 1.
	self assert: ((params at: 'param1') includes: 'a').
	self assert: ((params at: 'param1') includes: 'b').
	self assert: ((params at: 'param2') includes: 'a')!

testOnlyOneParamParsesToKeyWithNilValue
	self assert: (HttpServerRequest decodeUrlEncoded: 'param1')
		equals: (Dictionary new
				at: 'param1' put: nil;
				yourself)!

testOnlyOneParamWithEmptyValueParsesToParamWithEmptyString
	self assert: (HttpServerRequest decodeUrlEncoded: 'param1=')
		equals: (Dictionary new
				at: 'param1' put: '';
				yourself)!

testParameterSeparatorsAreAmpersandOrSemicolon
	self assert: (HttpServerRequest decodeUrlEncoded: 'param1=value1;param2=value2&param3=value3')
		equals: (Dictionary new
				at: 'param1' put: 'value1';
				at: 'param2' put: 'value2';
				at: 'param3' put: 'value3';
				yourself)! !
!RubyRackParamsStyleTest categoriesFor: #setUp!public! !
!RubyRackParamsStyleTest categoriesFor: #tearDown!public! !
!RubyRackParamsStyleTest categoriesFor: #testMatchString!public! !
!RubyRackParamsStyleTest categoriesFor: #testNestedParams1!public! !
!RubyRackParamsStyleTest categoriesFor: #testNestedParams2!public! !
!RubyRackParamsStyleTest categoriesFor: #testNestedParams3!public! !
!RubyRackParamsStyleTest categoriesFor: #testNestedParams4!public! !
!RubyRackParamsStyleTest categoriesFor: #testOnlyOneParamParsesToKeyWithNilValue!public! !
!RubyRackParamsStyleTest categoriesFor: #testOnlyOneParamWithEmptyValueParsesToParamWithEmptyString!public! !
!RubyRackParamsStyleTest categoriesFor: #testParameterSeparatorsAreAmpersandOrSemicolon!public! !

