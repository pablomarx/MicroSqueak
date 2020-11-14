MArrayedCollection variableSubclass: #MArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MArray commentStamp: '<historical>' prior: 0!
I represent an ArrayedCollection whose elements are objects.
!


!MArray methodsFor: 'comparing'!
hash
	"Make sure that equal (=) arrays hash equally."

	self size = 0 ifTrue: [^17171].
	^(self at: 1) hash + (self at: self size) hash! !


!MArray methodsFor: 'converting'!
asArray
	"Answer with the receiver itself."

	^self! !

!MArray methodsFor: 'converting' stamp: 'jm 10/27/2003 06:10'!
elementsExchangeIdentityWith: otherArray
	"This primitive performs a bulk mutation, causing all pointers to the elements of this array to be replaced by pointers to the corresponding elements of otherArray.  At the same time, all pointers to the elements of otherArray are replaced by pointers to the corresponding elements of this array."

	<primitive: 128>
	self primitiveFailed! !


!MArray methodsFor: 'printing' stamp: 'jm 11/14/2002 12:41'!
printOn: aStream

	aStream nextPutAll: '#('.
	self do: [:each | each printOn: aStream. aStream space].
	aStream nextPut: $).
! !


!MArray methodsFor: 'private'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	super replaceFrom: start to: stop with: replacement startingAt: repStart! !


MArrayedCollection variableByteSubclass: #MByteArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MByteArray commentStamp: '<historical>' prior: 0!
I represent an ArrayedCollection whose elements are integers between 0 and 255 packed efficiently into memory.
!


!MByteArray methodsFor: 'converting' stamp: 'jm 12/27/2000 10:28'!
asByteArray

	^ self
! !

!MByteArray methodsFor: 'converting' stamp: 'jm 10/27/2003 07:26'!
asString
	"Answer the receiver converted to a String."

	^ (MString new: self size)
		replaceFrom: 1
		to: self size
		with: self
		startingAt: 1
! !


!MByteArray methodsFor: 'private' stamp: 'jm 12/27/2000 10:32'!
replaceFrom: startIndex to: stopIndex with: source startingAt: srcStartIndex 
	"Primitive. Destructively replace the elements from startIndex to stopIndex in the receiver with the elements starting at srcStartIndex in the source collection. Answer the receiver. Range checks are performed in the primitive. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 105>
	super replaceFrom: startIndex to: stopIndex with: source startingAt: srcStartIndex.
! !


MSequenceableCollection subclass: #MInterval
	instanceVariableNames: 'start stop step '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MInterval commentStamp: '<historical>' prior: 0!
I represent a finite sequence of numbers.
!


!MInterval methodsFor: 'accessing'!
at: anInteger 
	"Answer the anInteger'th element."

	(anInteger >= 1 and: [anInteger <= self size])
		ifTrue: [^start + (step * (anInteger - 1))]
		ifFalse: [self errorSubscriptBounds: anInteger]! !

!MInterval methodsFor: 'accessing'!
at: anInteger put: anObject 
	"Storing into an Interval is not allowed."

	self error: 'you can not store into an interval'! !

!MInterval methodsFor: 'accessing'!
first 
	"Refer to the comment in SequenceableCollection|first."

	^start! !

!MInterval methodsFor: 'accessing' stamp: 'di 11/10/97 12:22'!
includes: aNumber
	^ aNumber between: self first and: self last! !

!MInterval methodsFor: 'accessing'!
increment
	"Answer the receiver's interval increment."

	^step! !

!MInterval methodsFor: 'accessing'!
last 
	"Refer to the comment in SequenceableCollection|last."

	^stop - (stop - start \\ step)! !

!MInterval methodsFor: 'accessing'!
size

	step < 0
		ifTrue: [start < stop
				ifTrue: [^0]
				ifFalse: [^stop - start // step + 1]]
		ifFalse: [stop < start
				ifTrue: [^0]
				ifFalse: [^stop - start // step + 1]]! !


!MInterval methodsFor: 'comparing'!
= anInterval 
	"Answer true if my species and anInterval species are equal, and
	if our starts, steps and sizes are equal."

	self species == anInterval species
		ifTrue: [^start = anInterval first
					and: [step = anInterval increment and: [self size = anInterval size]]]
		ifFalse: [^false]! !

!MInterval methodsFor: 'comparing'!
hash
	"Hash is reimplemented because = is implemented."

	^(((start hash bitShift: 2)
		bitOr: stop hash)
		bitShift: 1)
		bitOr: self size! !


!MInterval methodsFor: 'adding' stamp: 'jm 10/27/2003 06:08'!
add: newObject 
	"Adding to an Interval is not allowed."

	self shouldNotImplement.
! !


!MInterval methodsFor: 'removing'!
remove: newObject 
	"Removing from an Interval is not allowed."

	self error: 'elements cannot be removed from an Interval'! !


!MInterval methodsFor: 'enumerating'!
collect: aBlock
	| nextValue result |
	result _ self species new: self size.
	nextValue _ start.
	1 to: result size do:
		[:i |
		result at: i put: (aBlock value: nextValue).
		nextValue _ nextValue + step].
	^ result! !

!MInterval methodsFor: 'enumerating'!
do: aBlock

	| aValue |
	aValue _ start.
	step < 0
		ifTrue: [[stop <= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue + step]]
		ifFalse: [[stop >= aValue]
				whileTrue: 
					[aBlock value: aValue.
					aValue _ aValue + step]]! !


!MInterval methodsFor: 'printing'!
printOn: aStream

	aStream nextPut: $(.
	start printOn: aStream.
	aStream nextPutAll: ' to: '.
	stop printOn: aStream.
	step ~= 1
		ifTrue: 
			[aStream nextPutAll: ' by: '.
			step printOn: aStream].
	aStream nextPut: $)! !


!MInterval methodsFor: 'private'!
setFrom: startInteger to: stopInteger by: stepInteger

	start _ startInteger.
	stop _ stopInteger.
	step _ stepInteger! !

!MInterval methodsFor: 'private' stamp: 'jm 11/13/2002 16:52'!
species

	^ MArray
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MInterval class
	instanceVariableNames: ''!

!MInterval class methodsFor: 'instance creation' stamp: 'jm 10/29/2003 11:52'!
from: startInteger to: stopInteger 
	"Answer an instance of me, starting at startNumber, ending at stopNumber, and with an interval increment of 1."

	^ self basicNew
		setFrom: startInteger
		to: stopInteger
		by: 1
! !

!MInterval class methodsFor: 'instance creation' stamp: 'jm 10/29/2003 11:52'!
from: startInteger to: stopInteger by: stepInteger 
	"Answer an instance of me, starting at startNumber, ending at stopNumber, and with an interval increment of stepNumber."

	^self basicNew
		setFrom: startInteger
		to: stopInteger
		by: stepInteger! !


MSequenceableCollection subclass: #MOrderedCollection
	instanceVariableNames: 'array firstIndex lastIndex '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MOrderedCollection commentStamp: '<historical>' prior: 0!
I represent a collection of objects that grows as new objects are added. Objects can be added at the front, back, or even inserted at an arbitrary position.
!


!MOrderedCollection methodsFor: 'accessing'!
at: anInteger 
	"Answer my element at index anInteger. at: is used by a knowledgeable
	client to access an existing element"

	(anInteger < 1 or: [anInteger + firstIndex - 1 > lastIndex])
		ifTrue: [self errorNoSuchElement]
		ifFalse: [^ array at: anInteger + firstIndex - 1]! !

!MOrderedCollection methodsFor: 'accessing'!
at: anInteger put: anObject 
	"Put anObject at element index anInteger. at:put: cannot be used to
	append, front or back, to an ordered collection; it is used by a
	knowledgeable client to replace an element."

	| index |
	index _ anInteger asInteger.
	(index < 1 or: [index + firstIndex - 1 > lastIndex])
		ifTrue: [self errorNoSuchElement]
		ifFalse: [^array at: index + firstIndex - 1 put: anObject]! !

!MOrderedCollection methodsFor: 'accessing'!
first
	"Answer the first element. If the receiver is empty, create an errror
	message. This is a little faster than the implementation in the superclass."

	self emptyCheck.
	^ array at: firstIndex! !

!MOrderedCollection methodsFor: 'accessing'!
last
	"Answer the last element. If the receiver is empty, create an errror
	message. This is a little faster than the implementation in the superclass."

	self emptyCheck.
	^ array at: lastIndex! !

!MOrderedCollection methodsFor: 'accessing'!
size

	^lastIndex - firstIndex + 1! !


!MOrderedCollection methodsFor: 'copying'!
copyFrom: startIndex to: endIndex 
	"Answer a copy of the receiver that contains elements from position
	startIndex to endIndex."

	| targetCollection |
	endIndex < startIndex ifTrue: [^self species new: 0].
	targetCollection _ self species new: endIndex + 1 - startIndex.
	startIndex to: endIndex do: [:index | targetCollection add: (self at: index)].
	^ targetCollection! !

!MOrderedCollection methodsFor: 'copying' stamp: 'jm 12/31/2003 12:40'!
copyReplaceFrom: start to: stop with: replacementCollection 
	"Answer a copy of the receiver with replacementCollection's elements in
	place of the receiver's start'th to stop'th elements. This does not expect
	a 1-1 map from replacementCollection to the start to stop elements, so it
	will do an insert or append."

	| newOrderedCollection delta startIndex stopIndex |
	"if start is less than 1, ignore stop and assume this is inserting at the front. 
	if start greater than self size, ignore stop and assume this is appending. 
	otherwise, it is replacing part of me and start and stop have to be within my 
	bounds. "
	delta _ 0.
	startIndex _ start.
	stopIndex _ stop.
	start < 1
		ifTrue: [startIndex _ stopIndex _ 0]
		ifFalse: [startIndex > self size
				ifTrue: [startIndex _ stopIndex _ self size + 1]
				ifFalse: 
					[(stopIndex < (startIndex - 1) or: [stopIndex > self size])
						ifTrue: [self error: 'indices are out of bounds'].
					delta _ stopIndex - startIndex + 1]].
	newOrderedCollection _ 
		self species new: self size + replacementCollection size - delta.
	1 to: startIndex - 1 do: [:index | newOrderedCollection add: (self at: index)].
	1 to: replacementCollection size do: 
		[:index | newOrderedCollection add: (replacementCollection at: index)].
	stopIndex + 1 to: self size do: [:index | newOrderedCollection add: (self at: index)].
	^newOrderedCollection! !


!MOrderedCollection methodsFor: 'adding' stamp: 'jm 12/31/2003 13:50'!
add: newObject 
	"Append newObject to me. Equivalent to addLast:. Answer newObject."

	lastIndex = array size ifTrue: [self makeRoomAtLast].
	lastIndex _ lastIndex + 1.
	array at: lastIndex put: newObject.
	^ newObject
! !

!MOrderedCollection methodsFor: 'adding'!
addFirst: newObject 
	"Add newObject to the beginning of the receiver. Answer newObject."

	firstIndex = 1 ifTrue: [self makeRoomAtFirst].
	firstIndex _ firstIndex - 1.
	array at: firstIndex put: newObject.
	^ newObject! !


!MOrderedCollection methodsFor: 'removing'!
remove: oldObject ifAbsent: absentBlock

	| index |
	index _ firstIndex.
	[index <= lastIndex]
		whileTrue: 
			[oldObject = (array at: index)
				ifTrue: 
					[self removeIndex: index.
					^ oldObject]
				ifFalse: [index _ index + 1]].
	^ absentBlock value! !

!MOrderedCollection methodsFor: 'removing'!
removeFirst
	"Remove the first element of the receiver and answer it. If the receiver is 
	empty, create an error notification."
	| firstObject |
	self emptyCheck.
	firstObject _ array at: firstIndex.
	array at: firstIndex put: nil.
	firstIndex _ firstIndex + 1.
	^ firstObject! !

!MOrderedCollection methodsFor: 'removing'!
removeLast
	"Remove the last element of the receiver and answer it. If the receiver is 
	empty, create an error notification."
	| lastObject |
	self emptyCheck.
	lastObject _ array at: lastIndex.
	array at: lastIndex put: nil.
	lastIndex _ lastIndex - 1.
	^ lastObject! !


!MOrderedCollection methodsFor: 'enumerating'!
collect: aBlock 
	"Evaluate aBlock with each of my elements as the argument. Collect the 
	resulting values into a collection that is like me. Answer the new 
	collection. Override superclass in order to use add:, not at:put:."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | newCollection add: (aBlock value: each)].
	^newCollection! !

!MOrderedCollection methodsFor: 'enumerating'!
do: aBlock 
	"Override the superclass for performance reasons."
	| index |
	index _ firstIndex.
	[index <= lastIndex]
		whileTrue: 
			[aBlock value: (array at: index).
			index _ index + 1]! !

!MOrderedCollection methodsFor: 'enumerating' stamp: 'jm 10/29/2003 11:44'!
select: aBlock 
	"Evaluate aBlock with each of my elements as the argument. Collect into a new collection like the receiver, only those elements for which aBlock evaluates to true. Override the superclass in order to use add:, not at:put:."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | (aBlock value: each) ifTrue: [newCollection add: each]].
	^ newCollection
! !


!MOrderedCollection methodsFor: 'private'!
errorNoSuchElement

	self error: 'attempt to index non-existent element in an ordered collection'! !

!MOrderedCollection methodsFor: 'private' stamp: 'jm 12/31/2003 13:47'!
grow
	"Become larger. Typically, a subclass must override this method if it adds instance variables."

	| newArray |
	newArray _ MArray new: self size + (array size max: 2).
	newArray replaceFrom: 1 to: array size with: array startingAt: 1.
	array _ newArray.
! !

!MOrderedCollection methodsFor: 'private'!
insert: anObject before: spot
	| index delta spotIndex|
	spotIndex _ spot.
	delta _ spotIndex - firstIndex.
	firstIndex = 1
		ifTrue: 
			[self makeRoomAtFirst.
			spotIndex _ firstIndex + delta].
	index _ firstIndex _ firstIndex - 1.
	[index < (spotIndex - 1)]
		whileTrue: 
			[array at: index put: (array at: index + 1).
			index _ index + 1].
	array at: index put: anObject.
	^ anObject! !

!MOrderedCollection methodsFor: 'private'!
makeRoomAtFirst
	| delta index |
	delta _ array size - self size.
	delta = 0 ifTrue: 
			[self grow.
			delta _ array size - self size].
	lastIndex = array size ifTrue: [^ self]. "just in case we got lucky"
	index _ array size.
	[index > delta]
		whileTrue: 
			[array at: index put: (array at: index - delta + firstIndex - 1).
			array at: index - delta + firstIndex - 1 put: nil.
			index _ index - 1].
	firstIndex _ delta + 1.
	lastIndex _ array size! !

!MOrderedCollection methodsFor: 'private'!
makeRoomAtLast
	| newLast delta |
	newLast _ self size.
	array size - self size = 0 ifTrue: [self grow].
	(delta _ firstIndex - 1) = 0 ifTrue: [^ self].
	"we might be here under false premises or grow did the job for us"
	1 to: newLast do:
		[:index |
		array at: index put: (array at: index + delta).
		array at: index + delta put: nil].
	firstIndex _ 1.
	lastIndex _ newLast! !

!MOrderedCollection methodsFor: 'private'!
removeIndex: removedIndex
	| index |
	index _ removedIndex.
	[index < lastIndex]
		whileTrue: 
			[array at: index put: (array at: index + 1).
			index _ index + 1].
	array at: lastIndex put: nil.
	lastIndex _ lastIndex - 1! !

!MOrderedCollection methodsFor: 'private' stamp: 'jm 12/31/2003 13:27'!
setCollection: anArray

	array _ anArray.
	firstIndex _ array size // 3 max: 1.
	lastIndex _ firstIndex - 1.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MOrderedCollection class
	instanceVariableNames: ''!

!MOrderedCollection class methodsFor: 'instance creation' stamp: 'jm 12/31/2003 13:51'!
new

	^ self new: 8
! !

!MOrderedCollection class methodsFor: 'instance creation' stamp: 'jm 11/26/2003 20:06'!
new: anInteger 
	"If a subclass adds fields, then that subclass must reimplement new:."

	^ self basicNew setCollection: (MArray new: anInteger)
! !


MArrayedCollection variableByteSubclass: #MString
	instanceVariableNames: ''
	classVariableNames: 'AsciiOrder CaseInsensitiveOrder CaseSensitiveOrder LowercasingTable '
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MString commentStamp: '<historical>' prior: 0!
I represent an ArrayedCollection of Character objects efficiently packed into 8-bit bytes.

String support a vast array of useful methods, which can best be learned by browsing and trying out examples as you find them in the code.

Here are a few useful methods to look at...
	String match:
	String contractTo:

String also inherits many useful methods from its hierarchy, such as
	SequenceableCollection ,
	SequenceableCollection copyReplaceAll:with:
!


!MString methodsFor: 'accessing' stamp: 'jm 10/28/2003 11:31'!
at: index 
	"Primitive. Answer the Character stored in the field of the receiver
	indexed by the argument. Fail if the index argument is not an Integer or
	is out of bounds. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 63>
	^ (super at: index) asCharacter
! !

!MString methodsFor: 'accessing' stamp: 'jm 11/13/2002 16:28'!
at: index put: aCharacter 
	"Primitive. Store the Character in the field of the receiver indicated by
	the index. Fail if the index is not an Integer or is out of bounds, or if
	the argument is not a Character. Essential. See Object documentation
	whatIsAPrimitive."

	<primitive: 64>
	(aCharacter isKindOf: MCharacter)
		ifTrue: [	
			index isInteger
				ifTrue: [self errorSubscriptBounds: index]
				ifFalse: [self errorNonIntegerIndex]]
		ifFalse: [self error: 'Strings only store Characters']! !

!MString methodsFor: 'accessing' stamp: 'jm 12/8/2003 23:33'!
findString: key startingAt: start caseSensitive: caseSensitive
	"Answer the index in this String at which the substring key first occurs at or after the given starting index. The match can be case-sensitive or not. Answer zero if no match is found."

	^ self
		findSubstring: key
		in: self
		startingAt: start
		matchTable: (caseSensitive ifTrue: [CaseSensitiveOrder] ifFalse: [CaseInsensitiveOrder])
! !

!MString methodsFor: 'accessing' stamp: 'jm 12/8/2003 23:36'!
findTokens: delimiters
	"Answer the collection of tokens that result from parsing self. Any character in the String delimiters marks a border. Several delimiters in a row are considered as just one separation."

	| tokens keyStart keyStop |
	tokens _ MOrderedCollection new.
	keyStop _ 1.
	[keyStop <= self size] whileTrue: [
		keyStart _ self skipDelimiters: delimiters startingAt: keyStop.
		keyStop _ self findDelimiters: delimiters startingAt: keyStart.
		keyStart < keyStop
			ifTrue: [tokens add: (self copyFrom: keyStart to: (keyStop - 1))]].
	^ tokens
! !

!MString methodsFor: 'accessing' stamp: 'jm 10/26/2003 17:21'!
indexOf: aCharacter startingAt: start

	^ self indexOfAscii: aCharacter asciiValue inString: self startingAt: start
! !

!MString methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:48'!
indexOf: aCharacter startingAt: startIndex ifAbsent: absentBlock
	"Answer the index of the given Character within me starting the search at the given index. If I do not contain the Character, answer the result of evaluating the given block."

	| ans |
	ans _ self indexOfAscii: aCharacter asciiValue inString: self startingAt: startIndex.
	ans = 0
		ifTrue: [^ absentBlock value]
		ifFalse: [^ ans]
! !

!MString methodsFor: 'accessing' stamp: 'jm 12/8/2003 23:24'!
numArgs
	"Answer the number of arguments that the receiver would take considered as a selector or -1 if it couldn't be a selector."

	| firstChar numColons |
	firstChar _ self at: 1.
	firstChar isLetter ifTrue: [
		numColons _ 0. 
		self do: [:ch |
			ch tokenish ifFalse: [^ -1].
			ch = $: ifTrue: [numColons _ numColons + 1]].
		((numColons > 0) & (self last ~= $:)) ifTrue: [^ -1].
		^ numColons].
	firstChar isSpecial ifTrue: [
		self size = 1 ifTrue: [^ 1].
		((self size = 2) and: [(self at: 2) isSpecial]) ifTrue: [^ 1].
		^ -1].
	^ -1
! !

!MString methodsFor: 'accessing'!
size
	"Primitive. Answer the number of indexable fields in the receiver. This
	value is the same as the largest legal subscript. Essential. See Object
	documentation whatIsAPrimitive."

	<primitive: 62>
	^self basicSize! !


!MString methodsFor: 'comparing' stamp: 'di 2/27/98 12:16'!
< aString 
	"Answer whether the receiver sorts before aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) = 1! !

!MString methodsFor: 'comparing' stamp: 'di 2/27/98 12:17'!
<= aString 
	"Answer whether the receiver sorts before or equal to aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) <= 2! !

!MString methodsFor: 'comparing' stamp: 'jm 11/13/2002 18:48'!
= aString 
	"Answer whether the receiver sorts equally as aString.
	The collation order is simple ascii (with case differences)."

	aString species == MString ifFalse: [^ false].

	^ (self compare: self with: aString collated: AsciiOrder) = 2! !

!MString methodsFor: 'comparing' stamp: 'di 2/27/98 12:17'!
> aString 
	"Answer whether the receiver sorts after aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) = 3! !

!MString methodsFor: 'comparing' stamp: 'di 2/27/98 12:18'!
>= aString 
	"Answer whether the receiver sorts after or equal to aString.
	The collation order is simple ascii (with case differences)."

	^ (self compare: self with: aString collated: AsciiOrder) >= 2! !

!MString methodsFor: 'comparing' stamp: 'di 2/27/98 12:41'!
compare: aString 
	"Answer a comparison code telling how the receiver sorts relative to aString:
		1 - before
		2 - equal
		3 - after.
	The collation sequence is ascii with case differences ignored.
	To get the effect of a <= b, but ignoring case, use (a compare: b) <= 2."

	^ self compare: self with: aString collated: CaseInsensitiveOrder! !

!MString methodsFor: 'comparing'!
hash

	| l m |
	(l _ m _ self size) <= 2
	  ifTrue:
		[l = 2
		  ifTrue: [m _ 3]
		  ifFalse:
			[l = 1
			  ifTrue: [^((self at: 1) asciiValue bitAnd: 127) * 106].
			^21845]].
	^(self at: 1) asciiValue * 48 + ((self at: (m - 1)) asciiValue + l)! !


!MString methodsFor: 'converting' stamp: 'jm 11/24/2003 07:50'!
asByteArray
	"Answer a ByteArray containing the ASCII values of my characters. Uses a fast primitive that avoids character conversion."

	^ (MByteArray new: self size) replaceFrom: 1 to: self size with: self
! !

!MString methodsFor: 'converting' stamp: 'jm 12/8/2003 23:27'!
asLowercase
	"Answer a String made up from the receiver whose characters are all lowercase."

	| result |
	result _ self copy asString.
	self translate: result from: 1 to: result size table: LowercasingTable.
	^ result
! !

!MString methodsFor: 'converting' stamp: 'jm 5/14/1998 10:40'!
asString
	"Answer this string."

	^ self
! !

!MString methodsFor: 'converting' stamp: 'jm 11/30/2003 17:20'!
asSymbol
	"This is the only place that new Symbols are created. A Symbol is created if and only if there is not already a Symbol with its contents in existance."

	MSymbol allInstancesDo: [:sym | self = sym ifTrue: [^ sym]].
	^ (MSymbol basicNew: self size) initFrom: self
! !


!MString methodsFor: 'printing' stamp: 'jm 10/29/2003 11:21'!
printOn: aStream 
	"Print inside string quotes, doubling inbedded quotes."

	| x |
	aStream nextPut: $'.
	1 to: self size do: [:i |
		aStream nextPut: (x _ self at: i).
		x == $' ifTrue: [aStream nextPut: x]].
	aStream nextPut: $'.
! !


!MString methodsFor: 'private' stamp: 'jm 11/30/2003 16:35'!
compare: string1 with: string2 collated: order
	"Return 1, 2 or 3, if string1 is <, =, or > string2, with the collating order of characters given by the order array."

	| len1 len2 c1 c2 |
	<primitive: 235>

	len1 _ string1 size.
	len2 _ string2 size.
	1 to: (len1 min: len2) do: [:i |
		c1 _ order at: (string1 basicAt: i) + 1.
		c2 _ order at: (string2 basicAt: i) + 1.
		c1 = c2 ifFalse: [c1 < c2 ifTrue: [^ 1] ifFalse: [^ 3]]].
	len1 = len2 ifTrue: [^ 2].
	len1 < len2 ifTrue: [^ 1] ifFalse: [^ 3].
! !

!MString methodsFor: 'private'!
findDelimiters: delimiters startingAt: start 
	"Answer the index of the character within the receiver, starting at start, that matches one of the delimiters. If the receiver does not contain any of the delimiters, answer size + 1."

	start to: self size do: [:i |
		delimiters do: [:delim | delim = (self at: i) ifTrue: [^ i]]].
	^ self size + 1! !

!MString methodsFor: 'private' stamp: 'jm 11/30/2003 16:38'!
findSubstring: key in: body startingAt: start matchTable: matchTable
	"Answer the index in the string body at which the substring key first occurs, at or beyond start. The match is determined using matchTable, which can be used to effect, eg, case-insensitive matches. If no match is found, zero will be returned."
	"Note: The algorithm below is not optimum because it is intended to be translated to C."

	| index |
	<primitive: 246>
	key size = 0 ifTrue: [^ 0].
	start to: body size - key size + 1 do: [:startIndex |
		index _ 1.
		[(matchTable at: (body at: startIndex+index-1) asciiValue + 1) =
			(matchTable at: (key at: index) asciiValue + 1)
		] whileTrue: [
			index = key size ifTrue: [^ startIndex].
			index _ index+1]].
	^ 0
"
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 1 matchTable: CaseSensitiveOrder 1
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 2 matchTable: CaseSensitiveOrder 7
' ' findSubstring: 'abc' in: 'abcdefabcd' startingAt: 8 matchTable: CaseSensitiveOrder 0
' ' findSubstring: 'abc' in: 'abcdefABcd' startingAt: 2 matchTable: CaseSensitiveOrder 0
' ' findSubstring: 'abc' in: 'abcdefABcd' startingAt: 2 matchTable: CaseInsensitiveOrder 7
"! !

!MString methodsFor: 'private' stamp: 'jm 11/30/2003 16:39'!
indexOfAscii: anInteger inString: aString startingAt: start

	| stringSize |
	<primitive: 245>
	stringSize _ aString size.
	start to: stringSize do: [:pos |
		(aString at: pos) asciiValue = anInteger ifTrue: [^ pos]].
	^ 0
! !

!MString methodsFor: 'private'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"Primitive. This destructively replaces elements from start to stop in the receiver starting at index, repStart, in the collection, replacement. Answer the receiver. Range checks are performed in the primitive only. Optional. See Object documentation whatIsAPrimitive."
	<primitive: 105>
	super replaceFrom: start to: stop with: replacement startingAt: repStart! !

!MString methodsFor: 'private' stamp: 'jm 12/8/2003 23:29'!
skipDelimiters: delimiters startingAt: start 
	"Answer the index of the first character in this string starting at the given index that does NOT match one of the delimiters. If the receiver does not contain any of the delimiters, answer size + 1. Assumes the delimiters to be a non-empty string."

	start to: self size do: [:i |
		(delimiters indexOf: (self at: i) startingAt: 1) = 0 ifTrue: [^ i]].
	^ self size + 1
! !

!MString methodsFor: 'private' stamp: 'jm 11/30/2003 16:39'!
translate: aString from: start  to: stop table: table
	"Translate the characters in the given string in place using the given mapping table."

	<primitive: 243>
	start to: stop do: [:i |
		aString at: i put: (table at: (aString at: i) asciiValue + 1)].
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MString class
	instanceVariableNames: ''!

!MString class methodsFor: 'class initialization' stamp: 'jm 11/24/2003 07:57'!
initialize
	"self initialize"

	| order |
	AsciiOrder _ (0 to: 255) asByteArray.
	CaseInsensitiveOrder _ AsciiOrder copy.
	($a to: $z) do: [:c |
		CaseInsensitiveOrder
			at: c asciiValue + 1
			put: (CaseInsensitiveOrder at: c asUppercase asciiValue + 1)].

	"case-sensitive compare sorts space, digits, letters, all the rest..."
	CaseSensitiveOrder _ (AsciiOrder collect: [:x | 255]) asByteArray.
	order _ -1.
	' 0123456789' do: [:c |  "digits, 0-10"
		CaseSensitiveOrder at: c asciiValue + 1 put: (order _ order + 1)].
	($a to: $z) do: [:c |  "letters, 11-64"
		CaseSensitiveOrder at: c asUppercase asciiValue + 1 put: (order _ order + 1).
		CaseSensitiveOrder at: c asciiValue + 1 put: (order _ order + 1)].
	1 to: CaseSensitiveOrder size do: [:i |  "all other characters"
		(CaseSensitiveOrder at: i) = 255 ifTrue: [
			CaseSensitiveOrder at: i put: (order _ order + 1)]].
	order = 255 ifFalse: [self error: 'order problem'].

	"create a table for translating to lower case"
	LowercasingTable _ ((0 to: 255) collect: [:i | i asCharacter asLowercase]) asString.
! !


!MString class methodsFor: 'constants' stamp: 'jm 10/28/2003 11:45'!
cr
	"Answer a string containing a carriage return character."

	^ self with: MCharacter cr
! !


MString variableByteSubclass: #MSymbol
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Ordered'!
!MSymbol commentStamp: '<historical>' prior: 0!
I represent a String that has a single unique instance in the system. These unique string objects are used by the system as message selectors.

Notes:
  o In Microsqueak, symbols can *only* be created by the compiler, not at runtime.
  o To save space, we may eventually replace all symbols with unique integers. In that case, any code that converts symbols into strings (e.g., using asString) would fail.
!


!MSymbol methodsFor: 'accessing' stamp: 'jm 10/27/2003 07:20'!
at: anInteger put: anObject 
	"You cannot modify the receiver."

	self errorNoModification.
! !

!MSymbol methodsFor: 'accessing' stamp: 'jm 10/27/2003 07:20'!
replaceFrom: start to: stop with: replacement startingAt: repStart

	self errorNoModification.
! !


!MSymbol methodsFor: 'comparing' stamp: 'jm 10/27/2003 07:20'!
= anObject

	^ self == anObject
! !

!MSymbol methodsFor: 'comparing' stamp: 'jm 10/27/2003 07:21'!
hash

	^ self identityHash
! !


!MSymbol methodsFor: 'copying' stamp: 'jm 12/2/2003 22:24'!
basicCopy
	"Answer myself because Symbols are unique."
! !


!MSymbol methodsFor: 'converting' stamp: 'jm 10/27/2003 07:24'!
asString 
	"Answer a string containing my characters."

	| sz result |
	sz _ self size.
	result _ MString new: sz.
	result replaceFrom: 1 to: sz with: self startingAt: 1. 
	^ result
! !

!MSymbol methodsFor: 'converting' stamp: 'jm 11/30/2003 17:12'!
asSymbol

	^ self
! !


!MSymbol methodsFor: 'printing' stamp: 'jm 10/27/2003 07:27'!
printOn: aStream

	aStream nextPutAll: self.
! !


!MSymbol methodsFor: 'private' stamp: 'jm 10/27/2003 07:18'!
errorNoModification

	self error: 'Symbols can not be modified.'
! !

!MSymbol methodsFor: 'private' stamp: 'jm 11/30/2003 17:18'!
initFrom: aString
	"Warning!! Use only to initialize new Symbols. Symbols are assumed to be immutable there after."

	self size = aString size ifFalse: [self error: 'size mismatch'].
	super replaceFrom: 1 to: self size with: aString startingAt: 1.
! !

!MSymbol methodsFor: 'private' stamp: 'jm 11/13/2002 18:28'!
species

	^ MString
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MSymbol class
	instanceVariableNames: ''!

!MSymbol class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:31'!
new: size
	"Symbols are unique. You can create a new Symbol from a String using 'asSymbol'."

	self cannotInstantiate.
! !

MString initialize!
