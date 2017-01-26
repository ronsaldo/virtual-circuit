Class {
	#name : #VCSequentialAction,
	#superclass : #Object,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCSequentialAction >> on: condition applyInComponent: component [
	self subclassResponsibility
]
