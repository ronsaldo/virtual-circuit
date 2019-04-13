Class {
	#name : #VCAInductor,
	#superclass : #VCAPassiveComponent,
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAInductor >> addToWires [
	self left addEdge: self.
	self right addEdge: self.
]

{ #category : #'as yet unclassified' }
VCAInductor >> conductance [
	^ self value reciprocal
]

{ #category : #adding }
VCAInductor >> selectConductanceMatrix: matrices [
	^ matrices at: 1
]
