Class {
	#name : #VCBitPack,
	#superclass : #VCVariable,
	#instVars : [
		'wires'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
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
