"
I'm a model for user interaction for the rename method refactoring.
"
Class {
	#name : 'RBRenameInstanceVariableDriver',
	#superclass : 'RBInteractionDriver',
	#instVars : [
		'oldName',
		'class',
		'newName',
		'shouldEscape',
		'lastName'
	],
	#category : 'Refactoring-UI-Drivers',
	#package : 'Refactoring-UI',
	#tag : 'Drivers'
}

{ #category : 'execution' }
RBRenameInstanceVariableDriver >> applyChanges [
	
	refactoring privateTransform.
	self flag: 'The next line is horrible, 
					I must think of a better way to prevent changes from executing during tests'.
	(previewPresenterClass isKindOf: StRefactoringPreviewPresenterMock class)
		ifFalse: [ refactoring performChanges ]
]

{ #category : 'execution' }
RBRenameInstanceVariableDriver >> changes [

	^ refactoring privateTransform; changes
	
]

{ #category : 'execution' }
RBRenameInstanceVariableDriver >> configureRefactoring [

	refactoring := RBRenameInstanceVariableRefactoring
		               variable: oldName
		               class: class
]

{ #category : 'accessing' }
RBRenameInstanceVariableDriver >> newName: aString [
	"The only way to define newName is either using the UI (interactive mode) or using the initialization method >>scopes:variable:for:newName:"
	self shouldNotImplement 
]

{ #category : 'private' }
RBRenameInstanceVariableDriver >> prepareRefactoring [
	"The Driver is run in scripting mode, therefore the variable `newName` was defined in the method scopes:variable:for:newName:.
	We don't need to ask for the name to the user"
	refactoring newName: newName.
	refactoring checkApplicabilityPreconditions
]

{ #category : 'private' }
RBRenameInstanceVariableDriver >> prepareRefactoringInteractively [
	| failedConditions |
	
	"We ask the user for the variable new name"
	[ newName := self requestNewNameBasedOn: lastName.
	shouldEscape ifTrue: [ ^ self ].
	refactoring newName: newName.
	failedConditions := refactoring failedApplicabilityPreconditions.
	failedConditions isEmpty ]
		whileFalse: [
			failedConditions do: [ :cond |
				self application newInform
					label: cond errorString;
					title: 'Invalid name';
					openModal ] ].
]

{ #category : 'private' }
RBRenameInstanceVariableDriver >> requestNewNameBasedOn: aName [

	newName := SpRequestDialog new
		           title: 'Please provide a new variable name';
		           text: aName;
		           openModal.

	newName ifNil: [
		shouldEscape := true.
		^ self ].
	newName = oldName ifTrue: [
		shouldEscape := true.
		^ self ].
	lastName := newName.
	^ newName
]

{ #category : 'execution' }
RBRenameInstanceVariableDriver >> runRefactoring [

	self configureRefactoring.
	
	newName 
		ifNil: [ 
			"run in interactive mode" 
			shouldEscape := false.
			self prepareRefactoringInteractively
		 ]
		ifNotNil: [ 
			"run in script mode"
			self prepareRefactoring
		 ].
		
	self applyChanges
]

{ #category : 'initialization' }
RBRenameInstanceVariableDriver >> scopes: aCollection variable: aString for: aClass [ 
	"The driver is initialized in interactive mode (i.e. we will ask for the newName to the user while running the refactoring"
	scopes := aCollection.
	model :=  self refactoringScopeOn: scopes first.
	oldName := aString.
	lastName := aString.
	class := aClass
]

{ #category : 'initialization' }
RBRenameInstanceVariableDriver >> scopes: aCollection variable: aString for: aClass newName: aString2 [ 
	"The driver is initialized in script mode (i.e. we won't ask for the newName to the user while running the refactoring"
	self scopes: aCollection variable: aString for: aClass.
	newName := aString2
]
