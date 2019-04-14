Class {
	#name : #VCInOutPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #'as yet unclassified' }
VCInOutPin >> accept: aVisitor [
	^ aVisitor visitInOutPin: self
]

{ #category : #converting }
VCInOutPin >> asInstancePin [
	^ self copy value: nil; yourself.
]

{ #category : #testing }
VCInOutPin >> isInput [
	^ true
]

{ #category : #testing }
VCInOutPin >> isOutput [
	^ true
]
