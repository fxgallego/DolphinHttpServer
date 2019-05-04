"Load in the tests appropriate for DPRO and run them,"
(Package manager includesPackageNamed: 'Dolphin Base Tests') ifFalse: [
	SourceManager default fileIn: 'RegressionTestsLoad.st']!

[| results suite |
suite := TestSuite named: 'DolphinHttpServerRegressionTests'.
suite addTests: HttpServerCookieTest buildSuite allTests.
suite addTests: HttpServerHeadersTest buildSuite allTests.
suite addTests: HttpServerTest buildSuite allTests.
results := SmalltalkSystem current
				runRegressionTests: suite
				logTo: SessionManager current stdout
				verbose: true.
SessionManager current quit: results failureCount+results errorCount] postToInputQueue !
