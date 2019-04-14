Class {
	#name : #VCLogicalOperation,
	#superclass : #VCExpression,
	#instVars : [
		'operands',
		'operation'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #building }
VCLogicalOperation class >> operation: operation bits: bits first: first second: second [
	^ self new
		operation: operation;
		bits: bits;
		operands: { first . second };
		yourself
]

{ #category : #building }
VCLogicalOperation class >> operation: operation bits: bits operand: operand [
	^ self new
		operation: operation;
		bits: bits;
		operands: { operand };
		yourself
]

{ #category : #'as yet unclassified' }
VCLogicalOperation >> accept: aVisitor [
	^ aVisitor visitLogicalOperation: self
]

{ #category : #visualization }
VCLogicalOperation >> addRoassalEdgesFrom: element toView: view [
	| operandElements |
	super addRoassalEdgesFrom: element toView: view.
	
	operandElements := operands collect: [ :op | view elementFromModel: op ].
	view addAll: (RTLine edgesFrom: element toAll: operandElements)
]

{ #category : #accessing }
VCLogicalOperation >> operands [
	^ operands
]

{ #category : #accessing }
VCLogicalOperation >> operands: anObject [
	operands := anObject
]

{ #category : #accessing }
VCLogicalOperation >> operation [
	^ operation
]

{ #category : #accessing }
VCLogicalOperation >> operation: anObject [
	operation := anObject
]

{ #category : #accessing }
VCLogicalOperation >> printableName [
	^ operation
]
