Class {
	#name : #VCRegister,
	#superclass : #VCVariable,
	#instVars : [
		'clock'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCRegister >> accept: aVisitor [
	^ aVisitor visitRegister: self
]

{ #category : #accessing }
VCRegister >> clock [
	^ clock
]

{ #category : #accessing }
VCRegister >> clock: anObject [
	clock := anObject
]

{ #category : #testing }
VCRegister >> isRegister [
	^ true
]

{ #category : #testing }
VCRegister >> needsClock [
	^ true
]
