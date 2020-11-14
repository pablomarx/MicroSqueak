MObject subclass: #MFile
	instanceVariableNames: 'name fileID '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MFile commentStamp: 'jm 12/2/2003 08:01' prior: 0!
I support simple file i/o for MicroSqueak. Unlike Squeak FileStreams, I am not a Stream.
!


!MFile methodsFor: 'open/close' stamp: 'jm 11/24/2003 18:41'!
close
	"Close this file."

	fileID ifNotNil: [
		self primClose: fileID.
		fileID _ nil].
! !

!MFile methodsFor: 'open/close' stamp: 'jm 11/24/2003 20:14'!
name
	"Answer the name of this file."

	^ name
! !

!MFile methodsFor: 'open/close' stamp: 'jm 11/24/2003 20:23'!
openReadOnly: fileName
	"Open the file with the given name for reading and writing."

	name _ nil.
	fileID _ self primOpen: fileName writable: false.
	name _ fileName.
! !

!MFile methodsFor: 'open/close' stamp: 'jm 11/24/2003 20:23'!
openReadWrite: fileName
	"Open the file with the given name for reading only."

	name _ nil.
	fileID _ self primOpen: fileName writable: true.
	name _ fileName.
! !


!MFile methodsFor: 'file ops' stamp: 'jm 12/8/2003 23:44'!
cr

	self nextPutAll: (MString with: MCharacter cr).
! !

!MFile methodsFor: 'file ops' stamp: 'jm 10/1/2008 20:05'!
localFolderPath
	"Answer the path for the folder containing the image file."
	"MFile new localFolderPath"

	| imagePath delimiter i |
	imagePath _ self primImageName.
	delimiter _ $/.
	(imagePath includes: delimiter) ifFalse: [delimiter _ $\].
	i _ imagePath size.
	[(i > 0) and: [(imagePath at: i) ~= delimiter]] whileTrue: [i _ i - 1].
	i = 0 ifTrue: [^ ''].
	^ imagePath copyFrom: 1 to: i
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/26/2003 20:02'!
next: count
	"Answer a String containing the next count bytes of the file. If there are not count bytes left in the file, answer a String with as many bytes as available."

	| buffer n |
	buffer _ '' class new: count.
	n _ self primRead: fileID into: buffer startingAt: 1 count: count.
	n < count ifTrue: [buffer _ buffer copyFrom: 1 to: n].
	^ buffer
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/24/2003 19:59'!
nextPutAll: buffer
	"Write the contents of the given bytes or words object to this file."

	^ self primWrite: fileID from: buffer startingAt: 1 count: buffer basicSize
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/24/2003 20:18'!
position
	"Answer the current file position in bytes."

	^ self primGetPosition: fileID
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/24/2003 20:18'!
position: newPosition
	"Seek to the given file position in bytes."

	^ self primSetPosition: fileID to: newPosition
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/24/2003 20:03'!
readInto: buffer startingAt: startIndex count: count
	"Read up to count elements into the given array and answer the number of elements actually read. The buffer may either a byte- or word-indexable object."

	^ self primRead: fileID into: buffer startingAt: startIndex count: count
! !

!MFile methodsFor: 'file ops' stamp: 'jm 11/24/2003 20:16'!
size
	"Answer the size of this file in bytes."

	^ self primSize: fileID
! !


!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:01'!
primClose: id
	"Close this file. Don't raise an error if the primitive fails."

	<primitive: 151>
! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 18:47'!
primGetPosition: id
	"Get this files current position."

	<primitive: 152>
	self primitiveFailed
! !

!MFile methodsFor: 'primitives' stamp: 'jm 10/1/2008 20:04'!
primImageName
	"Answer the full path name for the current image."

	<primitive: 121>
	self primitiveFailed! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:22'!
primOpen: fileName writable: writableFlag
	"Open a file of the given name, and return the file ID obtained.
	If writableFlag is true, then
		if there is none with this name, then create one
		else prepare to overwrite the existing from the beginning
	otherwise
		if the file exists, open it read-only
		else return nil"

	<primitive: 153>
	self primitiveFailed
! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:05'!
primRead: id into: byteArray startingAt: startIndex count: count
	"Read up to count elements into the given buffer and answer the number of elements actually read. The buffer may either a byte- or word-indexable object."


	<primitive: 154>
	self primitiveFailed
! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:01'!
primSetPosition: id to: anInteger
	"Set this file to the given position."

	<primitive: 155>
	self primitiveFailed
! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:01'!
primSize: id
	"Answer the size of this file."

	<primitive: 157>
	self primitiveFailed
! !

!MFile methodsFor: 'primitives' stamp: 'jm 11/24/2003 20:05'!
primWrite: id from: buffer startingAt: startIndex count: count
	"Write up to count elements from the given buffer and answer the number of elements actually written. The buffer may either a byte- or word-indexable object."

	<primitive: 158>
	self primitiveFailed
! !


Number variableWordSubclass: #MFloat
	instanceVariableNames: ''
	classVariableNames: 'E Epsilon Halfpi Infinity Ln10 Ln2 MaxVal MaxValLn MinValLogBase2 NaN NegativeInfinity NegativeZero Pi RadiansPerDegree Sqrt2 Twopi '
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MFloat commentStamp: '<historical>' prior: 0!
My instances represent IEEE-754 floating-point double-precision numbers.  They have about 16 digits of accuracy and their range is between plus and minus 10^307. Some valid examples are:
	
	8.0 13.3 0.3 2.5e6 1.27e-30 1.27e-31 -12.987654e12

Mainly: no embedded blanks, little e for tens power, and a digit on both sides of the decimal point.
!


!MFloat methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:54'!
* aNumber 
	"Primitive. Answer the result of multiplying the receiver by aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 49>
	^ aNumber adaptToFloat: self andSend: #*! !

!MFloat methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:22'!
+ aNumber 
	"Primitive. Answer the sum of the receiver and aNumber. Essential.
	Fail if the argument is not a Float. See Object documentation
	whatIsAPrimitive."

	<primitive: 41>
	^ aNumber adaptToFloat: self andSend: #+! !

!MFloat methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:55'!
- aNumber 
	"Primitive. Answer the difference between the receiver and aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 42>
	^ aNumber adaptToFloat: self andSend: #-! !

!MFloat methodsFor: 'arithmetic' stamp: 'di 11/6/1998 13:55'!
/ aNumber 
	"Primitive. Answer the result of dividing receiver by aNumber.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 50>
	aNumber = 0 ifTrue: [self error: 'attempt to divide by zero'].
	^ aNumber adaptToFloat: self andSend: #/! !

!MFloat methodsFor: 'arithmetic'!
abs
	"This is faster than using Number abs."
	self < 0.0
		ifTrue: [^ 0.0 - self]
		ifFalse: [^ self]! !

!MFloat methodsFor: 'arithmetic'!
negated
	"Answer a Number that is the negation of the receiver."

	^0.0 - self! !

!MFloat methodsFor: 'arithmetic'!
reciprocal
	^ 1.0 / self! !


!MFloat methodsFor: 'mathematical functions'!
arcCos
	"Answer the angle in radians."

	^ Halfpi - self arcSin! !

!MFloat methodsFor: 'mathematical functions'!
arcSin
	"Answer the angle in radians."

	((self < -1.0) or: [self > 1.0]) ifTrue: [self error: 'Value out of range'].
	((self = -1.0) or: [self = 1.0])
		ifTrue: [^ Halfpi]
		ifFalse: [^ (self / (1.0 - (self * self)) sqrt) arcTan]! !

!MFloat methodsFor: 'mathematical functions'!
arcTan
	"Answer the angle in radians.
	 Optional. See Object documentation whatIsAPrimitive."

	| theta eps step sinTheta cosTheta |
	<primitive: 57>

	"Newton-Raphson"
	self < 0.0 ifTrue: [ ^ 0.0 - (0.0 - self) arcTan ].

	"first guess"
	theta _ (self * Halfpi) / (self + 1.0).

	"iterate"
	eps _ Halfpi * Epsilon.
	step _ theta.
	[(step * step) > eps] whileTrue: [
		sinTheta _ theta sin.
		cosTheta _ theta cos.
		step _ (sinTheta * cosTheta) - (self * cosTheta * cosTheta).
		theta _ theta - step].
	^ theta! !

!MFloat methodsFor: 'mathematical functions'!
cos
	"Answer the cosine of the receiver taken as an angle in radians."

	^ (self + Halfpi) sin! !

!MFloat methodsFor: 'mathematical functions'!
exp
	"Answer E raised to the receiver power.
	 Optional. See Object documentation whatIsAPrimitive." 

	| base fract correction delta div |
	<primitive: 59>

	"Taylor series"
	"check the special cases"
	self < 0.0 ifTrue: [^ (self negated exp) reciprocal].
	self = 0.0 ifTrue: [^ 1].
	self abs > MaxValLn ifTrue: [self error: 'exp overflow'].

	"get first approximation by raising e to integer power"
	base _ E raisedToInteger: (self truncated).

	"now compute the correction with a short Taylor series"
	"fract will be 0..1, so correction will be 1..E"
	"in the worst case, convergance time is logarithmic with 1/Epsilon"
	fract _ self fractionPart.
	fract = 0.0 ifTrue: [ ^ base ].  "no correction required"

	correction _ 1.0 + fract.
	delta _ fract * fract / 2.0.
	div _ 2.0.
	[delta > Epsilon] whileTrue: [
		correction _ correction + delta.
		div _ div + 1.0.
		delta _ delta * fract / div].
	correction _ correction + delta.
	^ base * correction! !

!MFloat methodsFor: 'mathematical functions' stamp: 'jm 3/27/98 06:28'!
floorLog: radix
	"Answer the floor of the log base radix of the receiver."

	^ (self log: radix) floor
! !

!MFloat methodsFor: 'mathematical functions'!
ln
	"Answer the natural logarithm of the receiver.
	 Optional. See Object documentation whatIsAPrimitive."

	| expt n mant x div pow delta sum eps |
	<primitive: 58>

	"Taylor series"
	self <= 0.0 ifTrue: [self error: 'ln is only defined for x > 0.0'].

	"get a rough estimate from binary exponent"
	expt _ self exponent.
	n _ Ln2 * expt.
	mant _ self timesTwoPower: 0 - expt.

	"compute fine correction from mantinssa in Taylor series"
	"mant is in the range [0..2]"
	"we unroll the loop to avoid use of abs"
	x _ mant - 1.0.
	div _ 1.0.
	pow _ delta _ sum _ x.
	x _ x negated.  "x <= 0"
	eps _ Epsilon * (n abs + 1.0).
	[delta > eps] whileTrue: [
		"pass one: delta is positive"
		div _ div + 1.0.
		pow _ pow * x.
		delta _ pow / div.
		sum _ sum + delta.
		"pass two: delta is negative"
		div _ div + 1.0.
		pow _ pow * x.
		delta _ pow / div.
		sum _ sum + delta].

	^ n + sum

	"2.718284 ln 1.0"! !

!MFloat methodsFor: 'mathematical functions'!
log
	"Answer the base 10 logarithm of the receiver."

	^ self ln / Ln10! !

!MFloat methodsFor: 'mathematical functions' stamp: 'jm 5/14/1998 11:04'!
raisedTo: aNumber
	"Answer the receiver raised to aNumber."

	0.0 = aNumber ifTrue: [^ 1.0].  "special case for 0.0 raisedTo: 0.0"
	^ (self ln * aNumber asFloat) exp
! !

!MFloat methodsFor: 'mathematical functions' stamp: 'tao 10/15/97 14:23'!
reciprocalLogBase2
	"optimized for self = 10, for use in conversion for printing"

	^ self = 10.0
		ifTrue: [Ln2 / Ln10]
		ifFalse: [Ln2 / self ln]! !

!MFloat methodsFor: 'mathematical functions'!
sin
	"Answer the sine of the receiver taken as an angle in radians.
	 Optional. See Object documentation whatIsAPrimitive."

	| sum delta self2 i |
	<primitive: 56>

	"Taylor series"
	"normalize to the range [0..Pi/2]"
	self < 0.0 ifTrue: [^ (0.0 - ((0.0 - self) sin))].
	self > Twopi ifTrue: [^ (self \\ Twopi) sin].
	self > Pi ifTrue: [^ (0.0 - (self - Pi) sin)].
	self > Halfpi ifTrue: [^ (Pi - self) sin].

	"unroll loop to avoid use of abs"
	sum _ delta _ self.
	self2 _ 0.0 - (self * self).
	i _ 2.0.
	[delta > Epsilon] whileTrue: [
		"once"
		delta _ (delta * self2) / (i * (i + 1.0)).
		i _ i + 2.0.
		sum _ sum + delta.
		"twice"
		delta _ (delta * self2) / (i * (i + 1.0)).
		i _ i + 2.0.
		sum _ sum + delta].
	^ sum! !

!MFloat methodsFor: 'mathematical functions'!
sqrt
	"Answer the square root of the receiver.
	 Optional. See Object documentation whatIsAPrimitive."

	| exp guess eps delta |
	<primitive: 55>

	"Newton-Raphson"
	self <= 0.0 ifTrue: [
		self = 0.0
			ifTrue: [^ 0.0]
			ifFalse: [^ self error: 'sqrt is invalid for x < 0']].

	"first guess is half the exponent"
	exp _ self exponent // 2.
	guess _ self timesTwoPower: (0 - exp).

	"get eps value"
	eps _ guess * Epsilon.
	eps _ eps * eps.
	delta _ (self - (guess * guess)) / (guess * 2.0).
	[(delta * delta) > eps] whileTrue: [
		guess _ guess + delta.
		delta _ (self - (guess * guess)) / (guess * 2.0)].
	^ guess! !

!MFloat methodsFor: 'mathematical functions'!
tan
	"Answer the tangent of the receiver taken as an angle in radians."

	^ self sin / self cos! !

!MFloat methodsFor: 'mathematical functions'!
timesTwoPower: anInteger 
	"Primitive. Answer with the receiver multiplied by 2.0 raised
	to the power of the argument.
	Optional. See Object documentation whatIsAPrimitive."

	<primitive: 54>

	anInteger < -29 ifTrue: [^ self * (2.0 raisedToInteger: anInteger)].
	anInteger < 0 ifTrue: [^ self / (1 bitShift: (0 - anInteger)) asFloat].
	anInteger < 30 ifTrue: [^ self * (1 bitShift: anInteger) asFloat].
	^ self * (2.0 raisedToInteger: anInteger)! !


!MFloat methodsFor: 'comparing' stamp: 'di 11/6/1998 13:55'!
< aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is less than the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 43>
	^ aNumber adaptToFloat: self andSend: #<! !

!MFloat methodsFor: 'comparing' stamp: 'di 11/6/1998 13:55'!
<= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is less than or equal to the argument. Otherwise return
	false. Fail if the argument is not a Float. Optional. See Object
	documentation whatIsAPrimitive."

	<primitive: 45>
	^ aNumber adaptToFloat: self andSend: #<=! !

!MFloat methodsFor: 'comparing' stamp: 'di 11/6/1998 13:56'!
= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is equal to the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 47>
	aNumber isNumber ifFalse: [^ false].
	^ aNumber adaptToFloat: self andSend: #=! !

!MFloat methodsFor: 'comparing' stamp: 'di 11/6/1998 13:57'!
> aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is greater than the argument. Otherwise return false.
	Fail if the argument is not a Float. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 44>
	^ aNumber adaptToFloat: self andSend: #>! !

!MFloat methodsFor: 'comparing' stamp: 'di 11/6/1998 13:57'!
>= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is greater than or equal to the argument. Otherwise return
	false. Fail if the argument is not a Float. Optional. See Object documentation 
	whatIsAPrimitive. "

	<primitive: 46>
	^ aNumber adaptToFloat: self andSend: #>! !

!MFloat methodsFor: 'comparing' stamp: 'jm 4/28/1998 01:04'!
hash
	"Hash is reimplemented because = is implemented. Both words of the float are used; 8 bits are removed from each end to clear most of the exponent regardless of the byte ordering. (The bitAnd:'s ensure that the intermediate results do not become a large integer.) Slower than the original version in the ratios 12:5 to 2:1 depending on values. (DNS, 11 May, 1997)"

	^ (((self basicAt: 1) bitAnd: 16r00FFFF00) +
	   ((self basicAt: 2) bitAnd: 16r00FFFF00)) bitShift: -8
! !

!MFloat methodsFor: 'comparing'!
~= aNumber 
	"Primitive. Compare the receiver with the argument and return true
	if the receiver is not equal to the argument. Otherwise return false.
	Fail if the argument is not a Float. Optional. See Object documentation
	whatIsAPrimitive."

	<primitive: 48>
	^super ~= aNumber! !


!MFloat methodsFor: 'testing' stamp: 'jm 4/30/1998 13:50'!
isInfinite
	"Return true if the receiver is positive or negative infinity."

	^ self = Infinity or: [self = NegativeInfinity]
! !

!MFloat methodsFor: 'testing' stamp: 'tao 10/10/97 16:39'!
isNaN
	"simple, byte-order independent test for Not-a-Number"

	^ self ~= self! !

!MFloat methodsFor: 'testing' stamp: 'jm 4/28/1998 01:10'!
sign
	"Answer 1 if the receiver is greater than 0, -1 if less than 0, else 0.
	Handle IEEE-754 negative-zero by reporting a sign of -1"

	self > 0 ifTrue: [^ 1].
	(self < 0 or: [((self at: 1) bitShift: -31) = 1]) ifTrue: [^ -1].
	^ 0! !


!MFloat methodsFor: 'truncation and round off'!
exponent
	"Primitive. Consider the receiver to be represented as a power of two
	multiplied by a mantissa (between one and two). Answer with the
	SmallInteger to whose power two is raised. Optional. See Object
	documentation whatIsAPrimitive."

	| positive |
	<primitive: 53>
	self >= 1.0 ifTrue: [^self floorLog: 2].
	self > 0.0
		ifTrue: 
			[positive _ (1.0 / self) exponent.
			self = (1.0 / (1.0 timesTwoPower: positive))
				ifTrue: [^positive negated]
				ifFalse: [^positive negated - 1]].
	self = 0.0 ifTrue: [^-1].
	^self negated exponent! !

!MFloat methodsFor: 'truncation and round off'!
fractionPart
	"Primitive. Answer a Float whose value is the difference between the 
	receiver and the receiver's asInteger value. Optional. See Object 
	documentation whatIsAPrimitive."

	<primitive: 52>
	^self - self truncated asFloat! !

!MFloat methodsFor: 'truncation and round off'!
rounded
	"Answer the integer nearest the receiver."

	self >= 0.0
		ifTrue: [^(self + 0.5) truncated]
		ifFalse: [^(self - 0.5) truncated]! !

!MFloat methodsFor: 'truncation and round off' stamp: 'tao 4/19/98 13:14'!
significand

	^ self timesTwoPower: (self exponent negated)! !

!MFloat methodsFor: 'truncation and round off' stamp: 'jm 10/28/2003 12:59'!
truncated
	"Answer with a SmallInteger equal to the value of the receiver without 
	its fractional part. The primitive fails if the truncated value cannot be 
	represented as a SmallInteger. In that case, the code below will compute 
	a LargeInteger truncated value.
	Essential. See Object documentation whatIsAPrimitive. "

	<primitive: 51>
	(self isInfinite or: [self isNaN]) ifTrue: [self error: 'Cannot truncate this number'].

	self abs < 2.0e16
		ifTrue: ["Fastest way when it may not be an integer"
				^ (self quo: 1073741823.0) * 1073741823 + (self rem: 1073741823.0) truncated]
		ifFalse: [^ self error: 'not yet implemented']! !


!MFloat methodsFor: 'converting' stamp: 'jm 12/2/2003 21:40'!
adaptToInteger: rcvr andSend: selector
	"If I am involved in arithmetic with an Integer, convert it to a Float."

	^ rcvr asFloat perform: selector with: self
! !

!MFloat methodsFor: 'converting'!
asFloat
	"Answer the receiver itself."

	^self! !

!MFloat methodsFor: 'converting'!
degreesToRadians
	"Answer the receiver in radians. Assumes the receiver is in degrees."

	^self * RadiansPerDegree! !

!MFloat methodsFor: 'converting'!
radiansToDegrees
	"Answer the receiver in degrees. Assumes the receiver is in radians."

	^self / RadiansPerDegree! !


!MFloat methodsFor: 'printing' stamp: 'jm 11/13/2002 16:31'!
absPrintOn: aStream base: base
	"Print my value on a stream in the given base.  Assumes that my value is strictly
	positive; negative numbers, zero, and NaNs have already been handled elsewhere.
	Based upon the algorithm outlined in:
	Robert G. Burger and R. Kent Dybvig
	Printing Floating Point Numbers Quickly and Accurately
	ACM SIGPLAN 1996 Conference on Programming Language Design and Implementation
	June 1996.
	This version performs all calculations with Floats instead of LargeIntegers, and loses
	about 3 lsbs of accuracy compared to an exact conversion."

	| significantBits fBase exp baseExpEstimate r s mPlus mMinus scale d tc1 tc2 fixedFormat decPointCount |
	self isInfinite ifTrue: [aStream nextPutAll: 'Infinity'. ^ self].
	significantBits _ 50.  "approximately 3 lsb's of accuracy loss during conversion"
	fBase _ base asFloat.
	exp _ self exponent.
	baseExpEstimate _ (exp * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
	exp >= 0
		ifTrue:
			[r _ self.
			s _ 1.0.
			mPlus _ 1.0 timesTwoPower: exp - significantBits.
			mMinus _ self significand ~= 1.0 ifTrue: [mPlus] ifFalse: [mPlus / 2.0]]
		ifFalse:
			[r _ self timesTwoPower: significantBits.
			s _ 1.0 timesTwoPower:  significantBits.
			mMinus _ 1.0 timesTwoPower: (exp max: -1024).
			mPlus _
				(exp = MinValLogBase2) | (self significand ~= 1.0)
					ifTrue: [mMinus]
					ifFalse: [mMinus * 2.0]].
	baseExpEstimate >= 0
		ifTrue:
			[s _ s * (fBase raisedToInteger: baseExpEstimate).
			exp = 1023
				ifTrue:   "scale down to prevent overflow to Infinity during conversion"
					[r _ r / fBase.
					s _ s / fBase.
					mPlus _ mPlus / fBase.
					mMinus _ mMinus / fBase]]
		ifFalse:
			[exp < -1023
				ifTrue:   "scale up to prevent denorm reciprocals overflowing to Infinity"
					[d _ (53 * fBase reciprocalLogBase2 - 1.0e-10) ceiling.
					scale _ fBase raisedToInteger: d.
					r _ r * scale.
					mPlus _ mPlus * scale.
					mMinus _ mMinus * scale.
					scale _ fBase raisedToInteger: (baseExpEstimate + d) negated]
				ifFalse:
				[scale _ fBase raisedToInteger: baseExpEstimate negated].
			s _ s / scale].
	(r + mPlus >= s)
		ifTrue: [baseExpEstimate _ baseExpEstimate + 1]
		ifFalse:
			[s _ s / fBase].
	(fixedFormat _ baseExpEstimate between: -3 and: 6)
		ifTrue:
			[decPointCount _ baseExpEstimate.
			baseExpEstimate <= 0
				ifTrue: [aStream nextPutAll: ('0.000000' truncateTo: 2 - baseExpEstimate)]]
		ifFalse:
			[decPointCount _ 1].
	[d _ (r / s) truncated.
	r _ r - (d * s).
	(tc1 _ r <= mMinus) | (tc2 _ r + mPlus >= s)] whileFalse:
		[aStream nextPut: (MCharacter digitValue: d).
		r _ r * fBase.
		mPlus _ mPlus * fBase.
		mMinus _ mMinus * fBase.
		decPointCount _ decPointCount - 1.
		decPointCount = 0 ifTrue: [aStream nextPut: $.]].
	tc2 ifTrue:
		[tc1 not | (tc1 & (r*2.0 >= s)) ifTrue: [d _ d + 1]].
	aStream nextPut: (MCharacter digitValue: d).
	decPointCount > 0
		ifTrue:
		[decPointCount - 1 to: 1 by: -1 do: [:i | aStream nextPut: $0].
		aStream nextPutAll: '.0'].
	fixedFormat ifFalse:
		[aStream nextPut: $e.
		aStream nextPutAll: (baseExpEstimate - 1) printString]! !

!MFloat methodsFor: 'printing' stamp: 'tao 4/19/98 23:31'!
printOn: aStream base: base
	"Handle sign, zero, and NaNs; all other values passed to absPrintOn:base:" 

	self isNaN ifTrue: [aStream nextPutAll: 'NaN'. ^ self]. "check for NaN before sign"
	self > 0.0
		ifTrue: [self absPrintOn: aStream base: base]
		ifFalse:
			[self sign = -1
				ifTrue: [aStream nextPutAll: '-'].
			self = 0.0
				ifTrue: [aStream nextPutAll: '0.0'. ^ self]
				ifFalse: [self negated absPrintOn: aStream base: base]]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MFloat class
	instanceVariableNames: ''!

!MFloat class methodsFor: 'class initialization' stamp: 'jm 4/30/1998 13:48'!
initialize
	"Float initialize"
	"Constants from Computer Approximations, pp. 182-183:
		Pi = 3.14159265358979323846264338327950288
		Pi/2 = 1.57079632679489661923132169163975144
		Pi*2 = 6.28318530717958647692528676655900576
		Pi/180 = 0.01745329251994329576923690768488612
		2.0 ln = 0.69314718055994530941723212145817657
		2.0 sqrt = 1.41421356237309504880168872420969808"

	Pi _ 3.14159265358979323846264338327950288.
	Halfpi _ Pi / 2.0.
	Twopi _ Pi * 2.0.
	RadiansPerDegree _ Pi / 180.0.

	Ln2 _ 0.69314718055994530941723212145817657.
	Ln10 _ 10.0 ln.
	Sqrt2 _ 1.41421356237309504880168872420969808.
	E _ 2.718281828459045235360287471353.

	Epsilon _ 0.000000000001.  "Defines precision of mathematical functions"

	MaxVal _ 1.7976931348623159e308.
	MaxValLn _ 709.782712893384.
	MinValLogBase2 _ -1074.

	Infinity _ MaxVal * MaxVal.
	NegativeInfinity _ 0.0 - Infinity.
	NaN _ Infinity - Infinity.
	NegativeZero _ 1.0 / Infinity negated.
! !


!MFloat class methodsFor: 'instance creation' stamp: 'jm 11/26/2003 20:10'!
readFrom: aStream 
	"Answer a new Float as described on the stream, aStream."

	^ (MNumber readFrom: aStream) asFloat
! !


!MFloat class methodsFor: 'constants'!
pi
	"Answer the constant, Pi."

	^Pi! !


Dictionary subclass: #MIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MIdentityDictionary commentStamp: '<historical>' prior: 0!
I differ from a normal Dictionary the way IdentitySet differs from a normal Set--I use identityHash and == to hash and compare keys. Thus, keys that are = to each other can be used for separate dictionary entries as long as they are distinct objects.
!


!MIdentityDictionary methodsFor: 'private' stamp: 'jm 12/8/2003 23:50'!
keys
	"Answer an array of the receiver's keys."

	| result |
	result _ OrderedCollection new: self size.
	self keysDo: [:key | result add: key].
	^ result asArray
! !

!MIdentityDictionary methodsFor: 'private' stamp: 'jm 2/18/98 13:18'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| finish hash start element |
	finish _ array size.
	finish > 4096
		ifTrue: [hash _ anObject identityHash * (finish // 4096)]
		ifFalse: [hash _ anObject identityHash].
	start _ (hash \\ array size) + 1.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element key == anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element key == anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !


Set subclass: #MIdentitySet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MIdentitySet commentStamp: '<historical>' prior: 0!
I am similar to a normal Set, except that I use the object's identityHash and == to test for equality. Thus, I can contain multiple instance of objects that are equal to each other. For example if you add 'foo' and 'foo' copy to a normal Set, that Set would keep only one copy of 'foo', since 'foo' = 'foo' copy. An IdentitySet would store both the original string and its copy because they are distinct objects (i.e., they are not == to each other).
!


!MIdentitySet methodsFor: 'private' stamp: 'jm 2/18/98 13:19'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| finish hash start element |
	finish _ array size.
	finish > 4096
		ifTrue: [hash _ anObject identityHash * (finish // 4096)]
		ifFalse: [hash _ anObject identityHash].
	start _ (hash \\ array size) + 1.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element == anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element == anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !


Object subclass: #MPoint
	instanceVariableNames: 'x y '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MPoint commentStamp: '<historical>' prior: 0!
I represent an x-y pair of numbers useful for designating a location on the screen.
!


!MPoint methodsFor: 'accessing' stamp: 'jm 11/13/2002 18:01'!
x

	^ x
! !

!MPoint methodsFor: 'accessing' stamp: 'jm 11/13/2002 18:00'!
y

	^ y
! !


!MPoint methodsFor: 'polar coordinates' stamp: 'jm 11/13/2002 18:05'!
degrees
	"Answer the angle the receiver makes with origin in degrees. Right is 0; down is 90."

	| tan theta |
	x = 0
		ifTrue: [
			y >= 0 ifTrue: [^ 90.0] ifFalse: [^ 270.0]]
		ifFalse: [
			tan _ y asFloat / x asFloat.
			theta _ tan arcTan.
			x >= 0
				ifTrue: [
					y >= 0
						ifTrue: [^ theta radiansToDegrees]
						ifFalse: [^ 360.0 + theta radiansToDegrees]]
				ifFalse: [
					^ 180.0 + theta radiansToDegrees]].
! !

!MPoint methodsFor: 'polar coordinates' stamp: 'jm 11/13/2002 18:03'!
r
	"Answer the receiver's radius in polar coordinate system."

	^ ((x * x) + (y * y)) sqrt
! !

!MPoint methodsFor: 'polar coordinates' stamp: 'jm 11/13/2002 18:05'!
theta
	"Answer the angle the receiver makes with origin in radians. See degrees."

	| tan theta |
	x = 0
		ifTrue: [
			y >= 0
				ifTrue: [^ 1.5708 "90.0 degreesToRadians"]
				ifFalse: [^ 4.71239 "270.0 degreesToRadians"]]
		ifFalse: [
			tan _ y asFloat / x asFloat.
			theta _ tan arcTan.
			x >= 0
				ifTrue: [
					y >= 0
						ifTrue: [^ theta]
						ifFalse: [^ 360.0 degreesToRadians + theta]]
				ifFalse: [^ 180.0 degreesToRadians + theta]].
! !


!MPoint methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:01'!
* arg 
	"Answer a Point that is the product of the receiver and arg."

	arg isPoint ifTrue: [^ (x * arg x) @ (y * arg y)].
	^ arg adaptToPoint: self andSend: #*! !

!MPoint methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:01'!
+ arg 
	"Answer a Point that is the sum of the receiver and arg."

	arg isPoint ifTrue: [^ (x + arg x) @ (y + arg y)].
	^ arg adaptToPoint: self andSend: #+! !

!MPoint methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:02'!
- arg 
	"Answer a Point that is the difference of the receiver and arg."

	arg isPoint ifTrue: [^ (x - arg x) @ (y - arg y)].
	^ arg adaptToPoint: self andSend: #-! !

!MPoint methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:02'!
/ arg 
	"Answer a Point that is the quotient of the receiver and arg."

	arg isPoint ifTrue: [^ (x / arg x) @ (y / arg y)].
	^ arg adaptToPoint: self andSend: #/! !

!MPoint methodsFor: 'arithmetic' stamp: 'di 11/6/1998 14:02'!
// arg 
	"Answer a Point that is the quotient of the receiver and arg."

	arg isPoint ifTrue: [^ (x // arg x) @ (y // arg y)].
	^ arg adaptToPoint: self andSend: #//! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:46'!
abs
	"Answer a Point whose x and y are the absolute values of the receiver's x and y."

	^ x abs @ y abs
! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:44'!
max: aPoint 
	"Answer a new Point whose x and y are the maximum of the receiver and the argument point x and y."

	^ (x max: aPoint x) @ (y max: aPoint y)
! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:45'!
min: aPoint 
	"Answer a new Point whose x and y are the minimum of the receiver's and the argument point's x and y."

	^ (x min: aPoint x) @ (y min: aPoint y)
! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 11/13/2002 17:50'!
negated
	"Answer a point whose x and y coordinates are the negatives of those of the receiver."

	^ x negated @ y negated
! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 6/3/1998 12:21'!
rounded
	"Answer a Point that is the receiver's x and y rounded. Answer the receiver if its coordinates are already integral."

	(x isInteger and: [y isInteger]) ifTrue: [^ self].
	^ x rounded @ y rounded
! !

!MPoint methodsFor: 'arithmetic' stamp: 'jm 5/29/1998 15:53'!
truncated
	"Answer a Point whose x and y coordinates are integers. Answer the receiver if its coordinates are already integral."

	(x isInteger and: [y isInteger]) ifTrue: [^ self].
	^ x truncated @ y truncated
! !


!MPoint methodsFor: 'comparing'!
= aPoint

	self species = aPoint species
		ifTrue: [^x = aPoint 
	"Refer to the comment in Object|=." x and: [y = aPoint y]]
		ifFalse: [^false]! !

!MPoint methodsFor: 'comparing' stamp: 'jm 11/13/2002 17:43'!
hash
	"Hash is reimplemented because = is implemented."

	^ (x hash bitShift: 2) bitXor: y hash
! !


!MPoint methodsFor: 'converting' stamp: 'jm 12/2/2003 21:50'!
adaptToFloat: rcvr andSend: selector
	"If I am involved in arithmetic with a Float, convert it to a Point."

	^ rcvr@rcvr perform: selector with: self
! !

!MPoint methodsFor: 'converting' stamp: 'jm 12/2/2003 21:47'!
adaptToInteger: rcvr andSend: selector
	"If I am involved in arithmetic with an Integer, convert it to a Point."

	^ rcvr@rcvr perform: selector with: self
! !

!MPoint methodsFor: 'converting' stamp: 'jm 11/13/2002 17:54'!
asPoint
	"Answer the receiver itself."

	^ self
! !


!MPoint methodsFor: 'point functions' stamp: 'jm 11/13/2002 17:56'!
crossProduct: aPoint 
	"Answer a number that is the cross product of the receiver and the argument, aPoint."

	^ (x * aPoint y) - (y * aPoint x)
! !

!MPoint methodsFor: 'point functions' stamp: 'jm 11/13/2002 17:56'!
dist: aPoint 
	"Answer the distance between aPoint and the receiver."

	^ (aPoint - self) r
! !

!MPoint methodsFor: 'point functions' stamp: 'jm 11/13/2002 17:56'!
dotProduct: aPoint 
	"Answer a number that is the dot product of the receiver and the argument."

	^ (x * aPoint x) + (y * aPoint y)
! !


!MPoint methodsFor: 'printing'!
printOn: aStream 
	"The receiver prints on aStream in terms of infix notation."

	x printOn: aStream.
	aStream nextPut: $@.
	y printOn: aStream! !


!MPoint methodsFor: 'private' stamp: 'jm 11/13/2002 17:59'!
setR: rho degrees: theta 

	| radians |
	radians _ theta asFloat degreesToRadians.
	x _ rho asFloat * radians cos.
	y _ rho asFloat * radians sin.
! !

!MPoint methodsFor: 'private' stamp: 'sw 3/21/2000 13:24'!
setX: xValue setY: yValue

	x _ xValue.
	y _ yValue! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MPoint class
	instanceVariableNames: ''!

!MPoint class methodsFor: 'instance creation' stamp: 'jm 11/13/2002 17:59'!
r: rho degrees: theta
	"Answer an instance of me with polar coordinates rho and theta."

	^ self new setR: rho degrees: theta
! !

!MPoint class methodsFor: 'instance creation' stamp: 'jm 11/13/2002 18:00'!
x: xValue y: yValue
	"Answer an instance of me with the given coordinates."

	^ self new setX: xValue setY: yValue
! !


LinkedList subclass: #MSemaphore
	instanceVariableNames: 'excessSignals '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional'!
!MSemaphore commentStamp: 'jm 12/2/2003 07:49' prior: 0!
I provide a way to synchronize processes using the 'signal' and 'wait' operations. A processing wishing to wait for some condition or for exclusive access to some data structure performs a wait operation. If the semaphore contains at least one signal, it decrements the signal count and proceeds. If it has no signals, the calling process is suspended until the semaphore is signaled by the virtual machine in response to some external event, such as new data arriving on a socket or a timeout expiring.

Warning: The virtual machine depends on the order of my instance variables.
!


!MSemaphore methodsFor: 'initialize' stamp: 'jm 12/8/2003 21:00'!
initialize
	"Consume any excess signals the receiver may have accumulated."

	excessSignals _ 0.
! !


!MSemaphore methodsFor: 'comparing' stamp: 'jm 10/26/2003 18:42'!
= anObject

	^ self == anObject
! !

!MSemaphore methodsFor: 'comparing' stamp: 'jm 10/26/2003 18:42'!
hash

	^ self identityHash
! !


!MSemaphore methodsFor: 'semaphore operations' stamp: 'jm 10/26/2003 18:44'!
critical: aBlock 
	"Evaluate the given block immediated if the receiver is not currently running the critical: method. If it is, evaluate the given block when the current critical: message is finished. Answer the result of evaluating the block."

	| result |
	self wait.
	result _ aBlock value.
	self signal.
	^ result
! !

!MSemaphore methodsFor: 'semaphore operations' stamp: 'jm 10/26/2003 18:49'!
signal
	"Primitive. Increment my signal count. If one or more processes are waiting on me, allow the first one to proceed. If no process is waiting, just remember the excess signal. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 85>
	self primitiveFailed.
! !

!MSemaphore methodsFor: 'semaphore operations' stamp: 'jm 10/26/2003 18:48'!
wait
	"Primitive. This semaphore must have a signal before the caller's process can proceed. If I have no signals, the process is suspended this semaphore is signalled. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 86>
	self primitiveFailed.
! !

MFloat initialize!
