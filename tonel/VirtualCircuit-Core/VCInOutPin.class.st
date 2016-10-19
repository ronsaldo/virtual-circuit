Class {
	#name : #VCInOutPin,
	#superclass : #VCPin,
	#category : #'VirtualCircuit-Core-Circuit'
}

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
