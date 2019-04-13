Class {
	#name : #VCACircuit,
	#superclass : #Object,
	#instVars : [
		'wires',
		'components'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #building }
VCACircuit class >> build: aBlock [
	^ self new build: aBlock
]

{ #category : #adding }
VCACircuit >> addComponent: aComponent [
	components add: aComponent.
	^ aComponent
]

{ #category : #adding }
VCACircuit >> addWire: aWire [
	wires add: aWire.
	^ aWire
]

{ #category : #building }
VCACircuit >> build: aBlock [
	aBlock value: (VCACircuitBuilder new circuit: self).
	self rebuildGraph
]

{ #category : #accessing }
VCACircuit >> components [
	^ components
]

{ #category : #initialization }
VCACircuit >> initialize [
	super initialize.
	components := OrderedCollection new.
	wires := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
VCACircuit >> modifiedNodalAnalysis [
	| ungroundedWires passiveComponents voltageSources m n matrices vector |
	ungroundedWires := wires select: #ungrounded.
	passiveComponents := components select: #isPassive.
	voltageSources := components select: #isVoltageSource.

	m := ungroundedWires size.
	n := voltageSources size.

	ungroundedWires doWithIndex: [ :wire :index| wire variableIndex: index ].
	voltageSources doWithIndex: [ :comp :index| comp variableIndex: index + m ].

	matrices := (1 to: 3) collect: [:i | PMMatrix zerosRows: m + n cols: m + n].
	vector := PMVector zeros: m + n.
	components do: [:comp |
		comp addToMatrices: matrices vector: vector
	].
	
	^ {matrices . vector}

]

{ #category : #'as yet unclassified' }
VCACircuit >> rebuildGraph [
	wires do: #clearEdges.
	components do: #addToWires.
	
]

{ #category : #accessing }
VCACircuit >> wires [
	^ wires
]
