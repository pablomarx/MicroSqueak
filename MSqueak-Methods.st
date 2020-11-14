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


MObject subclass: #MContext
	instanceVariableNames: 'sender pc stackp '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!
!MContext commentStamp: '<historical>' prior: 0!
Contexts are used by the virtual machine to represent stack frames. This is an abstract class. My two concrete subclasses are used to represent block and method stack frames.
!


!MContext methodsFor: 'accessing' stamp: 'jm 10/28/2003 13:10'!
sender
	"Answer the context that sent the message that created the receiver."

	^ sender
! !


!MContext methodsFor: 'other' stamp: 'jm 12/31/2003 09:37'!
blockCopy: numArgs 
	"Primitive. Distinguish a block of code from its enclosing method by creating a new BlockContext for that block. The compiler inserts into all methods that contain blocks the bytecodes to send the message blockCopy:. Do not use blockCopy: in code that you write!! Only the compiler can decide to send the message blockCopy:. Fail if numArgs is not a SmallInteger. Optional. No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 80>
	^ (MBlockContext newForMethod: self home method)
		home: self home
		startpc: pc + 2
		nargs: numArgs
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MContext class
	instanceVariableNames: ''!

!MContext class methodsFor: 'instance creation' stamp: 'jm 11/30/2003 16:54'!
newForMethod: aMethod
	"This is the only method for creating new contexts, other than by using the clone primitive. Any other attempts, such as inherited methods like shallowCopy, should be avoided or must at least be rewritten to determine the proper size for the method that will use this context. This is because asking a context its size (even basicSize!!) will not return the actual object size but only the number of fields currently accessible, as determined by stackp."

	^ super basicNew: aMethod frameSize
! !


MContext variableSubclass: #MBlockContext
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


MContext variableSubclass: #MMethodContext
	instanceVariableNames: 'method receiverMap receiver '
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


MObject subclass: #MMethodProperties
	instanceVariableNames: 'properties pragmas selector'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!


MObject subclass: #MPragma
	instanceVariableNames: 'method keyword arguments'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Methods'!

