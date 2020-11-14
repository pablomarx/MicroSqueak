Object subclass: #MicroSqueak
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MicroSqueak'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MicroSqueak class
	instanceVariableNames: ''!

!MicroSqueak class methodsFor: 'space analysis' stamp: 'jm 1/11/2004 08:55'!
analyzeLiterals
	"MicroSqueak analyzeLiterals"

	| results floats smallInts bigInts arrayBytes stringBytes symbolBytes oldCount |
	results _ Dictionary new.
	floats _ smallInts _ bigInts _ arrayBytes _ stringBytes _ symbolBytes _ 0.
	self allLiteralsAndClassVars do: [:o |
		o isNumber
			ifTrue: [
				o isFloat
					ifTrue: [floats _ floats + 1]
					ifFalse: [
						((o >= -16384) and: [o <= 16383])
							ifTrue: [smallInts _ smallInts + 1]
							ifFalse: [bigInts _ bigInts + 1]]]
			ifFalse: [
				o class == Array ifTrue: [arrayBytes _ arrayBytes + (4 * o size)].
				o class == ByteString ifTrue: [stringBytes _ stringBytes + o size].
				o class == ByteSymbol ifTrue: [symbolBytes _ symbolBytes + o size].
				oldCount _ results at: o class name ifAbsent: [0].
				results at: o class name put: oldCount + 1]].
	results at: #Float put: floats.
	results at: #SmallInteger put: smallInts.
	results at: #LargeInteger put: bigInts.
	results at: 'string bytes' put: stringBytes.
	results at: 'symbol bytes' put: symbolBytes.
	results at: 'array bytes' put: arrayBytes.
	^ results
! !

!MicroSqueak class methodsFor: 'space analysis' stamp: 'jm 11/2/2003 20:12'!
codeSize
	"Size of MethodDictionaries and CompiledMethods. Not including literals, classes, class variables, globals, or anything else."

	| result |
	result _ 0.
	MObject withAllSubclassesDo: [:c |
		result _ result +
			(self codeSizeFor: c methodDict) +
			(self codeSizeFor: c class methodDict)].
	^ result
! !

!MicroSqueak class methodsFor: 'space analysis' stamp: 'jm 10/1/2008 20:36'!
stats
	"self stats"

	| classVarCount methodCount literalCount bytecodeCount classes |
	classVarCount _ methodCount _ literalCount _ bytecodeCount _ 0.
	classes _ MObject withAllSubclasses asArray.
	classes do: [:c |
		classVarCount _ classVarCount + c classPool size.
		(c methodDict asArray, c class methodDict asArray) do: [:m |
			methodCount _ methodCount + 1.
			literalCount _ literalCount + m literals size.
			bytecodeCount _ bytecodeCount + (m endPC - m initialPC + 1)]].

	^ 'MicroSqueak Stats:
  classes: ', classes size printString, '
  class vars: ', classVarCount printString, '
  methods: ', methodCount printString, '
  literals: ', literalCount printString, '
  bytecodes: ', bytecodeCount printString, '
'.
! !


!MicroSqueak class methodsFor: 'message analysis' stamp: 'jm 10/28/2003 12:50'!
implemented

	| result |
	result _ Set new.
	MObject withAllSubclassesDo: [:c |
		result addAll: c methodDict keys.
		result addAll: c class methodDict keys].
	^ result asArray sort
! !

!MicroSqueak class methodsFor: 'message analysis' stamp: 'jm 11/3/2003 20:49'!
selectorsReachableFrom: initialList
	"(MicroSqueak selectorsReachableFrom: #(+)) size"
	"(MicroSqueak selectorsReachableFrom: #(isEmpty)) size"
	"(MicroSqueak selectorsReachableFrom: #(printString)) size"

	| selectorMap addBlock sel entry reachable toDo |
	selectorMap _ Dictionary new: 1000.
	addBlock _ [:a |
		entry _ selectorMap at: a key ifAbsent: [Set new].
		entry addAll: a value messages.
		selectorMap at: a key put: entry].
	MObject withAllSubclasses do: [:cl |
		cl methodDict associationsDo: addBlock.
		cl class methodDict associationsDo: addBlock].

	reachable _ Set new: 1000.
	toDo _ OrderedCollection withAll: initialList.
	[toDo size > 0] whileTrue: [
		sel _ toDo removeFirst.
		(reachable includes: sel) ifFalse: [
			reachable add: sel.
			toDo addAll: (selectorMap at: sel ifAbsent: [#()])]].
	^ reachable asArray sort
! !

!MicroSqueak class methodsFor: 'message analysis' stamp: 'jm 10/28/2003 12:52'!
sent

	| result |
	result _ IdentitySet new.
	MObject withAllSubclassesDo: [:c |
		(c methodDict asArray, c class methodDict asArray) do: [:m |
			m literals do: [:lit | (lit isKindOf: Symbol) ifTrue: [result add: lit]]]].
	^ result asArray sort
! !

!MicroSqueak class methodsFor: 'message analysis' stamp: 'jm 12/17/2003 21:47'!
unimplemented

	| result |
	result _ self sent asSet.
	self implemented do: [:sel | result remove: sel ifAbsent: []].
	result remove: #DoIt ifAbsent: [].
	^ result asArray
! !

!MicroSqueak class methodsFor: 'message analysis' stamp: 'jm 12/31/2003 14:35'!
unsent

	| result reservedSelectors |
	result _ self implemented asSet.
	self sent do: [:sel | result remove: sel ifAbsent: []].
	reservedSelectors _ #(
		ifError: ifFalse: ifTrue: ifTrue:ifFalse:
		ifNil: ifNil:ifNotNil: ifNotNil: ifNotNil:ifNil: isNil
		from:to: timesRepeat: to:by: to:by:do: to:do:
		and: or: yourself
		doesNotUnderstand: halt mustBeBoolean
		perform: perform:with:).
	Smalltalk specialSelectors, reservedSelectors do: [:el |
		el isNumber ifFalse: [result remove: el ifAbsent: []]].
	
	^ result asArray sort
! !


!MicroSqueak class methodsFor: 'class and variable analysis' stamp: 'jm 11/26/2003 18:58'!
allLiteralsAndClassVars
	"MicroSqueak allLiteralsAndClassVars"

	| result |
	result _ OrderedCollection new.
	MObject withAllSubclassesDo: [:c |
		result addAll: c classPool.
		(c methodDict asArray, c class methodDict asArray) do: [:m |
			result addAll: m literals]].
	^ result asArray select: [:o | o ~~ nil]  "don't include nil values"
! !

!MicroSqueak class methodsFor: 'class and variable analysis' stamp: 'jm 12/17/2003 21:43'!
classAndGlobalRefs

	| refs |
	refs _ Set new.
	MObject withAllSubclasses do: [:c |
		(c methodDict asArray, c class methodDict asArray) do: [:m |
			m literals do: [:lit |
				(lit class = Association and: [lit key notNil]) ifTrue: [refs add: lit key]]]].
	MObject withAllSubclasses do: [:c |
		refs remove: c name ifAbsent: [].
		c classPool keys do: [:classVar | refs remove: classVar ifAbsent: []]].
	refs remove: #Processor ifAbsent: [].
	^ refs asArray sort
! !

!MicroSqueak class methodsFor: 'class and variable analysis' stamp: 'jm 11/2/2003 20:32'!
classStats
	"Answer a string describing all the MicroSqueak classes and their stats."

	| s |
	s _ WriteStream on: (String new: 10000).
	self writeClassStatsFor: MObject indent: 0 on: s.
	^ s contents
! !

!MicroSqueak class methodsFor: 'class and variable analysis' stamp: 'jm 11/17/2003 09:24'!
classVarValues

	| result |
	result _ OrderedCollection new.
	MObject withAllSubclassesDo: [:c | result addAll: c classPool].
	^ result asArray select: [:o | o ~~ nil]  "don't include nil values"
! !

!MicroSqueak class methodsFor: 'class and variable analysis' stamp: 'jm 12/2/2003 06:20'!
unusedClasses
	"Answer a collection of usued MicroSqueak classes."

	| classes |
	classes _ MObject withAllSubclasses.

	"remove referenced classes"
	self allLiteralsAndClassVars do: [:v |
		((v isKindOf: Association) and: [v key notNil]) ifTrue: [
			classes remove: v value ifAbsent: []]].

	"remove system classes"
	#(MClass MMetaclass MCompiledMethod MTrue MFalse 
	  MBlockContext MMethodContext MProcessorScheduler) do: [:n |
		classes remove: (Smalltalk at: n) ifAbsent: []].

	"remove classes with subclasses"
	classes _ classes reject: [:c | c subclasses size > 0].

	^ classes! !


!MicroSqueak class methodsFor: 'file out' stamp: 'jm 12/4/2003 21:28'!
fileOutClasses
	"File out the MicroSqueak class library. Does not include system building and support categories."
	"self fileOutClasses"

	| f |
	f _ FileStream newFileNamed: 'MicroSqueakClasses.st'.
	SystemOrganization fileOutCategoriesMatching: 'MSqueak-*' on: f.
	f close.
! !


!MicroSqueak class methodsFor: 'private' stamp: 'jm 11/2/2003 20:12'!
codeSizeFor: methDict
	"Size of the given MethodDictionary and all its methods."

	| result |
	result _ 4 + 4 + (4 * methDict class instSize).  "inst vars + object headers for dict and array"
	result _ result + (8 * (2 raisedTo: (methDict size highBit))).  "indexable fields in dict and array"
	methDict do: [:m | result _ result + (self sizeOfMethod: m)].
	^ result
! !

!MicroSqueak class methodsFor: 'private' stamp: 'jm 11/3/2003 20:49'!
methodsReachableFrom: initialList
	"MicroSqueak methodsReachableFrom: #(+)"
	"MicroSqueak methodsReachableFrom: #(clone)"
	"MicroSqueak methodsReachableFrom: #(printString)"

	| reachable count |
	reachable _ (self selectorsReachableFrom: initialList) asSet.
	count _ 0.
	MObject withAllSubclasses do: [:cl |
		cl methodDict keys asArray, cl class methodDict keys asArray do: [:sel |
			(reachable includes: sel) ifTrue: [count _ count + 1]]].
	^ count
! !

!MicroSqueak class methodsFor: 'private' stamp: 'jm 11/2/2003 20:04'!
sizeOfMethod: meth
	"Answer the size of the given compiled method in bytes."

	| result |
	result _ 4 * 2.  "object header and method header word"
	result _ result + (4 * meth literals size).
	result _ result + ((meth endPC - meth initialPC + 1) roundUpTo: 4).
	^ result
! !

!MicroSqueak class methodsFor: 'private' stamp: 'jm 11/2/2003 20:33'!
writeClassStatsFor: aClass indent: indent on: aStream
	"Write class stats onto the given stream for the given class and it's subclasses."

	| mCount mBytes subclassList |
	mCount _ aClass methodDict size + aClass class methodDict size.
	mBytes _ (self codeSizeFor: aClass methodDict) + (self codeSizeFor: aClass class methodDict).
	indent timesRepeat: [aStream tab].
	aStream nextPutAll: aClass name; space.
	aStream nextPutAll: mCount printString, ' (', mBytes printString, ' bytes)'; cr.
	subclassList _ aClass subclasses asArray sort: [:c1 :c2 | c1 name < c2 name].
	subclassList do: [:c |
		self writeClassStatsFor: c indent: indent + 1 on: aStream].
! !


Object subclass: #MicroSqueakImageBuilder
	instanceVariableNames: 'globals objects specialObjectsArray specialObjectsOop '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MicroSqueak'!

!MicroSqueakImageBuilder methodsFor: 'entry points' stamp: 'jm 11/30/2003 19:10'!
buildImageNamed: fileName
	"MicroSqueakImageBuilder new buildImageNamed: 'JUNKMicroSqueak.image'"

	Smalltalk forgetDoIts.  "a DoIt left in one of subclasses of MObject can be a problem!!"
	self checkLayoutOfVMClasses.
	self collectClasses.
	self fixGlobalReferences.
	self buildScheduler.
	specialObjectsArray _ self buildSpecialObjectsArray.
	self collectObjectsFrom: specialObjectsArray.
	self writeImageFileNamed: fileName.
! !


!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 12/31/2003 10:01'!
buildCompactClassArray
	"Build and answer the compact classes array, an Array of size 31 containing pointers to compact classes. The MicroSqueak classes must have already been created and recorded in 'globals'; this method installs the compact class index into these new class objects."

	| ccNames c |
	ccNames _ #(
		CompiledMethod
		ByteSymbol
		Array
		ByteArray
		LargePositiveInteger
		LargeNegativeInteger
		MethodDictionary
		Association
		Metaclass
		Character
		ByteString
		Float
		BlockContext
		MethodContext
		Dictionary
	).
	(ccNames indexOf: #BlockContext) = (Smalltalk compactClassesArray indexOf: BlockContext)
		ifFalse: [self error: 'The VM depends on BlockContext''s compact class index'].
	(ccNames indexOf: #MethodContext) = (Smalltalk compactClassesArray indexOf: MethodContext)
		ifFalse: [self error: 'The VM depends on MethodContext''s compact class index'].

	"fix the compact class index in the class format words"
	ccNames withIndexDo: [:cName :i |
		c _ globals at: cName ifAbsent: [nil].
		c ifNotNil: [c setCompactClassIndex: i]].

	^ (ccNames collect: [:cName | globals at: cName ifAbsent: [nil]]),
		(Array new: (31 - ccNames size) withAll: nil).
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 11/30/2003 19:11'!
buildScheduler
	"Create new MProcessScheduler and install it as global 'Processor'."

	| scheduler |
	scheduler _ (globals at: #ProcessorScheduler) basicNew initProcessLists.
	globals at: #Processor put: scheduler.
	scheduler installIdleProcess.
	scheduler installStartProcess.
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 12/31/2003 10:23'!
buildSpecialObjectsArray
	"Build and answer the 'special objects' array, an array of all the objects needed by the Smalltalk virtual machine."

	| compactClasses specialObjects |
	compactClasses _ self buildCompactClassArray.

	specialObjects _ Array new: 48.
	specialObjects at: 1 put: nil.
	specialObjects at: 2 put: false.
	specialObjects at: 3 put: true.
	specialObjects at: 4 put: (globals associationAt: #Processor).
	specialObjects at: 5 put: nil.  "Bitmap"
	specialObjects at: 6 put: (globals at: #SmallInteger).
	specialObjects at: 7 put: (globals at: #ByteString).
	specialObjects at: 8 put: (globals at: #Array).
	specialObjects at: 9 put: globals. 
	specialObjects at: 10 put: (globals at: #Float ifAbsent: [nil]).
	specialObjects at: 11 put: (globals at: #MethodContext).
	specialObjects at: 12 put: (globals at: #BlockContext).
	specialObjects at: 13 put: (globals at: #Association).  "replacement for Point"
	specialObjects at: 14 put: (globals at: #LargePositiveInteger).
	specialObjects at: 15 put: nil.  "Display"
	specialObjects at: 16 put: (globals at: #Message).
	specialObjects at: 17 put: (globals at: #CompiledMethod).
	specialObjects at: 18 put: nil.  "low space Semaphore"
	specialObjects at: 19 put: nil.  "(globals at: #Semaphore)"
	specialObjects at: 20 put: (globals at: #Character).
	specialObjects at: 21 put: #doesNotUnderstand:.
	specialObjects at: 22 put: #cannotReturn:.
	specialObjects at: 23 put: nil.  "unused"

	"the 32 selectors that are compiled as special bytecodes, with the number of arguments of each"
	specialObjects at: 24 put: #(
		+ 1 - 1 < 1 > 1 <= 1 >= 1 = 1 ~= 1 * 1 / 1 \\ 1 @ 1 bitShift: 1 // 1 bitAnd: 1 bitOr: 1
		at: 1 at:put: 2 size 0 next 0 nextPut: 1 atEnd 0 == 1 class 0 blockCopy: 1 value 0 value: 1 do: 1 new 0 new: 1 x 0 y 0).

	specialObjects at: 25 put: ((0 to: 255) collect: [:ascii | Character value: ascii]).  "table of Characters in ascii order"
	specialObjects at: 26 put: #mustBeBoolean.
	specialObjects at: 27 put: (globals at: #ByteArray).
	specialObjects at: 28 put: (globals at: #Process).
	specialObjects at: 29 put: compactClasses.  "array of up to 31 classes whose instances can have compact headers"
	specialObjects at: 30 put: nil.  "delay semaphore"
	specialObjects at: 31 put: nil.  "user input semaphore"

	"Prototype instances that can be copied for fast initialization"
	specialObjects at: 32 put:
		((globals includesKey: #Float) ifTrue: [Float new: 2] ifFalse: [LargePositiveInteger new: 4]).
	specialObjects at: 33 put: (LargePositiveInteger new: 4).
	specialObjects at: 34 put: (Association new). "replacement for Point new"
	specialObjects at: 35 put: #cannotInterpret:.

	"Note: This must be fixed once we start using context prototypes"
	specialObjects at: 36 put: ((globals at: #MethodContext) new: 56).  "size is CompiledMethod fullFrameSize"
	specialObjects at: 37 put: nil.
	specialObjects at: 38 put: ((globals at: #BlockContext) new: 56).  "size is CompiledMethod fullFrameSize"

	specialObjects at: 39 put: Array new.  "array of objects referred to by C support code"
	specialObjects at: 40 put: nil.  "was PseudoContext"
	specialObjects at: 41 put: nil.  "was TranslatedMethod"
	specialObjects at: 42 put: nil.  "finalization Semaphore"
	specialObjects at: 43 put: (globals at: #LargeNegativeInteger).

	"44-48 are are reserved for the foreign function interface (they are nil here)"

	^ specialObjects
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 12/18/2003 08:18'!
checkLayoutOfVMClasses
	"Verify that the layout of classes that the VM depends on is the same as the corresponding Squeak class."
	"MicroSqueakImageBuilder new checkLayoutOfVMClasses"

	| sClass mClass |
	#(	Behavior
		MethodDictionary
		Association
		BlockContext
		MethodContext
		Array
		ByteArray
		ByteString
		Character
		ByteSymbol
		Dictionary
		LargePositiveInteger
		LargeNegativeInteger
		Float
		Point
		Process
		ProcessorScheduler
		Semaphore
	) do: [:n |
		sClass _ Smalltalk at: n.
		mClass _ Smalltalk at: ('M', n) asSymbol ifAbsent: [nil].
		mClass ifNotNil: [
			(sClass instSpec = mClass instSpec) ifFalse: [self error: 'Bad VM class layout: ', n]]].

	"compiled method is special"
	((MCompiledMethod instSpec = 8) & (MCompiledMethod instSize = 0)) ifFalse: [self error: 'Bad VM class layout: CompiledMethod'].! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 12/1/2003 22:33'!
classFromSqueak: squeakClass
	"Answer a new MicroSqueak class copied from the given Squeak class."

	| newMeta |
	newMeta _ MMetaclass new
		initMethodDict: (self methodDictFromSqueak: squeakClass class methodDict).
	newMeta soleInstance
		initFrom: squeakClass
		methodDict: (self methodDictFromSqueak: squeakClass methodDict).
	squeakClass == MCompiledMethod ifTrue: [
		newMeta soleInstance setFormat: (CompiledMethod format bitAnd: 16r7FF)].
	^ newMeta soleInstance
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 11/26/2003 19:25'!
collectClasses
	"Collect the entire class hierarchy for MicroSqueak, converting each Squeak class into a MicroSqueak MMetaClass object. Remove the leading 'M' from the class names and add all classes to the new globals dictionary."
	"MicroSqueakImageBuilder new collectClasses"

	| classMap inverseMap newClass  oldSuper |
	globals _ Dictionary new.
	classMap _ IdentityDictionary new.
	inverseMap _ IdentityDictionary new.

	MObject withAllSubclasses do: [:oldClass |
		newClass _ self classFromSqueak: oldClass.
		globals at: newClass name put: newClass.
		classMap at: oldClass put: newClass.
		inverseMap at: newClass put: oldClass].

	globals asArray do: [:newCl |
		'Object' = newCl name
			ifTrue: [
				newCl superclass: nil.
				newCl class superclass: (classMap at: MClass)]
			ifFalse: [
				oldSuper _ (inverseMap at: newCl) superclass.
				newCl superclass: (classMap at: oldSuper).
				newCl class superclass: (classMap at: oldSuper) class]].
				
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 12/14/2003 12:32'!
fixGlobalReferences
	"Add a globals entry for Processor, then fix all Associations in CompileMethod literals that refer to Squeak globals (classes and Processor) to refer to my globals."

	| classes lit |
	globals at: #Processor put: nil.  "filled in later"
	classes _ globals asArray select: [:o | o isNil not and: [o isBehavior]].
	classes do: [:cl |
		cl methodDict asArray, cl class methodDict asArray do: [:m |
			1 to: m numLiterals do: [:i |
				lit _ m objectAt: i + 1.  "offset by 1 for the method header word"
				(lit isKindOf: Association) ifTrue: [
					m objectAt: i + 1 put: (self mapGlobalAssociation: lit)]]]].
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 11/30/2003 10:13'!
mapGlobalAssociation: anAssociation
	"Answer either the given Association or a new Association to replace it."
	"Note: There may be some Associations that have 'nil' as a key. These are used for super sends in metaclasses. Fix the value parts of these associations."

	| k nonMetaName |
	#Processor = anAssociation key ifTrue: [^ globals associationAt: #Processor].
	anAssociation value isBehavior ifFalse: [^ anAssociation].

	anAssociation key ifNil: [  "association used in a 'super' call"
		nonMetaName _ anAssociation value soleInstance name.
		nonMetaName _ nonMetaName copyFrom: 2 to: nonMetaName size.  "remove leading 'M'"
		^ nil -> (globals at: nonMetaName asSymbol) class].  "new association for the new metatclass"

	anAssociation key
		ifNil: [k _ anAssociation value name. self halt: 'nil key, value: ', k]
		ifNotNil: [k _ (anAssociation key copyFrom: 2 to: anAssociation key size) asSymbol].

	^ globals associationAt: k
		ifAbsent: [self halt: 'Ref to a class not in globals: ', k. ^ (k -> nil)].
! !

!MicroSqueakImageBuilder methodsFor: 'object creation' stamp: 'jm 11/27/2003 11:00'!
methodDictFromSqueak: aMethodDictionary
	"Answer a new method dictionary created from the given Squeak method dictionary."
	"Note: The contents of the new MMethodDictionary are Squeak CompiledMethod objects. They will be converted into MicroSqueak CompiledMethods when the image file is built."

	| sz result meth |
	aMethodDictionary size = 0
		ifTrue: [sz _ 1]
		ifFalse: [sz _ 2 raisedTo: (aMethodDictionary size log: 2) ceiling].

	result _ (MethodDictionary basicNew: sz) init: sz.
	aMethodDictionary keys do: [:sel |
		meth _ (aMethodDictionary at: sel) copyWithTrailerBytes: #().
		result at: sel put: meth].
	^ result
! !


!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/30/2003 22:19'!
extraWordsIfContext: anObject
	"Answer the number of extra words to allocate for the given object if it is a BlockContext or MethodContext object. Answer zero if the object is not a context object."

	| className |
	className _ (self newClassFor: anObject) name.
	((className = #BlockContext) or: [className = #MethodContext])
		ifTrue: [^ 56 - anObject basicSize]
		ifFalse: [^ 0].
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/29/2003 21:11'!
headerAndTotalWordsFor: anObject
	"Answer an array containing the number of header words (1-3) and the number of words needed to store the contents of the given object."

	| cl contentsWords headerWords |
	cl _ self newClassFor: anObject.
	contentsWords _ cl instSize + (self extraWordsIfContext: anObject).
	cl isVariable ifTrue: [
		contentsWords _ contentsWords +
			(cl isBytes ifTrue: [(anObject basicSize + 3) // 4] ifFalse: [anObject basicSize])].

	headerWords _
		contentsWords > 63
			ifTrue: [3]
			ifFalse: [(cl indexIfCompact > 0) ifTrue: [1] ifFalse: [2]].

	^ Array with: headerWords with: (headerWords + contentsWords)
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 12/2/2003 07:55'!
newClassFor: anObject
	"Answer the object that will be the given object's class in the new image."

	| cl newClass |
	cl _ anObject class.
	((cl = MMetaclass) | (cl = MProcessList) | (cl = MProcessorScheduler) | (cl = MProcess) | (cl = MMethodContext))
		ifTrue: [newClass _ globals at: (cl name copyFrom: 2 to: cl name size) asSymbol ifAbsent: [nil]]
		ifFalse: [newClass _ globals at: cl name ifAbsent: [nil]].
	newClass ifNil: [
		"a metaclass; the new metaclass is the class of the new class with my sole instance's name"
		newClass _ (globals at: cl soleInstance name) class.
		self assert: [newClass == cl]].

	^ newClass
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/28/2003 10:06'!
oopFor: anObject map: oopMap
	"Answer an object pointer or SmallInteger encoding for the given object or SmallInteger."

	^ anObject isSmallInteger
		ifTrue: [(anObject bitShift: 1) + 1]
		ifFalse: [oopMap at: anObject].
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/28/2003 09:32'!
padToNextWord: aStream
	"Append zero to three bytes of zeros to the given stream to make its position be an even multiple of four bytes."

	[(aStream position \\ 4) = 0] whileFalse: [aStream nextPut: 0].
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/28/2003 11:14'!
sortedObjects
	"Answer a sorted list of objects to be stored in the image. Certain types of immutable objects (e.g., Booleans, Symbols, Characters, and CompiledMethods) are stored before other objects."

	| result characters symbols compiledMethods floats other isOther objClass |
	result _ OrderedCollection new: objects size + 3.
	result add: nil.		objects remove: nil ifAbsent: [].
	result add: true.		objects remove: true ifAbsent: [].
	result add: false.	objects remove: false ifAbsent: [].

	characters _ OrderedCollection new: 256.
	symbols _ OrderedCollection new: 2000.
	compiledMethods _ OrderedCollection new: 2000.
	floats _ OrderedCollection new: 100.
	other _ OrderedCollection new: objects size.

	objects do: [:o |
		isOther _ true.
		objClass _ o class.
		Character = objClass ifTrue: [characters add: o. isOther _ false].
		ByteSymbol = objClass ifTrue: [symbols add: o. isOther _ false].
		CompiledMethod = objClass ifTrue: [compiledMethods add: o. isOther _ false].
		Float = objClass ifTrue: [floats add: o. isOther _ false].
		isOther ifTrue: [other add: o]].

	result
		addAll: characters;
		addAll: symbols;
		addAll: compiledMethods;
		addAll: floats;
		addAll: other.

	^ result asArray
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/29/2003 20:41'!
writeImageFileNamed: fileName

	| objList oopMap nextOop hdrAndTotalWords s |
	objList _ self sortedObjects.
	oopMap _ IdentityDictionary new: 5000.

	"pass 1: assign oops"
	nextOop _ 0.  "nil is alway the first oop"
	objList do: [:o |
		hdrAndTotalWords _ self headerAndTotalWordsFor: o.
		oopMap at: o put: (nextOop + (4 * (hdrAndTotalWords first - 1))).  "oop is addr of last header word"
		nextOop _ nextOop + (4 * hdrAndTotalWords second)].

	"pass 2: write objects"
	s _ WriteStream on: (ByteArray new: 100000).
	objList do: [:o | self writeObject: o map: oopMap on: s].
	s position = nextOop ifFalse: [self error: 'first and second passes yielded different image sizes'].

	specialObjectsOop _ self oopFor: specialObjectsArray map: oopMap.
	self writeMemoryImage: s contents toFileNamed: fileName.
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 12/29/2003 19:21'!
writeMemoryImage: aByteArray toFileNamed: fileName

	| f |
	f _ (FileStream newFileNamed: fileName) binary.

	"write squeak image file header (64 bytes)"
	f int32: 6502.					"image format and version id"
	f int32: 64.						"header size (bytes)"
	f int32: aByteArray size.		"image size (bytes)"
	f int32: 0.						"location of start of image in memory"
	f int32: specialObjectsOop.		"oop of the special objects array"
	f int32: 999.						"last identity hash value"
	f int32: ((800 << 16) + 600).		"size of Display"
	f int32: 0.						"flag indicating full-screen mode"
	1 to: 8 do: [:i | f int32: 0].		"fill remaining 8 header words with zeros"

	"write the image data and close the file"
	f nextPutAll: aByteArray.		
	f close.
	FileDirectory default setMacFileNamed: f name type: 'STim' creator: 'FAST'.
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/29/2003 21:33'!
writeObjHeaderFor: anObject map: oopMap on: aStream
	"Write the one to three word object header for the given object on the given stream."
	"Base header word format:
		gc (3 bits) (highest bits)
		identity hash (12 bits)
		compact class index (5 bits)
		format (4 bits)
		size in words, including the base header word (6 bits)
		object header type (2 bits) (lowest bits)"

	| cl baseHeader indexableWords extraBytes totalWords hdrTypeBits |
	cl _ self newClassFor: anObject.
	baseHeader _
		((anObject identityHash bitAnd: 16rFFF) << 17) bitOr:  "hash bits"
		((cl format << 1) bitAnd: 16r1FF00).  "format bits and cc index"

	indexableWords _ 0.
	cl isVariable ifTrue: [
		cl isBytes
			ifTrue: [
				"two low bits of the format field are the # of bytes to subtract from rounded-up size"
				indexableWords _ (anObject basicSize + 3) // 4.
				extraBytes _ ((4 * indexableWords) - anObject basicSize) bitAnd: 3.
				baseHeader _ baseHeader bitOr: (extraBytes << 8)]
			ifFalse: [
				indexableWords _ anObject basicSize]].

	self assert: [(baseHeader bitAnd: 3) = 0].

	totalWords _ cl instSize + indexableWords + (self extraWordsIfContext: anObject) + 1.
	totalWords > 63
		ifTrue: [  "3-word header"
			hdrTypeBits _ 0.
			baseHeader _ baseHeader - (baseHeader bitAnd: 16rFF).  "set size field to zero"
			aStream uint32: ((4 * totalWords) bitOr: hdrTypeBits).
			aStream uint32: ((oopMap at: cl) bitOr: hdrTypeBits).
			aStream uint32: (baseHeader bitOr: hdrTypeBits)]
		ifFalse: [
			baseHeader _ baseHeader + (4 * totalWords).
			self assert: [(baseHeader bitAnd: 16rFF) = (4 * totalWords)].
			cl indexIfCompact = 0
				ifTrue: [  "2-word header"
					hdrTypeBits _ 1.
					aStream uint32: ((oopMap at: cl) bitOr: hdrTypeBits).
					aStream uint32: (baseHeader bitOr: hdrTypeBits)]
				ifFalse: [  "1-word header"
					hdrTypeBits _ 3.
					aStream uint32: (baseHeader bitOr: hdrTypeBits)]].
! !

!MicroSqueakImageBuilder methodsFor: 'image creation' stamp: 'jm 11/29/2003 21:37'!
writeObject: anObject map: oopMap on: aStream
	"Write the given object onto the given stream using the given dictionary to map object references to memory addresses."

	| objClass nilOop |
	objClass _ anObject class.
	self writeObjHeaderFor: anObject map: oopMap on: aStream.
	self assert: [((oopMap at: anObject) + 4) = aStream position].  "position is oop + base header size"

	"special case for CompiledMethod"
	objClass instSpec = CompiledMethod instSpec ifTrue: [
		1 to: anObject numLiterals + 1 do: [:i | "write literals"
			aStream int32: (self oopFor: (anObject objectAt: i) map: oopMap)].
		anObject initialPC to: anObject size do: [:i | aStream nextPut: (anObject at: i)].
		self padToNextWord: aStream.
		^ self].

	"write instance variables, if any"
	1 to: objClass instSize do: [:i |
		aStream int32: (self oopFor: (anObject instVarAt: i) map: oopMap)].

	objClass isVariable ifTrue: [
		objClass isPointers
			ifTrue: [  "write pointer fields"
				1 to: anObject basicSize do: [:i |
					aStream int32: (self oopFor: (anObject basicAt: i) map: oopMap)]]
			ifFalse: [  "write byte or word fields"
				objClass isBytes
					ifTrue: [
						1 to: anObject basicSize do: [:i | aStream nextPut: (anObject basicAt: i)].
						self padToNextWord: aStream]
					ifFalse: [
						1 to: anObject basicSize do: [:i | aStream uint32: (anObject basicAt: i)]]]].

	nilOop _ self oopFor: nil map: oopMap.
	(self extraWordsIfContext: anObject) timesRepeat: [aStream int32: nilOop].  "allocate stack space for contexts"
! !


!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/26/2003 21:26'!
check: anObject
	"Ensure that the given object is either a SmallInteger or appears in the objects set."

	anObject isSmallInteger ifTrue: [^ self].
	anObject ifNil: [^ self].
	(objects includes: anObject) ifFalse: [self error: 'bad object ref:', anObject printString].
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/26/2003 21:22'!
checkRefsOf: anObject
	"Check that all pointers in the given object appear in the objects dictionary."

	| objClass |
	objClass _ anObject class.
	1 to: objClass instSize do: [:i |  "scan the instance variables"
		self check: (anObject instVarAt: i)].

	(objClass isVariable and: [objClass isPointers]) ifTrue: [
		1 to: anObject basicSize do: [:i |  "scan the indexed fields"
			self check: (anObject basicAt: i)]].

	objClass == CompiledMethod ifTrue: [  "scan the CompiledMethod literals"
		anObject literals do: [:lit | self check: lit]].
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/24/2003 07:30'!
collectObjects
	"MicroSqueakImageBuilder new collectObjects"

	| toDo obj |
	objects _ IdentitySet new: 5000.
	toDo _ OrderedCollection new: 5000.
	self record: MObject in: toDo from: nil.
	[toDo isEmpty] whileFalse: [
		obj _ toDo removeFirst.
		self scan: obj into: toDo].
	^ objects
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/24/2003 16:09'!
collectObjectsFrom: root

	| toDo obj |
	objects _ IdentitySet new: 5000.
	toDo _ OrderedCollection new: 5000.
	self record: root in: toDo from: nil.
	[toDo isEmpty] whileFalse: [
		obj _ toDo removeFirst.
		self trace: obj into: toDo].
	^ objects
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 10/27/2003 12:33'!
record: obj in: toDo from: srcObj

	| objClass |
	(obj isNil or: [obj isSmallInteger]) ifTrue: [^ self].
	obj isSmallInteger ifTrue: [^ self].

	objClass _ obj class.
	(objects includes: obj) ifTrue: [^ self].  "already processed"

	obj == Smalltalk ifTrue: [^ self].
	objClass == ClassOrganizer ifTrue: [^ self].
	obj == Processor ifTrue: [^ self].
	objClass == LinkedList ifTrue: [self halt. ^ self]. "did we encounter a process?"

	obj isBehavior ifTrue: [
		((obj == MObject) or:
		 [(obj == MObject class) or:
		 [(obj inheritsFrom: MObject) or:
		 [obj inheritsFrom: MObject class]]])
			ifFalse: [^ self]].

	objects add: obj.
	toDo add: obj.
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 10/27/2003 11:31'!
scan: anObject into: toDo

	| objClass |
	objClass _ anObject class.
	1 to: objClass instSize do: [:i |  "scan the instance variables"
		self record: (anObject instVarAt: i) in: toDo from: anObject].

	(objClass isVariable and: [objClass isPointers]) ifTrue: [
		1 to: anObject basicSize do: [:i |  "scan the indexed fields"
			self record: (anObject basicAt: i) in: toDo from: anObject]].

	objClass == CompiledMethod ifTrue: [
		anObject literals do: [:literal |  "scan the CompiledMethod literals"
			self record: literal in: toDo from: anObject]].

	self record: objClass in: toDo from: anObject.
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/24/2003 16:09'!
trace: anObject into: toDo

	| objClass |
	objClass _ anObject class.
	1 to: objClass instSize do: [:i |  "scan the instance variables"
		self trace: (anObject instVarAt: i) into: toDo from: anObject].

	(objClass isVariable and: [objClass isPointers]) ifTrue: [
		1 to: anObject basicSize do: [:i |  "scan the indexed fields"
			self trace: (anObject basicAt: i) into: toDo from: anObject]].

	objClass == CompiledMethod ifTrue: [
		anObject literals do: [:literal |  "scan the CompiledMethod literals"
			self trace: literal into: toDo from: anObject]].

	self trace: objClass into: toDo from: anObject.
! !

!MicroSqueakImageBuilder methodsFor: 'object tracing' stamp: 'jm 11/28/2003 20:28'!
trace: obj into: toDo from: srcObj
	"Add the given object to objects and to the toDo list except if it is:
		- nil
		- a SmallInteger
		- already in objects (i.e., it has already been processed)
		- a Squeak class object (i.e., an instance of MMetaclass)
		- the Squeak 'Processor' object"

	obj ifNil: [^ self].
	obj isSmallInteger ifTrue: [^ self].
	(objects includes: obj) ifTrue: [^ self].  "already processed"

	(obj isBehavior and: [obj inheritsFrom: Object]) ifTrue: [^ self].  "don't trace Squeak classes"
	obj == Processor ifTrue: [^ self halt].  "don't trace references to the Squeak global 'Processor'"

	objects add: obj.
	toDo add: obj.
! !


!Object methodsFor: 'testing' stamp: 'sw 8/15/2018 19:45'!
isSmallInteger
	^ false.! !
	

!SmallInteger methodsFor: 'testing' stamp: 'sw 8/15/2018 19:45'!
isSmallInteger
	^ true.! !

