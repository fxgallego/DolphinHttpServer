# Dolphin Http Server

This is a multithreaded http server that wraps the Windows HTTP Server API. A low level wrapper is provided by Dolphin 7.
It includes thread pool to avoid running out of green processes when the server is being accesed by multiple clients.
It's a good replacement for Swazoo and much more stable too.

## Automated Installation
* Download and install [GitHub Package Manager](https://github.com/rko281/GitHub)
* Evaluate:
  `GitHubPackageManager install: 'fxgallego/DolphinHttpServer/Dolphin Http Server Demo'`

## Simplest example:
```
server := HttpServer new.
server
	addListener: 'DolphinSmaltalkHTTPServer'
	at: 'http://localhost:8080/'
	handler: [:request :response | response statusCode: 200; content: 'Hello'].
server start.
```
Point your browser to: http://localhost:8080

## DEMO
A demo is provided showing how to impement some minimal form and file upload handling.
1. Load the demo package
2. Evaluate `HttpServerDemo start` and navigate to http://localhost:8080

Use 7.0 branch with Dolphin 7.0 branch and master for Dolphin 7.1

## License
The MIT license