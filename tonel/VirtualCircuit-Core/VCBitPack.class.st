Class {
	#name : #VCBitPack,
	#superclass : #VCExpression,
	#instVars : [
		'wires'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #packing }
VCBitPack >> , other [
	^ owner addElement: (VCBitPack new
		wires: wires , {other asVCElementFor: owner };
		computeBitCount;
		yourself)
]

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

{ #category : #packing }
VCBitPack >> computeBitCount [
	bits := 0.
	wires do: [:wire | bits := bits + wire bits]
]

{ #category : #accessing }
VCBitPack >> wires [
	^ wires
]

{ #category : #accessing }
VCBitPack >> wires: anObject [
	wires := anObject
]
