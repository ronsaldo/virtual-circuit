Class {
	#name : #VCInputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCInputPin >> accept: aVisitor [
	^ aVisitor visitInputPin: self
]

{ #category : #converting }
VCInputPin >> asInstancePin [
	^ (self as: VCInstanceInputPin) value: nil; yourself.
]

{ #category : #testing }
VCInputPin >> isInput [
	^ true
]
