MObject subclass: #MReadStream
	instanceVariableNames: 'collection position readLimit '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Streams'!
!MReadStream commentStamp: '<historical>' prior: 0!
I support sequential access to a collection of objects. I keep track of the position of the next element to be processed; this position can be changed to allow random access.
!


!MReadStream methodsFor: 'accessing'!
contents
	"Answer with a copy of my collection from 1 to readLimit."

	^ collection copyFrom: 1 to: readLimit
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 15:34'!
next
	"Primitive. Answer the next object in the Stream represented by the receiver. Fail if the collection of this stream is not an Array or a String. Fail if the stream is positioned at its end, or if the position is out of bounds in the collection. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 65>
	position >= readLimit
		ifTrue: [^ nil]
		ifFalse: [^ collection at: (position _ position + 1)].
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 15:36'!
next: anInteger 
	"Answer a collection containing the next anInteger elements of my collection."

	| end result |
	end _ (position + anInteger) min: readLimit.
	result _ collection copyFrom: position + 1 to: end.
	position _ end.
	^ result
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 16:32'!
peek
	"Answer the next object without advancing my position. Answer nil if there are no more elements."

	| result |
	self atEnd ifTrue: [^ nil].
	result _ self next.
	position _ position - 1.
	^ result
! !

!MReadStream methodsFor: 'accessing'!
position
	"Answer the current position of accessing the sequence of objects."

	^ position
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 16:42'!
position: anInteger 
	"Set my current position to anInteger, as long as anInteger is within bounds. If not, report an error."

	anInteger >= 0 & (anInteger <= readLimit)
		ifTrue: [position _ anInteger asInteger]
		ifFalse: [self error: 'Position out of bounds: ', anInteger printString]
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 15:37'!
size
	"Compatibility with other streams (e.g., FileStream)"

	^ readLimit
! !

!MReadStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 16:44'!
skip: anInteger 
	"Set the receiver's position to be the current position+anInteger."

	self position: ((position + anInteger) min: readLimit).
! !


!MReadStream methodsFor: 'testing' stamp: 'jm 10/26/2003 14:10'!
atEnd
	"Primitive. Answer whether the receiver can access any more objects. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 67>
	^ position >= readLimit
! !

!MReadStream methodsFor: 'testing' stamp: 'jm 10/26/2003 16:35'!
peekFor: anObject
	"If my next element equals the given object, skip it and answer true. Otherwise, answer false and leave my position unchanged."

	| result |
	result _ self peek = anObject.
	result ifTrue: [self skip: 1].
	^ result
! !


!MReadStream methodsFor: 'private' stamp: 'jm 10/26/2003 17:02'!
on: aCollection
	"Initialize myself for streaming over the given collection."

	collection _ aCollection.
	readLimit _ aCollection size.
	position _ 0.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MReadStream class
	instanceVariableNames: ''!

!MReadStream class methodsFor: 'instance creation'!
on: aCollection 
	"Answer an instance of me, streaming over the elements of aCollection."

	^ self basicNew on: aCollection
! !


MReadStream subclass: #MWriteStream
	instanceVariableNames: 'writeLimit '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Streams'!
!MWriteStream commentStamp: '<historical>' prior: 0!
I support sequential reading and writing of a collection of objects. I keep track of the position of the next element to be processed; this position can be changed to allow random access.
!


!MWriteStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 16:21'!
contents
	"Answer with a copy of my collection up to the high-water mark that was written."

	readLimit _ readLimit max: position.
	^ collection copyFrom: 1 to: readLimit
! !

!MWriteStream methodsFor: 'accessing' stamp: 'jm 10/26/2003 16:20'!
position: anInteger 
	"Set my read position, but remember the high-water mark that was written."

	readLimit _ readLimit max: position.
	super position: anInteger.
! !

!MWriteStream methodsFor: 'accessing'!
size

	^ readLimit _ readLimit max: position
! !


!MWriteStream methodsFor: 'writing' stamp: 'jm 10/26/2003 16:55'!
nextPut: anObject 
	"Primitive. Insert the argument at the next position in the Stream represented by the receiver. Fail if the collection of this stream is not an Array or a String. Fail if the stream is positioned at its end, or if the position is out of bounds in the collection. Fail if the argument is not of the right type for the collection. Optional. See Object documentation whatIsAPrimitive."

	<primitive: 66>
	position >= writeLimit
		ifTrue: [^ self pastEndPut: anObject]
		ifFalse: [
			position _ position + 1.
			^ collection at: position put: anObject].
! !

!MWriteStream methodsFor: 'writing' stamp: 'jm 10/26/2003 16:52'!
nextPutAll: aCollection
	"Write the elements of the given collection starting at my current position. Answer the collection."
	"Optimization: If the given collection has the same class as my collection, use the fast operation replaceFrom:to:with:."

	| newEnd |
	collection class == aCollection class ifFalse: [
		aCollection do: [:v | self nextPut: v].
		^ aCollection].

	newEnd _ position + aCollection size.
	newEnd > writeLimit ifTrue: [  "grow my collection if necessary"
		collection _ collection,
			(collection species new: (newEnd - writeLimit + (collection size max: 20))).
		writeLimit _ collection size].

	collection replaceFrom: position + 1 to: newEnd  with: aCollection.
	position _ newEnd.
! !

!MWriteStream methodsFor: 'writing' stamp: 'jm 10/27/2003 05:49'!
space
	"Append a space character to me."

	self nextPut: MCharacter space.
! !


!MWriteStream methodsFor: 'private'!
on: aCollection

	super on: aCollection.
	readLimit _ 0.
	writeLimit _ aCollection size.
! !

!MWriteStream methodsFor: 'private' stamp: 'jm 10/26/2003 16:15'!
pastEndPut: anObject
	"Grow my collection."
	"Details: In general, double my size. Grow by at least 20 elements if my size is under 20 and grow by 20000 if my size is over 20000."

	collection _ collection,
		(collection class new: ((collection size max: 20) min: 20000)).
	writeLimit _ collection size.
	collection at: (position _ position + 1) put: anObject.
! !

