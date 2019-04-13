Class {
	#name : #VCADCVoltageSource,
	#superclass : #VCAVoltageSource,
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCADCVoltageSource >> addToMatrices: matrices vector: vector [
	| matrix |
	matrix := matrices at: 1.
	vector at: variableIndex put: value.
	positive variableIndex ifNotNil: [ :wireIndex |
		matrix
			at: wireIndex at: variableIndex put: 1;
			at: variableIndex at: wireIndex put: 1
	].
	negative variableIndex ifNotNil: [ :wireIndex |
		matrix
			at: wireIndex at: variableIndex put: -1;
			at: variableIndex at: wireIndex put: -1
	].

]
