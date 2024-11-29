"
I'm a class that do nothing in the suggestion list.

I return the list created from the compltion engine.

This class is created to pass the test.
"
Class {
	#name : 'NoSorter',
	#superclass : 'CompletionSorter',
	#category : 'NECompletion-Sorting',
	#package : 'NECompletion',
	#tag : 'Sorting'
}

{ #category : 'sorting' }
NoSorter >> sortCompletionList: anOrderedCollection [

	^ anOrderedCollection
]
