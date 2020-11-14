MObject subclass: #MBitBlt
	instanceVariableNames: 'destForm sourceForm fillWords rule destX destY width height sourceX sourceY clipX clipY clipWidth clipHeight colorMap '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional-Graphics'!

!MBitBlt methodsFor: 'initialization' stamp: 'jm 12/29/2003 11:17'!
initialize

	rule _ MForm over.
	sourceX _ sourceY _ 0.
	destX _ destY _ 0.
	clipX _ clipY _ 0.
	clipWidth _ clipHeight _ 100000.
! !


!MBitBlt methodsFor: 'setup' stamp: 'jm 12/11/2003 07:41'!
clipX: x y: y width: w height: h
	"Set my clipping boundaries. Setting the clipping bounds is optional."

	clipX _ x.
	clipY _ y.
	clipWidth _ w.
	clipHeight _ h.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/14/2003 18:00'!
destForm: aForm
	"Set my destination Form."

	destForm _ aForm.
	clipX _ 0.
	clipY _ 0.
	clipWidth _ aForm width.
	clipHeight _ aForm height.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/10/2003 22:56'!
destX: x y: y width: w height: h
	"Set the destination rectangle for this operation."

	destX _ x.
	destY _ y.
	width _ w.
	height _ h.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/29/2003 11:13'!
fillR: r g: g b: b
	"Set my fill color to the given RGB value, where r, g, and b are in the range 0-255. The destination form must be set before calling this method, since the pixel pattern created depends on the destination depth."
	"Note: The ranges of r, g, and b are not checked."

	| d pix |
	d _ destForm depth.
	d = 8 ifTrue: [
		pix _ 41 + ((r // 37) * 36) + ((g // 37) * 6) + (b // 37).
		^ self fillWords: (MWordArray with: 16r01010101 * pix)].
	d = 16 ifTrue: [  "5 bits each of r, g, b"
		pix _ ((r // 8) bitShift: 10) + ((g // 8) bitShift: 5) + (b // 8).
		^ self fillWords: (MWordArray with:  (pix bitShift: 16) + pix)].
	d = 32 ifTrue: [^ self fillWords: (MWordArray with: (r bitShift: 16) + (g bitShift: 8) + b)].
	self error: 'color is supported only for depths 8, 16, and 32'
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/10/2003 23:00'!
rule: anInteger
	"Set the combination rule, an integer between 0 and 34 that determines how pixels are combined in this operation."

	rule _ anInteger.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/14/2003 17:49'!
sourceForm: aForm
	"Set my source and destination forms. The source form may be nil if filling with a color."

	sourceForm _ aForm.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/10/2003 22:58'!
sourceX: x y: y
	"Set the top-left corner of the destination rectangle for this operation."

	sourceX _ x.
	sourceY _ y.
! !

!MBitBlt methodsFor: 'setup' stamp: 'jm 12/10/2003 22:59'!
width: w height: h
	"Set the width and height for this operation."

	width _ w.
	height _ h.
! !


!MBitBlt methodsFor: 'operate' stamp: 'jm 12/29/2003 11:06'!
copyBits
	"Primitive. Perform the movement of bits from the source form to the destination form. Fail if any variables are not of the right type or if the combination rule is not implemented."

	<primitive: 96>
	self primitiveFailed
! !

!MBitBlt methodsFor: 'operate' stamp: 'jm 12/29/2003 11:07'!
copyBitsTranslucent: factor
	"This entry point to BitBlt supplies an extra argument to specify translucency for operations 30 and 31.  The argument must be an integer between 0 and 255."

	<primitive: 96>
	self primitiveFailed
! !


!MBitBlt methodsFor: 'private' stamp: 'jm 12/14/2003 17:42'!
fillWords
	"Answer the array of pixel words using for filling with a color."
 
	^ fillWords
! !

!MBitBlt methodsFor: 'private' stamp: 'jm 12/14/2003 17:54'!
fillWords: aBitmapOrNil
	"Set the array of pixel words using for filling with a color."
 
	fillWords _ aBitmapOrNil.
! !


MObject subclass: #MForm
	instanceVariableNames: 'bits width height depth bitBlt '
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional-Graphics'!

!MForm methodsFor: 'initialization' stamp: 'jm 12/29/2003 11:18'!
setWidth: w height: h depth: d

	| wordsPerLine |
	wordsPerLine _ ((w * d) + 31) // 32.
	bits _ MByteArray new: (4 * wordsPerLine * h).
	width _ w.
	height _ h.
	depth _ d.
	bitBlt _ MBitBlt new
		destForm: self;
		fillR: 255 g: 0 b: 0.  "default color"
! !


!MForm methodsFor: 'accessing' stamp: 'jm 12/11/2003 08:21'!
bits

	^ bits
! !

!MForm methodsFor: 'accessing' stamp: 'jm 12/15/2003 22:39'!
copyX: x y: y width: w height: h
	"Answer a new form containing given rectangular portion of this form."

	| result |
	result _ MForm basicNew setWidth: w height: h depth: depth.
	MBitBlt new
		sourceForm: self;
		destForm: result;
		sourceX: x y: y;
		width: w height: h;
		copyBits.
	^ result
! !

!MForm methodsFor: 'accessing' stamp: 'jm 12/11/2003 08:21'!
depth

	^ depth
! !

!MForm methodsFor: 'accessing' stamp: 'jm 12/11/2003 08:21'!
height

	^ height
! !

!MForm methodsFor: 'accessing' stamp: 'jm 12/11/2003 08:21'!
width

	^ width
! !


!MForm methodsFor: 'drawing' stamp: 'jm 12/14/2003 17:56'!
drawForm: aForm x: x y: y rule: anInteger
	"Fill the given rectangle with the current fill color."

	| oldFill |
	oldFill _ bitBlt fillWords.
	bitBlt
		sourceForm: aForm;
		destX: x y: y width: aForm width height: aForm height;
		rule: anInteger;
		copyBits.
	bitBlt sourceForm: nil.
	bitBlt fillWords: oldFill.
! !

!MForm methodsFor: 'drawing' stamp: 'jm 12/14/2003 17:57'!
fillRectX: x y: y w: w h: h
	"Fill the given rectangle with the current fill color."

	bitBlt
		destX: x y: y width: w height: h;
		copyBits.
! !

!MForm methodsFor: 'drawing' stamp: 'jm 12/14/2003 17:57'!
setColorR: r g: g b: b
	"Set the fill color for rectangle drawing operations."

	bitBlt fillR: r g: g b: b.
! !


!MForm methodsFor: 'display' stamp: 'jm 12/29/2003 21:35'!
beDisplayDepth: d
	"Install myself as the Display. Drawing onto me will then cause the screen or window to be updated."

	| screenExtent |
	screenExtent _ self primScreenSize.
	self
		setWidth: (screenExtent instVarAt: 1)
		height: (screenExtent instVarAt: 2)
		depth: d.
	MSystem specialObjectsArray at: 15 put: self.  "make this Form the Display"
! !

!MForm methodsFor: 'display' stamp: 'jm 12/29/2003 11:05'!
primScreenSize
	"Answer the actual screen size. In MicroSqueak, this will be an Association object since MicroSqueak doesn't have Points."

	<primitive: 106>
	self primitiveFailed
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

MForm class
	instanceVariableNames: ''!

!MForm class methodsFor: 'instance creation' stamp: 'jm 12/11/2003 08:15'!
width: w height: h depth: d

	^ self basicNew setWidth: w height: h depth: d
! !


!MForm class methodsFor: 'constants' stamp: 'jm 12/29/2003 11:16'!
over

	^ 3
! !

!MForm class methodsFor: 'constants' stamp: 'jm 12/29/2003 11:16'!
paint

	^ 25
! !


MArrayedCollection variableWordSubclass: #MWordArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MSqueak-Optional-Graphics'!

