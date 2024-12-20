"
Aplhabetical sorting
"
Class {
	#name : 'AlphabeticSorter',
	#superclass : 'CompletionSorter',
	#category : 'HeuristicCompletion-Model-Sorting',
	#package : 'HeuristicCompletion-Model',
	#tag : 'Sorting'
}

{ #category : 'description' }
AlphabeticSorter class >> kind [

	^ 'alphabetical'
]

{ #category : 'sorting' }
AlphabeticSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection sort
]
