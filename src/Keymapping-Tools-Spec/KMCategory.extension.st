Extension { #name : 'KMCategory' }

{ #category : '*Keymapping-Tools-Spec' }
KMCategory >> scopeName [

	^  self name
]

{ #category : '*Keymapping-Tools-Spec' }
KMCategory >> shortcuts [

	1 halt.
	^ (self entriesAt: #all) keymaps
]
