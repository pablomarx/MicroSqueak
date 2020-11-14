MObject subclass: #MException
	instanceVariableNames: 'messageText tag signalContext handlerContext outerContext'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Exceptions'!

!MException methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:19'!
description
	"Return a textual description of the exception."

	| desc mt |
	desc := self class name asString.
	^(mt := self messageText) == nil
		ifTrue: [desc]
		ifFalse: [desc, ': ', mt]! !

!MException methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:19'!
messageText
	"Return an exception's message text."
	^ messageText ifNil: [ MByteString empty ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MException class
	instanceVariableNames: ''!


MException subclass: #MError
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Exceptions'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MError class
	instanceVariableNames: ''!
