"
I contain the methods that are included in a TraitedClass.
The Traits are also TraitedClass, as they share the same behavior.
These methods override the implementation in Class 
I am added during the creation of the class, if the superclass does not have them.

Check 

TraitedMetaclass >> #initializeBasicMethods 

This method is invoked during the construction of the class, and flattens my methods in the new traited class.
"
Class {
	#name : 'TraitedClass',
	#superclass : 'Object',
	#classInstVars : [
		'users'
	],
	#category : 'Traits-Base',
	#package : 'Traits',
	#tag : 'Base'
}

{ #category : 'users' }
TraitedClass class >> addUser: aClass [

	self basicUsers add: aClass
]

{ #category : 'users' }
TraitedClass class >> basicUsers [
	^ users ifNil: [ users := WeakSet new ]
]

{ #category : 'accessing' }
TraitedClass class >> classTrait [
	^ self class
]

{ #category : 'testing' }
TraitedClass class >> isTrait [
	<reflection: 'Class structural inspection - Traits'>
	^ true
]

{ #category : 'users' }
TraitedClass class >> removeUser: aClass [

	self basicUsers remove: aClass ifAbsent: [ ]
]

{ #category : 'users' }
TraitedClass class >> traitUsers [
	^ #()
]

{ #category : 'accessing - method dictionary' }
TraitedClass >> addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aProtocol [
	"When a new methods is added, I add it to the localMethodDict and also propagate the changes to my users"
	<reflection: 'Class structural modification - Selector/Method modification'>
	self localMethodDict at: selector put: compiledMethod.

	super addAndClassifySelector: selector withMethod: compiledMethod inProtocol: aProtocol.

	TraitChange addSelector: selector on: self
]

{ #category : 'querying' }
TraitedClass >> allTraits [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition allTraits
]

{ #category : 'initialization' }
TraitedClass >> doRebuildMethodDictionary [

	| selectors removedSelectors modified |
	"During the creation of the class or after a change in the traitComposition, the whole method dictionary is calculated.
	If I return true, my users should be updated""1. I recreate the local methodDict"
	modified := false.
	self methodDict valuesDo: [ :m | m traitSource ifNil: [ self localMethodDict at: m selector put: m ] ].

	"2. I filter the selectors from the trait composition, rejecting the ones that are locally defined.
	And then I install the methods in myself. The trait composition only install the method if it is needed."
	selectors := self traitComposition selectors reject: [ :e | self localMethodDict includesKey: e ].
	selectors do: [ :e | modified := modified | (self traitComposition installSelector: e into: self replacing: false) ].

	"3. I handle the methods that I have and they are no more in the traitComposition."
	removedSelectors := self methodDict keys reject: [ :aSelector | (selectors includes: aSelector) or: [ self localMethodDict includesKey: aSelector ] ].
	modified := modified | removedSelectors isNotEmpty.
	removedSelectors do: [ :aSelector |
		self methodDict removeKey: aSelector.
		self removeFromProtocols: aSelector ].

	^ modified
]

{ #category : 'testing' }
TraitedClass >> findOriginClassOf: aMethod [

	"I return the myself or the trait that has the original implementation of a method.
	If the method is an alias, the returned class includes the original aliased method"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	
	(aMethod hasProperty: #traitSource)
		ifTrue: [ ^ aMethod traitSource innerClass ].

	(self includesLocalSelector: aMethod selector)
		ifTrue: [ ^ self ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ ^ self ]) innerClass
]

{ #category : 'testing' }
TraitedClass >> findOriginMethodOf: aMethod [

	"I return the original method for a aMethod.
	If this is a local method, the original method is itself.
	If it cames from a trait composition I look for the method in the trait composition.
	First I try with the trait stored in the traitSource.
	If it is an aliased or conflicting method, the method is look up in the whole trait composition"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	
	(self includesLocalSelector: aMethod selector)
		ifTrue: [ ^ aMethod ].

	(aMethod hasProperty: #traitSource)
		ifTrue: [ |newSelector|
			newSelector := self traitComposition originSelectorOf: aMethod selector.
			^ aMethod traitSource compiledMethodAt: newSelector ifAbsent: [aMethod] ].

	^ (self traitComposition traitDefining: aMethod selector ifNone: [ self ])
		compiledMethodAt: aMethod selector ifAbsent: [ ^ aMethod ]
]

{ #category : 'testing' }
TraitedClass >> hasTraitComposition [

	^ self traitComposition isEmpty not
]

{ #category : 'testing' }
TraitedClass >> includesLocalSelector: aSymbol [
	<reflection: 'Class structural inspection - Shared pool inspection'>
	^ self isLocalSelector: aSymbol
]

{ #category : 'testing' }
TraitedClass >> isAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my or in another composition somewhere deeper in
	the tree of traits compositions."

	^ self traitComposition isAliasSelector: aSymbol
]

{ #category : 'testing' }
TraitedClass >> isLocalAliasSelector: aSymbol [
	"Return true if the selector aSymbol is an alias defined
	in my trait composition."

	^ self traitComposition isLocalAliasSelector: aSymbol
]

{ #category : 'testing' }
TraitedClass >> isLocalSelector: aSelector [
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict includesKey: aSelector
]

{ #category : 'accessing' }
TraitedClass >> localMethodDict [
	"The local methodDict is in the metaclass. In this way I do not have to recompile the methods during the bootstrap when we don't have a compiler."
	^ self class baseLocalMethods
]

{ #category : 'accessing' }
TraitedClass >> localMethodDict: aMethodDictionary [
	^ self class baseLocalMethods: aMethodDictionary
]

{ #category : 'accessing' }
TraitedClass >> localMethods [
	"returns the methods of classes excluding the ones of the traits that the class uses"
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict values
]

{ #category : 'accessing - method dictionary' }
TraitedClass >> localSelectors [
	<reflection: 'Class structural inspection - Selectors and methods inspection'>
	^ self localMethodDict keys
]

{ #category : 'initialization' }
TraitedClass >> rebuildMethodDictionary [

	"Useful to be rewritten in Traits"
	^ self doRebuildMethodDictionary
]

{ #category : 'categories' }
TraitedClass >> recategorizeSelector: selector from: oldProtocol to: newProtocol [
	"When a method is recategorized I have to classify the method, but also recategorize the aliases pointing to it"

	| originalProtocol |
	"If it is nil is because it is a removal. It will removed when the method is removed."
	newProtocol ifNil: [ ^ self ].

	originalProtocol := (self protocolOfSelector: selector) ifNil: [ ^ self ].
	originalProtocol name = oldProtocol name ifTrue: [ self classify: selector under: newProtocol name ].

	(self traitComposition reverseAlias: selector) do: [ :selectorAlias |
		self recategorizeSelector: selectorAlias from: oldProtocol to: newProtocol.
		self notifyOfRecategorizedSelector: selectorAlias from: oldProtocol to: newProtocol ]
]

{ #category : 'recompilation' }
TraitedClass >> recompile: selector from: oldClass [

	super recompile: selector from: oldClass.
	TraitChange addSelector: selector on: self
]

{ #category : 'trait-composition' }
TraitedClass >> removeFromComposition: aTrait [

	self setTraitComposition: (self traitComposition copyWithoutTrait: aTrait asTraitComposition)
]

{ #category : 'removing' }
TraitedClass >> removeFromSystem: logged [

	"When a traited class is removed the traits it is using should be updated"
	| mySubclasses |
	self traitComposition removeUser: self.
	self class traitComposition removeUser: self class.

	TraitedClass removeUser: self class.

	mySubclasses := self subclasses.

	super removeFromSystem: logged.

	"As I am a traited class my subclasses does not have the basic traited class
	methods, so I add them."
	mySubclasses do: [ :each | each class initializeBasicMethods ]
]

{ #category : 'removing' }
TraitedClass >> removeSelector: aSelector [

	"When a selector is removed it should be notified to my users.
	Check the class TraitChange for more details"
	<reflection: 'Class structural modification - Selector/Method modification'>
	super removeSelector: aSelector.
	self localMethodDict removeKey: aSelector ifAbsent: [  ].

	TraitChange removeSelector: aSelector on: self
]

{ #category : 'accessing' }
TraitedClass >> traitComposition [
	"My trait composition is in my class. So I do not need to recompile the methods when installing them during bootstrap"
	^ self class baseComposition
]

{ #category : 'accessing' }
TraitedClass >> traitComposition: aComposition [

	aComposition asTraitComposition allTraits do: [ :aMaybeTrait |
		aMaybeTrait isTrait ifFalse: [
			self error: 'All the members of the trait composition should be traits' ]].

	self class baseComposition: aComposition
]

{ #category : 'accessing' }
TraitedClass >> traitCompositionString [
	^ self traitComposition asString
]

{ #category : 'accessing' }
TraitedClass >> traitUsers [
	"I am a traited class, I have no users, this is for compatibility with traits"
		<reflection: 'Class structural inspection - Traits'>
	^ #()
]

{ #category : 'accessing' }
TraitedClass >> traits [
	<reflection: 'Class structural inspection - Traits'>
	^ self traitComposition traits
]
