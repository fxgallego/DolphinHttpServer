"Load in the tests appropriate for DPRO and run them,"
(Package manager includesPackageNamed: 'Dolphin Base Tests') ifFalse: [
	SourceManager default fileIn: 'RegressionTestsLoad.st']!

[| results suite |
suite := TestSuite named: 'RegressionTests'.
suite addTests: HttpServerCookieTest buildSuite allTests.
suite addTests: HttpServerHeadersTest buildSuite allTests.
suite addTests: HttpServerRequestTest buildSuite allTests.
suite addTests: HttpServerResponseTest buildSuite allTests.
suite addTests: HttpServerTest buildSuite allTests.
suite addTests: MultiValueDictionaryTest buildSuite allTests.
results := SmalltalkSystem current
				runRegressionTests: suite
				logTo: SessionManager current stdout
				verbose: true.
SessionManager current quit: results failureCount+results errorCount] postToInputQueue !
