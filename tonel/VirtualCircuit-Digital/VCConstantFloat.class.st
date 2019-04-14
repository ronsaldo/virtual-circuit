Class {
	#name : #VCConstantFloat,
	#superclass : #VCConstant,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #visiting }
VCConstantFloat >> accept: aVisitor [
	^ aVisitor visitConstantFloat: self
]
