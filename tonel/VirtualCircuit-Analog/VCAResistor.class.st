Class {
	#name : #VCAResistor,
	#superclass : #VCAPassiveComponent,
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAResistor >> addToWires [
	self left addEdge: self.
	self right addEdge: self.
]

{ #category : #'as yet unclassified' }
VCAResistor >> conductance [
	^ self value reciprocal
]

{ #category : #adding }
VCAResistor >> selectConductanceMatrix: matrices [
	^ matrices at: 2
]
