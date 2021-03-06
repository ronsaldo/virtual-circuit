Class {
	#name : #VCVariable,
	#superclass : #VCExpression,
	#instVars : [
		'value'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #comparing }
VCVariable >> <== newValue [
	^ VCVariableAssignment new
		variable: self;
		value: (self adaptElement: newValue);
		yourself
]

{ #category : #visiting }
VCVariable >> accept: aVisitor [
	^ aVisitor visitVariable: self
]

{ #category : #visualization }
VCVariable >> addRoassalEdgesFrom: element toView: view [
	value isVirtualCircuitElement ifTrue: [
		view add: (RTLine edgeFrom: element to: (view elementFromModel: value))
	].
]

{ #category : #testing }
VCVariable >> isVariable [
	^ true
]

{ #category : #'as yet unclassified' }
VCVariable >> localPrefix [
	^ 'variable'
]

{ #category : #accessing }
VCVariable >> maxValue [
	^ (1 << bits) - 1
]

{ #category : #accessing }
VCVariable >> minValue [
	^ 0
]

{ #category : #initialization }
VCVariable >> setDefaultValue [
	self value: 0
]

{ #category : #accessing }
VCVariable >> value [
	^ value
]

{ #category : #accessing }
VCVariable >> value: aValue [
	value := self adaptElement: aValue
]
