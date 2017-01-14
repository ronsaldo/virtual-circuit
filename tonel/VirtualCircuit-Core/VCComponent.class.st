Class {
	#name : #VCComponent,
	#superclass : #VCElement,
	#instVars : [
		'cacheSelector',
		'cacheClass',
		'dependents',
		'pins',
		'elements'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #building }
VCComponent class >> build: aBlock [
	^ self new build: aBlock
	
]

{ #category : #building }
VCComponent class >> name: aName build: aBlock [
	^ self new name: aName; build: aBlock
	
]

{ #category : #building }
VCComponent class >> name: aName cacheClass: cacheClass cacheSelector: cacheSelector build: aBlock [
	^ self new
		name: aName;
		cacheClass: cacheClass;
		cacheSelector: cacheSelector;
		build: aBlock
	
]

{ #category : #visiting }
VCComponent >> accept: aVisitor [
	^ aVisitor visitComponent: self
]

{ #category : #caching }
VCComponent >> addAsDependency [
	cacheClass ifNil: [ ^ self ].
	elements select: #isComponentInstance thenDo: [ :instance | instance baseComponent addDependent: self ]
]

{ #category : #caching }
VCComponent >> addDependent: aComponent [
	self assert: aComponent isComponent.
	dependents add: aComponent.
]

{ #category : #adding }
VCComponent >> addElement: element [
	element owner: self.
	elements add: element.
	^ element
]

{ #category : #adding }
VCComponent >> addPin: pin [
	pins at: pin name ifPresent: [
		self error: 'Trying to override existing pin named: ' , pin name.
	] ifAbsentPut: [ pin ].
	
	pin component: self.
	^ self addElement: pin
]

{ #category : #building }
VCComponent >> build: aBlock [
	| builder |
	builder := VCComponentBuilder new component: self.
	aBlock cull: builder cull: self.
	self addAsDependency.
	^ self
]

{ #category : #accessing }
VCComponent >> cacheClass [
	^ cacheClass
]

{ #category : #accessing }
VCComponent >> cacheClass: anObject [
	cacheClass := anObject
]

{ #category : #accessing }
VCComponent >> cacheSelector [
	^ cacheSelector
]

{ #category : #accessing }
VCComponent >> cacheSelector: anObject [
	cacheSelector := anObject
]

{ #category : #accessing }
VCComponent >> elements [
	^ elements
]

{ #category : #caching }
VCComponent >> flushCache [
	cacheClass ifNotNil: [
		cacheClass flushComponentSelector: cacheSelector.
	].

	cacheClass := nil.
	cacheSelector := nil.
	dependents do: #flushCache; removeAll.
	
]

{ #category : #initialization }
VCComponent >> initialize [
	super initialize.
	pins := Dictionary new.
	elements := OrderedCollection new.
	dependents := Set new.
]

{ #category : #testing }
VCComponent >> isComponent [
	^ true
]

{ #category : #building }
VCComponent >> makeInstance [
	^ VCComponentInstance new baseComponent: self
]

{ #category : #accessing }
VCComponent >> pins [
	^ pins
]

{ #category : #synthesis }
VCComponent >> synthesizeWith: synthesizer [
	^ synthesizer synthesizeComponent: self
]

{ #category : #synthesis }
VCComponent >> verilog [
	^ VCSynthesizerVerilog synthesize: self
]

{ #category : #synthesis }
VCComponent >> verilogToFileNamed: fileName [
	| code |
	code := self verilog.
	fileName asFileReference writeStreamDo: [ :out | out truncate; nextPutAll: code ]
]

{ #category : #visualization }
VCComponent >> visualize [
	| view viewElements |
	view := RTView new.
	view @ RTDraggableView.
	
	viewElements := elements collect: [:element | element roassalElementForView: view ].
	viewElements do: [ :element | element model addRoassalEdgesFrom: element toView: view ].

	"RTForceBasedLayout on: viewElements."
	RTFlowLayout on: viewElements.
	"RTDominanceTreeLayout on: viewElements."
	^ view
]
