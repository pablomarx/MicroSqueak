MObject variableSubclass: #MAdditionalMethodState
	instanceVariableNames: 'method selector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:36'!
at: aKey
	"Answer the property value or pragma associated with aKey."
	
	^self at: aKey ifAbsent: [self error: 'not found']! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:36'!
at: aKey ifAbsent: aBlock
	"Answer the property value or pragma associated with aKey or,
	 if aKey isn't found, answer the result of evaluating aBlock."

	1 to: self basicSize do:
		[:i |
		| propertyOrPragma "<Association|Pragma>" |
		(propertyOrPragma := self basicAt: i) key == aKey ifTrue:
			[^propertyOrPragma isVariableBinding
				ifTrue: [propertyOrPragma value]
				ifFalse: [propertyOrPragma]]].
	^aBlock value! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:36'!
at: aKey put: aValue
	"Replace the property value or pragma associated with aKey."
	| keyAlreadyExists |
	keyAlreadyExists := false.
	
	1 to: self basicSize do:
		[:i |
		| propertyOrPragma "<Association|Pragma>" |
		(propertyOrPragma := self basicAt: i) key == aKey ifTrue: [
			keyAlreadyExists := true.
			propertyOrPragma isVariableBinding
				ifTrue: [propertyOrPragma value: aValue]
				ifFalse: [self basicAt: i put: aValue]]].
	
	keyAlreadyExists ifFalse: [
		method propertyValueAt: aKey put: aValue ].
	
	^ aValue! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:36'!
copyWith: aPropertyOrPragma "<Association|Pragma>"
	"Answer a copy of the receiver which includes aPropertyOrPragma"
	| bs copy |
	(MAssociation == aPropertyOrPragma class
	 or: [MPragma == aPropertyOrPragma class]) ifFalse:
		[self error: self class name, ' instances should hold only Associations or Pragmas.'].
	copy := self class new: (bs := self basicSize) + 1.
	1 to: bs do:
		[:i|
		copy basicAt: i put: (self basicAt: i)].
	copy basicAt: bs + 1 put: aPropertyOrPragma.
	^copy
		selector: selector;
		setMethod: method;
		yourself
! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:42'!
copyWithout: aPropertyOrPragma "<Association|Pragma>"
	"Answer a copy of the receiver which no longer includes aPropertyOrPragma"
	| bs copy offset |
	copy := self class new: (bs := self basicSize) - ((self includes: aPropertyOrPragma)
													ifTrue: [1]
													ifFalse: [0]).
	offset := 0.
	1 to: bs do:
		[:i|
		(self basicAt: i) = aPropertyOrPragma
			ifTrue: [offset := 1]
			ifFalse: [copy basicAt: i - offset put: (self basicAt: i)]].
	^copy
		selector: selector;
		setMethod: method;
		yourself
! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:35'!
includes: aPropertyOrPragma "<Association|Pragma>"
	"Test if the property or pragma is present."

	1 to: self basicSize do:
		[:i |
		(self basicAt: i) = aPropertyOrPragma ifTrue:
			[^true]].
	^false! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:36'!
includesKey: aKey
	"Test if the property aKey or pragma with selector aKey is present."

	1 to: self basicSize do:
		[:i |
		(self basicAt: i) key == aKey ifTrue:
			[^true]].
	^false! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:41'!
includesProperty: aKey
	"Test if the property aKey is present."

	1 to: self basicSize do: [:i |
		| propertyOrPragma "<Association|Pragma>" |
		propertyOrPragma := self basicAt: i.
		(propertyOrPragma isVariableBinding
		 and: [propertyOrPragma key == aKey]) ifTrue:
			[^true]].
	^false! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:35'!
isEmpty
	^self basicSize = 0! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:39'!
isMethodProperties
	^ true! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:42'!
propertyValueAt: aKey ifAbsent: aBlock
	"Answer the property value associated with aKey or, if aKey isn't found, answer the result of evaluating aBlock."

	1 to: self basicSize do: [:i |
		| propertyOrPragma "<Association|Pragma>" |
		propertyOrPragma := self basicAt: i.
		(propertyOrPragma isVariableBinding
		 and: [propertyOrPragma key == aKey]) ifTrue:
			[^propertyOrPragma value]].
	^aBlock value! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:35'!
removeKey: aKey
	"Remove the property with aKey. Answer the property or raise an error if aKey isn't found."
	
	^ self removeKey: aKey ifAbsent: [ self error: 'Property not found' ].! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:35'!
removeKey: aKey ifAbsent: aBlock
	"Remove the property with aKey. Answer the value or, if aKey isn't found, answer the result of evaluating aBlock."
	
	1 to: self basicSize do: [:i |
		| propertyOrPragma "<Association|Pragma>" |
		propertyOrPragma := self basicAt: i.
		(propertyOrPragma isVariableBinding
				ifTrue: [propertyOrPragma key]
				ifFalse: [propertyOrPragma keyword])
			== aKey ifTrue:
			[^method removeProperty: aKey]].
	^aBlock value! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:30'!
selector
	^selector! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:30'!
selector: aSymbol
	selector := aSymbol! !

!MAdditionalMethodState methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:37'!
setMethod: aMethod
	method := aMethod.
	1 to: self basicSize do:
		[:i| | propertyOrPragma "<Association|Pragma>" |
		(propertyOrPragma := self basicAt: i) isVariableBinding ifFalse:
			[propertyOrPragma setMethod: aMethod]]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MAdditionalMethodState class
	instanceVariableNames: ''!

!MAdditionalMethodState class methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:40'!
selector: aSelector with: aPropertyOrPragma
	^(self basicNew: 1)
		selector: aSelector;
		basicAt: 1 put: aPropertyOrPragma;
		yourself! !


MObject variableSubclass: #MBlockClosure
	instanceVariableNames: 'outerContext startpc numArgs'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/23/2018 00:02'!
asContext
	"Create a MethodContext that is ready to execute self.  Assumes self takes no args (if it does the args will be nil)"

	^self asContextWithSender: nil! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:16'!
asContextWithSender: aContext
	"Inner private support method for evaluation.  Do not use unless you know what you're doing."

	^(MMethodContext newForMethod: outerContext method)
		setSender: aContext
		receiver: outerContext receiver
		method: outerContext method
		closure: self
		startpc: startpc! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:55'!
home
	^outerContext home! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:55'!
ifError: errorHandlerBlock
	"Evaluate the block represented by the receiver, and normally return it's value.  If an error occurs, the errorHandlerBlock is evaluated, and it's value is instead returned.  The errorHandlerBlock must accept zero, one, or two parameters (the error message and the receiver)."
	"Examples:
		[1 whatsUpDoc] ifError: [:err :rcvr | 'huh?'].
		[1 / 0] ifError: [:err :rcvr |
			'ZeroDivide' = err
				ifTrue: [Float infinity]
				ifFalse: [self error: err]]
"

	^ self on: Error do: [:ex |
		errorHandlerBlock valueWithPossibleArgs: {ex description. ex receiver}]! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:55'!
method
	^outerContext method! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/23/2018 00:23'!
msecs
	"Answer the number of milliseconds it took to evaluate this block."

	| startMSecs |
	startMSecs _ MSystem milliseconds.
	self value.
	^ MSystem milliseconds - startMSecs
! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
numArgs
	"Answer the number of arguments that must be used to evaluate this block"

	^numArgs! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:18'!
numArgsError: numArgsForInvocation

	| printNArgs |
	printNArgs := [:n| n printString, ' argument', (n = 1 ifTrue: [''] ifFalse:['s'])]. 
	self error: 
			'This block accepts ', (printNArgs value: numArgs), 
			', but was called with ', (printNArgs value: numArgsForInvocation), '.'! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:16'!
numCopiedValues
	"Answer the number of copied values of the receiver.  Since these are
	 stored in the receiver's indexable fields this is the receiver's basic size.
	 Primitive. Answer the number of indexable variables in the receiver. 
	 This value is the same as the largest legal subscript."

	<primitive: 62>
	^self basicSize! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:18'!
on: exception do: handlerAction
	"Evaluate the receiver in the scope of an exception handler."

	<primitive: 199>  "just a marker, fail and execute the following"
	^ self value! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:33'!
outerContext
	^outerContext! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
printOn: aStream
	aStream nextPutAll: '[closure] in '.
	outerContext printOn: aStream! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:19'!
receiver
	^outerContext receiver! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
sender
	"Answer the context that sent the message that created the receiver."

	^outerContext sender! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
value
	"Activate the receiver, creating a closure activation (MethodContext)
	 whose closure is the receiver and whose caller is the sender of this message.
	 Supply the copied values to the activation as its arguments and copied temps.
	 Primitive. Optional (but you're going to want this for performance)."
	| newContext ncv |
	<primitive: 201>
	numArgs ~= 0 ifTrue:
		[self numArgsError: 0].
	newContext := self asContextWithSender: thisContext sender.
	(ncv := self numCopiedValues) > 0 ifTrue:
		[newContext stackp: ncv.
		1 to: ncv do: "nil basicSize = 0"
			[:i| newContext at: i put: (self at: i)]].
	thisContext privSender: newContext! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
value: anArg
	"Activate the receiver, creating a closure activation (MethodContext)
	 whose closure is the receiver and whose caller is the sender of this message.
	 Supply the argument and copied values to the activation as its arguments and copied temps.
	 Primitive. Optional (but you're going to want this for performance)."
	| newContext ncv |
	<primitive: 202>
	numArgs ~= 1 ifTrue:
		[self numArgsError: 1].
	newContext := self asContextWithSender: thisContext sender.
	ncv := self numCopiedValues.
	newContext stackp: ncv + 1.
	newContext at: 1 put: anArg.
	1 to: ncv do:
		[:i| newContext at: i + 1 put: (self at: i)].
	thisContext privSender: newContext! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
value: firstArg value: secondArg
	"Activate the receiver, creating a closure activation (MethodContext)
	 whose closure is the receiver and whose caller is the sender of this message.
	 Supply the arguments and copied values to the activation as its arguments and copied temps.
	 Primitive. Optional (but you're going to want this for performance)."
	| newContext ncv |
	<primitive: 203>
	numArgs ~= 2 ifTrue:
		[self numArgsError: 2].
	newContext := self asContextWithSender: thisContext sender.
	ncv := self numCopiedValues.
	newContext stackp: ncv + 2.
	newContext at: 1 put: firstArg.
	newContext at: 2 put: secondArg.
	1 to: ncv do:
		[:i| newContext at: i + 2 put: (self at: i)].
	thisContext privSender: newContext! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 21:56'!
valueWithArguments: anArray
	"Activate the receiver, creating a closure activation (MethodContext)
	 whose closure is the receiver and whose caller is the sender of this message.
	 Supply the arguments in an anArray and copied values to the activation as its arguments and copied temps.
	 Primitive. Optional (but you're going to want this for performance)."
	| newContext ncv |
	<primitive: 206>
	numArgs ~= anArray size ifTrue:
		[self numArgsError: anArray size].
	newContext := self asContextWithSender: thisContext sender.
	ncv := self numCopiedValues.
	newContext stackp: ncv + numArgs.
	1 to: numArgs do:
		[:i| newContext at: i put: (anArray at: i)].
	1 to: ncv do:
		[:i| newContext at: i + numArgs put: (self at: i)].
	thisContext privSender: newContext! !

!MBlockClosure methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:16'!
valueWithPossibleArgs: anArray 

	^numArgs = 0
		ifTrue: [self value]
		ifFalse:
			[self valueWithArguments:
				(numArgs = anArray size
					ifTrue: [anArray]
					ifFalse:
						[numArgs > anArray size
							ifTrue: [anArray, (MArray new: numArgs - anArray size)]
							ifFalse: [anArray copyFrom: 1 to: numArgs]])]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MBlockClosure class
	instanceVariableNames: ''!



MByteArray variableByteSubclass: #MCompiledMethod
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MCompiledMethod commentStamp: 'jm 11/30/2003 18:54' prior: 0!
I represent a compiled method. I contain a header word, a set of indexable slots that hold literal objects needed by my code, and a sequence of bytecodes. CompiledMethods are the only kind of object that can contain a mixture of pointer slots (the literal slots) and uninterpreted bits (the bytecodes). This is an optimization that minimizes both space the the number of objects needed to represent the code of a Smalltalk image. Because there are typically a large number of CompiledMethods in an image, this optimization an important one, although it does add complexity to the system.
!


!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 12/31/2003 10:11'!
frameSize
	"Answer the size of temporary frame needed to run the receiver."
	"NOTE:  Versions 2.7 and later use two sizes of contexts."

	(self header bitAnd: 16r20000) = 0
		ifTrue: [^ 16]
		ifFalse: [^ 56].
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/29/2003 19:47'!
header
	"Answer the method header word containing information about the form of this method (e.g., number of literals) and the context needed to run it."

	^ self objectAt: 1
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/30/2003 18:47'!
initialPC
	"Answer the program counter for my first bytecode."

	^ (4 * (self numLiterals + 1)) + 1
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/30/2003 18:48'!
numLiterals
	"Answer the number of literals used by the receiver."
	
	^ (self header bitShift: -9) bitAnd: 16rFF
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/30/2003 18:41'!
numTemps
	"Answer the number of temporary variables used by this method."
	
	^ (self header bitShift: -18) bitAnd: 16r3F
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/29/2003 19:48'!
objectAt: index 
	"Primitive. Answer the method header (if index = 1) or a literal (if index > 1) from the receiver. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 68>
	self primitiveFailed
! !

!MCompiledMethod methodsFor: 'accessing' stamp: 'jm 11/30/2003 18:42'!
objectAt: index put: value
	"Primitive. Store the value argument into a literal in the receiver. An index of 2 corresponds to the first literal. Fails if the index is less than 2 or greater than the number of literals. Answer the value as the result. Normally only the compiler sends this message because only the compiler stores values in CompiledMethods. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 69>
	self primitiveFailed
! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:42'!
literalAt: index 
	"Answer the literal indexed by the argument."

	^self objectAt: index + 1! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:40'!
literalAt: index put: value 
	"Replace the literal indexed by the first argument with the second 
	argument. Answer the second argument."

	^self objectAt: index + 1 put: value! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:31'!
method
	"polymorphic with closure"

	^ self! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:31'!
numArgs
	"Answer the number of arguments the receiver takes."

	^ (self header bitShift: -24) bitAnd: 16r0F! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:41'!
penultimateLiteral
	"Answer the penultimate literal of the receiver, which holds either
	 the receiver's selector or its properties (which will hold the selector)."
	| pIndex |
	^(pIndex := self numLiterals - 1) > 0 
		ifTrue: [self literalAt: pIndex]
		ifFalse: [nil]! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:39'!
penultimateLiteral: anObject
	"Answer the penultimate literal of the receiver, which holds either
	 the receiver's selector or its properties (which will hold the selector)."
	| pIndex |
	(pIndex := self numLiterals - 1) > 0 
		ifTrue: [self literalAt: pIndex put: anObject]
		ifFalse: [self error: 'insufficient literals']! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:42'!
propertyValueAt: propName ifAbsent: aBlock
	| propertiesOrSelector |
	^(propertiesOrSelector := self penultimateLiteral) isMethodProperties
		ifTrue: [propertiesOrSelector propertyValueAt: propName ifAbsent: aBlock]
		ifFalse: [aBlock value]! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:38'!
propertyValueAt: propName put: propValue
	"Set or add the property with key propName and value propValue.
	 If the receiver does not yet have a method properties create one and replace
	 the selector with it.  Otherwise, either relace propValue in the method properties
	 or replace method properties with one containing the new property."
	| propertiesOrSelector |
	(propertiesOrSelector := self penultimateLiteral) isMethodProperties ifFalse:
		[self penultimateLiteral: ((MAdditionalMethodState
									selector: propertiesOrSelector
									with: (Association
											key: propName asSymbol
											value: propValue))
									setMethod: self;
									yourself).
		^propValue].
	(propertiesOrSelector includesProperty: propName) ifTrue:
		[^propertiesOrSelector at: propName put: propValue].
	self penultimateLiteral: (propertiesOrSelector
								copyWith: (MAssociation
												key: propName asSymbol
												value: propValue)).
	^propValue! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:41'!
removeProperty: propName
	"Remove the property propName if it exists.
	 Do _not_ raise an error if the property is missing."
	| value |
	value := self propertyValueAt: propName ifAbsent: [^nil].
	self penultimateLiteral: (self penultimateLiteral copyWithout:
									(MAssociation
										key: propName
										value: value)).
	^value! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:48'!
selector
	"Answer a method's selector.  This is either the penultimate literal,
	 or, if the method has any properties or pragmas, the selector of
	 the MethodProperties stored in the penultimate literal."
	| penultimateLiteral | 
	^(penultimateLiteral := self penultimateLiteral) isMethodProperties
		ifTrue: [penultimateLiteral selector]
		ifFalse: [penultimateLiteral]! !

!MCompiledMethod methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:48'!
selector: aSelector
	"Set a method's selector.  This is either the penultimate literal,
	 or, if the method has any properties or pragmas, the selector of
	 the MethodProperties stored in the penultimate literal."
	| penultimateLiteral nl | 
	(penultimateLiteral := self penultimateLiteral) isMethodProperties
		ifTrue: [penultimateLiteral selector: aSelector]
		ifFalse: [(nl := self numLiterals) < 2 ifTrue:
					[self error: 'insufficient literals to hold selector'].
				self literalAt: nl - 1 put: aSelector]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MCompiledMethod class
	instanceVariableNames: ''!
	

MObject subclass: #MInstructionStream
	instanceVariableNames: 'sender pc'
	classVariableNames: 'SpecialConstants'
	poolDictionaries: ''
	category: 'MSqueak-Methods'!

!MInstructionStream methodsFor: 'as yet unclassified' stamp: 'sw 8/23/2018 00:09'!
method
	"Answer the compiled method that supplies the receiver's bytecodes."

	^sender		"method access when used alone (not as part of a context)"! !

!MInstructionStream methodsFor: 'as yet unclassified' stamp: 'sw 8/22/2018 23:31'!
pc
	^ pc! !

!MInstructionStream methodsFor: 'as yet unclassified' stamp: 'sw 8/22/2018 23:29'!
privSender: aContext 

	sender := aContext! !

!MInstructionStream methodsFor: 'as yet unclassified' stamp: 'sw 8/22/2018 23:29'!
sender
	^ sender! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MInstructionStream class
	instanceVariableNames: ''!


MInstructionStream subclass: #MContextPart
	instanceVariableNames: 'stackp'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MContextPart commentStamp: '<historical>' prior: 0!
Contexts are used by the virtual machine to represent stack frames. This is an abstract class. My two concrete subclasses are used to represent block and method stack frames.
!

!MContextPart methodsFor: 'other' stamp: 'jm 12/31/2003 09:37'!
blockCopy: numArgs 
	"Primitive. Distinguish a block of code from its enclosing method by creating a new BlockContext for that block. The compiler inserts into all methods that contain blocks the bytecodes to send the message blockCopy:. Do not use blockCopy: in code that you write!! Only the compiler can decide to send the message blockCopy:. Fail if numArgs is not a SmallInteger. Optional. No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 80>
	^ (MBlockContext newForMethod: self home method)
		home: self home
		startpc: pc + 2
		nargs: numArgs
! !

!MContextPart methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:16'!
stackp: newStackp
	"Storing into the stack pointer is a potentially dangerous thing.
	This primitive stores nil into any cells that become accessible as a result,
	and it performs the entire operation atomically."
	"Once this primitive is implemented, failure code should cause an error"

	<primitive: 76>
	self error: 'stackp store failure'.
"
	stackp == nil ifTrue: [stackp := 0].
	newStackp > stackp  'effectively checks that it is a number'
		ifTrue: [oldStackp := stackp.
				stackp := newStackp.
				'Nil any newly accessible cells'
				oldStackp + 1 to: stackp do: [:i | self at: i put: nil]]
		ifFalse: [stackp := newStackp]
"! !
	
"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MContextPart class
	instanceVariableNames: ''!

!MContextPart class methodsFor: 'instance creation' stamp: 'jm 11/30/2003 16:54'!
newForMethod: aMethod
	"This is the only method for creating new contexts, other than by using the clone primitive. Any other attempts, such as inherited methods like shallowCopy, should be avoided or must at least be rewritten to determine the proper size for the method that will use this context. This is because asking a context its size (even basicSize!!) will not return the actual object size but only the number of fields currently accessible, as determined by stackp."

	^ super basicNew: aMethod frameSize
! !


MContextPart variableSubclass: #MBlockContext
	instanceVariableNames: 'nargs startpc home '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MBlockContext commentStamp: 'jm 11/30/2003 18:47' prior: 0!
I represent the context (stack frame) for a code block (code in square backets such as "[3 + 4]"). I know how many arguments I need. I support a number of messages for evaluating myself.
!


!MBlockContext methodsFor: 'accessing' stamp: 'jm 11/30/2003 16:41'!
home

	^ home
! !

!MBlockContext methodsFor: 'accessing' stamp: 'jm 11/30/2003 16:57'!
home: aMethodContext startpc: initialPC nargs: argCount

	home _ aMethodContext.
	startpc _ initialPC.
	nargs _ argCount.
! !

!MBlockContext methodsFor: 'accessing' stamp: 'jm 11/30/2003 16:49'!
method

	^ home method
! !

!MBlockContext methodsFor: 'accessing' stamp: 'jm 12/8/2003 23:16'!
numArgs

	^ nargs
! !


!MBlockContext methodsFor: 'evaluating' stamp: 'jm 5/22/2003 20:25'!
ifError: errorHandlerBlock
	"Evaluate the block represented by the receiver. If an error occurs the given handler block is evaluated. The handler block can be either a zero- or two-argument block; if the latter, then the error message and receiver are supplied to it as parameters. Answer the value returned by the handler block if the receiver gets an error."
	"Warning: The receiver should not contain an explicit return since that would leave an obsolete error handler hanging around."
	"Examples:
		[1 whatsUpDoc] ifError: [:err :rcvr | ^ 'huh?'].
		[1 whatsUpDoc] ifError: ['huh'].
		[1 / 0] ifError: [:err :rcvr |
			'division by 0' = err
				ifTrue: [^ Float infinity]
				ifFalse: [self error: err]]
"

	| activeProcess lastHandler val |
	activeProcess _ Processor activeProcess.
	lastHandler _ activeProcess errorHandler.
	activeProcess errorHandler: [:aString :aReceiver |
		activeProcess errorHandler: lastHandler.
		errorHandlerBlock numArgs = 0 ifTrue: [^ errorHandlerBlock value].
		^ errorHandlerBlock value: aString value: aReceiver].
	val _ self value.
	activeProcess errorHandler: lastHandler.
	^ val
! !

!MBlockContext methodsFor: 'evaluating' stamp: 'jm 12/9/2003 00:07'!
msecs
	"Answer the number of milliseconds it took to evaluate this block."

	| startMSecs |
	startMSecs _ MSystem milliseconds.
	self value.
	^ MSystem milliseconds - startMSecs
! !

!MBlockContext methodsFor: 'evaluating' stamp: 'jm 11/30/2003 17:02'!
value
	"Evaluate this block without any arguments."

	<primitive: 81>
	^ self valueWithArguments: #()
! !

!MBlockContext methodsFor: 'evaluating' stamp: 'jm 11/30/2003 17:02'!
value: arg 
	"Evaluate this block with one argument."

	<primitive: 81>
	^ self valueWithArguments: (MArray with: arg)
! !

!MBlockContext methodsFor: 'evaluating' stamp: 'jm 11/30/2003 17:03'!
value: arg1 value: arg2 
	"Evaluate this block with two arguments."

	<primitive: 81>
	^ self valueWithArguments: (MArray with: arg1 with: arg2)
! !

!MBlockContext methodsFor: 'evaluating' stamp: 'jm 11/30/2003 17:06'!
valueWithArguments: anArray
	"Primitive. Evaluate the block represented by the receiver. The argument is an Array whose elements are the arguments for the block. Fail if the length of the Array is not the same as the the number of arguments that the block was expecting. Fail if the block is already being executed. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 82>
	anArray size = nargs
		ifTrue: [self error: 'Attempt to evaluate a block that is already being evaluated.']
		ifFalse: [self error: 'This block requires ', nargs printString, ' arguments.']
		! !

!MBlockContext methodsFor: 'as yet unclassified' stamp: 'sw 8/23/2018 00:02'!
asContext

	^ self! !

!MBlockContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:32'!
instVarAt: index put: value
	index = 3 ifTrue: [self stackp: value. ^ value].
	^ super instVarAt: index put: value! !

!MBlockContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:18'!
on: exception do: handlerAction
	"Evaluate the receiver in the scope of an exception handler."

	<primitive: 199>  "just a marker, fail and execute the following"
	^ self value! !

!MBlockContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:19'!
receiver 
	"Refer to the comment in ContextPart|receiver."

	^home receiver! !

!MBlockContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:15'!
valueWithPossibleArgs: anArray 

     "Evaluate the block represented by the receiver. 
     If the block requires arguments, take them from anArray. If anArray is too
     large, the rest is ignored, if it is too small, use nil for the other arguments"

	self numArgs = 0 ifTrue: [^self value].
	self numArgs = anArray size ifTrue: [^self valueWithArguments: anArray].
	self numArgs > anArray size ifTrue: [
		^self valueWithArguments: anArray,
				(MArray new: (self numArgs - anArray size))
	].
	^self valueWithArguments: (anArray copyFrom: 1 to: self numArgs)
! !


MObject subclass: #MMessage
	instanceVariableNames: 'selector arguments lookupClass '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MMessage commentStamp: 'jm 12/8/2003 22:44' prior: 0!
When a message is not understood by its receiver, the virtual machine creates an instance of me to record the selector and arguments of the message and sends the receiver #doesNotUnderstand: with this Message object as the argument. The allows objects to respond the message in some other way if they so choose.
!


!MMessage methodsFor: 'accessing' stamp: 'jm 10/28/2003 09:18'!
arguments
	"Answer the message arguments array."

	^ arguments
! !

!MMessage methodsFor: 'accessing' stamp: 'jm 10/28/2003 09:19'!
lookupClass
	"Answer the message lookupClass."

	^ lookupClass
! !

!MMessage methodsFor: 'accessing' stamp: 'jm 10/28/2003 09:15'!
selector
	"Answer the message selector."

	^ selector
! !


!MMessage methodsFor: 'sending' stamp: 'jm 10/28/2003 09:18'!
sentTo: anObject
	"Answer the result of sending this message to the given object."

	lookupClass == nil
		ifTrue: [^ anObject perform: selector withArguments: arguments]
		ifFalse: [^ anObject perform: selector withArguments: arguments
					inSuperclass: lookupClass].
! !


!MMessage methodsFor: 'printing' stamp: 'jm 12/8/2003 22:44'!
printOn: aStream 
	"Refer to the comment in Object|printOn:."
 
	super printOn: aStream.
	aStream
		nextPutAll: ' selector: ', selector printString;
		nextPutAll: ' args: ', arguments printString.
! !

!MMessage methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:32'!
numArgs
	"Answer the number of arguments in this message"

	^arguments size! !


MContextPart variableSubclass: #MMethodContext
	instanceVariableNames: 'method closureOrNil receiver '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MMethodContext commentStamp: 'jm 11/30/2003 18:45' prior: 0!
I represent the context (stack frame) for an executing method.
!


!MMethodContext methodsFor: 'accessing' stamp: 'jm 11/30/2003 16:49'!
method

	^ method
! !

!MMethodContext methodsFor: 'accessing' stamp: 'jm 10/28/2003 14:08'!
removeSelf
	"Nil the receiver pointer and answer its former value."

	| result |
	result _ receiver.
	receiver _ nil.
	^ result
! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/23/2018 00:09'!
asContext

	^ self! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:32'!
home 
	"Answer the context in which the receiver was defined."

	closureOrNil == nil ifTrue:
		[^self].
	^closureOrNil outerContext home! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:32'!
instVarAt: index put: value
	index = 3 ifTrue: [self stackp: value. ^ value].
	^ super instVarAt: index put: value! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:33'!
outerContext
	"Answer the context within which the receiver is nested."

	^closureOrNil == nil ifFalse:
		[closureOrNil outerContext]! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:32'!
receiver 
	"Refer to the comment in ContextPart|receiver."

	^receiver! !

!MMethodContext methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:17'!
setSender: s receiver: r method: m closure: c startpc: startpc
	"Create the receiver's initial state."

	sender := s.
	receiver := r.
	method := m.
	closureOrNil := c.
	pc := startpc.
	stackp := 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!
	

MDictionary variableSubclass: #MMethodDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MMethodDictionary commentStamp: '<historical>' prior: 0!
I am used by Behaviors to hold the correspondence between selectors (names of methods) and the CompiledMethod objects.

I behave like a normal Dictionary but I am implemented differently. In a normal Dictionary, the instance variable 'array' holds an array of Associations. But since there are thousands of methods in the system, these Associations objects would waste space. Thus, I am implemented as a variable-sized object that keeps the list of keys (selectors) in the indexable fields of the instance and keeps the values (CompiledMethods) in the instance variable 'array'.

Note: The virtual machine depends on my representation. Don't change it unless you really know what you're doing!!
!


!MMethodDictionary methodsFor: 'accessing' stamp: 'jm 10/28/2003 10:20'!
add: anAssociation

	^ self at: anAssociation key put: anAssociation value
! !

!MMethodDictionary methodsFor: 'accessing'!
at: key ifAbsent: aBlock

	| index |
	index _ self findElementOrNil: key.
	(self basicAt: index) == nil ifTrue: [ ^ aBlock value ].
	^ array at: index
! !

!MMethodDictionary methodsFor: 'accessing' stamp: 'jm 10/28/2003 10:20'!
at: key put: value
	"Set the value at key to be value."

	| index |
	index _ self findElementOrNil: key.
	(self basicAt: index) == nil
		ifTrue: 
			[tally _ tally + 1.
			self basicAt: index put: key].
	array at: index put: value.
	self fullCheck.
	^ value
! !

!MMethodDictionary methodsFor: 'accessing' stamp: 'jm 10/28/2003 10:19'!
includesKey: aSymbol
	"This override assumes that pointsTo is a fast primitive."

	^ super pointsTo: aSymbol
! !

!MMethodDictionary methodsFor: 'accessing' stamp: 'jm 11/30/2003 17:11'!
keyAtIdentityValue: value ifAbsent: exceptionBlock
	"Answer the key whose value equals the argument, value. If there is none, answer the result of evaluating exceptionBlock."

	| k |
	1 to: self basicSize do: [:i |
		value == (array at: i) ifTrue: [
			(k _ self basicAt: i) ifNotNil: [^ k]]].
	^ exceptionBlock value
! !


!MMethodDictionary methodsFor: 'removing' stamp: 'jm 10/28/2003 10:21'!
removeKey: key ifAbsent: errorBlock
	"MicroSqueak does not support method removal."

	self shouldNotImplement.
! !


!MMethodDictionary methodsFor: 'enumeration' stamp: 'jm 11/24/2003 09:22'!
associationsDo: aBlock

	| key |
	tally = 0 ifTrue: [^ self].
	1 to: self basicSize do: [:i |
		(key _ self basicAt: i) ifNotNil: [
			aBlock value: (key -> (array at: i))]].
! !

!MMethodDictionary methodsFor: 'enumeration' stamp: 'jm 10/28/2003 10:24'!
do: aBlock

	tally = 0 ifTrue: [^ self].
	1 to: self basicSize do: [:i |
		(self basicAt: i) ifNotNil: [aBlock value: (array at: i)]].
! !

!MMethodDictionary methodsFor: 'enumeration' stamp: 'jm 10/28/2003 10:23'!
keysDo: aBlock

	| key |
	tally = 0 ifTrue: [^ self].
	1 to: self basicSize do: [:i |
		(key _ self basicAt: i) ifNotNil: [aBlock value: key]].
! !


!MMethodDictionary methodsFor: 'copying' stamp: 'jm 12/2/2003 22:32'!
copy
	"Copy my values array."

	^ self basicCopy withArray: array basicCopy
! !


!MMethodDictionary methodsFor: 'private' stamp: 'jm 10/28/2003 10:28'!
grow

	| newSelf key |
	newSelf _ self species new: self basicSize.  "This will double the size"
	1 to: self basicSize do:
		[:i | key _ self basicAt: i.
		key == nil ifFalse: [newSelf at: key put: (array at: i)]].
	self become: newSelf.
! !

!MMethodDictionary methodsFor: 'private'!
keyAt: index

	^ self basicAt: index
! !

!MMethodDictionary methodsFor: 'private' stamp: 'jm 10/28/2003 10:32'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."

	| element start finish |
	start _ (anObject identityHash \\ array size) + 1.
	finish _ array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ self basicAt: index) == nil or: [element == anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ self basicAt: index) == nil or: [element == anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"
! !

!MMethodDictionary methodsFor: 'private' stamp: 'jm 10/28/2003 10:31'!
swap: oneIndex with: otherIndex

	| element |
	element _ self basicAt: oneIndex.
	self basicAt: oneIndex put: (self basicAt: otherIndex).
	self basicAt: otherIndex put: element.
	super swap: oneIndex with: otherIndex.
! !

!MMethodDictionary methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 23:22'!
keyAtValue: value ifAbsent: exceptionBlock
	"Answer the key whose value equals the argument, value. If there is
	none, answer the result of evaluating exceptionBlock."
	
	value ifNotNil: [
		1 to: self basicSize do: [ :index |
			(array at: index) = value ifTrue: [
				^self basicAt: index ] ] ].
	^exceptionBlock value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MMethodDictionary class
	instanceVariableNames: ''!

!MMethodDictionary class methodsFor: 'instance creation' stamp: 'jm 10/28/2003 10:13'!
new: nElements
	"Create a Dictionary large enough to hold nElements without growing."
	"NOTE: The basic size MUST be a power of 2. It is VITAL (see grow) that size gets doubled if nElements is a power of 2."

	| size |
	size _ 1 bitShift: nElements highBit.
	^ (self basicNew: size) init: size
! !


MObject subclass: #MPragma
	instanceVariableNames: 'method keyword arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
arguments
	"Answer the arguments of the receiving pragma. For a pragma defined as <key1: val1 key2: val2> this will answer #(val1 val2)."

	^ arguments! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
key
	"Answer the keyword of the pragma (the selector of its message pattern).
	 This accessor provides polymorphism with Associations used for properties."
	^keyword! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
keyword
	"Answer the keyword of the pragma (the selector of its message pattern).
	 For a pragma defined as <key1: val1 key2: val2> this will answer #key1:key2:."

	^ keyword! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
method
	"Answer the compiled-method containing the pragma."

	^ method! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
numArgs
	"Answer the number of arguments in the pragma."

	^ self arguments size.! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:34'!
selector
	"Answer the selector of the method containing the pragma.
	 Do not confuse this with the selector of the pragma's message pattern."

	^method selector! !

!MPragma methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:37'!
setMethod: aCompiledMethod
	method := aCompiledMethod! !

