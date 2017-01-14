Class {
	#name : #VCInstanceInputPin,
	#superclass : #VCInputPin,
	#instVars : [
		'instance'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCInstanceInputPin >> accept: aVisitor [
	^ aVisitor visitInstanceInputPin: self
]

{ #category : #accessing }
VCInstanceInputPin >> instance [
	^ instance
]

{ #category : #accessing }
VCInstanceInputPin >> instance: anObject [
	instance := anObject
]
