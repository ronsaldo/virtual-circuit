Class {
	#name : #VCSequentialAction,
	#superclass : #Object,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #converting }
VCSequentialAction >> asVCSequentialAction [
	^ self
]

{ #category : #accessing }
VCSequentialAction >> on: condition applyInComponent: component [
	self subclassResponsibility
]
