"
Reverse alphabetic sorting
"
Class {
	#name : 'ReverseAlphabeticSorter',
	#superclass : 'CompletionSorter',
	#category : 'HeuristicCompletion-Model-Sorting',
	#package : 'HeuristicCompletion-Model',
	#tag : 'Sorting'
}

{ #category : 'description' }
ReverseAlphabeticSorter class >> kind [

	^ 'reverse'
]

{ #category : 'sorting' }
ReverseAlphabeticSorter >> sortCompletionList: anOrderedCollection [
	"this is just for testing, reverse sort makes no sense in practice"
	^ anOrderedCollection sort reverse
]
