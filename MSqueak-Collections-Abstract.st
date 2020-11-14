MObject subclass: #MCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Abstract'!
!MCollection commentStamp: '<historical>' prior: 0!
I am the abstract superclass for classes that represent a collection of elements such as lists, arrays, sets, and dictionaries.
!


!MCollection methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:31'!
size
	"Answer how many elements the receiver contains."

	| count |
	count _ 0.
	self do: [:each | count _ count + 1].
	^ count
! !

!MCollection methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:35'!
sum
	"Answer the sum of the elements of this collection. If the collection is empty, answer zero."
	"Details: Use an arbitrary element of the collection as the initial value so this method will work for collections of any kind of object that understands + and -."

	| total seed |
	total _ seed _ self detect: [:x | true] ifNone: [^ 0].
	self do: [:el | total _ total + el].
	^ total - seed  "subtract the seed value from the total"
! !


!MCollection methodsFor: 'testing' stamp: 'jm 12/31/2003 12:31'!
includes: anObject 
	"Answer whether anObject is one of the receiver's elements."

	self do: [:each | anObject = each ifTrue: [^ true]].
	^ false
! !

!MCollection methodsFor: 'testing' stamp: 'jm 12/31/2003 12:32'!
isEmpty
	"Answer whether the receiver contains any elements."

	^ self size = 0
! !


!MCollection methodsFor: 'adding/removing' stamp: 'jm 12/31/2003 12:32'!
add: newObject 
	"Include newObject as one of my elements. Answer newObject. ArrayedCollections cannot respond to this message."

	self subclassResponsibility
! !

!MCollection methodsFor: 'adding/removing'!
remove: oldObject 
	"Remove oldObject as one of the receiver's elements. Answer oldObject 
	unless no element is equal to oldObject, in which case, create an error 
	notification."

	^self remove: oldObject ifAbsent: [self errorNotFound]! !

!MCollection methodsFor: 'adding/removing'!
remove: oldObject ifAbsent: anExceptionBlock 
	"Remove oldObject as one of the receiver's elements. If several of the 
	elements are equal to oldObject, only one is removed. If no element is 
	equal to oldObject, answer the result of evaluating anExceptionBlock. 
	Otherwise, answer the argument, oldObject. SequenceableCollections 
	cannot respond to this message."

	self subclassResponsibility! !


!MCollection methodsFor: 'enumerating'!
collect: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Collect the resulting values into a collection like the receiver. Answer 
	the new collection."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | newCollection add: (aBlock value: each)].
	^newCollection! !

!MCollection methodsFor: 'enumerating'!
detect: aBlock ifNone: exceptionBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Answer the first element for which aBlock evaluates to true. If none 
	evaluate to true, then evaluate the argument, exceptionBlock."

	self do: [:each | (aBlock value: each) ifTrue: [^each]].
	^exceptionBlock value! !

!MCollection methodsFor: 'enumerating'!
do: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument."

	self subclassResponsibility! !

!MCollection methodsFor: 'enumerating'!
select: aBlock 
	"Evaluate aBlock with each of the receiver's elements as the argument. 
	Collect into a new collection like the receiver, only those elements for 
	which aBlock evaluates to true. Answer the new collection."

	| newCollection |
	newCollection _ self species new.
	self do: [:each | (aBlock value: each) ifTrue: [newCollection add: each]].
	^newCollection! !


!MCollection methodsFor: 'converting' stamp: 'jm 11/13/2002 16:24'!
asArray
	"Answer an Array whose elements are the elements of this collection. The order in which elements are added depends on the order in which this collection enumerates its elements. In the case of unordered collections, the ordering is not necessarily the same for multiple requests for the conversion."

	| result i |
	result _ MArray new: self size.
	i _ 0.
	self do: [:each | result at: (i _ i + 1) put: each].
	^ result
! !

!MCollection methodsFor: 'converting' stamp: 'jm 11/24/2003 07:48'!
asByteArray
	"Answer a ByteArray containing my elements."

	| result i |
	result _ MByteArray new: self size.
	i _ 0.
	self do: [:each | result at: (i _ i + 1) put: each].
	^ result
! !

!MCollection methodsFor: 'converting' stamp: 'jm 11/13/2002 17:19'!
asSet
	"Answer a Set whose elements are the unique elements of the receiver."

	| aSet |
	aSet _ MSet new: self size.
	self do: [:each | aSet add: each].
	^ aSet
! !


!MCollection methodsFor: 'printing' stamp: 'di 6/20/97 09:09'!
printOn: aStream 
	"Refer to the comment in Object|printOn:."
	aStream nextPutAll: self class name, ' ('.
	self do: [:element | element printOn: aStream. aStream space].
	aStream nextPut: $)! !


!MCollection methodsFor: 'private'!
emptyCheck

	self isEmpty ifTrue: [self errorEmptyCollection]! !

!MCollection methodsFor: 'private'!
errorEmptyCollection

	self error: 'this collection is empty'! !

!MCollection methodsFor: 'private'!
errorNotFound

	self error: 'Object is not in the collection.'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MCollection class
	instanceVariableNames: ''!

!MCollection class methodsFor: 'instance creation'!
with: anObject 
	"Answer an instance of me containing anObject."

	| newCollection |
	newCollection _ self new.
	newCollection add: anObject.
	^newCollection! !

!MCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject 
	"Answer an instance of me containing the two arguments as elements."

	| newCollection |
	newCollection _ self new.
	newCollection add: firstObject.
	newCollection add: secondObject.
	^newCollection! !

!MCollection class methodsFor: 'instance creation'!
with: firstObject with: secondObject with: thirdObject 
	"Answer an instance of me containing the three arguments as elements."

	| newCollection |
	newCollection _ self new.
	newCollection add: firstObject.
	newCollection add: secondObject.
	newCollection add: thirdObject.
	^newCollection! !


MCollection subclass: #MSequenceableCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Abstract'!
!MSequenceableCollection commentStamp: '<historical>' prior: 0!
I am an abstract superclass for collections that have a well-defined order associated with their elements. Thus each element is externally-named by integers referred to as indices.
!


!MSequenceableCollection methodsFor: 'comparing'!
= otherCollection
	"Answer whether the species of the receiver is the same as
	otherCollection's species, and the receiver's size is the same as
	otherCollection's size, and each of the receiver's elements equal the
	corresponding element of otherCollection."
	| size |
	(size _ self size) = otherCollection size ifFalse: [^false].
	self species == otherCollection species ifFalse: [^false].
	1 to: size do:
		[:index |
		(self at: index) = (otherCollection at: index) ifFalse: [^false]].
	^true! !


!MSequenceableCollection methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:49'!
at: index ifAbsent: absentBlock
	"Answer the element at the given index. If I do not contain an element at that index, answer the result of evaluating the argument, absentBlock."

	(index between: 1 and: self size) ifTrue: [^ self at: index].
	^ absentBlock value
! !

!MSequenceableCollection methodsFor: 'accessing'!
first
	"Answer the first element of the receiver. Create an error notification if 
	the receiver contains no elements."

	self emptyCheck.
	^self at: 1! !

!MSequenceableCollection methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:46'!
indexOf: anObject ifAbsent: absentBlock
	"Answer the index of the given object within me. If I do not contain the given object, answer the result of evaluating the given block."

	^ self indexOf: anObject startingAt: 1 ifAbsent: absentBlock
! !

!MSequenceableCollection methodsFor: 'accessing' stamp: 'jm 12/31/2003 12:47'!
indexOf: anObject startingAt: startIndex ifAbsent: absentBlock
	"Answer the index of the given object within me starting the search at the given index. If I do not contain the given object, answer the result of evaluating the given block."

	startIndex to: self size do: [:i | (self at: i) = anObject ifTrue: [^ i]].
	^ absentBlock value
! !

!MSequenceableCollection methodsFor: 'accessing'!
last
	"Answer the last element of the receiver. Create an error notification if 
	the receiver contains no elements."

	self emptyCheck.
	^self at: self size! !

!MSequenceableCollection methodsFor: 'accessing'!
replaceFrom: start to: stop with: replacement 
	"This destructively replaces elements from start to stop in the receiver. 
	Answer the receiver itself. Use copyReplaceFrom:to:with: for 
	insertion/deletion which may alter the size of the result."

	replacement size = (stop - start + 1)
		ifFalse: [self error: 'Size of replacement doesnt match'].
	^self replaceFrom: start to: stop with: replacement startingAt: 1! !

!MSequenceableCollection methodsFor: 'accessing'!
replaceFrom: start to: stop with: replacement startingAt: repStart 
	"This destructively replaces elements from start to stop in the receiver 
	starting at index, repStart, in the sequenceable collection, 
	replacementCollection. Answer the receiver. No range checks are 
	performed."

	| index repOff |
	repOff _ repStart - start.
	index _ start - 1.
	[(index _ index + 1) <= stop]
		whileTrue: [self at: index put: (replacement at: repOff + index)]! !

!MSequenceableCollection methodsFor: 'accessing'!
size

	self subclassResponsibility! !


!MSequenceableCollection methodsFor: 'removing' stamp: 'jm 10/27/2003 06:08'!
remove: oldObject ifAbsent: anExceptionBlock 
	"SequencableCollections cannot implement removing."

	self shouldNotImplement.
! !


!MSequenceableCollection methodsFor: 'copying' stamp: 'di 1/16/98 16:40'!
, otherCollection 
	"Concatenate two Strings or Collections."
	
	^ self copyReplaceFrom: self size + 1
		  to: self size
		  with: otherCollection
"
#(2 4 6 8) , #(who do we appreciate)
((2989 printStringBase: 16) copyFrom: 4 to: 6) , ' boy!!'
"! !

!MSequenceableCollection methodsFor: 'copying'!
copyFrom: start to: stop 
	"Answer a copy of a subset of the receiver, starting from element at 
	index start until element at index stop."

	| newSize |
	newSize _ stop - start + 1.
	^(self species new: newSize)
		replaceFrom: 1
		to: newSize
		with: self
		startingAt: start! !

!MSequenceableCollection methodsFor: 'copying'!
copyReplaceFrom: start to: stop with: replacementCollection 
	"Answer a copy of the receiver satisfying the following conditions: If 
	stop is less than start, then this is an insertion; stop should be exactly 
	start-1, start = 1 means insert before the first character, start = size+1 
	means append after last character. Otherwise, this is a replacement; start 
	and stop have to be within the receiver's bounds."

	| newSequenceableCollection newSize endReplacement |
	newSize _ self size - (stop - start + 1) + replacementCollection size.
	endReplacement _ start - 1 + replacementCollection size.
	newSequenceableCollection _ self species new: newSize.
	newSequenceableCollection
		replaceFrom: 1
		to: start - 1
		with: self
		startingAt: 1.
	newSequenceableCollection
		replaceFrom: start
		to: endReplacement
		with: replacementCollection
		startingAt: 1.
	newSequenceableCollection
		replaceFrom: endReplacement + 1
		to: newSize
		with: self
		startingAt: stop + 1.
	^newSequenceableCollection! !

!MSequenceableCollection methodsFor: 'copying'!
copyWith: newElement 
	"Answer a copy of the receiver that is 1 bigger than the receiver and has 
	newElement at the last element."

	| newIC |
	newIC _ self species new: self size + 1.
	newIC 
		replaceFrom: 1
		to: self size
		with: self
		startingAt: 1.
	newIC at: newIC size put: newElement.
	^newIC! !


!MSequenceableCollection methodsFor: 'enumerating'!
collect: aBlock 
	"Refer to the comment in Collection|collect:."
	| result |
	result _ self species new: self size.
	1 to: self size do:
		[:index | result at: index put: (aBlock value: (self at: index))].
	^ result! !

!MSequenceableCollection methodsFor: 'enumerating'!
do: aBlock 
	"Refer to the comment in Collection|do:."
	1 to: self size do:
		[:index | aBlock value: (self at: index)]! !

!MSequenceableCollection methodsFor: 'enumerating' stamp: 'jm 10/27/2003 06:42'!
select: aBlock 
	"Refer to the comment in Collection|select:."

	| s |
	s _ MWriteStream on: (self species new: self size).
	1 to: self size do: [:i |
		(aBlock value: (self at: i)) ifTrue: [s nextPut: (self at: i)]].
	^ s contents
! !


!MSequenceableCollection methodsFor: 'converting' stamp: 'jm 11/13/2002 16:40'!
asArray
	"Answer an Array whose elements are the elements of the receiver, in the same order."

	| newArray |
	newArray _ MArray new: self size.
	1 to: self size do: [:index | newArray at: index put: (self at: index)].
	^ newArray
! !


!MSequenceableCollection methodsFor: 'private' stamp: 'jm 10/28/2003 10:31'!
swap: oneIndex with: anotherIndex 
	"Move the element at oneIndex to anotherIndex, and vice-versa."

	| element |
	element _ self at: oneIndex.
	self at: oneIndex put: (self at: anotherIndex).
	self at: anotherIndex put: element.
! !


MSequenceableCollection subclass: #MArrayedCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Abstract'!
!MArrayedCollection commentStamp: '<historical>' prior: 0!
I am an abstract collection whose elements can be accessed using integer keys between 1 and my size. I also support sorting.
!


!MArrayedCollection methodsFor: 'accessing' stamp: 'jm 10/26/2003 19:52'!
size
	"Primitive. Answer the number of indexable fields in the receiver. This value is the same as the largest legal subscript. Primitive is specified here to override MSequenceableCollection size. Essential. See Object documentation whatIsAPrimitive. "

	<primitive: 62>
	^ self basicSize
! !


!MArrayedCollection methodsFor: 'adding' stamp: 'jm 10/26/2003 19:52'!
add: newObject

	self shouldNotImplement.
! !


!MArrayedCollection methodsFor: 'sorting' stamp: 'jm 9/17/2000 22:20'!
mergeFirst: first middle: middle last: last into: dst by: aBlock
	"Private!! Merge the sorted ranges [first..middle] and [middle+1..last] of the receiver into the range [first..last] of dst."

	| i1 i2 val1 val2 out |
	i1 _ first.
	i2 _ middle + 1.
	val1 _ self at: i1.
	val2 _ self at: i2.
	out _ first - 1.  "will be pre-incremented"

	"select 'lower' half of the elements based on comparator"
	[(i1 <= middle) and: [i2 <= last]] whileTrue: [
		(aBlock value: val2 value: val1)
			ifTrue: [
				dst at: (out _ out + 1) put: val2.
				i2 _ i2 + 1.
				i2 <= last ifTrue: [val2 _ self at: i2]]
			ifFalse: [
				dst at: (out _ out + 1) put: val1.
				val1 _ self at: (i1 _ i1 + 1)]].

	"copy the remaining elements"
	i1 <= middle
		ifTrue: [
			dst replaceFrom: out + 1 to: last with: self startingAt: i1]
		ifFalse: [
			dst replaceFrom: out + 1 to: last with: self startingAt: i2].
! !

!MArrayedCollection methodsFor: 'sorting' stamp: 'jm 12/2/2003 22:12'!
mergeSortFrom: startIndex to: stopIndex by: aBlock
	"Sort the given range of indices using the mergesort algorithm. Mergesort is a worst-case O(N log N) sorting algorithm that usually does only half as many comparisons as heapsort or quicksort."
	"Details: recursively split the range to be sorted into two halves, mergesort each half, then merge the two halves together. An extra copy of the data is used as temporary storage and successive merge phases copy data back and forth between the receiver and this copy. The recursion is set up so that the final merge is performed into the receiver, resulting in the receiver being completely sorted."

	| temp |
	self size <= 1 ifTrue: [^ self].  "nothing to do"
	startIndex = stopIndex ifTrue: [^ self].
	(startIndex >= 1 and: [startIndex < stopIndex])
		ifFalse: [self error: 'bad start index'].
	stopIndex <= self size
		ifFalse: [self error: 'bad stop index'].
	temp _ self basicCopy.
	self mergeSortFrom: startIndex to: stopIndex src: temp dst: self by: aBlock.
! !

!MArrayedCollection methodsFor: 'sorting' stamp: 'jm 4/27/98 04:54'!
mergeSortFrom: first to: last src: src dst: dst by: aBlock
	"Private!! Split the range to be sorted in half, sort each half, and merge the two half-ranges into dst."

	| middle |
	first = last ifTrue: [^ self].
	middle _ (first + last) // 2.
	self mergeSortFrom: first to: middle src: dst dst: src by: aBlock.
	self mergeSortFrom: middle + 1 to: last src: dst dst: src by: aBlock.
	src mergeFirst: first middle: middle last: last into: dst by: aBlock.
! !

!MArrayedCollection methodsFor: 'sorting' stamp: 'jm 4/27/98 05:48'!
sort
	"Sort this array into ascending order using the '<' operator."

	self mergeSortFrom: 1 to: self size by: [:el1 :el2 | el1 < el2].
! !

!MArrayedCollection methodsFor: 'sorting' stamp: 'jm 4/27/98 04:52'!
sort: aBlock
	"Sort this array using the given comparision block. The block should take two arguments and return true if the first element should precede the second in the sorted result."

	self mergeSortFrom: 1 to: self size by: aBlock.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MArrayedCollection class
	instanceVariableNames: ''!

!MArrayedCollection class methodsFor: 'instance creation' stamp: 'jm 11/30/2003 09:28'!
new
	"Answer a new instance of me, with size = 0."

	^ self new: 0
! !

!MArrayedCollection class methodsFor: 'instance creation' stamp: 'jm 10/26/2003 19:55'!
with: anObject 
	"Answer a new instance of me, containing only anObject."

	| newCollection |
	newCollection _ self new: 1.
	newCollection at: 1 put: anObject.
	^ newCollection
! !

!MArrayedCollection class methodsFor: 'instance creation' stamp: 'jm 10/26/2003 19:57'!
with: firstObject with: secondObject 
	"Answer a new instance of me containing the two arguments as elements."

	| newCollection |
	newCollection _ self new: 2.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	^ newCollection
! !

!MArrayedCollection class methodsFor: 'instance creation' stamp: 'jm 10/26/2003 19:57'!
with: firstObject with: secondObject with: thirdObject 
	"Answer a new instance of me, containing the three arguments as elements."

	| newCollection |
	newCollection _ self new: 3.
	newCollection at: 1 put: firstObject.
	newCollection at: 2 put: secondObject.
	newCollection at: 3 put: thirdObject.
	^ newCollection
! !

