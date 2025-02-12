"
This baseline is used to generate Pharo images from the local clone of pharo-project/pharo repository. 

Depends on:
- BaselineOfSUnit

Load type: 
- linear

Installs:
- Graphics-* packages (Form, Bitmap, GrafPort...)
"
Class {
	#name : 'BaselineOfDisplay',
	#superclass : 'BaselineOf',
	#instVars : [
		'initializersEnabled'
	],
	#classVars : [
		'Initialized'
	],
	#category : 'BaselineOfDisplay',
	#package : 'BaselineOfDisplay'
}

{ #category : 'baseline' }
BaselineOfDisplay >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec preLoadDoIt: #'preload:package:'.
		spec postLoadDoIt: #'postload:package:'.
		
		spec 
			package: 'Colors';
			package: 'Graphics-Display Objects';
			package: 'Graphics-Primitives' with: [ spec requires: 'Graphics-Display Objects' ];
			package: 'Graphics-Transformations'
		
		 ].
]

{ #category : 'actions' }
BaselineOfDisplay >> installBitmap [

	"install new Bitmap class to special objects array"

	| array |
	
	array := Smalltalk specialObjectsArray copy.
	array at: 5 put: Bitmap.

	Smalltalk specialObjectsArray becomeForward: array.
]

{ #category : 'actions' }
BaselineOfDisplay >> postload: loader package: packageSpec [

	| display |
	
	"Ignore pre and post loads if already executed"
	Initialized = true ifTrue: [ ^ self ].
	
	self installBitmap.

	display := (Smalltalk classNamed: #DisplayScreen) new.
	display setExtent: 0@0 depth: 2.
	Smalltalk globals at: #Display put: display.

	Cursor webLink. "set the webLink cursor shape"
					
	Cursor initialize.
	DisplayScreen initialize.
	BitBlt initialize.
	Form initialize.
	Color initialize.
	
	MCMethodDefinition initializersEnabled: initializersEnabled.

	Initialized := true.
]

{ #category : 'actions' }
BaselineOfDisplay >> preload: loader package: packageSpec [

	"Ignore pre and post loads if already executed"
	Initialized = true ifTrue: [ ^ self ].

	"Declare global variable"
	Smalltalk globals at: #Display put: nil.

	initializersEnabled := MCMethodDefinition initializersEnabled.
	MCMethodDefinition initializersEnabled: false.
]
