Class {
	#name : #VCConstantInteger,
	#superclass : #VCConstant,
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #visiting }
VCConstantInteger >> accept: aVisitor [
	^ aVisitor visitConstantInteger: self
]
