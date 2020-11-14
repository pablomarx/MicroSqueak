MObject subclass: #MProcess
	instanceVariableNames: 'nextLink suspendedContext priority myList errorHandler '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Processes'!
!MProcess commentStamp: 'jm 11/24/2003 21:12' prior: 0!
I represent an independent path of control in the system. This path of control can be stopped (by sending the message suspend) and later restarted (by sending the message resume). When any one of several paths of control can be advanced, the single instance of MProcessorScheduler determines which one will actually be advanced partly using the process priority.

Note: The virtual machine depends on the order of my first four instance variables.
!


!MProcess methodsFor: 'process control' stamp: 'jm 10/26/2003 19:35'!
resume
	"Primitive. Allow this process to proceed. Put the receiver in line to become the active process. Fail if the receiver is already waiting on a queue (i.e., on a Semaphore or on a scheduler queue). Essential. See Object documentation whatIsAPrimitive."

	<primitive: 87>
	self primitiveFailed.
! !

!MProcess methodsFor: 'process control' stamp: 'jm 10/26/2003 19:43'!
suspend
	"Primitive. Stop this process in such a way that it can be restarted later (see resume). If the receiver is the active process, suspend it. Otherwise, remove the receiver from its suspended process list. Essential. See Object documentation whatIsAPrimitive."

	<primitive: 88>
	Processor activeProcess == self
		ifTrue: [self primitiveFailed]
		ifFalse: [
			Processor remove: self ifAbsent: [self error: 'This process was not active'].
			myList _ nil]
! !

!MProcess methodsFor: 'process control' stamp: 'jm 12/31/2003 09:41'!
terminate 
	"Stop this process forever."

	Processor activeProcess == self
		ifTrue: [
			thisContext removeSelf suspend]
		ifFalse: [
			myList ifNotNil: [
				myList remove: self ifAbsent: [].
				myList _ nil].
			suspendedContext _ nil].
! !


!MProcess methodsFor: 'accessing' stamp: 'jm 10/26/2003 19:24'!
errorHandler

    ^ errorHandler
! !

!MProcess methodsFor: 'accessing'!
errorHandler: aBlock

    errorHandler _ aBlock.
! !

!MProcess methodsFor: 'accessing' stamp: 'jm 10/26/2003 20:07'!
nextLink

	^ nextLink
! !

!MProcess methodsFor: 'accessing' stamp: 'jm 10/26/2003 20:10'!
nextLink: aLink 

	nextLink _ aLink.
! !

!MProcess methodsFor: 'accessing'!
priority
	"Answer the priority of the receiver."

	^ priority
! !

!MProcess methodsFor: 'accessing' stamp: 'jm 12/2/2003 06:57'!
priority: anInteger 
	"Set the receiver's priority to anInteger. The priority is used by the VM as an index into the scheduler's array of process queues so it must be an integer between 1 and Processor highestPriority."

	priority _ (anInteger asInteger max: 1) min: Processor highestPriority.
! !


!MProcess methodsFor: 'printing'!
printOn: aStream

	super printOn: aStream.
	aStream nextPutAll: ' in '.
	suspendedContext printOn: aStream
! !


!MProcess methodsFor: 'private' stamp: 'jm 12/2/2003 07:04'!
initSuspendedContext: aContext

	suspendedContext _ aContext.
	priority _ 1.  "lowest priority"
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MProcess class
	instanceVariableNames: ''!

!MProcess class methodsFor: 'instance creation' stamp: 'jm 12/2/2003 07:05'!
for: aContext priority: anInteger
	"Answer an instance of me for the given context (usually a Block) at the given priority."

	^ self new
		initSuspendedContext: aContext;
		priority: anInteger
! !


MSequenceableCollection subclass: #MProcessList
	instanceVariableNames: 'firstLink lastLink '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Processes'!
!MProcessList commentStamp: 'jm 12/2/2003 07:58' prior: 0!
I represent a linked list of Process objects. A process can be on at most one LinkedList at a time. Instances of me are used by the process scheduler and the virtual machine to store queues of waiting processes, one for each process priority level. Semaphore, a subclass of me, keeps a linked list of processes waiting to be signalled.

Warning: The virtual machine depends on the order of my instance variables.
!


!MProcessList methodsFor: 'accessing' stamp: 'jm 12/2/2003 07:35'!
first
	"Answer the first element. Raise an error if I am empty."

	self emptyCheck.
	^ firstLink
! !

!MProcessList methodsFor: 'accessing' stamp: 'jm 12/2/2003 07:35'!
size
	"Answer the number of elements I contain."

	| tally |
	tally _ 0.
	self do: [:each | tally _ tally + 1].
	^ tally
! !


!MProcessList methodsFor: 'testing' stamp: 'jm 12/2/2003 07:34'!
isEmpty

	^ firstLink == nil
! !


!MProcessList methodsFor: 'adding' stamp: 'jm 12/2/2003 07:38'!
add: aLink 
	"Add aLink to the end of the receiver's list. Answer aLink."

	^ self addLast: aLink
! !

!MProcessList methodsFor: 'adding' stamp: 'jm 12/2/2003 07:37'!
addLast: aLink 
	"Add aLink to the end of the receiver's list. Answer aLink."

	self isEmpty
		ifTrue: [firstLink _ aLink]
		ifFalse: [lastLink nextLink: aLink].
	lastLink _ aLink.
	^ aLink
! !


!MProcessList methodsFor: 'removing' stamp: 'jm 12/2/2003 07:41'!
remove: aLink ifAbsent: aBlock  
	"Remove aLink from the receiver. If it is not there, answer the result of evaluating aBlock."

	| tempLink |
	aLink == firstLink
		ifTrue: [firstLink _ aLink nextLink.
				aLink == lastLink
					ifTrue: [lastLink _ nil]]
		ifFalse: [tempLink _ firstLink.
				[tempLink == nil ifTrue: [^aBlock value].
				 tempLink nextLink == aLink]
					whileFalse: [tempLink _ tempLink nextLink].
				tempLink nextLink: aLink nextLink.
				aLink == lastLink
					ifTrue: [lastLink _ tempLink]].
	aLink nextLink: nil.
	^ aLink
! !

!MProcessList methodsFor: 'removing' stamp: 'jm 12/2/2003 07:40'!
removeFirst
	"Remove and answer the first element. Raise an error if I am empty."

	| oldLink |
	self emptyCheck.
	oldLink _ firstLink.
	firstLink == lastLink
		ifTrue: [firstLink _ nil. lastLink _ nil]
		ifFalse: [firstLink _ oldLink nextLink].
	oldLink nextLink: nil.
	^ oldLink
! !


!MProcessList methodsFor: 'enumerating' stamp: 'jm 12/2/2003 07:41'!
do: aBlock
	"Evaluate the given block for each of my elements."

	| aLink |
	aLink _ firstLink.
	[aLink == nil] whileFalse: [
		aBlock value: aLink.
		aLink _ aLink nextLink].
! !


MObject subclass: #MProcessorScheduler
	instanceVariableNames: 'suspendedProcessLists activeProcess '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Processes'!
!MProcessorScheduler commentStamp: '<historical>' prior: 0!
My single instance, named Processor, coordinates the use of the physical processor by all Processes requiring service.

Warning: The virtual machine depends on the order of my instance variables.
!


!MProcessorScheduler methodsFor: 'accessing'!
activeProcess
	"Answer the currently running Process."

	^ activeProcess
! !

!MProcessorScheduler methodsFor: 'accessing' stamp: 'jm 11/28/2003 18:54'!
highestPriority
	"Answer the number of priority levels currently available for use."

	^ suspendedProcessLists size
! !


!MProcessorScheduler methodsFor: 'other' stamp: 'jm 10/26/2003 19:13'!
remove: aProcess ifAbsent: aBlock 
	"Remove the given process from the list on which it is waiting. If the process is not on the queue for it's priority, evaluate the given block. Always answer the process."

	(suspendedProcessLists at: aProcess priority) remove: aProcess ifAbsent: aBlock.
	^ aProcess
! !


!MProcessorScheduler methodsFor: 'private' stamp: 'jm 12/2/2003 07:17'!
idleProcess
	"A default background process that simply loops forever. It runs only when no higher priority processes are available, perhaps because they are waiting on a semaphore or timer."

	[true] whileTrue: ["do nothing"].
! !

!MProcessorScheduler methodsFor: 'private' stamp: 'jm 12/9/2003 00:16'!
initProcessLists
	"Create process lists for prioriy levels 1 through 5."

	suspendedProcessLists _ (1 to: 5) collect: [:i | MProcessList new].
! !

!MProcessorScheduler methodsFor: 'private' stamp: 'jm 12/9/2003 00:15'!
installIdleProcess
	"Install an idle process of the lowest possible priority that is always runnable."
	"Details: The virtual machine requires that there is always some runnable process that can be scheduled; this background process ensures that this is the case."

	| idleList idleProc |
	"terminate any old idle processes"
	idleList _ suspendedProcessLists at: 1.
	[idleList isEmpty] whileFalse: [idleList first terminate].

	idleProc _ MProcess for: ([self idleProcess] asContext) priority: 1.
	(suspendedProcessLists at: idleProc priority) addLast: idleProc
! !

!MProcessorScheduler methodsFor: 'private' stamp: 'jm 12/9/2003 00:15'!
installStartProcess
	"Install the startup process as the active process. This process will run when MicroSqueak is started."

	activeProcess _ MProcess for: ([MSystem start] asContext) priority: 3.
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MProcessorScheduler class
	instanceVariableNames: ''!

!MProcessorScheduler class methodsFor: 'instance creation' stamp: 'jm 12/8/2003 22:23'!
new
	"The VM depends on a unique scheduler."

	self cannotInstantiate.
! !

