Class {
	#name : #VCInputPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #converting }
VCInputPin >> asInstancePin [
	^ (self as: VCOutputPin) value: nil; yourself.
]

{ #category : #testing }
VCInputPin >> isInput [
	^ true
]
