"
I'm a class that does nothing in the suggestion list.

I return the list created from the completion engine.

This class is created to pass the test.
"
Class {
	#name : 'NoSorter',
	#superclass : 'CompletionSorter',
	#category : 'HeuristicCompletion-Model-Sorting',
	#package : 'HeuristicCompletion-Model',
	#tag : 'Sorting'
}

{ #category : 'sorting' }
NoSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection
]
