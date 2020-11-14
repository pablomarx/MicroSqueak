MMagnitude subclass: #MAssociation
	instanceVariableNames: 'key value '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Unordered'!
!MAssociation commentStamp: '<historical>' prior: 0!
I represent a key-value pair. My instances can serve as entries in a Dictionary. They are used to store global and class variables.
!


!MAssociation methodsFor: 'accessing' stamp: 'jm 12/21/2000 06:38'!
key

	^ key
! !

!MAssociation methodsFor: 'accessing' stamp: 'jm 12/21/2000 06:38'!
key: anObject 

	key _ anObject.
! !

!MAssociation methodsFor: 'accessing' stamp: 'jm 12/21/2000 06:38'!
key: aKey value: anObject 

	key _ aKey.
	value _ anObject.
! !

!MAssociation methodsFor: 'accessing' stamp: 'jm 12/21/2000 06:39'!
value

	^ value
! !

!MAssociation methodsFor: 'accessing' stamp: 'jm 12/21/2000 06:39'!
value: anObject 

	value _ anObject.
! !


!MAssociation methodsFor: 'printing' stamp: 'jm 10/29/2003 11:24'!
printOn: aStream
	"Print in the format (key->value)."

	aStream nextPut: $(.
	key printOn: aStream.
	aStream nextPutAll: '->'.
	value printOn: aStream.
	aStream nextPut: $).
! !


!MAssociation methodsFor: 'comparing' stamp: 'jm 12/21/2000 06:43'!
< aLookupKey 
	"Sort by keys."

	^ key < aLookupKey key
! !

!MAssociation methodsFor: 'comparing' stamp: 'jm 12/21/2000 06:42'!
= anAssociation
	"True if the receiver and argument have equal keys."

	self species = anAssociation species
		ifTrue: [^ key = anAssociation key]
		ifFalse: [^ false].
! !

!MAssociation methodsFor: 'comparing' stamp: 'jm 12/21/2000 06:41'!
hash
	"Hash is reimplemented because = is implemented."

	^ key hash
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MAssociation class
	instanceVariableNames: ''!

!MAssociation class methodsFor: 'instance creation' stamp: 'jm 12/21/2000 06:40'!
key: newKey value: newValue
	"Answer a new Association with the given key and value."

	^ self new key: newKey value: newValue
! !


MCollection subclass: #MSet
	instanceVariableNames: 'tally array '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Unordered'!
!MSet commentStamp: '<historical>' prior: 0!
I represent a collection of elements in which each element is stored only once. Elements must respond to hash and =.
!


!MSet methodsFor: 'testing' stamp: 'jm 11/13/2002 17:20'!
= aSet

	(aSet isKindOf: MSet) ifFalse: [^ false].
	self size = aSet size ifFalse: [^ false].
	self do: [:each | (aSet includes: each) ifFalse: [^ false]].
	^ true
! !

!MSet methodsFor: 'testing'!
includes: anObject 
	^ (array at: (self findElementOrNil: anObject)) ~~ nil! !


!MSet methodsFor: 'adding' stamp: 'go 10/1/97 09:33'!
add: newObject
	"Add an element. User error instead of halt. go 10/1/97 09:33"

	| index |
	newObject == nil ifTrue: [self error: 'Sets cannot meaningfully contain nil as an element'].
	index _ self findElementOrNil: newObject.
	(array at: index) == nil ifTrue:
		[self atNewIndex: index put: newObject].
	^ newObject! !


!MSet methodsFor: 'removing'!
remove: oldObject ifAbsent: aBlock

	| index |
	index _ self findElementOrNil: oldObject.
	(array at: index) == nil ifTrue: [ ^ aBlock value ].
	array at: index put: nil.
	tally _ tally - 1.
	self fixCollisionsFrom: index.
	^ oldObject! !


!MSet methodsFor: 'enumerating' stamp: 'jm 11/13/2002 17:21'!
collect: aBlock 
	"Return a Set containing the result of evaluating aBlock for each element of this set."

	| newSet |
	tally = 0 ifTrue: [^ MSet new: 2].
	newSet _ MSet new: self size.
	array do: [:each | each == nil ifFalse: [newSet add: (aBlock value: each)]].
	^ newSet
! !

!MSet methodsFor: 'enumerating'!
do: aBlock 
	tally = 0 ifTrue: [^ self].
	array do: 
		[:element | element == nil ifFalse: [aBlock value: element]]! !


!MSet methodsFor: 'private'!
atNewIndex: index put: anObject
	array at: index put: anObject.
	tally _ tally + 1.
	self fullCheck! !

!MSet methodsFor: 'private' stamp: 'jm 12/2/2003 22:22'!
copy

	^ self basicCopy withArray: array basicCopy
! !

!MSet methodsFor: 'private'!
findElementOrNil: anObject
	"Answer the index of a first slot containing either a nil (indicating an empty slot) or an element that matches the given object. Answer the index of that slot or zero. Fail if neither a match nor an empty slot is found."
	| index |
	index _ self scanFor: anObject.
	index > 0 ifTrue: [ ^ index ].

	"Bad scene.  Neither have we found a matching element
	nor even an empty slot.  No hashed set is ever supposed to get
	completely full."
	self error: 'There is no free space in this set!!'.! !

!MSet methodsFor: 'private'!
fixCollisionsFrom: index
	"The element at index has been removed and replaced by nil.
	This method moves forward from there, relocating any entries
	that had been placed below due to collisions with this one"
	| length oldIndex newIndex element |
	oldIndex _ index.
	length _ array size.
	[oldIndex = length
			ifTrue: [oldIndex _  1]
			ifFalse: [oldIndex _  oldIndex + 1].
	(element _ self keyAt: oldIndex) == nil]
		whileFalse: 
			[newIndex _ self findElementOrNil: element.
			oldIndex = newIndex ifFalse: [self swap: oldIndex with: newIndex]]! !

!MSet methodsFor: 'private' stamp: 'di 11/4/97 20:11'!
fullCheck
	"Keep array at least 1/4 free for decent hash behavior"
	array size - tally < (array size // 4 max: 1)
		ifTrue: [self grow]! !

!MSet methodsFor: 'private' stamp: 'jm 12/31/2003 13:46'!
grow
	"Grow the elements array and reinsert the old elements."

	| oldElements |
	oldElements _ array.
	array _ MArray new: array size + (array size max: 2).
	tally _ 0.
	oldElements do: [:each |
		each == nil ifFalse: [self noCheckAdd: each]].
! !

!MSet methodsFor: 'private' stamp: 'jm 11/13/2002 16:41'!
init: n
	"Initialize array to an array size of n."

	array _ MArray new: n.
	tally _ 0.
! !

!MSet methodsFor: 'private'!
keyAt: index
	"May be overridden by subclasses so that fixCollisions will work"
	^ array at: index! !

!MSet methodsFor: 'private'!
noCheckAdd: anObject
	array at: (self findElementOrNil: anObject) put: anObject.
	tally _ tally + 1! !

!MSet methodsFor: 'private'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish |
	start _ (anObject hash \\ array size) + 1.
	finish _ array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element = anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element = anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !

!MSet methodsFor: 'private'!
size
	^ tally! !

!MSet methodsFor: 'private'!
swap: oneIndex with: otherIndex
	"May be overridden by subclasses so that fixCollisions will work"

	array swap: oneIndex with: otherIndex
! !

!MSet methodsFor: 'private'!
withArray: anArray
	"private -- for use only in copy"
	array _ anArray! !


!MSet methodsFor: 'accessing' stamp: 'jm 11/24/2003 09:19'!
asArray
	"Return an array whose elements are those of the receiver.  "

	| s |
	s _ MWriteStream on: (MArray new: self size).
	self do: [:el | s nextPut: el].
	^ s contents
! !


!MSet methodsFor: 'converting' stamp: 'jm 12/8/2003 22:45'!
asSet

	^ self
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MSet class
	instanceVariableNames: ''!

!MSet class methodsFor: 'instance creation' stamp: 'jm 10/26/2003 20:05'!
new

	^ self new: 4
! !

!MSet class methodsFor: 'instance creation' stamp: 'jm 11/26/2003 20:08'!
new: nElements
	"Create a Set large enough to hold nElements without growing."

	| initialSize |
	"make large enough size to hold nElements with some slop (see fullCheck)"
	nElements <= 0
		ifTrue: [initialSize _ 1]
		ifFalse: [initialSize _ ((nElements + 1) * 4) // 3].

	^ self basicNew init: initialSize
! !


MSet subclass: #MDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Unordered'!
!MDictionary commentStamp: '<historical>' prior: 0!
I represent a set of elements that can be viewed from one of two perspectives: a set of associations, or a set of values that are externally named where the name can be any object that responds to =. The external name is referred to as the key.
!


!MDictionary methodsFor: 'accessing'!
associationAt: key 
	^ self associationAt: key ifAbsent: [self errorKeyNotFound]! !

!MDictionary methodsFor: 'accessing'!
associationAt: key ifAbsent: aBlock 
	"Answer the association with the given key.
	If key is not found, return the result of evaluating aBlock."

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	nil == assoc ifTrue: [ ^ aBlock value ].
	^ assoc! !

!MDictionary methodsFor: 'accessing'!
at: key 
	"Answer the value associated with the key."

	^ self at: key ifAbsent: [self errorKeyNotFound]! !

!MDictionary methodsFor: 'accessing'!
at: key ifAbsent: aBlock 

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	nil == assoc ifTrue: [ ^ aBlock value ].
	^ assoc value! !

!MDictionary methodsFor: 'accessing' stamp: 'jm 11/13/2002 16:25'!
at: key put: anObject 
	"Set the value at key to be anObject.  If key is not found, create a new
	entry for key and set is value to anObject. Answer anObject."
	| index element |
	index _ self findElementOrNil: key.
	element _ array at: index.
	element == nil
		ifTrue: [self atNewIndex: index put: (MAssociation key: key value: anObject)]
		ifFalse: [element value: anObject].
	^ anObject! !

!MDictionary methodsFor: 'accessing'!
keyAtValue: value 
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer nil."

	^self keyAtValue: value ifAbsent: [self errorValueNotFound]! !

!MDictionary methodsFor: 'accessing' stamp: 'tk 2/18/97'!
keyAtValue: value ifAbsent: exceptionBlock
	"Answer the key that is the external name for the argument, value. If 
	there is none, answer the result of evaluating exceptionBlock.
	: Use =, not ==, so stings like 'this' can be found.  Note that MethodDictionary continues to use == so it will be fast."
 
	self associationsDo: 
		[:association | value = association value ifTrue: [^association key]].
	^exceptionBlock value! !

!MDictionary methodsFor: 'accessing' stamp: 'jm 11/13/2002 18:08'!
keys
	"Answer a Set containing the receiver's keys."

	| aSet |
	aSet _ MSet new: self size.
	self keysDo: [:key | aSet add: key].
	^ aSet
! !


!MDictionary methodsFor: 'testing'!
includes: anObject

	self do: [:each | anObject = each ifTrue: [^true]].
	^false! !

!MDictionary methodsFor: 'testing'!
includesKey: key 
	"Answer whether the receiver has a key equal to the argument, key."
	| index |
	index _ self findElementOrNil: key.
	(array at: index) == nil	
		ifTrue: [^ false]
		ifFalse: [^ true]! !


!MDictionary methodsFor: 'adding'!
add: anAssociation
	| index element |
	index _ self findElementOrNil: anAssociation key.
	element _ array at: index.
	element == nil
		ifTrue: [self atNewIndex: index put: anAssociation]
		ifFalse: [element value: anAssociation value].
	^ anAssociation! !


!MDictionary methodsFor: 'removing' stamp: 'jm 10/27/2003 06:08'!
remove: anObject

	self shouldNotImplement.
! !

!MDictionary methodsFor: 'removing' stamp: 'jm 10/27/2003 06:08'!
remove: anObject ifAbsent: exceptionBlock

	self shouldNotImplement.
! !

!MDictionary methodsFor: 'removing'!
removeKey: key 
	"Remove key from the receiver.
	If key is not in the receiver, notify an error."

	^ self removeKey: key ifAbsent: [self errorKeyNotFound]! !

!MDictionary methodsFor: 'removing'!
removeKey: key ifAbsent: aBlock 
	"Remove key (and its associated value) from the receiver. If key is not in 
	the receiver, answer the result of evaluating aBlock. Otherwise, answer 
	the value externally named by key."

	| index assoc |
	index _ self findElementOrNil: key.
	assoc _ array at: index.
	assoc == nil ifTrue: [ ^ aBlock value ].
	array at: index put: nil.
	tally _ tally - 1.
	self fixCollisionsFrom: index.
	^ assoc value! !


!MDictionary methodsFor: 'enumerating'!
associationsDo: aBlock 
	"Evaluate aBlock for each of the receiver's elements (key/value 
	associations)."

	super do: aBlock! !

!MDictionary methodsFor: 'enumerating' stamp: 'jm 11/13/2002 17:37'!
collect: aBlock 
	"Evaluate aBlock with each of my values as the argument. Collect the resulting values into a collection that is like me. Answer with the new collection."

	| newCollection |
	newCollection _ MOrderedCollection new: self size.
	self do: [:each | newCollection add: (aBlock value: each)].
	^ newCollection
! !

!MDictionary methodsFor: 'enumerating'!
do: aBlock

	super do: [:assoc | aBlock value: assoc value]! !

!MDictionary methodsFor: 'enumerating'!
keysDo: aBlock 
	"Evaluate aBlock for each of the receiver's keys."

	self associationsDo: [:association | aBlock value: association key]! !

!MDictionary methodsFor: 'enumerating'!
select: aBlock 
	"Evaluate aBlock with each of my values as the argument. Collect into a
	new dictionary, only those associations for which aBlock evaluates to
	true."

	| newCollection |
	newCollection _ self species new.
	self associationsDo: 
		[:each | 
		(aBlock value: each value) ifTrue: [newCollection add: each]].
	^newCollection! !


!MDictionary methodsFor: 'copying' stamp: 'jm 12/2/2003 22:31'!
copy
	"Must copy all my associations or later stores into either dictionary will effect both the original and the copy."

	^ self basicCopy withArray:
		(array collect: [:assoc |
			assoc
				ifNil: [nil]
				ifNotNil: [MAssociation key: assoc key value: assoc value]])
! !


!MDictionary methodsFor: 'printing' stamp: 'di 6/20/97 09:10'!
printOn: aStream
	aStream nextPutAll: self class name, ' ('.
	self associationsDo: [:element | element printOn: aStream. aStream space].
	aStream nextPut: $)! !


!MDictionary methodsFor: 'private'!
errorKeyNotFound

	self error: 'key not found'! !

!MDictionary methodsFor: 'private'!
errorValueNotFound

	self error: 'value not found'! !

!MDictionary methodsFor: 'private'!
keyAt: index
	"May be overridden by subclasses so that fixCollisions will work"
	| assn |
	assn _ array at: index.
	assn == nil ifTrue: [^ nil]
				ifFalse: [^ assn key]! !

!MDictionary methodsFor: 'private'!
noCheckAdd: anObject
	"Must be defined separately for Dictionary because (self findElementOrNil:) expects a key, not an association.  9/7/96 tk"

	array at: (self findElementOrNil: anObject key) put: anObject.
	tally _ tally + 1! !

!MDictionary methodsFor: 'private'!
scanFor: anObject
	"Scan the key array for the first slot containing either a nil (indicating an empty slot) or an element that matches anObject. Answer the index of that slot or zero if no slot is found. This method will be overridden in various subclasses that have different interpretations for matching elements."
	| element start finish |
	start _ (anObject hash \\ array size) + 1.
	finish _ array size.

	"Search from (hash mod size) to the end."
	start to: finish do:
		[:index | ((element _ array at: index) == nil or: [element key = anObject])
			ifTrue: [^ index ]].

	"Search from 1 to where we started."
	1 to: start-1 do:
		[:index | ((element _ array at: index) == nil or: [element key = anObject])
			ifTrue: [^ index ]].

	^ 0  "No match AND no empty slot"! !

