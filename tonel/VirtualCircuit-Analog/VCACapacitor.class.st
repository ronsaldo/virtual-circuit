Class {
	#name : #VCACapacitor,
	#superclass : #VCAPassiveComponent,
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCACapacitor >> addToWires [
	self left addEdge: self.
	self right addEdge: self.
]

{ #category : #'as yet unclassified' }
VCACapacitor >> conductance [
	^ self value
]

{ #category : #adding }
VCACapacitor >> selectConductanceMatrix: matrices [
	^ matrices at: 3
]
