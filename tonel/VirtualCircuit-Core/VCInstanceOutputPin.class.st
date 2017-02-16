Class {
	#name : #VCInstanceOutputPin,
	#superclass : #VCOutputPin,
	#instVars : [
		'instance'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCInstanceOutputPin >> accept: aVisitor [
	^ aVisitor visitInstanceOutputPin: self
]

{ #category : #accessing }
VCInstanceOutputPin >> instance [
	^ instance
]

{ #category : #accessing }
VCInstanceOutputPin >> instance: anObject [
	instance := anObject
]