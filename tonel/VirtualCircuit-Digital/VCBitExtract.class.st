Class {
	#name : #VCBitExtract,
	#superclass : #VCExpression,
	#instVars : [
		'wire',
		'count',
		'index'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #visiting }
VCBitExtract >> accept: aVisitor [
	^ aVisitor visitBitExtract: self
]

{ #category : #visualization }
VCBitExtract >> addRoassalEdgesFrom: element toView: view [
	super addRoassalEdgesFrom: element toView: view.
	view add: (RTLine edgeFrom: element to: (view elementFromModel: wire))
]

{ #category : #accessing }
VCBitExtract >> index [
	^ index
]

{ #category : #accessing }
VCBitExtract >> index: anObject [
	index := anObject.
	self assert: index > 0.
]

{ #category : #accessing }
VCBitExtract >> wire [
	^ wire
]

{ #category : #accessing }
VCBitExtract >> wire: anObject [
	wire := anObject
]
