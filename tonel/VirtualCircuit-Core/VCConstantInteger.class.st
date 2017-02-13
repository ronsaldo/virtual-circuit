Class {
	#name : #VCConstantInteger,
	#superclass : #VCConstant,
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCConstantInteger >> accept: aVisitor [
	^ aVisitor visitConstantInteger: self
]
