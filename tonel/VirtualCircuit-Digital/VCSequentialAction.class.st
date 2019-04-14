Class {
	#name : #VCSequentialAction,
	#superclass : #Object,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #converting }
VCSequentialAction >> asVCSequentialAction [
	^ self
]

{ #category : #accessing }
VCSequentialAction >> on: condition applyInComponent: component [
	self subclassResponsibility
]
