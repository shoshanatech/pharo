Class {
	#name : 'EFFFICallTest',
	#superclass : 'EFTest',
	#category : 'EnlumineurFormatter-Tests',
	#package : 'EnlumineurFormatter-Tests'
}

{ #category : 'configurations' }
EFFFICallTest >> basicConfiguration [

	^ self contextClass new
]

{ #category : 'configurations' }
EFFFICallTest >> noNewLineBetweenTopCommentsConfiguration [
	"Here we can control explicitely the configuration we want."

	" String streamContents: [:s |
			EFContext new storeOn: s]"

	^ self contextClass basicNew
		  indentStyle: #tabulation;
		  formatCommentCloseToStatements: false;
		  useBasicCommentFormat: true;
		  numberOfNewLinesAfterMethodSignature: 1;
		  numberOfNewLinesAfterMethodSignatureWithMethodComment: 1;
		  numberOfNewLinesAfterMethodComment: 0;
		  indentExtraSpaces: 0
]

{ #category : 'tests' }
EFFFICallTest >> testSimpleFFI [

	| expr source |
	expr := OCParser parseMethod: 'getAxis: axis
	^ self ffiCall: #( Sint16 SDL_GameControllerGetAxis(self , int axis) )
	'.
	configurationSelector := #basicConfiguration.
	source := self formatter format: expr.
	self assert: source equals: 'getAxis: axis
	^ self ffiCall: #( Sint16 SDL_GameControllerGetAxis(self , int axis) )
	'
]
