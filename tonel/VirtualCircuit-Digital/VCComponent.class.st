Class {
	#name : #VCComponent,
	#superclass : #VCElement,
	#instVars : [
		'cacheSelector',
		'cacheClass',
		'dependents',
		'pins',
		'elements',
		'autoClock',
		'clockPin',
		'resetPin',
		'autoReset'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #building }
VCComponent class >> build: aBlock [
	^ self new build: aBlock
	
]

{ #category : #defaults }
VCComponent class >> defaultClockPinName [
	^ #clock
]

{ #category : #defaults }
VCComponent class >> defaultResetPinName [
	^ #reset
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
	(element needsClock and: [ self isAutoClock ])ifTrue: [
		self connectClockTo: element.
	].
	(element hasReset and: [ self isAutoReset ])ifTrue: [
		self connectResetTo: element.
	].

	^ element
]

{ #category : #adding }
VCComponent >> addPin: pin [
	pins at: pin name ifPresent: [
		self error: 'Trying to override existing pin named: ' , pin name.
	] ifAbsentPut: [ pin ].

	pin name == #clock ifTrue: [ needsClock := true ].
	
	pin component: self.
	^ self addElement: pin
]

{ #category : #clock }
VCComponent >> autoClock [
	self autoClock: self class defaultClockPinName.
]

{ #category : #clock }
VCComponent >> autoClock: clockPinName [
	autoClock := true.
	self ensureClockPin: clockPinName.
]

{ #category : #reset }
VCComponent >> autoReset [
	self autoReset: self class defaultResetPinName.
]

{ #category : #reset }
VCComponent >> autoReset: resetPinName [
	autoReset := true.
	self ensureResetPin: resetPinName.
]

{ #category : #building }
VCComponent >> build: aBlock [
	| builder |
	builder := self builder.
	aBlock cull: builder cull: self.
	self addAsDependency.
	^ self
]

{ #category : #building }
VCComponent >> builder [
	^ VCComponentBuilder new component: self.
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
VCComponent >> clockPin [
	^ clockPin
]

{ #category : #accessing }
VCComponent >> clockPin: anObject [
	clockPin := anObject
]

{ #category : #clock }
VCComponent >> connectClockTo: aComponent [
	self assert: clockPin isNotNil.
	aComponent clock: clockPin
]

{ #category : #reset }
VCComponent >> connectResetTo: aComponent [
	self assert: resetPin isNotNil.
	aComponent reset: resetPin
]

{ #category : #accessing }
VCComponent >> elements [
	^ elements
]

{ #category : #clock }
VCComponent >> ensureClockPin [
	^ self ensureClockPin: self class defaultClockPinName
]

{ #category : #clock }
VCComponent >> ensureClockPin: pinName [
	clockPin ifNotNil: [ ^ clockPin ].
	clockPin := self addPin: (VCInputPin new name: pinName; bits: 1; yourself).
	self assert: self needsClock.
	^ clockPin
]

{ #category : #reset }
VCComponent >> ensureResetPin [
	^ self ensureResetPin: self class defaultResetPinName
]

{ #category : #reset }
VCComponent >> ensureResetPin: pinName [
	resetPin ifNotNil: [ ^ resetPin ].
	resetPin := self addPin: (VCInputPin new name: pinName; bits: 1; yourself).
	self assert: self hasReset.
	^ resetPin
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

{ #category : #reset }
VCComponent >> hasReset [
	^ resetPin isNotNil
]

{ #category : #initialization }
VCComponent >> initialize [
	super initialize.
	pins := Dictionary new.
	elements := OrderedCollection new.
	dependents := Set new.
	autoClock := false.
	autoReset := false.
]

{ #category : #clock }
VCComponent >> isAutoClock [
	^ autoClock
]

{ #category : #reset }
VCComponent >> isAutoReset [
	^ autoReset
]

{ #category : #testing }
VCComponent >> isComponent [
	^ true
]

{ #category : #building }
VCComponent >> makeInstance [
	^ VCComponentInstance new baseComponent: self
]

{ #category : #clock }
VCComponent >> needsClock [
	^ clockPin isNotNil
]

{ #category : #accessing }
VCComponent >> pins [
	^ pins
]

{ #category : #accessing }
VCComponent >> resetPin [
	^ resetPin
]

{ #category : #accessing }
VCComponent >> resetPin: anObject [
	resetPin := anObject
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

{ #category : #synthesis }
VCComponent >> vhdl [
	^ VCSynthesizerVHDL synthesize: self
]

{ #category : #synthesis }
VCComponent >> vhdlToFileNamed: fileName [
	| code |
	code := self vhdl.
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
