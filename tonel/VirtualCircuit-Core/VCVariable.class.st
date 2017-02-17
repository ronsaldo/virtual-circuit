Class {
	#name : #VCVariable,
	#superclass : #VCExpression,
	#instVars : [
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #comparing }
VCVariable >> <== newValue [
	^ VCVariableAssignment new
		variable: self;
		value: (self adaptElement: newValue);
		yourself
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
