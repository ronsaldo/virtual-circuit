Class {
	#name : #VCRegisterAssignment,
	#superclass : #VCSequentialAction,
	#instVars : [
		'register',
		'value'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #converting }
VCRegisterAssignment >> asVCElementFor: anOwner bits: bitCount [
	^ value asVCElementFor: anOwner bits: bitCount
]

{ #category : #'as yet unclassified' }
VCRegisterAssignment >> on: condition applyInComponent: component [
	register value: (condition ifTrue: value ifFalse: register value)
]

{ #category : #accessing }
VCRegisterAssignment >> register [
	^ register
]

{ #category : #accessing }
VCRegisterAssignment >> register: anObject [
	register := anObject
]

{ #category : #accessing }
VCRegisterAssignment >> value [
	^ value
]

{ #category : #accessing }
VCRegisterAssignment >> value: anObject [
	value := anObject
]
