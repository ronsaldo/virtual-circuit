Class {
	#name : #VCConstantFloat,
	#superclass : #VCConstant,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCConstantFloat >> accept: aVisitor [
	^ aVisitor visitConstantFloat: self
]
