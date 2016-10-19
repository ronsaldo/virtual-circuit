Class {
	#name : #VCOutputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #converting }
VCOutputPin >> asInstancePin [
	^ (self as: VCInputPin) value: nil; yourself.
]

{ #category : #testing }
VCOutputPin >> isOutput [
	^ true
]
