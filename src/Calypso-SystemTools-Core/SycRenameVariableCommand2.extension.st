Extension { #name : 'SycRenameVariableCommand2' }

{ #category : '*Calypso-SystemTools-Core' }
SycRenameVariableCommand2 class >> sourceCodeMenuActivation [
	<classAnnotation>

	^SycSourceCodeMenuActivation byRootGroupItemOrder: 1.1 for: ClySourceCodeContext
]
