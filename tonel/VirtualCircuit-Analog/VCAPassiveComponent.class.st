Class {
	#name : #VCAPassiveComponent,
	#superclass : #VCAComponent,
	#instVars : [
		'value',
		'positive',
		'negative'
	],
	#category : #'VirtualCircuit-Analog'
}

{ #category : #adding }
VCAPassiveComponent >> addToMatrices: matrices vector: vector [
	| leftIndex rightIndex conductance matrix |
	leftIndex := self left variableIndex.
	rightIndex := self right variableIndex.
	
	conductance := self conductance.
	matrix := self selectConductanceMatrix: matrices.
	
	leftIndex ifNotNil: [ 
		matrix at: leftIndex at: leftIndex put: (matrix at: leftIndex at: leftIndex) + conductance
	].
	rightIndex ifNotNil: [ 
		matrix at: rightIndex at: rightIndex put: (matrix at: rightIndex at: rightIndex) + conductance
	].

	(leftIndex isNotNil and: [ rightIndex isNotNil ]) ifTrue: [ 
		matrix at: rightIndex at: leftIndex put: conductance.
		matrix at: leftIndex at: rightIndex put: conductance.
	]

]

{ #category : #'as yet unclassified' }
VCAPassiveComponent >> conductance [
	self subclassResponsibility
]

{ #category : #testing }
VCAPassiveComponent >> isPassive [
	^ true
]

{ #category : #accessing }
VCAPassiveComponent >> left [
	^ positive
]

{ #category : #accessing }
VCAPassiveComponent >> left: aWrire [
	self positive: aWrire
]

{ #category : #accessing }
VCAPassiveComponent >> negative [
	^ negative
]

{ #category : #accessing }
VCAPassiveComponent >> negative: anObject [
	negative := anObject
]

{ #category : #accessing }
VCAPassiveComponent >> positive [
	^ positive
]

{ #category : #accessing }
VCAPassiveComponent >> positive: anObject [
	positive := anObject
]

{ #category : #accessing }
VCAPassiveComponent >> right [
	^ negative
]

{ #category : #accessing }
VCAPassiveComponent >> right: aWrire [
	self negative: aWrire
]

{ #category : #adding }
VCAPassiveComponent >> selectConductanceMatrix: matrices [
	self subclassResponsibility
]

{ #category : #accessing }
VCAPassiveComponent >> value [
	^ value
]

{ #category : #accessing }
VCAPassiveComponent >> value: anObject [
	value := anObject
]
