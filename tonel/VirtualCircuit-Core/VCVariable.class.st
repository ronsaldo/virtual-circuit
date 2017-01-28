Class {
	#name : #VCVariable,
	#superclass : #VCExpression,
	#instVars : [
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

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

{ #category : #accessing }
VCVariable >> value [
	^ value
]

{ #category : #accessing }
VCVariable >> value: anObject [
	value := anObject
]
