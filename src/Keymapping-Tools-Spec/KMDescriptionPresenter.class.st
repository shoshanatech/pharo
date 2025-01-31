"
A KMDescription is a window showing the description of shortcuts for a specified set of symbols reprensenting KMCategories
"
Class {
	#name : 'KMDescriptionPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'actionBar',
		'categoryList',
		'selectedAction',
		'shortcutTable',
		'inputPresenter'
	],
	#category : 'Keymapping-Tools-Spec',
	#package : 'Keymapping-Tools-Spec'
}

{ #category : 'instance creation' }
KMDescriptionPresenter class >> descriptionText [

	^ 'Show the description of shortcuts for the system'
]

{ #category : 'accessing' }
KMDescriptionPresenter class >> icon [

	^ self iconNamed: #keymapBrowser
]

{ #category : 'instance creation' }
KMDescriptionPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: 'Shortcuts Editor')
		action: [ self open ];
		order: 34;
		parent: #Tools;
		icon: self icon;
		help: self descriptionText
]

{ #category : 'instance creation' }
KMDescriptionPresenter class >> open [

	<script>
	^ self new open
]

{ #category : 'api' }
KMDescriptionPresenter >> allAPIsEntry [
	"Set the receiver's category items to a list of categories in aCollectionOfSymbols.
	We also build an 'All' category including all keymaps in aCollectionOfSymbols"

	| newCategoryItem |

	newCategoryItem := KMCategoryAll new categoryName: 'All'.
	KMRepository default categories inject: newCategoryItem into: [ : a : b | a , b ].
	newCategoryItem addAll: self shortcutActivationCmdInstances.
	^ newCategoryItem
]

{ #category : 'initialization' }
KMDescriptionPresenter >> connectPresenters [

	categoryList transmitTo: shortcutTable transform: [ :item | self keymapsAtCategory: item model ].
	inputPresenter whenTextChangedDo: [ :text | self filterTable: text ].
	shortcutTable whenActivatedDo: [ :item | item value inspect selectedItem ]
]

{ #category : 'layout' }
KMDescriptionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 6;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Filter scopes' expand: false;
				   add: categoryList;
				   yourself)
		  expand: false;
		  add: inputPresenter expand: false;
		  add: shortcutTable;
		  add: actionBar withConstraints: [ :c | c height: 25 ];
		  yourself
]

{ #category : 'initialization' }
KMDescriptionPresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		shortcutTable items: (self keymapsAtCategory: categoryList selectedItem).
		^ self ].

	newItems := (self keymapsAtCategory: categoryList selectedItem) select: [ :each |
		            { each name. each scopeName. each description } anySatisfy: [ :aString | 
								aString includesSubstring: aText caseSensitive: false ] ].
	shortcutTable items: newItems
]

{ #category : 'initialization' }
KMDescriptionPresenter >> initialize [

	| shortcutItems |
	super initialize.

	shortcutItems := { self allAPIsEntry } , self shortcutActivationCategoriesItems
	                 , { (KMRepository default categoryForName: KMRepository default categories keys) }.
	categoryList items: shortcutItems
]

{ #category : 'initialization' }
KMDescriptionPresenter >> initializePresenters [

	categoryList := self newDropList
		                display: [ :category | category name ];
		                yourself.
	inputPresenter := self newTextInput
		                  placeholder: 'Filter';
		                  yourself.

	shortcutTable := self newTable.
	shortcutTable
		activateOnDoubleClick;
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		addColumn: (SpStringTableColumn title: 'Shortcut' evaluated: #shortcut);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: #description);
		addColumn: (SpStringTableColumn new
				 title: 'Scope';
				 evaluated: [ :each | each scopeName ];
				 beSortable;
				 width: 150;
				 yourself);
		beResizable.

	actionBar := self newActionBar.
	actionBar addLast: (SpButtonPresenter new
			 action: [ self window close ];
			 label: 'Close';
			 yourself)
]

{ #category : 'initialization' }
KMDescriptionPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'Shortcuts Editor';
		initialExtent: 900 @ 650
]

{ #category : 'initialization' }
KMDescriptionPresenter >> keymapsAtCategory: aKMCategoryOrKMCategoryItemPresenter [
	"Answer a <Collection> of keymaps"

	^ (aKMCategoryOrKMCategoryItemPresenter isKindOf: KMCategoryAll)
		  ifFalse: [ (aKMCategoryOrKMCategoryItemPresenter entriesAt: #all) keymaps asOrderedCollection ]
		  ifTrue: [ aKMCategoryOrKMCategoryItemPresenter shortcuts ]
]

{ #category : 'api - keymaps' }
KMDescriptionPresenter >> kmCategories: aCollectionOfSymbols [
	"Set the receiver's category items to a list of categories in aCollectionOfSymbols.
	We also build an 'All' category including all keymaps in aCollectionOfSymbols"
	categoryList appendCollection:
		(aCollectionOfSymbols collect: [ :e | KMRepository default categoryForName: e ] as: OrderedCollection)
]

{ #category : 'api - commander' }
KMDescriptionPresenter >> shortcutActivationCategories [
	"Answer a <Collection> of <...> representing each a category of shortcuts created using the Commander 1 framework"

	^ (self shortcutActivationCmdInstances 
		groupedBy: [ : cmdShortcutActivation | cmdShortcutActivation annotatedClass packageName ]) values
]

{ #category : 'api - commander' }
KMDescriptionPresenter >> shortcutActivationCategoriesItems [
	"Answer a <Collection> of <KMCategoryItemPresenter> representing each a category of shortcuts created using the Commander 1 framework"

	^ self shortcutActivationCategories
			collect: [ : shortcuts | 
				KMCategoryAll new 
					categoryName: shortcuts anyOne annotatedClass packageName;
					shortcuts: shortcuts;
					yourself ]
]

{ #category : 'api - commander' }
KMDescriptionPresenter >> shortcutActivationCmdInstances [

	^ CmdShortcutActivation registeredInstances copyWithoutAll: CmdShortcutActivation redefiningInstances
]

{ #category : 'callbacks' }
KMDescriptionPresenter >> shortcutDetailsFor: anObject [ 

	^ anObject 
		ifNotNil: [ : aKMKeymapOrCmdShortcutActivation | 
			selectedAction := aKMKeymapOrCmdShortcutActivation action.
			selectedAction method sourceCode ]
		ifNil: [ String empty ]
]
