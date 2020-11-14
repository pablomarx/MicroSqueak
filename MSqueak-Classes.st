MObject subclass: #MBehavior
	instanceVariableNames: 'superclass methodDict format dummy1 dummy2 dummy3 '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Classes'!
!MBehavior commentStamp: 'jm 12/31/2003 09:25' prior: 0!
I describe the behavior of other objects. I provide the minimum state needed by the virtual machine to lookup and execute methods. Most objects are actually instances of my richer subclass, Class, but I may a good starting point for providing instance-specific object behavior.

Note: The virtual machine depends on the exact ordering of my instance variables.

Note: For debugging purposes, three dummy instance variables have been added. This allows existing VM's to find class names during debugging and stack printing.
!


!MBehavior methodsFor: 'initialization' stamp: 'jm 11/24/2003 09:23'!
initialize
	"Default initialization."

	superclass _ MObject.
	format _ 2.
	methodDict _ MMethodDictionary new.
! !


!MBehavior methodsFor: 'instance creation' stamp: 'jm 10/28/2003 13:55'!
basicNew
	"Primitive. Answer an instance of the receiver (which is a class) with no indexable fields. Fail if the class is variable-sized. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 70>
	self isVariable ifTrue: [^ self basicNew: 0].
	"space must be low"
	self error: 'low space'.
! !

!MBehavior methodsFor: 'instance creation' stamp: 'jm 10/28/2003 13:55'!
basicNew: desiredSize 
	"Primitive. Answer an instance of this class with the given number of indexable variables. Fail if this class is not indexable, if the argument is not a positive Integer, or if there is not enough memory available. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 71>
	self isVariable ifFalse: [
		self error: self name, ' is not variable-sized'].
	(desiredSize isInteger not or: [desiredSize < 0]) ifTrue: [
		self error: 'bad size'].
	self error: 'low space'.
! !

!MBehavior methodsFor: 'instance creation' stamp: 'jm 11/23/2003 10:00'!
new

	^ self basicNew
! !

!MBehavior methodsFor: 'instance creation' stamp: 'jm 11/23/2003 09:58'!
new: desiredSize

	^ self basicNew: desiredSize
! !


!MBehavior methodsFor: 'accessing' stamp: 'jm 11/23/2003 10:16'!
allInstVarNames
	"Answer an Array of the names of all my instance variables."

	^ (1 to: self instSize) collect: [:i | 'instVar', i printString].
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/26/2003 18:38'!
classPool

	^ nil
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/24/2003 14:20'!
isBehavior
	"Answer true if I am a subclass of Behavior."

	^ true
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/14/2002 17:44'!
methodDict
	"Answer my method dictionary."

	^ methodDict
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/14/2002 21:09'!
name
	"Answer a String that names the receiver as well possible. Overridden by my subclasses."

	superclass
		ifNil: [^ 'a subclass of nil']
		ifNotNil: [^ 'a subclass of ', superclass name].
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/23/2003 13:24'!
selectorAtMethod: method setClass: classResultBlock 
	"Answer the message selector associated with the compiled method and evaluate the classResultBlock on the class in which that selector is defined."
	"Note: This method is here only to support the Squeak debugger."

	| sel |
	sel _ self methodDict
		keyAtIdentityValue: method
		ifAbsent: [
			superclass ifNil: [
				classResultBlock value: self.
				^ #DoIt].
			sel _ superclass selectorAtMethod: method setClass: classResultBlock.
			sel == #DoIt ifTrue: [classResultBlock value: self].  "if selector is DoIt, set class to me"
			^ sel].
	classResultBlock value: self.
	^ sel
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/26/2003 18:38'!
sharedPools

	^ nil
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/14/2002 17:02'!
superclass
	"Answer my superclass."

	^ superclass
! !

!MBehavior methodsFor: 'accessing' stamp: 'jm 11/23/2003 11:46'!
superclass: aBehaviorOrNil
	"Set my superclass."

	superclass _ aBehaviorOrNil.
! !


!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:29'!
format
	"Answer a integer that encodes the format of instances of this class receiver. For now, this format word has exactly the same format as normal Squeak."

	^ format
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:33'!
indexIfCompact
	"If my compact class index is non-zero, then instances of this class will be compact, and their class will have an entry in Smalltalk compactClassesArray."

	^ (format bitShift: -11) bitAnd: 16r1F
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:17'!
instSize
	"Answer the number of named instance variables of the receiver. Objects can have up to 255 instance variables."

	^ ((format bitShift: -10) bitAnd: 16rC0) + ((format bitShift: -1) bitAnd: 16r3F) - 1
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:23'!
instSpec

	^ (format bitShift: -7) bitAnd: 16rF
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:25'!
isBits
	"Answer whether the receiver contains just bits (not pointers)."

	^ self instSpec >= 6
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:24'!
isBytes
	"Answer true if the receiver is byte-indexable. This is always false for non-indexable and pointer objects."

	^ self instSpec >= 8
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:25'!
isPointers
	"Answer true if the receiver contains object pointers (versus bytes or words)."

	^ self isBits not
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/23/2003 10:24'!
isVariable
	"Answer true if the receiver has indexable fields."

	^ self instSpec >= 2
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 11/27/2003 09:55'!
setCompactClassIndex: ccIndex
	"If my compact class index is non-zero, then instances of this class will be compact, and their class will have an entry in Smalltalk compactClassesArray."

	((ccIndex > 0) and: [ccIndex <= 31]) ifFalse: [^ self error: 'compact class index must 1-31'].
	self indexIfCompact = 0 ifFalse: [^ self error: self name, ' is already compact!!'].
	format _ format + (ccIndex bitShift: 11).
! !

!MBehavior methodsFor: 'format accessing' stamp: 'jm 12/1/2003 22:26'!
setFormat: anInteger
	"Warning!! Risky operation. Should only be done when there are not instances of this class."

	format _ anInteger.
! !


!MBehavior methodsFor: 'subclasses and superclasses' stamp: 'jm 12/8/2003 22:13'!
canUnderstand: selector 
	"Answer whether the receiver can respond to the message whose selector is the argument. The selector can be in the method dictionary of the receiver's class or any of its superclasses."

	^ (self lookupSelector: selector) ~~ nil
! !

!MBehavior methodsFor: 'subclasses and superclasses' stamp: 'jm 11/14/2002 20:25'!
inheritsFrom: aClass 
	"Answer whether the argument is on the receiver's superclass chain."

	| this |
	this _ superclass.
	[this == nil] whileFalse: [
		this == aClass ifTrue: [^true].
		this _ this superclass].
	^ false
! !

!MBehavior methodsFor: 'subclasses and superclasses' stamp: 'jm 11/30/2003 18:33'!
lookupSelector: selector
	"Look up the given selector in the methodDictionaries of every class in my superclass chain and answer the corresponding method if found. Answer nil if no method is found."

	| lookupClass mDict |
	lookupClass _ self.
	[lookupClass == nil] whileFalse: [
		mDict _ lookupClass methodDict.
		(mDict includesKey: selector) ifTrue: [^ mDict at: selector].
		lookupClass _ lookupClass superclass].
	^ nil
! !


!MBehavior methodsFor: 'instance enumeration' stamp: 'jm 10/27/2003 06:27'!
allInstances 
	"Answer a collection of all current instances of the receiver."

	| all |
	all _ MOrderedCollection new.
	self allInstancesDo: [:x | x == all ifFalse: [all add: x]].
	^ all asArray
! !

!MBehavior methodsFor: 'instance enumeration' stamp: 'jm 11/14/2002 20:22'!
allInstancesDo: aBlock
	"Evaluate the given block for each instance of the receiver."

	| inst |
	self == MUndefinedObject ifTrue: [^ aBlock value: nil].
	inst _ self someInstance.
	[inst == nil] whileFalse: [
		aBlock value: inst.
		inst _ inst nextInstance].
! !

!MBehavior methodsFor: 'instance enumeration' stamp: 'jm 10/27/2003 06:14'!
someInstance
	"Primitive. Answer the first instance in the enumeration of all instances of the receiver. Answer nil if there are none. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 77>
	^ nil
! !


!MBehavior methodsFor: 'printing' stamp: 'jm 11/23/2003 12:55'!
printOn: aStream 

	aStream nextPutAll: self name.
! !


MBehavior subclass: #MClass
	instanceVariableNames: 'name instVarNames classVariables '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Classes'!
!MClass commentStamp: '<historical>' prior: 0!
I add the following facilities to Behavior:
	o class name
	o named instance variables
	o an optional dictionary of class variables
!


!MClass methodsFor: 'initialization' stamp: 'jm 11/24/2003 23:06'!
initFrom: aSqueakClass methodDict: newMethodDict
	"Fill in my instance variables from the given Squeak Class using the given MethodDictionary."

	superclass _ MObject.  "corrected later"
	methodDict _ newMethodDict.
	format _ aSqueakClass format.
	name _ (aSqueakClass name copyFrom: 2 to: aSqueakClass name size) asSymbol.  "omit leading M"
	instVarNames _ aSqueakClass instVarNames.
	classVariables _ aSqueakClass classPool.

	instVarNames size = 0 ifTrue: [instVarNames _ nil].
	classVariables size = 0 ifTrue: [classVariables _ nil].
! !


!MClass methodsFor: 'accessing' stamp: 'jm 11/23/2003 13:30'!
classVariables
	"Answer the dictionary of class variables that I share with my sole instance, or nil if I have none."

	^ classVariables
! !

!MClass methodsFor: 'accessing' stamp: 'jm 10/28/2003 08:37'!
instVarNames
	"Answer an Array of the receiver's instance variable names."

	instVarNames ifNil: [^ #()].
	^ instVarNames
! !

!MClass methodsFor: 'accessing' stamp: 'jm 10/28/2003 08:49'!
name

	^ name
! !


MBehavior subclass: #MMetaclass
	instanceVariableNames: 'soleInstance '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Classes'!
!MMetaclass commentStamp: 'jm 11/30/2003 10:30' prior: 0!
My instances support class-specific class behavior such as class initialization and instance creation messages. There is a subclass of me for every normal class, and there is exactly one instance of each of these subclasses, one for each class. Subclasses of me get their names and class pools from their associated class.

In general, the superclass hierarchy for metaclasses parallels that of their classes. For example:

	Integer superclass == Number, and
	Integer class superclass == Number class

However there is a singularity at Object. Here the class hierarchy terminates, but the metaclass hierarchy must wrap around to Class, since ALL metaclasses are subclasses of Class. Thus,

	Object superclass == nil, but
	Object class superclass == Class

If this is confusing, don't worry; it doesn't really matter unless you're trying to change the way classes work.
!


!MMetaclass methodsFor: 'initialization' stamp: 'jm 11/30/2003 10:04'!
initMethodDict: newMethodDict
	"Initialize myself with the given method dictionary. Create but do not initialize my soleInstance."

	superclass _ MClass.
	methodDict _ newMethodDict.
	format _ MClass format.  "all metaclasses have the same format as MClass"
	soleInstance _ self basicNew.
! !


!MMetaclass methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:23'!
new
	"Each metaclass should have exactly one instance."

	self cannotInstantiate.
! !


!MMetaclass methodsFor: 'accessing' stamp: 'jm 11/23/2003 10:56'!
name
	"Answer my name, either 'Metaclass' or the name of my class followed by ' class'."

	soleInstance 
		ifNil: [^ 'Metaclass']
		ifNotNil: [^ soleInstance name, ' class'].
! !

!MMetaclass methodsFor: 'accessing' stamp: 'jm 11/23/2003 10:55'!
soleInstance
	"Answer my only instance."

	^ soleInstance
! !

