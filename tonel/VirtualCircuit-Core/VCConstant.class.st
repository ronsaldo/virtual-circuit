Class {
	#name : #VCConstant,
	#superclass : #VCVariable,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCConstant >> accept: aVisitor [
	^ aVisitor visitConstant: self
]
