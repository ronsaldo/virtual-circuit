Class {
	#name : #VCComponentInstance,
	#superclass : #VCElement,
	#instVars : [
		'baseComponent',
		'pins'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCComponentInstance >> accept: aVisitor [
	^ aVisitor visitComponentInstance: self
]

{ #category : #visualization }
VCComponentInstance >> addRoassalEdgesFrom: element toView: view [
	super addRoassalEdgesFrom: element toView: view.
	
	pins valuesDo: [ :pin |
		pin addRoassalEdgesFrom: (view elementFromModel: pin) toView: view
	].
	
]

{ #category : #accessing }
VCComponentInstance >> baseComponent [
	^ baseComponent
]

{ #category : #accessing }
VCComponentInstance >> baseComponent: anObject [
	baseComponent := anObject
]

{ #category : #'reflective operations' }
VCComponentInstance >> doesNotUnderstand: aMessage [
	| cleanSelector pin |
	self assert: aMessage arguments size <= 1.
	cleanSelector := aMessage selector.
	cleanSelector last = $: ifTrue: [ cleanSelector := cleanSelector allButLast ].
	pin := self pin: cleanSelector.
	
	aMessage arguments ifNotEmpty: [ 
		pin value: aMessage arguments first
	].
	
	^ pin
]

{ #category : #initialization }
VCComponentInstance >> initialize [
	super initialize.
	pins := Dictionary new.
	
]

{ #category : #testing }
VCComponentInstance >> isComponentInstance [
	^ true
]

{ #category : #'as yet unclassified' }
VCComponentInstance >> needsClock [
	^ baseComponent needsClock
]

{ #category : #'pin connection' }
VCComponentInstance >> pin: pinName [
	^ pins at: pinName ifAbsentPut: [ 
		(baseComponent pins at: pinName) asInstancePin
			instance: self;
			owner: self owner;
			yourself
	]
]

{ #category : #'pin connection' }
VCComponentInstance >> pin: pinName value: value [
	| pin |
	pin := self pin: pinName.
	pin value: value.
	^ value
]

{ #category : #accessing }
VCComponentInstance >> pins [
	^ pins
]

{ #category : #accessing }
VCComponentInstance >> pins: anObject [
	pins := anObject
]

{ #category : #accessing }
VCComponentInstance >> printableName [
	^ name ifNil: [ baseComponent name ]
]

{ #category : #visualization }
VCComponentInstance >> roassalElementForView: view [
	| rtElement shape pinElements |
	shape := RTCompositeShape new.
	shape add: (RTBox new color: (Color blue alpha: 0.3)).
	shape add: (RTLabel new text: #printableName).
	shape vertical.

	rtElement := shape elementOn: self.
	view add: rtElement.
	
	pinElements := pins values collect: [ :pin | pin roassalElementForView: view ].
	RTGridLayout on: pinElements.
	view addAll: pinElements.

	RTNest new on: rtElement nest: pinElements.
	^ rtElement
]

{ #category : #synthesis }
VCComponentInstance >> synthesizeWith: synthesizer [
	^ synthesizer synthesizeComponentInstance: self
]
