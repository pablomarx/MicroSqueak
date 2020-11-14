MObject subclass: #MMagnitude
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MMagnitude commentStamp: '<historical>' prior: 0!
I hold shared behavior for objects that measure something linear such numbers, dates, and times. I support comparisons via <, =, and >, as well as min/max.
!


!MMagnitude methodsFor: 'comparing'!
< aMagnitude 
	"Answer whether the receiver is less than the argument."

	^self subclassResponsibility! !

!MMagnitude methodsFor: 'comparing'!
<= aMagnitude 
	"Answer whether the receiver is less than or equal to the argument."

	^(self > aMagnitude) not! !

!MMagnitude methodsFor: 'comparing'!
= aMagnitude 
	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^self subclassResponsibility! !

!MMagnitude methodsFor: 'comparing'!
> aMagnitude 
	"Answer whether the receiver is greater than the argument."

	^aMagnitude < self! !

!MMagnitude methodsFor: 'comparing'!
>= aMagnitude 
	"Answer whether the receiver is greater than or equal to the argument."

	^(self < aMagnitude) not! !

!MMagnitude methodsFor: 'comparing'!
between: min and: max 
	"Answer whether the receiver is less than or equal to the argument, max, 
	and greater than or equal to the argument, min."

	^self >= min and: [self <= max]! !

!MMagnitude methodsFor: 'comparing'!
hash
	"Hash must be redefined whenever = is redefined."

	^self subclassResponsibility! !


!MMagnitude methodsFor: 'testing'!
max: aMagnitude 
	"Answer the receiver or the argument, whichever has the greater 
	magnitude."

	self > aMagnitude
		ifTrue: [^self]
		ifFalse: [^aMagnitude]! !

!MMagnitude methodsFor: 'testing'!
min: aMagnitude 
	"Answer the receiver or the argument, whichever has the lesser 
	magnitude."

	self < aMagnitude
		ifTrue: [^self]
		ifFalse: [^aMagnitude]! !


MMagnitude subclass: #MCharacter
	instanceVariableNames: 'value '
	classVariableNames: 'CharacterTable '
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MCharacter commentStamp: '<historical>' prior: 0!
I represent a character by storing its associated ASCII code (extended to 256 codes). My instances are created uniquely, so that all instances of a character ($R, for example) are identical.
!


!MCharacter methodsFor: 'accessing' stamp: 'jm 11/23/2003 13:10'!
asciiValue
	"Answer the value of the receiver that represents its ascii encoding."

	^ value
! !

!MCharacter methodsFor: 'accessing' stamp: 'jm 11/28/2003 17:29'!
digitValue
	"Answer 0-9 if the receiver is $0-$9, 10-35 if it is $A-$Z, and -1 otherwise. This is used to parse literal numbers of radix 2-36."

	value <= $9 asciiValue 
		ifTrue: [^value - $0 asciiValue].
	value >= $A asciiValue 
		ifTrue: [value <= $Z asciiValue ifTrue: [^value - $A asciiValue + 10]].
	^ -1! !


!MCharacter methodsFor: 'comparing' stamp: 'jm 11/28/2003 17:30'!
< aCharacter 
	"Answer true if my value is less than the given character's value."

	^ self asciiValue < aCharacter asciiValue
! !

!MCharacter methodsFor: 'comparing' stamp: 'jm 11/28/2003 17:30'!
= aCharacter 
	"Primitive. Answer true if the receiver and the argument are the same object (have the same object pointer) and false otherwise. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 110>
	^ self == aCharacter
! !

!MCharacter methodsFor: 'comparing' stamp: 'jm 11/28/2003 17:31'!
> aCharacter 
	"Answer true if my value is greater than the given character's value."

	^ self asciiValue > aCharacter asciiValue
! !

!MCharacter methodsFor: 'comparing' stamp: 'jm 11/28/2003 17:31'!
hash
	"My hash is my value."

	^ value
! !


!MCharacter methodsFor: 'testing' stamp: 'jm 11/28/2003 17:14'!
isDigit
	"Answer whether the receiver is a digit."

	^ value >= 48 and: [value <= 57]
! !

!MCharacter methodsFor: 'testing' stamp: 'jm 11/28/2003 17:13'!
isLetter
	"Answer whether the receiver is a letter."

	^ (65 <= value and: [value <= 90]) or:
		[97 <= value and: [value <= 122]]
! !

!MCharacter methodsFor: 'testing' stamp: 'jm 11/28/2003 17:15'!
isSpecial
	"Answer whether the receiver is one of the special characters"

	^ '+/\*~<>=@%|&?!!' includes: self
! !

!MCharacter methodsFor: 'testing' stamp: 'jm 10/28/2003 11:40'!
isUppercase
	"Answer whether the receiver is an uppercase letter."

	^ 65 <= value and: [value <= 90]
! !

!MCharacter methodsFor: 'testing' stamp: 'jm 11/28/2003 17:16'!
isVowel
	"Answer true if the receiver is one of the vowels AEIOU (either upper- or lowercase)."

	^ 'AEIOU' includes: self asUppercase
! !

!MCharacter methodsFor: 'testing' stamp: 'jm 11/28/2003 17:16'!
tokenish
	"Answer true if the receiver is a valid token-character--that is, a letter, digit, or colon."

	^ self isLetter or: [self isDigit or: [self = $:]]
! !


!MCharacter methodsFor: 'copying' stamp: 'jm 12/2/2003 22:02'!
basicCopy
	"Answer myself because Characters are unique."
! !


!MCharacter methodsFor: 'printing' stamp: 'jm 10/26/2003 17:45'!
printOn: aStream

	aStream nextPut: $$.
	aStream nextPut: self.
! !


!MCharacter methodsFor: 'converting' stamp: 'jm 10/28/2003 11:33'!
asCharacter
	"Answer the receiver itself."

	^ self
! !

!MCharacter methodsFor: 'converting' stamp: 'jm 11/28/2003 17:33'!
asInteger
	"Answer my ASCII value."

	^ value
! !

!MCharacter methodsFor: 'converting' stamp: 'jm 11/28/2003 17:34'!
asLowercase
	"If I am uppercase, answer the matching lowercase Character. Otherwise, answer myself."
	
	(65 <= value and: [value <= 90])  "self isUppercase"
		ifTrue: [^ (value + 32) asCharacter]
		ifFalse: [^ self]
! !

!MCharacter methodsFor: 'converting' stamp: 'jm 11/13/2002 18:19'!
asString

	^ MByteString with: self
! !

!MCharacter methodsFor: 'converting' stamp: 'jm 10/28/2003 11:42'!
asUppercase
	"If the receiver is lowercase, answer its matching uppercase Character."
	
	(97 <= value and: [value <= 122])  "self isLowercase"
		ifTrue: [^ (value - 32) asCharacter]
		ifFalse: [^ self]
! !

!MCharacter methodsFor: 'converting' stamp: 'jm 10/28/2003 11:38'!
to: other
	"Answer with a collection of all characters in the given ASCII range. For example, $a to: $z"

	^ (self asciiValue to: other asciiValue)
		collect: [:i | i asCharacter]
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MCharacter class
	instanceVariableNames: ''!

!MCharacter class methodsFor: 'instance creation' stamp: 'sw 8/15/2018 19:45'!
asciiValue: anInteger 
	"Answer the Character whose ASCII value is anInteger."

	^ self value: anInteger
! !

!MCharacter class methodsFor: 'instance creation' stamp: 'sw 8/15/2018 19:45'!
digitValue: x 
	"Answer the Character whose digit value is x. For example, answer $9 for x=9, $0 for x=0, $A for x=10, $Z for x=35."

	| i |
	i _ x asInteger.
	^ self value: (i < 10 ifTrue: [48 + i] ifFalse: [55 + i]) + 1
! !

!MCharacter class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:25'!
new
	"There are 256 unique Characters; creating new ones is not allowed."

	self cannotInstantiate.
! !

!MCharacter class methodsFor: 'instance creation' stamp: 'sw 8/15/2018 19:45'!
value: anInteger 
	"Answer the MCharacter whose ascii value is anInteger."
	| ch |
	CharacterTable ifNil: [CharacterTable := MArray new: 256].
	ch := CharacterTable at: anInteger + 1.
	ch ifNil: [ ch := super new. ch instVarAt:1 put: anInteger. ch. ].
	^ ch.
! !


!MCharacter class methodsFor: 'constants' stamp: 'jm 11/23/2003 13:06'!
cr
	"Answer the Character representing a carriage return."

	^ 13 asCharacter
! !

!MCharacter class methodsFor: 'constants' stamp: 'jm 11/23/2003 13:06'!
lf
	"Answer the Character representing a linefeed."

	^ 10 asCharacter
! !

!MCharacter class methodsFor: 'constants' stamp: 'jm 11/23/2003 13:06'!
space
	"Answer the Character representing a space."

	^ 32 asCharacter
! !

!MCharacter class methodsFor: 'constants' stamp: 'jm 11/23/2003 13:06'!
tab
	"Answer the Character representing a tab."

	^ 9 asCharacter
! !

MMagnitude subclass: #MNumber
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MNumber commentStamp: '<historical>' prior: 0!
I am the superclass for all numbers. My descendent subclasses provide concrete representations of particular kinds of numbers.

All my subclasses participate in a simple type coercion mechanism that supports mixed-mode arithmetic and comparisons. It works as follows:  If
	self<typeA> op: arg<typeB>
fails because of incompatible types, then it is retried in the following form:
	(arg adaptToTypeA: self) op: arg adaptToTypeA.
This gives the arg of typeB an opportunity to resolve the incompatibility, knowing exactly what two types are involved. If self is more general, then arg will be converted, and viceVersa. This mechanism is extensible to any new number classes that one might wish to add to Squeak. The only requirement is that every subclass of Number must support a pair of conversion methods specific to each of the other subclasses of Number.
!


!MNumber methodsFor: 'arithmetic'!
* aNumber 
	"Answer the result of multiplying the receiver by aNumber."

	self subclassResponsibility! !

!MNumber methodsFor: 'arithmetic'!
+ aNumber 
	"Answer the sum of the receiver and aNumber."

	self subclassResponsibility! !

!MNumber methodsFor: 'arithmetic'!
- aNumber 
	"Answer the difference between the receiver and aNumber."

	self subclassResponsibility! !

!MNumber methodsFor: 'arithmetic'!
/ aNumber 
	"Answer the result of dividing the receiver by aNumber."

	self subclassResponsibility! !

!MNumber methodsFor: 'arithmetic'!
// aNumber 
	"Integer quotient defined by division with truncation toward negative 
	infinity. 9//4 = 2, -9//4 = -3. -0.9//0.4 = -3. \\ answers the remainder 
	from this division."

	^(self / aNumber) floor! !

!MNumber methodsFor: 'arithmetic'!
\\ aNumber 
	"modulo. Remainder defined in terms of //. Answer a Number with the 
	same sign as aNumber. e.g. 9\\4 = 1, -9\\4 = 3, 9\\-4 = -3, 0.9\\0.4 = 0.1."

	^self - (self // aNumber * aNumber)! !

!MNumber methodsFor: 'arithmetic'!
abs
	"Answer a Number that is the absolute value (positive magnitude) of the 
	receiver."

	self < 0
		ifTrue: [^self negated]
		ifFalse: [^self]! !

!MNumber methodsFor: 'arithmetic'!
negated
	"Answer a Number that is the negation of the receiver."

	^0 - self! !

!MNumber methodsFor: 'arithmetic'!
quo: aNumber 
	"Integer quotient defined by division with truncation toward zero. -9 quo: 
	4 = -2, -0.9 quo: 0.4 = -2. rem: answers the remainder from this division."

	^(self / aNumber) truncated! !

!MNumber methodsFor: 'arithmetic'!
reciprocal
	"Answer 1 divided by the receiver. Create an error notification if the 
	receiver is 0."

	self = 0
		ifTrue: [^self error: 'zero has no reciprocal']
		ifFalse: [^1 / self]! !

!MNumber methodsFor: 'arithmetic'!
rem: aNumber 
	"Remainder defined in terms of quo:. Answer a Number with the same 
	sign as self. e.g. 9 rem: 4 = 1, -9 rem: 4 = -1. 0.9 rem: 0.4 = 0.1."

	^self - ((self quo: aNumber) * aNumber)! !


!MNumber methodsFor: 'mathematical functions'!
arcCos 
	"The receiver is the cosine of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcCos! !

!MNumber methodsFor: 'mathematical functions'!
arcSin
	"The receiver is the sine of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcSin! !

!MNumber methodsFor: 'mathematical functions'!
arcTan
	"The receiver is the tangent of an angle. Answer the angle measured in 
	radians."

	^self asFloat arcTan! !

!MNumber methodsFor: 'mathematical functions'!
cos
	"The receiver represents an angle measured in radians. Answer its cosine."

	^self asFloat cos! !

!MNumber methodsFor: 'mathematical functions'!
exp
	"Answer the exponential of the receiver as a floating point number."

	^self asFloat exp! !

!MNumber methodsFor: 'mathematical functions' stamp: 'jm 3/27/98 06:16'!
floorLog: radix
	"Answer the floor of the log base radix of the receiver."

	^ self asFloat floorLog: radix
! !

!MNumber methodsFor: 'mathematical functions'!
ln
	"Answer the natural log of the receiver."

	^self asFloat ln! !

!MNumber methodsFor: 'mathematical functions' stamp: 'di 9/8/1998 17:10'!
log
	"Answer the base-10 log of the receiver."

	^self asFloat log! !

!MNumber methodsFor: 'mathematical functions'!
log: aNumber 
	"Answer the log base aNumber of the receiver."

	^self ln / aNumber ln! !

!MNumber methodsFor: 'mathematical functions'!
raisedTo: aNumber 
	"Answer the receiver raised to aNumber."
	(aNumber isInteger)
		ifTrue: ["Do the special case of integer power"
				^self raisedToInteger: aNumber].
	aNumber = 0 ifTrue: [^1].		"Special case of exponent=0"
	aNumber = 1 ifTrue: [^self].		"Special case of exponent=1"
	^(aNumber * self ln) exp		"Otherwise raise it to the power using logarithms"! !

!MNumber methodsFor: 'mathematical functions'!
raisedToInteger: anInteger 
	"Answer the receiver raised to the power anInteger where the argument 
	must be a kind of Integer. This is a special case of raisedTo:."
	(anInteger isInteger)
		ifFalse: [^self error: 'raisedToInteger: only works for integral arguments'].
	anInteger = 0 ifTrue: [^1].
	anInteger = 1 ifTrue: [^self].
	anInteger > 1 
		ifTrue: [^(self * self raisedToInteger: anInteger // 2)
					* (self raisedToInteger: anInteger \\ 2)].
	^(self raisedToInteger: anInteger negated) reciprocal! !

!MNumber methodsFor: 'mathematical functions'!
sin
	"The receiver represents an angle measured in radians. Answer its sine."

	^self asFloat sin! !

!MNumber methodsFor: 'mathematical functions'!
sqrt
	"Answer the square root of the receiver."

	^self asFloat sqrt! !

!MNumber methodsFor: 'mathematical functions'!
tan
	"The receiver represents an angle measured in radians. Answer its 
	tangent."

	^self asFloat tan! !


!MNumber methodsFor: 'truncation and round off' stamp: 'jm 12/31/2003 10:06'!
ceiling
	"Answer the integer nearest the receiver toward positive infinity."

	self <= 0
		ifTrue: [^ self truncated]
		ifFalse: [^ self negated floor negated]
! !

!MNumber methodsFor: 'truncation and round off'!
floor
	"Answer the integer nearest the receiver toward negative infinity."

	| truncation |
	truncation _ self truncated.
	self >= 0 ifTrue: [^truncation].
	self = truncation
		ifTrue: [^truncation]
		ifFalse: [^truncation - 1]! !

!MNumber methodsFor: 'truncation and round off'!
roundTo: aNumber 
	"Answer the integer that is a multiple of aNumber that is nearest the 
	receiver."

	^(self / aNumber) rounded * aNumber! !

!MNumber methodsFor: 'truncation and round off' stamp: 'jm 11/30/2003 16:40'!
roundUpTo: aNumber 
	"Answer the next multiple of aNumber toward infinity that is nearest the receiver."

	^ (self / aNumber) ceiling * aNumber
! !

!MNumber methodsFor: 'truncation and round off'!
rounded
	"Answer the integer nearest the receiver."

	^(self + (self sign / 2)) truncated! !

!MNumber methodsFor: 'truncation and round off'!
truncateTo: aNumber 
	"Answer the next multiple of aNumber toward zero that is nearest the 
	receiver."

	^(self quo: aNumber)
		* aNumber! !

!MNumber methodsFor: 'truncation and round off'!
truncated
	"Answer an integer nearest the receiver toward zero."

	^self quo: 1! !


!MNumber methodsFor: 'testing'!
isNumber
	^ true! !

!MNumber methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ self < 0! !

!MNumber methodsFor: 'testing'!
sign
	"Answer 1 if the receiver is greater than 0, -1 if less than 0, else 0."

	self > 0 ifTrue: [^1].
	self < 0 ifTrue: [^-1].
	^0! !


!MNumber methodsFor: 'converting' stamp: 'jm 12/2/2003 21:38'!
adaptToFloat: rcvr andSend: selector 
	"If I am involved in arithmetic with a Float, convert me to a Float."

	^ rcvr perform: selector with: self asFloat
! !

!MNumber methodsFor: 'converting' stamp: 'jm 12/2/2003 21:40'!
adaptToInteger: rcvr andSend: selector
	"If I am involved in arithmetic with a Integer, convert us and evaluate exprBlock."

	^ self subclassResponsibility
! !

!MNumber methodsFor: 'converting'!
asInteger
	"Answer an Integer nearest the receiver toward zero."

	^self truncated! !

!MNumber methodsFor: 'converting'!
degreesToRadians
	"The receiver is assumed to represent degrees. Answer the conversion to 
	radians."

	^self asFloat degreesToRadians! !

!MNumber methodsFor: 'converting'!
radiansToDegrees
	"The receiver is assumed to represent radians. Answer the conversion to 
	degrees."

	^self asFloat radiansToDegrees! !


!MNumber methodsFor: 'intervals' stamp: 'jm 11/13/2002 16:59'!
to: stop
	"Answer an Interval from the receiver up to the argument incrementing by 1."

	^ MInterval from: self to: stop by: 1
! !

!MNumber methodsFor: 'intervals' stamp: 'jm 11/13/2002 16:59'!
to: stop by: step
	"Answer an Interval from the receiver up to stop incrementing by step."

	^ MInterval from: self to: stop by: step
! !

!MNumber methodsFor: 'intervals'!
to: stop by: step do: aBlock 
	"Normally compiled in-line, and therefore not overridable.
	Evaluate aBlock for each element of the interval (self to: stop by: step)."
	| nextValue |
	nextValue _ self.
	step < 0
		ifTrue: [[stop <= nextValue]
				whileTrue: 
					[aBlock value: nextValue.
					nextValue _ nextValue + step]]
		ifFalse: [[stop >= nextValue]
				whileTrue: 
					[aBlock value: nextValue.
					nextValue _ nextValue + step]]! !

!MNumber methodsFor: 'intervals'!
to: stop do: aBlock 
	"Normally compiled in-line, and therefore not overridable.
	Evaluate aBlock for each element of the interval (self to: stop by: 1)."
	| nextValue |
	nextValue _ self.
	[nextValue <= stop]
		whileTrue: 
			[aBlock value: nextValue.
			nextValue _ nextValue + 1]! !


!MNumber methodsFor: 'printing'!
printOn: aStream
	"Default print radix is 10"
	self printOn: aStream base: 10! !

!MNumber methodsFor: 'printing' stamp: 'jm 10/29/2003 12:05'!
printStringBase: base

	| stream |
	stream _ MWriteStream on: (MByteString new: 100).
	self printOn: stream base: base.
	^ stream contents
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MNumber class
	instanceVariableNames: ''!

!MNumber class methodsFor: 'instance creation' stamp: 'jm 12/2/2003 21:34'!
readFrom: stringOrStream 
	"Answer a number as described on aStream. The number may include a leading radix specification, as in 16rFADE."

	| value base aStream sign |
	aStream _ (stringOrStream class = MByteString)
		ifTrue: [MReadStream on: stringOrStream]
		ifFalse: [stringOrStream].
	sign _ (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	base _ 10.
	value _ MInteger readFrom: aStream base: base.
	(aStream peekFor: $r) ifTrue: [
		"<base>r<integer>"
		(base _ value) < 2 ifTrue: [^ self error: 'Invalid radix'].
		(aStream peekFor: $-) ifTrue: [sign _ sign negated].
		value _ MInteger readFrom: aStream base: base].
	^ self readRemainderOf: value from: aStream base: base withSign: sign
! !

!MNumber class methodsFor: 'instance creation' stamp: 'jm 12/2/2003 21:34'!
readFrom: stringOrStream base: base
	"Answer a number as described on aStream in the given number base."

	| aStream sign |
	aStream _ (stringOrStream class = MByteString)
		ifTrue: [MReadStream on: stringOrStream]
		ifFalse: [stringOrStream].
	sign _ (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	^ self
		readRemainderOf: (MInteger readFrom: aStream base: base)
		from: aStream base: base withSign: sign
! !

!MNumber class methodsFor: 'instance creation' stamp: 'jm 10/27/2003 07:47'!
readRemainderOf: integerPart from: aStream base: base withSign: sign
	"Read optional fractional part and exponent, and return the final result"
	"MNumber readFrom: (ReadStream on: '3r-22.2')"

	| value fraction fracpos |
	value _ integerPart.
	(aStream peekFor: $.) ifTrue: [  "<integer>.<fraction>"
		(aStream atEnd not and: [aStream peek digitValue between: 0 and: base - 1])
			ifTrue: [
				fracpos _ aStream position.
				fraction _ MInteger readFrom: aStream base: base.
				fraction _ fraction asFloat / (base raisedTo: aStream position - fracpos).
				value _ value asFloat + fraction]
			ifFalse: [ "oops - just <integer>."
				aStream skip: -1.  "un-gobble the period"
				^ value * sign]].

	(aStream peekFor: $e) ifTrue: [  "<integer>e<exponent>"
		value _ value * (base raisedTo: (MInteger readFrom: aStream))].

	^ value * sign
! !


MNumber subclass: #MInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MInteger commentStamp: '<historical>' prior: 0!
MInteger comment:
'I am a common abstract superclass for all Integer implementations. My implementation subclasses are SmallInteger, LargePositiveInteger, and LargeNegativeInteger.
	
Integer division consists of:
	/	exact division, answers a fraction if result is not a whole integer
	//	answers an Integer, rounded towards negative infinity
	\\	is modulo rounded towards negative infinity
	quo: truncated division, rounded towards zero'!


!MInteger methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
* aNumber
	"Refer to the comment in Number * " 
	aNumber isInteger ifTrue:
		[^ self digitMultiply: aNumber 
					neg: self negative ~~ aNumber negative].
	^ aNumber adaptToInteger: self andSend: #*! !

!MInteger methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
+ aNumber
	"Refer to the comment in Number + "
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [^ (self digitAdd: aNumber) normalize]
			ifFalse: [^ self digitSubtract: aNumber]].
	^ aNumber adaptToInteger: self andSend: #+! !

!MInteger methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:59'!
- aNumber
	"Refer to the comment in Number - "
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [^ self digitSubtract: aNumber]
			ifFalse: [^ (self digitAdd: aNumber) normalize]].
	^ aNumber adaptToInteger: self andSend: #-! !

!MInteger methodsFor: 'arithmetic' stamp: 'jm 11/11/2002 20:11'!
/ aNumber
	"Refer to the comment in Number / "

	| quoRem |
	aNumber isInteger ifTrue: [
		quoRem _ self digitDiv: aNumber abs neg: self negative ~~ aNumber negative.
		(quoRem at: 2) = 0
			ifTrue: [^ (quoRem at: 1) normalize]
			ifFalse: [^ self asFloat / aNumber asFloat]].
	^ aNumber adaptToInteger: self andSend: #/
! !

!MInteger methodsFor: 'arithmetic'!
// aNumber

	| q |
	aNumber = 0 ifTrue: [^self error: 'division by 0'].
	self = 0 ifTrue: [^0].
	q _ self quo: aNumber 
	"Refer to the comment in Number|//.".
	(q negative
		ifTrue: [q * aNumber ~= self]
		ifFalse: [q = 0 and: [self negative ~= aNumber negative]])
		ifTrue: [^q - 1"Truncate towards minus infinity"]
		ifFalse: [^q]! !

!MInteger methodsFor: 'arithmetic' stamp: 'jm 10/27/2003 07:39'!
quo: aNumber 
	"Refer to the comment in Number quo: "
	| ng quo |
	aNumber isInteger ifTrue: 
		[ng _ self negative == aNumber negative == false.
		quo _ (self digitDiv:
			(aNumber isSmallInteger
				ifTrue: [aNumber abs]
				ifFalse: [aNumber])
			neg: ng) at: 1.
		^ quo normalize].
	^ aNumber adaptToInteger: self andSend: #quo:! !


!MInteger methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
< aNumber
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [self negative
						ifTrue: [^ (self digitCompare: aNumber) > 0]
						ifFalse: [^ (self digitCompare: aNumber) < 0]]
			ifFalse: [^ self negative]].
	^ aNumber adaptToInteger: self andSend: #<! !

!MInteger methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
= aNumber
	aNumber isNumber ifFalse: [^ false].
	aNumber isInteger ifTrue:
		[aNumber negative == self negative
			ifTrue: [^ (self digitCompare: aNumber) = 0]
			ifFalse: [^ false]].
	^ aNumber adaptToInteger: self andSend: #=! !

!MInteger methodsFor: 'comparing' stamp: 'di 11/6/1998 14:00'!
> aNumber
	aNumber isInteger ifTrue:
		[self negative == aNumber negative
			ifTrue: [self negative
						ifTrue: [^(self digitCompare: aNumber) < 0]
						ifFalse: [^(self digitCompare: aNumber) > 0]]
			ifFalse: [^ aNumber negative]].
	^ aNumber adaptToInteger: self andSend: #>! !

!MInteger methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^(self lastDigit bitShift: 8) + (self digitAt: 1)! !


!MInteger methodsFor: 'testing'!
isInteger
	"True for all subclasses of Integer."

	^ true! !


!MInteger methodsFor: 'truncation and round off'!
ceiling 
	"Refer to the comment in Number|ceiling."! !

!MInteger methodsFor: 'truncation and round off'!
floor 
	"Refer to the comment in Number|floor."! !

!MInteger methodsFor: 'truncation and round off'!
normalize 
	"SmallInts OK; LgInts override"
	^ self! !

!MInteger methodsFor: 'truncation and round off'!
rounded 
	"Refer to the comment in Number|rounded."! !

!MInteger methodsFor: 'truncation and round off'!
truncated 
	"Refer to the comment in Number|truncated."! !


!MInteger methodsFor: 'enumerating'!
timesRepeat: aBlock 
	"Evaluate the argument, aBlock, the number of times represented by the 
	receiver."

	| count |
	count _ 1.
	[count <= self]
		whileTrue: 
			[aBlock value.
			count _ count + 1]! !


!MInteger methodsFor: 'bit manipulation'!
bitAnd: n 
	"Answer an Integer whose bits are the logical AND of the receiver's bits 
	and those of the argument, n."
	| norm |
	norm _ n normalize.
	^ self digitLogic: norm
		op: #bitAnd:
		length: (self digitLength max: norm digitLength)! !

!MInteger methodsFor: 'bit manipulation' stamp: 'di 4/30/1998 10:32'!
bitClear: aMask 
	"Answer an Integer equal to the receiver, except with all bits cleared that are set in aMask."

	^ (self bitOr: aMask) - aMask! !

!MInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitInvert
	"Answer an Integer whose bits are the logical negation of the receiver's bits.
	Numbers are interpreted as having 2's-complement representation."

	^ -1 - self! !

!MInteger methodsFor: 'bit manipulation'!
bitOr: n 
	"Answer an Integer whose bits are the logical OR of the receiver's bits 
	and those of the argument, n."
	| norm |
	norm _ n normalize.
	^self digitLogic: norm
		op: #bitOr:
		length: (self digitLength max: norm digitLength)! !

!MInteger methodsFor: 'bit manipulation'!
bitShift: shiftCount 
	"Answer an Integer whose value (in twos-complement representation) is 
	the receiver's value (in twos-complement representation) shifted left by 
	the number of bits indicated by the argument. Negative arguments shift 
	right. Zeros are shifted in from the right in left shifts."
	| rShift |
	shiftCount >= 0 ifTrue: [^ self digitLshift: shiftCount].
	rShift _ 0 - shiftCount.
	^ (self digitRshift: (rShift bitAnd: 7)
				bytes: (rShift bitShift: -3)
				lookfirst: self digitLength) normalize! !

!MInteger methodsFor: 'bit manipulation'!
bitXor: n 
	"Answer an Integer whose bits are the logical XOR of the receiver's bits 
	and those of the argument, n."
	| norm |
	norm _ n normalize.
	^self
		digitLogic: norm
		op: #bitXor:
		length: (self digitLength max: norm digitLength)! !


!MInteger methodsFor: 'converting' stamp: 'jm 11/23/2003 13:12'!
asCharacter
	"Answer the Character whose value is the receiver."

	^ MCharacter asciiValue: self
! !

!MInteger methodsFor: 'converting' stamp: 'jm 12/31/2003 10:12'!
asFloat
	"Answer a Float that represents the value of the receiver.
	Optimized to process only the significant digits of a LargeInteger.
	SqR: 11/30/1998 21:11"

	| sum firstByte shift |
	shift _ 0.
	sum _ 0.
	firstByte _ self size - 7 max: 1.
	firstByte to: self size do:
		[:byteIndex | 
		sum _ ((self digitAt: byteIndex) asFloat timesTwoPower: shift) + sum.
		shift _ shift + 8].
	^ sum * self sign asFloat timesTwoPower: firstByte - 1 * 8
! !

!MInteger methodsFor: 'converting'!
asInteger
	"Answer with the receiver itself."

	^self

! !


!MInteger methodsFor: 'benchmarks' stamp: 'jm 11/20/1998 07:06'!
benchFib  "Handy send-heavy benchmark"
	"(result // seconds to run) = approx calls per second"
	" | r t |
	  t _ Time millisecondsToRun: [r _ 26 benchFib].
	  (r * 1000) // t"
	"138000 on a Mac 8100/100"
	^ self < 2
		ifTrue: [1] 
		ifFalse: [(self-1) benchFib + (self-2) benchFib + 1]
! !

!MInteger methodsFor: 'benchmarks' stamp: 'jm 12/31/2003 12:50'!
benchmark  "Handy bytecode-heavy benchmark"
	"(500000 // time to run) = approx bytecodes per second"
	"5000000 // (Time millisecondsToRun: [10 benchmark]) * 1000"
	"3059000 on a Mac 8100/100"
    | size flags prime k count |
    size _ 8190.
    1 to: self do:
        [:iter |
        count _ 0.
        flags _ (1 to: size) collect: [:i | true].
        1 to: size do:
            [:i | (flags at: i) ifTrue:
                [prime _ i+1.
                k _ i + prime.
                [k <= size] whileTrue:
                    [flags at: k put: false.
                    k _ k + prime].
                count _ count + 1]]].
    ^ count! !


!MInteger methodsFor: 'printing' stamp: 'jm 10/26/2003 13:29'!
printOn: aStream base: b 
	"Print a representation of the receiver on the stream, aStream, in base, b, 
	where 2<=b<=16."
	| digits source dest i j pos t rem |
	b = 10 ifFalse: [b printOn: aStream. aStream nextPut: $r].
	i _ self digitLength.
	"Estimate size of result, conservatively"
	digits _ MArray new: i * 8.
	pos _ 0.
	dest _ i <= 1
		ifTrue: [self]
		ifFalse: [MLargePositiveInteger new: i].
	source _ self.
	[i >= 1]
		whileTrue: 
			[rem _ 0.
			j _ i.
			[j > 0]
				whileTrue: 
					[t _ (rem bitShift: 8) + (source digitAt: j).
					dest digitAt: j put: t // b.
					rem _ t \\ b.
					j _ j - 1].
			pos _ pos + 1.
			digits at: pos put: rem.
			source _ dest.
			(source digitAt: i) = 0 ifTrue: [i _ i - 1]].
	"(dest digitAt: 1) printOn: aStream base: b."
	[pos > 0]
		whileTrue:
			[aStream nextPut: (MCharacter digitValue: (digits at: pos)).
			pos _ pos - 1]! !


!MInteger methodsFor: 'system primitives'!
lastDigit
	"Answer the last digit of the integer."

	^self digitAt: self digitLength! !

!MInteger methodsFor: 'system primitives'!
replaceFrom: start to: stop with: replacement startingAt: repStart
	| j |  "Catches failure if LgInt replace primitive fails"
	j _ repStart.
	start to: stop do:
		[:i |
		self digitAt: i put: (replacement digitAt: j).
		j _ j+1]! !


!MInteger methodsFor: 'private'!
copyto: x
	| stop |
	stop _ self digitLength min: x digitLength.
	^ x replaceFrom: 1 to: stop with: self startingAt: 1! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitAdd: arg
	| len arglen accum sum |
	accum _ 0.
	(len _ self digitLength) < (arglen _ arg digitLength)
		ifTrue: [len _ arglen].
	"Open code max: for speed"
	sum _ MInteger new: len neg: self negative.
	1 to: len do: 
		[:i |
		accum _ (accum bitShift: -8) + (self digitAt: i) + (arg digitAt: i).
		sum digitAt: i put: (accum bitAnd: 255)].
	accum > 255 ifTrue: 
			[sum _ sum growby: 1.
			sum at: sum digitLength put: (accum bitShift: -8)].
	^sum! !

!MInteger methodsFor: 'private'!
digitCompare: arg
	"Compare the magnitude of self with that of arg.
	Return a code of 1, 0, -1 for self >, = , < arg"
	| len arglen argDigit selfDigit |
	len _ self digitLength.
	(arglen _ arg digitLength) ~= len 
		ifTrue: [arglen > len
					ifTrue: [^-1]
					ifFalse: [^1]].
	[len > 0]
		whileTrue: 
			[(argDigit _ arg digitAt: len) ~= (selfDigit _ self digitAt: len) 
				ifTrue: [argDigit < selfDigit
							ifTrue: [^1]
							ifFalse: [^-1]].
			len _ len - 1].
	^0! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitDiv: arg neg: ng 
	"Answer with an array of (quotient, remainder)."

	| quo rem ql d div dh dnh dl qhi qlo j l hi lo r3 a t |
	arg = 0 ifTrue: [^ self error: 'division by 0'].
	l _ self digitLength - arg digitLength + 1.
	l <= 0 ifTrue: [^MArray with: 0 with: self].
	d _ 8 - arg lastDigit highBit.
	div _ arg digitLshift: d.  div _ div growto: div digitLength + 1.
	"shifts so high order word is >=128"
	rem _ self digitLshift: d.
	rem digitLength = self digitLength ifTrue:
		[rem _ rem growto: self digitLength + 1].
	"makes a copy and shifts"
	quo _ MInteger new: l neg: ng.
	dl _ div digitLength - 1.
	"Last actual byte of data"
	ql _ l.
	dh _ div digitAt: dl.
	dnh _ dl = 1
			ifTrue: [0]
			ifFalse: [div digitAt: dl - 1].
	1 to: ql do: 
		[:k | 
		"maintain quo*arg+rem=self"
		"Estimate rem/div by dividing the leading to bytes of rem by dh."
		"The estimate is q = qhi*16+qlo, where qhi and qlo are nibbles."
		j _ rem digitLength + 1 - k.
		"r1 _ rem digitAt: j."
		(rem digitAt: j) = dh
			ifTrue: [qhi _ qlo _ 15"i.e. q=255"]
			ifFalse: 
				["Compute q = (r1,r2)//dh, t = (r1,r2)\\dh.  
				Note that r1,r2 are bytes, not nibbles.  
				Be careful not to generate intermediate results exceeding 13 bits."
				"r2 _ (rem digitAt: j - 1)."
				t _ ((rem digitAt: j) bitShift: 4) + ((rem digitAt: j - 1) bitShift: -4).
				qhi _ t // dh.
				t _ (t \\ dh bitShift: 4) + ((rem digitAt: j - 1) bitAnd: 15).
				qlo _ t // dh.
				t _ t \\ dh.
				"Next compute (hi,lo) _ q*dnh"
				hi _ qhi * dnh.
				lo _ qlo * dnh + ((hi bitAnd: 15) bitShift: 4).
				hi _ (hi bitShift: -4) + (lo bitShift: -8).
				lo _ lo bitAnd: 255.
				"Correct overestimate of q.  
				Max of 2 iterations through loop -- see Knuth vol. 2"
				r3 _ j < 3 ifTrue: [0]
						 ifFalse: [rem digitAt: j - 2].
				[(t < hi or: [t = hi and: [r3 < lo]]) and: 
						["i.e. (t,r3) < (hi,lo)"
						qlo _ qlo - 1.
						lo _ lo - dnh.
						lo < 0 ifTrue: 
								[hi _ hi - 1.
								lo _ lo + 256].
						hi >= dh]]
					whileTrue: [hi _ hi - dh].
				qlo < 0
					ifTrue: 
						[qhi _ qhi - 1.
						qlo _ qlo + 16]].
		"Subtract q*div from rem"
		l _ j - dl.
		a _ 0.
		1 to: div digitLength do: 
			[:i | 
			hi _ (div digitAt: i) * qhi.
			lo _ a + (rem digitAt: l) 
					- ((hi bitAnd: 15) bitShift: 4) 
					- ((div digitAt: i) * qlo).
			rem digitAt: l
				put: lo - (lo // 256 * 256) "sign-tolerant form of (lo bitAnd: 255)".
			a _ (lo // 256) - (hi bitShift: -4).
			l _ l + 1].
		a < 0 ifTrue: 
				["Add div back into rem, decrease q by 1"
				qlo _ qlo - 1.
				l _ j - dl.
				a _ 0.
				1 to: div digitLength do: 
					[:i | 
					a _ (a bitShift: -8) + (rem digitAt: l) + (div digitAt: i).
					rem digitAt: l put: (a bitAnd: 255).
					l _ l + 1]].
		quo digitAt: quo digitLength + 1 - k put: (qhi bitShift: 4) + qlo].
	rem _ rem digitRshift: d bytes: 0 lookfirst: dl.
	^ MArray with: quo with: rem
! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitLogic: arg op: op length: len
	| result neg1 neg2 rneg z1 z2 rz b1 b2 b |
	neg1 _ self negative.
	neg2 _ arg negative.
	rneg _ 
		((neg1 ifTrue: [-1] ifFalse: [0])
			perform: op 
			with: (neg2
					ifTrue: [-1]
					ifFalse: [0])) < 0.
	result _ MInteger new: len neg: rneg.
	rz _ z1 _ z2 _ true.
	1 to: result digitLength do: 
		[:i | 
		b1 _ self digitAt: i.
		neg1 
			ifTrue: [b1 _ z1
						ifTrue: [b1 = 0
									ifTrue: [0]
									ifFalse: 
										[z1 _ false.
										256 - b1]]
						ifFalse: [255 - b1]].
		b2 _ arg digitAt: i.
		neg2 
			ifTrue: [b2 _ z2
						ifTrue: [b2 = 0
									ifTrue: [0]
									ifFalse: 
										[z2 _ false.
										256 - b2]]
						ifFalse: [255 - b2]].
		b _ b1 perform: op with: b2.
		b = 0
			ifTrue: 
				[result digitAt: i put: 0]
			ifFalse: 
				[result 
					digitAt: i 
					put: (rneg
							ifTrue: [rz ifTrue: 
											[rz _ false.
											256 - b]
										ifFalse: [255 - b]]
						ifFalse: [b])]].
	^ result normalize! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitLshift: shiftCount
	| carry rShift mask len result digit byteShift bitShift highBit |
	(highBit _ self highBit) = 0 ifTrue: [^ 0].
	len _ highBit + shiftCount + 7 // 8.
	result _ MInteger new: len neg: self negative.
	byteShift _ shiftCount // 8.
	bitShift _ shiftCount \\ 8.
	bitShift = 0 ifTrue:  
		["Fast version for byte-aligned shifts"
		^ result replaceFrom: byteShift+1 to: len
				with: self startingAt: 1].
	carry _ 0.
	rShift _ bitShift - 8.
	mask _ 255 bitShift: 0 - bitShift.
	1 to: byteShift do: [:i | result digitAt: i put: 0].
	1 to: len - byteShift do: 
		[:i | 
		digit _ self digitAt: i.
		result digitAt: i + byteShift 
			put: (((digit bitAnd: mask) bitShift: bitShift) bitOr: carry).
		carry _ digit bitShift: rShift].
	^ result! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitMultiply: arg neg: ng
	| prod prodLen carry digit k ab |
	(arg digitLength = 1 and: [(arg digitAt: 1) = 0]) ifTrue: [^ 0].
	prodLen _ self digitLength + arg digitLength.
	prod _ MInteger new: prodLen neg: ng.
	"prod starts out all zero"
	1 to: self digitLength do: 
		[:i | 
		(digit _ self digitAt: i) ~= 0
			ifTrue: 
				[k _ i.
				carry _ 0.
				"Loop invariant: 0<=carry<=0377, k=i+j-1"
				1 to: arg digitLength do: 
					[:j | 
					ab _ ((arg digitAt: j) * digit) + carry
							+ (prod digitAt: k).
					carry _ ab bitShift: -8.
					prod digitAt: k put: (ab bitAnd: 255).
					k _ k + 1].
				prod digitAt: k put: carry]].
	^ prod normalize! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitRshift: anInteger bytes: b lookfirst: a 
	 "Shift right 8*b+anInteger bits, 0<=n<8.
	Discard all digits beyond a, and all zeroes at or below a."
	| n x r f m digit count i |
	n _ 0 - anInteger.
	x _ 0.
	f _ n + 8.
	i _ a.
	m _ 255 bitShift: 0 - f.
	digit _ self digitAt: i.
	[((digit bitShift: n) bitOr: x) = 0 and: [i ~= 1]] whileTrue:
		[x _ digit bitShift: f "Can't exceed 8 bits".
		i _ i - 1.
		digit _ self digitAt: i].
	i <= b ifTrue: [^MInteger new: 0 neg: self negative].  "All bits lost"
	r _ MInteger new: i - b neg: self negative.
	count _ i.
	x _ (self digitAt: b + 1) bitShift: n.
	b + 1 to: count do:
		[:j | digit _ self digitAt: j + 1.
		r digitAt: j - b put: (((digit bitAnd: m) bitShift: f) bitOr: x) 
			"Avoid values > 8 bits".
		x _ digit bitShift: n].
	^r! !

!MInteger methodsFor: 'private' stamp: 'jm 11/13/2002 16:57'!
digitSubtract: arg
	| smaller larger z sum sl al ng |
	sl _ self digitLength.
	al _ arg digitLength.
	(sl = al
		ifTrue: 
			[[(self digitAt: sl) = (arg digitAt: sl) and: [sl > 1]]
				whileTrue: [sl _ sl - 1].
			al _ sl.
			(self digitAt: sl) < (arg digitAt: sl)]
		ifFalse: [sl < al])
		ifTrue: 
			[larger _ arg.
			smaller _ self.
			ng _ self negative == false.
			sl _ al]
		ifFalse: 
			[larger _ self.
			smaller _ arg.
			ng _ self negative].
	sum _ MInteger new: sl neg: ng.
	z _ 0.
	"Loop invariant is -1<=z<=1"
	1 to: sl do:
		[:i |
		z _ z + (larger digitAt: i) - (smaller digitAt: i).
		sum digitAt: i
			put: z - (z // 256 * 256) "sign-tolerant form of (z bitAnd: 255)".
		z _ z // 256].
	^ sum normalize! !

!MInteger methodsFor: 'private'!
growby: n

	^self growto: self digitLength + n! !

!MInteger methodsFor: 'private'!
growto: n

	^self copyto: (self species new: n)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MInteger class
	instanceVariableNames: ''!

!MInteger class methodsFor: 'instance creation' stamp: 'jm 11/13/2002 17:01'!
new: length neg: neg
	"Answer an instance of a large integer with the given size and sign."

	neg 
		ifTrue: [^ MLargeNegativeInteger new: length]
		ifFalse: [^ MLargePositiveInteger new: length].
! !

!MInteger class methodsFor: 'instance creation'!
readFrom: aStream 
	"Answer a new Integer as described on the stream, aStream.
	Embedded radix specifiers not allowed - use Number readFrom: for that."
	^self readFrom: aStream base: 10! !

!MInteger class methodsFor: 'instance creation'!
readFrom: aStream base: base 
	"Answer an instance of one of my concrete subclasses. Initial minus sign 
	accepted, and bases > 10 use letters A-Z. Embedded radix specifiers not 
	allowed--use Number readFrom: for that. Answer zero (not an error) if 
	there are no digits."

	| digit value neg |
	neg _ aStream peekFor: $-.
	value _ 0.
	[aStream atEnd]
		whileFalse: 
			[digit _ aStream next digitValue.
			(digit < 0 or: [digit >= base])
				ifTrue: 
					[aStream skip: -1.
					neg ifTrue: [^ value negated].
					^ value]
				ifFalse: [value _ value * base + digit]].
	neg ifTrue: [^ value negated].
	^ value! !


MInteger variableByteSubclass: #MLargePositiveInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MLargePositiveInteger commentStamp: '<historical>' prior: 0!
I represent positive integers of more than 30 bits (ie, >= 1073741824).  These values are beyond the range of SmallInteger, and are encoded here as an array of 8-bit digits.  Care must be taken, when new values are computed, that any result that COULD BE a SmallInteger IS a SmallInteger (see normalize).

Note that the bit manipulation primitives, bitAnd:, bitShift:, etc., = and ~= run without failure (and therefore fast) if the value fits in 32 bits.  This is a great help to the simulator.!


!MLargePositiveInteger methodsFor: 'arithmetic'!
* anInteger 
	"Primitive. Multiply the receiver by the argument and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive. "

	<primitive: 29>
	^super * anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
+ anInteger 
	"Primitive. Add the receiver to the argument and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 21>
	^super + anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
- anInteger 
	"Primitive. Subtract the argument from the receiver and answer with an
	Integer result. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 22>
	^super - anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
/ anInteger 
	"Primitive. Divide the receiver by the argument and answer with the
	result if the division is exact. Fail if the result is not a whole integer.
	Fail if the argument is 0. Fail if either the argument or the result is not
	a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive. "

	<primitive: 30>
	^super / anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
// anInteger 
	"Primitive. Divide the receiver by the argument and return the result.
	Round the result down towards negative infinity to make it a whole
	integer. Fail if the argument is 0. Fail if either the argument or the
	result is not a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824).
	Optional. See Object documentation whatIsAPrimitive. "

	<primitive: 32>
	^super // anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
\\ anInteger 
	"Primitive. Take the receiver modulo the argument. The result is the
	remainder rounded towards negative infinity, of the receiver divided
	by the argument. Fail if the argument is 0. Fail if either the argument
	or the result is not a SmallInteger or a LargePositiveInteger less than
	2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 31>
	^super \\ anInteger! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
abs! !

!MLargePositiveInteger methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:36'!
negated

	^ (self copyto: (MLargeNegativeInteger new: self digitLength))
		normalize  "Need to normalize to catch SmallInteger minVal"
! !

!MLargePositiveInteger methodsFor: 'arithmetic'!
quo: anInteger 
	"Primitive. Divide the receiver by the argument and return the result.
	Round the result down towards zero to make it a whole integer. Fail if
	the argument is 0. Fail if either the argument or the result is not a
	SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824). Optional. See
	Object documentation whatIsAPrimitive."

	<primitive: 33>
	^super quo: anInteger! !


!MLargePositiveInteger methodsFor: 'bit manipulation'!
bitAnd: anInteger 
	"Primitive. Answer an Integer whose bits are the logical AND of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 14>
	^ super bitAnd: anInteger! !

!MLargePositiveInteger methodsFor: 'bit manipulation'!
bitOr: anInteger 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 15>
	^ super bitOr: anInteger! !

!MLargePositiveInteger methodsFor: 'bit manipulation'!
bitShift: anInteger 
	"Primitive. Answer an Integer whose value (in twos-complement 
	representation) is the receiver's value (in twos-complement
	representation) shifted left by the number of bits indicated by the
	argument. Negative arguments shift right. Zeros are shifted in from the
	right in left shifts. The sign bit is extended in right shifts.
	Fail if the receiver or result is greater than 32 bits.
	See Object documentation whatIsAPrimitive."
	<primitive: 17>
	^super bitShift: anInteger! !

!MLargePositiveInteger methodsFor: 'bit manipulation'!
bitXor: anInteger 
	"Primitive. Answer an Integer whose bits are the logical XOR of the
	receiver's bits and those of the argument. Fail if the receiver or argument
	is greater than 32 bits. See Object documentation whatIsAPrimitive."
	<primitive: 16>
	^ super bitXor: anInteger! !

!MLargePositiveInteger methodsFor: 'bit manipulation' stamp: 'di 5/19/1998 20:23'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the receiver is zero. This method is allowed (and needed) for LargeNegativeIntegers as well, since Squeak's LargeIntegers are sign/magnitude."
	| realLength lastDigit |
	realLength _ self digitLength.
	[(lastDigit _ self digitAt: realLength) = 0]
		whileTrue:
		[(realLength _ realLength - 1) = 0 ifTrue: [^ 0]].
	^ lastDigit highBit + (8 * (realLength - 1))
! !


!MLargePositiveInteger methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ false! !

!MLargePositiveInteger methodsFor: 'testing' stamp: 'jm 3/27/98 06:19'!
sign
	"Optimization. Answer 1 since receiver is greater than 0."

	^ 1
! !


!MLargePositiveInteger methodsFor: 'comparing'!
< anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than the argument. Otherwise answer false. Fail if the
	argument is not a SmallInteger or a LargePositiveInteger less than 2-to-the-30th (1073741824).
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 23>
	^super < anInteger! !

!MLargePositiveInteger methodsFor: 'comparing'!
<= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than or equal to the argument. Otherwise answer false.
	Fail if the argument is not a SmallInteger or a LargePositiveInteger less
	than 2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 25>
	^super <= anInteger! !

!MLargePositiveInteger methodsFor: 'comparing'!
= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	receiver or argument is negative or greater than 32 bits.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 7>
	^ super = anInteger! !

!MLargePositiveInteger methodsFor: 'comparing'!
> anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger or a LargePositiveInteger less than
	2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 24>
	^super > anInteger! !

!MLargePositiveInteger methodsFor: 'comparing'!
>= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger or a LargePositiveInteger
	less than 2-to-the-30th (1073741824). Optional. See Object documentation whatIsAPrimitive."

	<primitive: 26>
	^super >= anInteger! !

!MLargePositiveInteger methodsFor: 'comparing'!
~= anInteger 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	receiver or argument is negative or greater than 32 bits.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 8>
	^ super ~= anInteger! !


!MLargePositiveInteger methodsFor: 'converting' stamp: 'jm 11/13/2002 17:22'!
normalize
	"Check for leading zeroes and return shortened copy if so"
	| sLen val len oldLen |
	"First establish len = significant length"
	len _ oldLen _ self digitLength.
	[len = 0 ifTrue: [^0].
	(self digitAt: len) = 0]
		whileTrue: [len _ len - 1].

	"Now check if in SmallInteger range"
	sLen _ MSmallInteger maxVal digitLength.
	(len <= sLen
		and: [(self digitAt: sLen) <= (MSmallInteger maxVal digitAt: sLen)])
		ifTrue: ["If so, return its SmallInt value"
				val _ 0.
				len to: 1 by: -1 do:
					[:i | val _ (val *256) + (self digitAt: i)].
				^ val].

	"Return self, or a shortened copy"
	len < oldLen
		ifTrue: [^ self growto: len]
		ifFalse: [^ self]! !


!MLargePositiveInteger methodsFor: 'system primitives'!
digitAt: index 
	"Primitive. Answer the value of an indexable field in the receiver. Fail if 
	the argument (the index) is not an Integer or is out of bounds. Essential. 
	See Object documentation whatIsAPrimitive."

	<primitive: 60>
	self digitLength < index
		ifTrue: [^0]
		ifFalse: [^super at: index]! !

!MLargePositiveInteger methodsFor: 'system primitives'!
digitAt: index put: value 
	"Primitive. Store the second argument (value) in the indexable field of 
	the receiver indicated by index. Fail if the value is negative or is larger 
	than 255. Fail if the index is not an Integer or is out of bounds. Answer 
	the value that was stored. Essential. See Object documentation 
	whatIsAPrimitive."

	<primitive: 61>
	^super at: index put: value! !

!MLargePositiveInteger methodsFor: 'system primitives'!
digitLength
	"Primitive. Answer the number of indexable fields in the receiver. This 
	value is the same as the largest legal subscript. Essential. See Object 
	documentation whatIsAPrimitive."

	<primitive: 62>
	self primitiveFailed! !

!MLargePositiveInteger methodsFor: 'system primitives'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	^ super replaceFrom: start to: stop with: replacement startingAt: repStart! !


MLargePositiveInteger variableByteSubclass: #MLargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MLargeNegativeInteger commentStamp: '<historical>' prior: 0!
I am just like LargePositiveInteger, but representing a negative number.
!


!MLargeNegativeInteger methodsFor: 'arithmetic'!
abs
	^ self negated! !

!MLargeNegativeInteger methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:01'!
negated

	^ self copyto: (MLargePositiveInteger new: self digitLength)
! !


!MLargeNegativeInteger methodsFor: 'converting' stamp: 'jm 11/13/2002 17:22'!
normalize
	"Check for leading zeroes and return shortened copy if so"
	| sLen val len oldLen minVal |
	"First establish len = significant length"
	len _ oldLen _ self digitLength.
	[len = 0 ifTrue: [^0].
	(self digitAt: len) = 0]
		whileTrue: [len _ len - 1].

	"Now check if in SmallInteger range"
	sLen _ 4  "SmallInteger minVal digitLength".
	len <= sLen ifTrue:
		[minVal _ MSmallInteger minVal.
		(len < sLen
			or: [(self digitAt: sLen) < minVal lastDigit])
			ifTrue: ["If high digit less, then can be small"
					val _ 0.
					len to: 1 by: -1 do:
						[:i | val _ (val *256) - (self digitAt: i)].
					^ val].
		1 to: sLen do:  "If all digits same, then = minVal"
			[:i | (self digitAt: i) = (minVal digitAt: i)
					ifFalse: ["Not so; return self shortened"
							len < oldLen
								ifTrue: [^ self growto: len]
								ifFalse: [^ self]]].
		^ minVal].

	"Return self, or a shortened copy"
	len < oldLen
		ifTrue: [^ self growto: len]
		ifFalse: [^ self]! !


!MLargeNegativeInteger methodsFor: 'testing' stamp: 'di 4/23/1998 11:18'!
negative
	"Answer whether the receiver is mathematically negative."

	^ true! !

!MLargeNegativeInteger methodsFor: 'testing' stamp: 'jm 3/27/98 06:19'!
sign
	"Optimization. Answer -1 since receiver is less than 0."

	^ -1
! !


!MLargeNegativeInteger methodsFor: 'printing'!
printOn: aStream base: b 
	"Refer to the comment in Integer|printOn:base:."

	aStream nextPut: $-.
	super printOn: aStream base: b! !


MInteger subclass: #MSmallInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Numeric'!
!MSmallInteger commentStamp: 'jm 12/31/2003 09:18' prior: 0!
My instances are 31-bit numbers, stored in twos complement form. The allowable range is approximately +- 1 billion (see SmallInteger minVal, maxVal).
!


!MSmallInteger methodsFor: 'arithmetic'!
* aNumber 
	"Primitive. Multiply the receiver by the argument and answer with the
	result if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger. Essential. No Lookup. See Object documentation
	whatIsAPrimitive."

	<primitive: 9>
	self = 0 ifTrue: [^0].
	"This eliminates the need for a self=0 check in LargeInteger *"
	^super * aNumber! !

!MSmallInteger methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:12'!
+ aNumber 
	"Primitive. Add the receiver to the argument and answer with the result
	if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger  Essential  No Lookup. See Object documentation
	whatIsAPrimitive."

	<primitive: 1>
	aNumber isInteger ifTrue: [^ super + aNumber].
	^ aNumber adaptToInteger: self andSend: #+! !

!MSmallInteger methodsFor: 'arithmetic'!
- aNumber 
	"Primitive. Subtract the argument from the receiver and answer with the
	result if it is a SmallInteger. Fail if the argument or the result is not a
	SmallInteger. Essential. No Lookup. See Object documentation
	whatIsAPrimitive."

	<primitive: 2>
	^super - aNumber! !

!MSmallInteger methodsFor: 'arithmetic' stamp: 'jm 10/27/2003 07:40'!
/ aNumber 
	"Primitive. Divide the receiver by the argument and return the result if the division is exact. Fail if the result is not a whole integer. Fail if the argument is 0 or is not a SmallInteger. Optional. No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 10>
	aNumber = 0 ifTrue: [^ self error: 'division by 0'].
	aNumber isSmallInteger
		ifTrue: [^ self asFloat / aNumber asFloat]
		ifFalse: [^ super / aNumber].
! !

!MSmallInteger methodsFor: 'arithmetic'!
// aNumber 
	"Primitive. Divide the receiver by the argument and answer with the
	result. Round the result down towards negative infinity to make it a
	whole integer. Fail if the argument is 0 or is not a SmallInteger.
	Essential. No Lookup. See Object documentation whatIsAPrimitive. "

	<primitive: 12>
	^super // aNumber"Do with quo: if primitive fails"! !

!MSmallInteger methodsFor: 'arithmetic'!
\\ aNumber 
	"Primitive. Take the receiver modulo the argument. The result is the
	remainder rounded towards negative infinity, of the receiver divided by
	the argument Fail if the argument is 0 or is not a SmallInteger. Optional.
	No Lookup. See Object documentation whatIsAPrimitive."

	<primitive: 11>
	^super \\ aNumber"Do with // if primitive fails"! !

!MSmallInteger methodsFor: 'arithmetic' stamp: 'jm 10/27/2003 07:40'!
quo: aNumber 
	"Primitive. Divide the receiver by the argument and answer with the result. Round the result down towards zero to make it a whole integer. Fail if the argument is 0 or is not a MSmallInteger. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 13>
	aNumber = 0 ifTrue: [^ self error: 'Attempt to divide by zero'].
	aNumber class isSmallInteger
		ifTrue: [self primitiveFailed]
		ifFalse: [^ super quo: aNumber].
! !


!MSmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitAnd: arg 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 14>
	self >= 0 ifTrue: [^ arg bitAnd: self].
	^ (self bitInvert bitOr: arg bitInvert) bitInvert! !

!MSmallInteger methodsFor: 'bit manipulation' stamp: 'di 4/30/1998 10:33'!
bitOr: arg 
	"Primitive. Answer an Integer whose bits are the logical OR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 15>
	self >= 0 ifTrue: [^ arg bitOr: self].
	^ arg < 0
		ifTrue: [(self bitInvert bitAnd: arg bitInvert) bitInvert]
		ifFalse: [(self bitInvert bitClear: arg) bitInvert]! !

!MSmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitShift: arg 
	"Primitive. Answer an Integer whose value is the receiver's value shifted
	left by the number of bits indicated by the argument. Negative arguments
	shift right. The receiver is interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 17>
	self >= 0 ifTrue: [^ super bitShift: arg].
	^ arg >= 0
		ifTrue: [(self negated bitShift: arg) negated]
		ifFalse: [(self bitInvert bitShift: arg) bitInvert]! !

!MSmallInteger methodsFor: 'bit manipulation' stamp: 'wb 4/28/1998 12:17'!
bitXor: arg 
	"Primitive. Answer an Integer whose bits are the logical XOR of the
	receiver's bits and those of the argument, arg.
	Numbers are interpreted as having 2's-complement representation.
	Essential.  See Object documentation whatIsAPrimitive."

	<primitive: 16>
	self >= 0 ifTrue: [^ arg bitXor: self].
	^ arg < 0
		ifTrue: [self bitInvert bitXor: arg bitInvert]
		ifFalse: [(self bitInvert bitXor: arg) bitInvert]! !

!MSmallInteger methodsFor: 'bit manipulation' stamp: 'jm 5/1/1998 14:54'!
highBit
	"Answer the index of the high order bit of the receiver, or zero if the receiver is zero. Raise an error if the receiver is negative, since negative integers are defined to have an infinite number of leading 1's in 2's-complement arithmetic."

	| shifted bitNo |
	self < 0 ifTrue: [self error: 'highBit is not defined for negative integers'].
	shifted _ self.
	bitNo _ 0.
	[shifted < 16] whileFalse:
		[shifted _ shifted bitShift: -4.
		bitNo _ bitNo + 4].
	[shifted = 0] whileFalse:
		[shifted _ shifted bitShift: -1.
		bitNo _ bitNo + 1].
	^ bitNo
! !


!MSmallInteger methodsFor: 'testing' stamp: 'jm 10/27/2003 07:36'!
isSmallInteger

	^ true
! !


!MSmallInteger methodsFor: 'comparing'!
< aNumber 
	"Primitive. Compare the receiver with the argument and answer with
	true if the receiver is less than the argument. Otherwise answer false.
	Fail if the argument is not a SmallInteger. Essential. No Lookup. See
	Object documentation whatIsAPrimitive."

	<primitive: 3>
	^super < aNumber! !

!MSmallInteger methodsFor: 'comparing'!
<= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is less than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger. Optional. No Lookup.
	See Object documentation whatIsAPrimitive. "

	<primitive: 5>
	^super <= aNumber! !

!MSmallInteger methodsFor: 'comparing'!
= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is equal to the argument. Otherwise answer false. Fail if the
	argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive. "

	<primitive: 7>
	^super = aNumber! !

!MSmallInteger methodsFor: 'comparing'!
> aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive."

	<primitive: 4>
	^super > aNumber! !

!MSmallInteger methodsFor: 'comparing'!
>= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is greater than or equal to the argument. Otherwise answer
	false. Fail if the argument is not a SmallInteger. Optional. No Lookup.
	See Object documentation whatIsAPrimitive."

	<primitive: 6>
	^super >= aNumber! !

!MSmallInteger methodsFor: 'comparing' stamp: 'jm 12/31/2003 09:14'!
hash

	^ self
! !

!MSmallInteger methodsFor: 'comparing' stamp: 'jm 11/14/2002 14:20'!
identityHash

	^ self
! !

!MSmallInteger methodsFor: 'comparing' stamp: 'yo 11/4/2010 22:34'!
scaledIdentityHash
	"For identityHash values returned by primitive 75, answer
	such values times 2^18.  Otherwise, match the existing
	identityHash implementation"
	
	^self! !

!MSmallInteger methodsFor: 'comparing'!
~= aNumber 
	"Primitive. Compare the receiver with the argument and answer true if
	the receiver is not equal to the argument. Otherwise answer false. Fail if
	the argument is not a SmallInteger. Essential. No Lookup. See Object
	documentation whatIsAPrimitive."

	<primitive: 8>
	^super ~= aNumber! !


!MSmallInteger methodsFor: 'copying' stamp: 'jm 12/2/2003 22:25'!
basicCopy
	"I am immutable (and not really an object), so answer myself."
! !


!MSmallInteger methodsFor: 'converting'!
asFloat
	"Primitive. Answer a Float that represents the value of the receiver.
	Essential. See Object documentation whatIsAPrimitive."

	<primitive: 40>
	self primitiveFailed! !


!MSmallInteger methodsFor: 'printing' stamp: 'jm 10/26/2003 13:31'!
printOn: aStream base: b
	"Refer to the comment in Integer|printOn:base:."
	"self maxVal printStringBase: 2"

	| digitsInReverse x i |
	self < 0 ifTrue: [
		aStream nextPut: $-.
		^ self negated printOn: aStream base: b].

	b = 10 ifFalse: [b printOn: aStream. aStream nextPut: $r].
	digitsInReverse _ MArray new: 32.
	x _ self.
	i _ 0.
	[x >= b] whileTrue: [
		digitsInReverse at: (i _ i + 1) put: x \\ b.
		x _ x // b].
	digitsInReverse at: (i _ i + 1) put: x.
	[i > 0] whileTrue: [
		aStream nextPut: (MCharacter digitValue: (digitsInReverse at: i)).
		i _ i - 1].
! !


!MSmallInteger methodsFor: 'system primitives' stamp: 'jm 11/13/2002 17:22'!
digitAt: n 
	"Answer the value of an indexable field in the receiver. Fail if the 
	argument (the index) is not an Integer or is out of bounds."
	n>4 ifTrue: [^ 0].
	self < 0
		ifTrue: 
			[self = MSmallInteger minVal ifTrue:
				["Can't negate minVal -- treat specially"
				^ #(0 0 0 64) at: n].
			^ ((0-self) bitShift: (1-n)*8) bitAnd: 16rFF]
		ifFalse: [^ (self bitShift: (1-n)*8) bitAnd: 16rFF]! !

!MSmallInteger methodsFor: 'system primitives' stamp: 'jm 12/31/2003 09:17'!
digitAt: n put: value 
	"Fails. The digits of a small integer can not be modified."

	self error: 'You cannot store in a SmallInteger'
! !

!MSmallInteger methodsFor: 'system primitives'!
digitLength
	"Answer the number of indexable fields in the receiver. This value is the 
	same as the largest legal subscript. Included so that a SmallInteger can 
	behave like a LargePositiveInteger or LargeNegativeInteger."

	(self < 16r100 and: [self > -16r100]) ifTrue: [^ 1].
	(self < 16r10000 and: [self > -16r10000]) ifTrue: [^ 2].
	(self < 16r1000000 and: [self > -16r1000000]) ifTrue: [^ 3].
	^ 4! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MSmallInteger class
	instanceVariableNames: ''!

!MSmallInteger class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:24'!
new
	"SmallIntegers are created as constants or by performing arithmetic."

	self cannotInstantiate.
! !


!MSmallInteger class methodsFor: 'constants'!
maxVal
	"Answer the maximum value for a SmallInteger."
	^ 16r3FFFFFFF! !

!MSmallInteger class methodsFor: 'constants'!
minVal
	"Answer the minimum value for a SmallInteger."
	^ -16r40000000! !

