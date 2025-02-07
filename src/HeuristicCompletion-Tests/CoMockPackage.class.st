Class {
	#name : 'CoMockPackage',
	#superclass : 'Object',
	#instVars : [
		'definedClasses'
	],
	#category : 'HeuristicCompletion-Tests-Core',
	#package : 'HeuristicCompletion-Tests',
	#tag : 'Core'
}

{ #category : 'accessing' }
CoMockPackage >> definedClasses [ 
	
	^ definedClasses ifNil: [ definedClasses := OrderedCollection new ]
]

{ #category : 'accessing' }
CoMockPackage >> definedClasses: aCollection [
	"preferrably a collection of MockClasses"
	
	definedClasses := aCollection 
]
