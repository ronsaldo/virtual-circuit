Class {
	#name : #VCOutputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'as yet unclassified' }
VCOutputPin >> accept: aVisitor [
	^ aVisitor visitOutputPin: self
]

{ #category : #converting }
VCOutputPin >> asInstancePin [
	^ (self as: VCInstanceOutputPin) value: nil; yourself.
]

{ #category : #'as yet unclassified' }
VCOutputPin >> connectWith: anotherPin [ 
	anotherPin connectWithSinkPin: self
]

{ #category : #testing }
VCOutputPin >> isOutput [
	^ true
]
