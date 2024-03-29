﻿"Filed out from Dolphin Smallalk"!

Object subclass: #ThreadPool
	instanceVariableNames: 'maxPoolSize minPoolSize poolManager queueWorkers workQueue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'minWorkers maxWorkers workerTimeout'!
ThreadPool guid: (GUID fromString: '{219a54bd-a9ad-4ffd-9710-87ef11f841fa}')!
ThreadPool comment: ''!
!ThreadPool categoriesForClass!Kernel-Objects! !
!ThreadPool methodsFor!

adjustThreadPoolSize
	(Delay forSeconds: 1) wait.
	(queueWorkers anySatisfy: [:each | each isDead]) ifTrue: [self cleanDead].
	self isPoolTooSmall
		ifTrue: [self startWorker]
		ifFalse: [self isPoolTooBig ifTrue: [self killWorker]]!

cleanDead
	"Private - Clean dead processes, for example those kill when a debugger session ends
	on terminated by exception handling."

	[queueWorkers removeAll: (queueWorkers select: [:each | each isDead])] forkAt: Processor userSchedulingPriority!

initialize
	super initialize.
	minPoolSize := self class minWorkers.
	maxPoolSize := self class maxWorkers.
	workQueue := SharedQueue new.
	queueWorkers := SharedIdentitySet new
!

isPoolTooBig
	^queueWorkers size > minPoolSize and: [workQueue size < queueWorkers size]!

isPoolTooSmall
	^queueWorkers size < minPoolSize
		or: [workQueue size > queueWorkers size and: [queueWorkers size < maxPoolSize]]!

isRunning
	^poolManager notNil and: [poolManager isAlive]!

killWorker
	"Private - just queue a task that kill the activeProcess, 
    which will be the worker that picks it up"

	self
		queueWorkItem: [self isPoolTooBig ifTrue: [(queueWorkers remove: Processor activeProcess) terminate]]
		expiresAt: (TimeStamp current addSeconds: 600)!

processQueueElement
	workQueue next evaluate!

queueWorkItem: aBlock
	self queueWorkItem: aBlock expiresAt: (TimeStamp current addSeconds: self class workerTimeout)!

queueWorkItem: aBlock expiresAt: aTimestamp
	| worker |
	worker := ThreadWorker on: aBlock expires: aTimestamp.
	workQueue nextPut: worker.
	^worker!

start
	self stop.
	minPoolSize timesRepeat: [self startWorker].
	poolManager := [[self adjustThreadPoolSize] repeat] forkAt: Processor systemBackgroundPriority.
	poolManager name: 'ThreadPool manager'!

startWorker
	| process |
	process := queueWorkers
				add: ([[self processQueueElement] repeat] forkAt: Processor systemBackgroundPriority).
	process name: 'ThreadWorker process'!

stop
	queueWorkers do: [:each | each terminate].
	queueWorkers := SharedIdentitySet new.
	workQueue := SharedQueue new.
	poolManager
		ifNotNil: 
			[poolManager terminate.
			poolManager := nil]! !
!ThreadPool categoriesFor: #adjustThreadPoolSize!private! !
!ThreadPool categoriesFor: #cleanDead!private! !
!ThreadPool categoriesFor: #initialize!private! !
!ThreadPool categoriesFor: #isPoolTooBig!private! !
!ThreadPool categoriesFor: #isPoolTooSmall!private! !
!ThreadPool categoriesFor: #isRunning!public! !
!ThreadPool categoriesFor: #killWorker!private! !
!ThreadPool categoriesFor: #processQueueElement!private! !
!ThreadPool categoriesFor: #queueWorkItem:!public! !
!ThreadPool categoriesFor: #queueWorkItem:expiresAt:!public! !
!ThreadPool categoriesFor: #start!public! !
!ThreadPool categoriesFor: #startWorker!private! !
!ThreadPool categoriesFor: #stop!public! !

!ThreadPool class methodsFor!

maxWorkers
	maxWorkers ifNil: [maxWorkers := 15].
	^maxWorkers!

maxWorkers: anInteger
	maxWorkers := anInteger!

minWorkers
	minWorkers ifNil: [minWorkers := 5].
	^minWorkers!

minWorkers: anInteger
	minWorkers := anInteger!

new
	^super new initialize!

stopAll
	"Despite the instances of the receiver implements free, it probably will never be garbage collected
	because the private processes of the receiver still references the receiver.
	The aim of this method is stop all instances of the receiver to allow them die in peace.
	
	self stopAll 
	
	"

	self allInstances do: [:each | each stop]!

workerTimeout
	"Timeout in seconds"

	workerTimeout ifNil: [workerTimeout := 60].
	^workerTimeout!

workerTimeout: seconds
	workerTimeout := seconds! !
!ThreadPool class categoriesFor: #maxWorkers!public! !
!ThreadPool class categoriesFor: #maxWorkers:!public! !
!ThreadPool class categoriesFor: #minWorkers!public! !
!ThreadPool class categoriesFor: #minWorkers:!public! !
!ThreadPool class categoriesFor: #new!public! !
!ThreadPool class categoriesFor: #stopAll!public! !
!ThreadPool class categoriesFor: #workerTimeout!public! !
!ThreadPool class categoriesFor: #workerTimeout:!public! !

