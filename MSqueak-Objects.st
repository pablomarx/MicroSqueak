Object subclass: #MObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Objects'!
!MObject commentStamp: '<historical>' prior: 0!
I provide default behavior common to all objects, such as class access, copying and printing.
!


!MObject methodsFor: 'initialization' stamp: 'jm 10/28/2003 14:11'!
initialize
	"Initialize this object. Usually called by new when a new object is created. This default implementation does nothing."
! !


!MObject methodsFor: 'accessing' stamp: 'jm 11/28/2003 22:10'!
at: index 
	"Primitive. Assumes receiver is indexable. Answer the value of an indexable element in the receiver. Fail if the argument index is not an  Integer or is out of bounds. Essential. Do not override in a subclass. See Object documentation whatIsAPrimitive."

	<primitive: 60>
	index isInteger ifTrue: [self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^ self basicAt: index asInteger]
		ifFalse: [self errorNonIntegerIndex].
! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/28/2003 22:11'!
at: index put: value 
	"Primitive. Assumes receiver is indexable. Store the second argument 
	value in the indexable element of the receiver indicated by index. Fail 
	if the index is not an Integer or is out of bounds. Or fail if the value is 
	not of the right type for this kind of collection. Answer the value that 
	was stored. Essential. Do not override in a subclass. See Object 
	documentation whatIsAPrimitive."

	<primitive: 61>
	index isInteger
		ifTrue: [
			(index >= 1 and: [index <= self size])
				ifTrue: [self errorImproperStore]
				ifFalse: [self errorSubscriptBounds: index]].
	index isNumber
		ifTrue: [^ self basicAt: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex].
! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/14/2002 14:16'!
basicAt: index 
	"Primitive. Assumes receiver is indexable. Answer the value of an indexable element in the receiver. Fail if the argument index is not an  Integer or is out of bounds. Essential. Do not override in a subclass. See Object documentation whatIsAPrimitive."

	<primitive: 60>
	index isInteger ifTrue: [self errorSubscriptBounds: index].
	index isNumber
		ifTrue: [^ self basicAt: index asInteger]
		ifFalse: [self errorNonIntegerIndex].
! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/14/2002 14:18'!
basicAt: index put: value 
	"Primitive. Assumes receiver is indexable. Store the second argument 
	value in the indexable element of the receiver indicated by index. Fail 
	if the index is not an Integer or is out of bounds. Or fail if the value is 
	not of the right type for this kind of collection. Answer the value that 
	was stored. Essential. Do not override in a subclass. See Object 
	documentation whatIsAPrimitive."

	<primitive: 61>
	index isInteger
		ifTrue: [
			(index >= 1 and: [index <= self size])
				ifTrue: [self errorImproperStore]
				ifFalse: [self errorSubscriptBounds: index]].
	index isNumber
		ifTrue: [^ self basicAt: index asInteger put: value]
		ifFalse: [self errorNonIntegerIndex].
! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/14/2002 14:14'!
basicSize
	"Primitive. Answer the number of indexable variables in the receiver. This value is the same as the largest legal subscript. Essential. Do not override in any subclass. See Object documentation whatIsAPrimitive."

	<primitive: 62>
	^ 0  "for fixed-size objects"
! !

!MObject methodsFor: 'accessing'!
instVarAt: index 
	"Primitive. Answer a fixed variable in an object. The numbering of the 
	variables corresponds to the named instance variables. Fail if the index 
	is not an Integer or is not the index of a fixed variable. Essential. See 
	Object documentation whatIsAPrimitive."

	<primitive: 73>
	"Access beyond fixed variables."
	^self basicAt: index - self class instSize		! !

!MObject methodsFor: 'accessing'!
instVarAt: anInteger put: anObject 
	"Primitive. Store a value into a fixed variable in the receiver. The 
	numbering of the variables corresponds to the named instance variables. 
	Fail if the index is not an Integer or is not the index of a fixed variable. 
	Answer the value stored as the result. Using this message violates the 
	principle that each object has sovereign control over the storing of 
	values into its instance variables. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 74>
	"Access beyond fixed fields"
	^self basicAt: anInteger - self class instSize put: anObject! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/14/2002 14:30'!
species
	"Answer the preferred class for reconstructing the receiver, which is typically some kind of collection. For example, the response to this message determines the type of object returned by the collect: or select: messages. Species and class are not always the same. For example, the species of Interval is Array."

	^ self class
! !

!MObject methodsFor: 'accessing' stamp: 'jm 11/11/2002 19:04'!
yourself
	"Answer the receiver. Useful in cascaded message expressions."
! !


!MObject methodsFor: 'testing'!
ifNil: nilBlock
	"Return self, or evaluate the block if I'm == nil (q.v.)"

	^ self! !

!MObject methodsFor: 'testing'!
ifNil: nilBlock ifNotNil: ifNotNilBlock
	"Evaluate the block, unless I'm == nil (q.v.)"

	^ ifNotNilBlock value! !

!MObject methodsFor: 'testing'!
ifNotNil: ifNotNilBlock
	"Evaluate the block, unless I'm == nil (q.v.)"

	^ ifNotNilBlock value! !

!MObject methodsFor: 'testing'!
ifNotNil: ifNotNilBlock ifNil: nilBlock 
	"If I got here, I am not nil, so evaluate the block ifNotNilBlock"

	^ ifNotNilBlock value! !

!MObject methodsFor: 'testing' stamp: 'jm 11/24/2003 14:20'!
isBehavior
	"Answer true if I am a subclass of Behavior."

	^ false
! !

!MObject methodsFor: 'testing'!
isInteger
	"Overridden to return true in Integer."

	^ false! !

!MObject methodsFor: 'testing' stamp: 'jm 11/11/2002 18:59'!
isNil
	"Answer true if the receiver is nil."

	^ false
! !

!MObject methodsFor: 'testing'!
isNumber
	"Overridden to return true in Number, natch"
	^ false! !

!MObject methodsFor: 'testing' stamp: 'jm 10/27/2003 07:37'!
isSmallInteger

	^ false
! !

!MObject methodsFor: 'testing' stamp: 'sw 8/21/2018 22:39'!
isVariableBinding

	^ false
! !

!MObject methodsFor: 'testing' stamp: 'jm 11/14/2002 14:35'!
pointsTo: anObject
	"Answer true if the receiver contains a reference to the given object."

	<primitive: 132>
	1 to: self class instSize do:
		[:i | (self instVarAt: i) == anObject ifTrue: [^ true]].
	1 to: self basicSize do:
		[:i | (self basicAt: i) == anObject ifTrue: [^ true]].
	^ false
! !


!MObject methodsFor: 'comparing'!
= anObject 
	"Answer whether the receiver and the argument represent the same 
	object. If = is redefined in any subclass, consider also redefining the 
	message hash."

	^self == anObject! !

!MObject methodsFor: 'comparing'!
== anObject 
	"Primitive. Answer whether the receiver and the argument are the same 
	object (have the same object pointer). Do not redefine the message == in 
	any other class!! Essential. No Lookup. Do not override in any subclass. 
	See Object documentation whatIsAPrimitive."

	<primitive: 110>
	self primitiveFailed! !

!MObject methodsFor: 'comparing'!
hash
	"Answer a SmallInteger whose value is related to the receiver's identity.
	May be overridden, and should be overridden in any classes that define = "

	^ self identityHash! !

!MObject methodsFor: 'comparing' stamp: 'jm 11/14/2002 14:21'!
identityHash
	"Answer a SmallInteger whose value is related to the receiver's identity. This method must not be overridden, except by SmallInteger. Primitive. Fails if the receiver is a SmallInteger. Essential. See Object documentation whatIsAPrimitive. Do not override!!"

	<primitive: 75>
	self primitiveFailed
! !

!MObject methodsFor: 'comparing' stamp: 'yo 11/4/2010 22:34'!
scaledIdentityHash
	"For identityHash values returned by primitive 75, answer
	such values times 2^18.  Otherwise, match the existing
	identityHash implementation"

	^self identityHash * 262144 "bitShift: 18"! !

!MObject methodsFor: 'comparing' stamp: 'jm 11/14/2002 14:22'!
~= anObject 
	"Answer whether the receiver and the argument do not represent the same object."

	^ (self = anObject) == false
! !

!MObject methodsFor: 'comparing'!
~~ anObject
	"Answer whether the receiver and the argument are not the same object 
	(do not have the same object pointer)."

	self == anObject
		ifTrue: [^ false]
		ifFalse: [^ true]! !


!MObject methodsFor: 'copying' stamp: 'jm 12/2/2003 22:30'!
basicCopy
	"Answer a copy of the receiver that shares the receiver's instance variables. This is usually handled by the primitive, so the code below is for documentation."

	| class result sz |
	<primitive: 148>
	class _ self class.
	class isVariable
		ifTrue: [
			sz _ self basicSize.
			result _ class basicNew: sz.
			1 to: sz do: [:i | result basicAt: i put: (self basicAt: i)]]
		ifFalse: [
			result _ class basicNew].

	1 to: class instSize do: [:i | result instVarAt: i put: (self instVarAt: i)].
	^ result
! !

!MObject methodsFor: 'copying' stamp: 'jm 12/2/2003 22:36'!
copy
	"Answer a copy of me. Subclasses should usually override this method to change copying behavior, not basicCopy. The exception is classes with unique instances, such as Symbol. This operation does not generally copy all the objects that I refer to.."

	^ self basicCopy
! !


!MObject methodsFor: 'converting' stamp: 'jm 12/2/2003 21:37'!
-> anObject
	"Answer an Association with myself as its key and anObject as its value."

	^ MAssociation new key: self value: anObject
! !

!MObject methodsFor: 'converting' stamp: 'yo 11/4/2010 22:35'!
asSetElement
	"Answer an object, which can be put into a Set as element , wrapped
	by one of SetElement instance, if necessary. 
	Default implementation is to answer self"
! !

!MObject methodsFor: 'converting' stamp: 'yo 11/4/2010 22:38'!
enclosedSetElement
	"The receiver is included into a set as an element. 
	Since some objects require wrappers (see SetElement) to be able to be included into a Set,
	a set sends this message to its element to make sure it getting real object,
	instead of its wrapper.
	Only SetElement instance or its subclasses allowed to answer something different than receiver itself"
	
! !

!MObject methodsFor: 'class membership' stamp: 'jm 12/2/2003 21:32'!
class
	"Primitive. Answer the object which is the receiver's class. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 111>
	self primitiveFailed
! !

!MObject methodsFor: 'class membership' stamp: 'jm 11/14/2002 21:14'!
isKindOf: aClass 
	"Answer whether the class, aClass, is a superclass or class of the receiver."

	self class == aClass
		ifTrue: [^ true]
		ifFalse: [^ self class inheritsFrom: aClass].
! !

!MObject methodsFor: 'class membership' stamp: 'jm 11/14/2002 20:59'!
respondsTo: aSymbol 
	"Answer whether the receiver's class or one of its superclasses has the given symbol as a message selector."

	^ self class canUnderstand: aSymbol
! !


!MObject methodsFor: 'error handling' stamp: 'jm 12/8/2003 22:09'!
doesNotUnderstand: aMessage 
	 "Handle a failed attempt to send the given message to the receiver because the receiver does not implement or inherit a method for the message selector. The 'doesNotUnderstand:' message is sent by the virtual machine when a message send fails. If the receiver has an error handling block, invoke it. Otherwise, report an error."
	"MObject new snark"

	| errorString handler |
	errorString _ 'Message not understood: ', aMessage selector.
	(handler _ Processor activeProcess errorHandler)
		ifNil: [self handleExceptionName: errorString context: thisContext]
		ifNotNil: [handler value: errorString value: self].

	^ aMessage sentTo: self  "resend the message if the user proceeds from the debugger"
! !

!MObject methodsFor: 'error handling' stamp: 'jm 12/8/2003 22:10'!
error: aString 
	"The default behavior for error: is the same as halt:. The code is replicated in order to avoid having an extra message send on the stack. This additional message is the one a subclass should override in order to change the error handling behavior."
	"MObject new error: 'test error'"

	| handler |
	(handler _ Processor activeProcess errorHandler)
		ifNil: [self handleExceptionName: aString context: thisContext]
		ifNotNil: [handler value: aString value: self]
! !

!MObject methodsFor: 'error handling' stamp: 'jm 12/24/2003 09:55'!
handleExceptionName: aString context: aContext
	"Handle an error or halt with the given name in the given context."
	"Not yet implemented. For now, just print the error and exit."	

	MObject superclass
		ifNil: [
			self putString: aString; putcr.
			MSystem exitToDebugger]  "exit to the VM debugger"
		ifNotNil: [super error: aString].  "running in Squeak; use Squeak error handler"
! !


!MObject methodsFor: 'errors' stamp: 'jm 12/2/2003 21:28'!
errorImproperStore
	"Error: an improper store was attempted."

	self error: 'Improper store into indexable object.'
! !

!MObject methodsFor: 'errors' stamp: 'jm 12/2/2003 21:27'!
errorNonIntegerIndex
	"Error: attempting to use a non-integer object as an index."

	self error: 'Only integers should be used as indices.'
! !

!MObject methodsFor: 'errors' stamp: 'jm 12/2/2003 21:28'!
errorSubscriptBounds: index 
	"Error: the given index is out of range."

	self error: 'Subscript is out of bounds: ', index printString
! !

!MObject methodsFor: 'errors' stamp: 'jm 12/17/2003 22:01'!
mustBeBoolean
	"Error: attempt to use a non-Boolean object as if it were true or false. This message is sent by the virtual machine."

	self error: 'NonBoolean receiver.'.
	^ true
! !

!MObject methodsFor: 'errors' stamp: 'jm 10/27/2003 06:09'!
primitiveFailed
	"Announce that a primitive has failed."

	self error: 'a primitive has failed'.
! !

!MObject methodsFor: 'errors' stamp: 'jm 11/14/2002 14:24'!
shouldNotImplement
	"Announce that, although the receiver inherits this message, it should not implement it."

	self error: 'This message is not appropriate for this object'
! !

!MObject methodsFor: 'errors' stamp: 'jm 11/14/2002 14:26'!
subclassResponsibility
	"This message sets up a framework for the behavior of subclasses of this class. Announce that the subclass should have implemented this message."

	self error: 'My subclass should have overridden one of my messages.'
! !


!MObject methodsFor: 'perform' stamp: 'jm 11/13/2002 16:54'!
perform: aSymbol 
	"Primitive. Send the receiver the unary message indicated by the 
	argument. The argument is the selector of the message. Invoke 
	messageNotUnderstood: if the number of arguments expected by the 
	selector is not zero. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol withArguments: (MArray new: 0)
! !

!MObject methodsFor: 'perform' stamp: 'jm 11/13/2002 16:54'!
perform: aSymbol with: anObject 
	"Primitive. Send the receiver the keyword message indicated by the 
	arguments. The first argument is the selector of the message. The other 
	argument is the argument of the message to be sent. Invoke 
	messageNotUnderstood: if the number of arguments expected by the 
	selector is not one. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 83>
	^ self perform: aSymbol withArguments: (MArray with: anObject)
! !

!MObject methodsFor: 'perform' stamp: 'jm 12/2/2003 21:34'!
perform: selector withArguments: anArray 
	"Primitive. Send the receiver the keyword message indicated by the 
	arguments. The argument, selector, is the selector of the message. The 
	arguments of the message are the elements of anArray. Invoke 
	messageNotUnderstood: if the number of arguments expected by the 
	selector is not the same as the length of anArray. Essential. See Object 
	documentation whatIsAPrimitive."

	<primitive: 84>
	(selector class = MByteSymbol)
		ifFalse: [^ self error: 'selector argument must be a Symbol'].
	self primitiveFailed! !

!MObject methodsFor: 'perform' stamp: 'jm 12/2/2003 21:34'!
perform: selector withArguments: argArray inSuperclass: lookupClass
	"NOTE:  This is just like perform:withArguments: except that the message lookup process begins, not with the receivers's class, but with the supplied superclass instead. It will fail if lookupClass cannot be found among the receiver's superclasses. Primitive. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 100>
	(selector class = MByteSymbol)
		ifFalse: [^ self error: 'selector argument must be a Symbol'].
	(selector numArgs = argArray size)
		ifFalse: [^ self error: 'incorrect number of arguments'].
	(self class == lookupClass or: [self class inheritsFrom: lookupClass])
		ifFalse: [^ self error: 'lookupClass is not in my inheritance chain'].
	self primitiveFailed.
! !


!MObject methodsFor: 'printing' stamp: 'jm 12/2/2003 21:30'!
printOn: aStream 
	"Print a description of me on the given stream."

	| n |
	n _ self class name.
	aStream nextPutAll: (n first isVowel ifTrue: ['an '] ifFalse: ['a ']), n
! !

!MObject methodsFor: 'printing' stamp: 'jm 12/2/2003 21:31'!
printString
	"Answer a string describing me."

	| stream |
	stream _ MWriteStream on: (MByteString new: 100).
	self printOn: stream.
	^ stream contents
! !

!MObject methodsFor: 'printing' stamp: 'jm 12/22/2003 16:22'!
putString: aString
	"Write the given string to the standard output stream."

	aString do: [:ch | self putAscii: ch asciiValue].
! !

!MObject methodsFor: 'printing' stamp: 'jm 12/22/2003 16:38'!
putcr
	"Write a carriage return to the standard output stream."

	self putAscii: 13.
! !


!MObject methodsFor: 'system primitives' stamp: 'jm 11/13/2002 16:53'!
become: otherObject 
	"Swap the object pointers of the receiver and the argument. After this, all variables in the entire system that used to point to the receiver now point to the argument, and vice-versa. Fails if either object is a SmallInteger."

	(MArray with: self)
		elementsExchangeIdentityWith: (MArray with: otherObject)
! !

!MObject methodsFor: 'system primitives' stamp: 'jm 12/2/2003 08:11'!
beep
	"Emit a short beep sound. Do nothing if the primitive fails."

	<primitive: 140>
! !

!MObject methodsFor: 'system primitives' stamp: 'jm 11/14/2002 20:23'!
nextInstance
	"Primitive. Answer the next instance after the receiver in the enumeration of all instances of this class. Fails if all instances have been enumerated. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 78>
	^ nil
! !

!MObject methodsFor: 'system primitives' stamp: 'jm 10/27/2003 06:10'!
nextObject
	"Primitive. Answer the next object after the receiver in the enumeration of all objects. Answer 0 when all objects have been enumerated."

	<primitive: 139>
	self primitiveFailed
! !

!MObject methodsFor: 'system primitives' stamp: 'jm 12/22/2003 16:02'!
putAscii: asciiValue
	"Put the given ascii character (0..255) to standard output. Do nothing if this primitive is not supported."
	
	<primitive: 249>
! !

!MObject methodsFor: 'system primitives' stamp: 'jm 10/27/2003 06:09'!
someObject
	"Primitive. Answer the first object in the enumeration of all objects."

	<primitive: 138>
	self primitiveFailed
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MObject class
	instanceVariableNames: ''!

!MObject class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:32'!
cannotInstantiate
	"This message is sent if you try to create new instances of classes with unique instances such as booleans or characters."

	self error: 'You cannot create new instances of ', self name
! !

!MObject class methodsFor: 'instance creation' stamp: 'jm 10/28/2003 14:10'!
new
	"Create a new instance of me and initialize it."

	^ self basicNew initialize
! !


MObject subclass: #MTrue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Objects'!
!MTrue commentStamp: '<historical>' prior: 0!
I represent the logical value true.
!


!MTrue methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:15'!
& alternativeObject 
	"Answer true if both the receiver AND the argument are true. Unlike and:, the argument is always evaluted."

	^ alternativeObject
! !

!MTrue methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:42'!
and: alternativeBlock 
	"Answer true if both the receiver AND the result of evaluating the given block are true. Only evaluate the given block if the receiver is true."

	^ alternativeBlock value
! !

!MTrue methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:23'!
not
	"Answer the negation of the receiver."

	^ false
! !

!MTrue methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:43'!
or: alternativeBlock 
	"Answer true if either the receiver OR the argument are true. Only evaluate the given block if the receiver is false."

	^ true
! !

!MTrue methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:23'!
| aBoolean 
	"Answer true if either the receiver OR the argument are true. Unlike or:, the argument is always evaluted."

	^ true
! !


!MTrue methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:30'!
ifFalse: falseBlock 
	"If the receiver is false, answer the result of evaluating the given block. Otherwise, answer nil. Raise an error notification if the receiver is not a boolean. Execution does not actually reach here because the expression is compiled in-line."

	^ nil
! !

!MTrue methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:30'!
ifTrue: trueBlock 
	"If the receiver is true, answer the result of evaluating the given block. Otherwise, answer nil. Raise an error notification if the true is not a boolean. Execution does not actually reach here because the expression is compiled in-line."

	^ trueBlock value
! !

!MTrue methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:28'!
ifTrue: trueBlock ifFalse: falseBlock 
	"If the receiver is true, answer the result of evaluating trueBlock. Otherwise, answer the result of evaluating falseBlock. Raise an error notification if the receiver is not a boolean. Execution does not actually reach here because this message is compiled in-line."

	^ trueBlock value
! !


!MTrue methodsFor: 'copying' stamp: 'jm 12/2/2003 22:24'!
basicCopy 
	"There is the only one instance of me, so answer myself."
! !


!MTrue methodsFor: 'printing' stamp: 'jm 11/11/2002 19:00'!
printOn: aStream 

	aStream nextPutAll: 'true'.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MTrue class
	instanceVariableNames: ''!

!MTrue class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:25'!
new
	"There is a single unique instance of each boolean."

	self cannotInstantiate.
! !


MTrue subclass: #MFalse
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Objects'!
!MFalse commentStamp: '<historical>' prior: 0!
I represent the logical value true.
!


!MFalse methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:37'!
& aBoolean 
	"Answer true if both the receiver AND the argument are true. Unlike and:, the argument is always evaluted."

	^ false
! !

!MFalse methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:43'!
and: alternativeBlock 
	"Answer true if both the receiver AND the result of evaluating the given block are true. Only evaluate the given block if the receiver is true."

	^ false
! !

!MFalse methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:37'!
not
	"Answer the negation of the receiver."

	^ true
! !

!MFalse methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:44'!
or: alternativeBlock 
	"Answer true if either the receiver OR the argument are true. Only evaluate the given block if the receiver is false."

	^ alternativeBlock value
! !

!MFalse methodsFor: 'logical operations' stamp: 'jm 11/11/2002 18:37'!
| aBoolean 
	"Answer true if either the receiver OR the argument are true. Unlike or:, the argument is always evaluted."

	^ aBoolean
! !


!MFalse methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:39'!
ifFalse: falseBlock 
	"If the receiver is false, answer the result of evaluating the given block. Otherwise, answer nil. Raise an error notification if the receiver is not a boolean. Execution does not actually reach here because the expression is compiled in-line."

	^ falseBlock value
! !

!MFalse methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:39'!
ifTrue: trueBlock 
	"If the receiver is true, answer the result of evaluating the given block. Otherwise, answer nil. Raise an error notification if the true is not a boolean. Execution does not actually reach here because the expression is compiled in-line."

	^ nil
! !

!MFalse methodsFor: 'controlling' stamp: 'jm 11/11/2002 18:40'!
ifTrue: trueBlock ifFalse: falseBlock 
	"If the receiver is true, answer the result of evaluating trueBlock. Otherwise, answer the result of evaluating falseBlock. Raise an error notification if the receiver is not a boolean. Execution does not actually reach here because this message is compiled in-line."

	^ falseBlock value
! !


!MFalse methodsFor: 'printing' stamp: 'jm 11/11/2002 19:00'!
printOn: aStream 

	aStream nextPutAll: 'false'.
! !


MObject subclass: #MUndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Objects'!
!MUndefinedObject commentStamp: '<historical>' prior: 0!
I describe the behavior of my sole instance, nil, an object used as the value of variables or array elements that have not been initialized or for results that are meaningless.
!


!MUndefinedObject methodsFor: 'testing' stamp: 'jm 11/11/2002 18:57'!
isNil 
	"Answer true if the receiver is nil."

	^ true
! !


!MUndefinedObject methodsFor: 'controlling'!
ifNil: aBlock
	"A convenient test, in conjunction with Object ifNil:"

	^ aBlock value! !

!MUndefinedObject methodsFor: 'controlling'!
ifNil: nilBlock ifNotNil: ifNotNilBlock
	"Evaluate the block for nil because I'm == nil"

	^ nilBlock value! !

!MUndefinedObject methodsFor: 'controlling'!
ifNotNil: aBlock
	"A convenient test, in conjunction with Object ifNotNil:"

	^ self! !


!MUndefinedObject methodsFor: 'copying' stamp: 'jm 12/2/2003 22:24'!
basicCopy
	"There is the only one instance of me, so answer myself."
! !


!MUndefinedObject methodsFor: 'printing' stamp: 'jm 11/11/2002 18:53'!
printOn: aStream 

	aStream nextPutAll: 'nil'.
! !

!MUndefinedObject methodsFor: 'sets support' stamp: 'yo 11/8/2010 11:31'!
asSetElement
	"Since nil is a singleton, we need only a single wrapper instance to represent it in set,
	created in advance"
	^ MSetElement withNil! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MUndefinedObject class
	instanceVariableNames: ''!

!MUndefinedObject class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:24'!
new
	"There is a single unique instance of me."

	self cannotInstantiate.
! !

