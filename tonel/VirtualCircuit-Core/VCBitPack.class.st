Class {
	#name : #VCBitPack,
	#superclass : #VCExpression,
	#instVars : [
		'wires'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #visiting }
VCBitPack >> accept: aVisitor [
	^ aVisitor visitBitPack: self
]

{ #category : #visualization }
VCBitPack >> addRoassalEdgesFrom: element toView: view [
	| wireElements |
	super addRoassalEdgesFrom: element toView: view.
	
	wireElements := wires collect: [ :op | view elementFromModel: op ].
	view addAll: (RTLine edgesFrom: element toAll: wireElements)
]

{ #category : #accessing }
VCBitPack >> wires [
	^ wires
]

{ #category : #accessing }
VCBitPack >> wires: anObject [
	wires := anObject
]
