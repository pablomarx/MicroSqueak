MObject subclass: #MClassBinding
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Support'!

	
MObject subclass: #MReadOnlyVariableBinding
	instanceVariableNames: 'key value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Collections-Support'!

!MReadOnlyVariableBinding methodsFor: 'as yet unclassified' stamp: 'sw 8/21/2018 22:39'!
isVariableBinding
	^ true! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MReadOnlyVariableBinding class
	instanceVariableNames: ''!


MObject subclass: #MSetElement
	instanceVariableNames: 'enclosedElement'
	classVariableNames: 'NilElement'
	poolDictionaries: ''
	category: 'MSqueak-Collections-Support'!

!MSetElement methodsFor: 'comparing' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:51'!
= anObject
	^ anObject class = self class and: [ enclosedElement = anObject enclosedSetElement ]
! !

!MSetElement methodsFor: 'comparing' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:52'!
hash
	^ enclosedElement hash
! !


!MSetElement methodsFor: 'converting' stamp: 'yo 11/8/2010 11:30'!
asSetElement
	"A receiver has to be included into a set, as a distinct object.
	We need to wrap receiver in own turn, otherwise #enclosedSetElement will return wrong object for that set"
	^ MSetElement with: self! !


!MSetElement methodsFor: 'accessing' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:49'!
enclosedSetElement
	^ enclosedElement! !

!MSetElement methodsFor: 'accessing' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:49'!
enclosedSetElement: anObject
	enclosedElement := anObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MSetElement class
	instanceVariableNames: ''!

!MSetElement class methodsFor: 'instance creation' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:53'!
with: anObject
	^ self new enclosedSetElement: anObject! !


!MSetElement class methodsFor: 'accessing' stamp: 'yo 11/8/2010 11:29  <  Igor.Stasenko 11/13/2009 05:56'!
withNil
	^ NilElement
! !
