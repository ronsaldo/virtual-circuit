Class {
	#name : #VCAWire,
	#superclass : #Object,
	#instVars : [
		'variableIndex',
		'edges',
		'grounded'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAWire >> addEdge: anEdge [
	edges := edges copyWith: anEdge 
]

{ #category : #'as yet unclassified' }
VCAWire >> clearEdges [
	edges := #().
	grounded := false.
]

{ #category : #accessing }
VCAWire >> edges [
	^ edges
]

{ #category : #accessing }
VCAWire >> grounded [
	^ grounded
]

{ #category : #accessing }
VCAWire >> grounded: anObject [
	grounded := anObject
]

{ #category : #accessing }
VCAWire >> ungrounded [
	^ grounded not
]

{ #category : #accessing }
VCAWire >> variableIndex [
	^ variableIndex
]

{ #category : #accessing }
VCAWire >> variableIndex: anObject [
	variableIndex := anObject
]
