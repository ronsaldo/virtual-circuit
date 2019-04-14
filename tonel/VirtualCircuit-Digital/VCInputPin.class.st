Class {
	#name : #VCInputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'as yet unclassified' }
VCInputPin >> accept: aVisitor [
	^ aVisitor visitInputPin: self
]

{ #category : #converting }
VCInputPin >> asInstancePin [
	^ (self as: VCInstanceInputPin) value: nil; yourself.
]

{ #category : #'as yet unclassified' }
VCInputPin >> connectWith: anotherPin [ 
	anotherPin connectWithSourcePin: self
]

{ #category : #testing }
VCInputPin >> isInput [
	^ true
]
