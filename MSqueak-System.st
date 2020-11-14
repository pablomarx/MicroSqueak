MObject subclass: #MSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-System'!
!MSystem commentStamp: '<historical>' prior: 0!
I represent the system itself. I implement some useful system facilities as class methods. I am a very lightweight version of the 'SystemDictionary' in other Smalltalk systems.
!


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MSystem class
	instanceVariableNames: ''!

!MSystem class methodsFor: 'system startup' stamp: 'jm 10/1/2008 20:18'!
graphicsTest
	"This method is called when the image is started. Add a call to your own code here."
	"MSystem graphicsTest"

	| f |
	self log: 'Screen size: ', MForm new primScreenSize printString.
	f _ MForm new.
	f beDisplayDepth: 32.
	0 to: 255 do: [:r |
		0 to: 255 do: [:gb |
			f setColorR: r g: gb b: gb.
			f fillRectX: gb y: 0 w: 1 h: f height]].
	f setColorR: 255 g: 255 b: 0.
	f fillRectX: 0 y: 0 w: 30 h: 30.
! !

!MSystem class methodsFor: 'system startup' stamp: 'jm 10/1/2008 20:52'!
start
	"This method is called when the image is started. Add a call to your own code here."
	"MSystem start"

	self log: 'Welcome to MicroSqueak!!'.
	self log: self tinyBenchmarks.
	self log: MForm new primScreenSize printString.
	self beep.
	self beep.
	"self graphicsTest."
	MObject superclass ifNil: [self quit].  "quit only when running in MicroSqueak; this avoids accidentally quitting form your normal Squeak image when you're testing the start method!!"
! !


!MSystem class methodsFor: 'misc' stamp: 'jm 12/2/2003 22:52'!
allObjectsDo: aBlock 
	"Evaluate the argument, aBlock, for each object in the system excluding SmallIntegers."

	| object |
	object _ self someObject.
	[0 == object] whileFalse: [
		aBlock value: object.
		object _ object nextObject].
! !

!MSystem class methodsFor: 'misc' stamp: 'jm 11/24/2003 21:01'!
getchar
	"Answer the ASCII value of the next character from the keyboard buffer. Answer nil if no key has been typed."

	| ch |
	(ch _ self primKeyboardNext)
		ifNil: [^ nil]
		ifNotNil: [^ ch bitAnd: 16rFF].
! !

!MSystem class methodsFor: 'misc' stamp: 'jm 11/13/2002 18:57'!
milliseconds
	"Answer the current value of the millisecond clock. Optional primitive."
	"Note: The millisecond clock may wrap around frequently, depending on the underlaying hardware. If no hardware clock is available, it may always return 0."

	<primitive: 135>
	^ 0
! !

!MSystem class methodsFor: 'misc' stamp: 'jm 12/9/2003 00:08'!
tinyBenchmarks
	"Report the results of running the two tiny Squeak benchmarks."

	| n t1 t2 r |
	n _ 25.
	t1 _ [n benchmark] msecs.
	t2 _ [r _ 28 benchFib] msecs.
	^ ((n * 500000 * 1000) // t1) printString, ' bytecodes/sec; ',
	  ((r * 1000) // t2) printString, ' sends/sec'
! !


!MSystem class methodsFor: 'primitives' stamp: 'jm 10/1/2008 20:15'!
append: aString toFile: fileName
	"Append the given string to the file with the given name."

	| f |
	f _ MFile new.
	f openReadWrite: (f localFolderPath, fileName).
	f position: f size.
	f nextPutAll: aString.
	f cr.
	f close.

	! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/2/2003 08:09'!
exitToDebugger
	"Tell the VM that we've encountered an unhandled error or halt."

	<primitive: 114>
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/2/2003 08:07'!
garbageCollect
	"Primitive. Reclaims all garbage and answers the number of bytes of available space."

	<primitive: 130>
	self primitiveFailed
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/2/2003 06:46'!
getVMParameters
	"Answer an Array containing the current values of the VM's internal parameter and statistics registers. The same primitive can be called with one integer argument to read a specific parameter and with two parameters to set a writable parameter, although these variations may not be implemented. Optional."
	"VM parameters are numbered as follows:
		1	end of old-space (0-based, read-only)
		2	end of young-space (read-only)
		3	end of memory (read-only)
		4	allocationCount (read-only)
		5	allocations between GCs (read-write)
		6	survivor count tenuring threshold (read-write)
		7	full GCs since startup (read-only)
		8	total milliseconds in full GCs since startup (read-only)
		9	incremental GCs since startup (read-only)
		10	total milliseconds in incremental GCs since startup (read-only)
		11	tenures of surving objects since startup (read-only)
		12-20 specific to the translating VM (obsolete)
		21   root table size (read-only)
		22   root table overflows since startup (read-only)"

	<primitive: 254>
	self primitiveFailed
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/2/2003 08:07'!
incrementalGarbageCollect
	"Primitive. Reclaims recently created garbage fairly quickly and answers the number of bytes of available space."

	<primitive: 131>
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 10/1/2008 20:12'!
log: aString

	self append: aString toFile: 'log.txt'.
	! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 11/24/2003 21:00'!
primKeyboardNext
	"Answer the next keycode from the keyboard buffer. A keycode is 12 bits: four modifier flags in the 4 most significant bits and the 8 bit ISO character in the least significant bits. Answer nil if no key has been typed."

	<primitive: 108>
	^ nil
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/22/2003 15:48'!
quit
	"Exit from Squeak."

	<primitive: 113>
! !

!MSystem class methodsFor: 'primitives' stamp: 'jm 12/29/2003 20:09'!
specialObjectsArray
	"Answer the virtual machine's special objects array."

	<primitive: 129>
	self primitiveFailed
! !

