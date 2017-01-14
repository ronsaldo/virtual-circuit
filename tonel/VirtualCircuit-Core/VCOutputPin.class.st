Class {
	#name : #VCOutputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCOutputPin >> accept: aVisitor [
	^ aVisitor visitOutputPin: self
]

{ #category : #converting }
VCOutputPin >> asInstancePin [
	^ (self as: VCInstanceOutputPin) value: nil; yourself.
]

{ #category : #testing }
VCOutputPin >> isOutput [
	^ true
]
