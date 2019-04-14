Class {
	#name : #VCBitRepeat,
	#superclass : #VCExpression,
	#instVars : [
		'wire',
		'count'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #visiting }
VCBitRepeat >> accept: aVisitor [
	^ aVisitor visitBitRepeat: self
]

{ #category : #accessing }
VCBitRepeat >> count [
	^ count
]

{ #category : #accessing }
VCBitRepeat >> count: anObject [
	count := anObject
]

{ #category : #accessing }
VCBitRepeat >> wire [
	^ wire
]

{ #category : #accessing }
VCBitRepeat >> wire: anObject [
	wire := anObject
]
