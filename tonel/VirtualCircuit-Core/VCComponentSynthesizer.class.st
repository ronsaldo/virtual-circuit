Class {
	#name : #VCComponentSynthesizer,
	#superclass : #Object,
	#instVars : [
		'globalSynthesizer',
		'currentComponent',
		'currentModule',
		'inputs',
		'outputs',
		'registers',
		'wires',
		'instantiatedElements',
		'gensymCount',
		'submodules',
		'wireAssignments',
		'registerAssignments'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #'as yet unclassified' }
VCComponentSynthesizer >> addRegister: registerName assignment: value onClock: clockName [
	registerAssignments add: { registerName . value . clockName }
]

{ #category : #adding }
VCComponentSynthesizer >> addWire: wireName assignment: value [
	wireAssignments add: { wireName . value }
]

{ #category : #'code generation' }
VCComponentSynthesizer >> declareValue: value [
	value ifNil: [ ^ nil ].
	instantiatedElements at: value ifPresent: [ :varName | ^ varName ].
	^ value accept: self
]

{ #category : #'code generation' }
VCComponentSynthesizer >> emitBit: index count: count extract: wire [
	self subclassResponsibility
]

{ #category : #'code generation' }
VCComponentSynthesizer >> emitBitPack: values [
	self subclassResponsibility
]

{ #category : #'code generation' }
VCComponentSynthesizer >> generateSymbolPrefix: prefix [
	gensymCount := gensymCount + 1.
	^ prefix , gensymCount asString
]

{ #category : #'code generation' }
VCComponentSynthesizer >> getOrCreateVariableName: variable [
	^ instantiatedElements at: variable ifAbsentPut: [
		variable isRegister ifTrue: [ 
			registers add: variable
		] ifFalse: [
			wires add: variable
		].
	
		self generateSymbolPrefix: (variable name ifNil: ['_local'])
	]
]

{ #category : #accessing }
VCComponentSynthesizer >> globalSynthesizer [
	^ globalSynthesizer
]

{ #category : #accessing }
VCComponentSynthesizer >> globalSynthesizer: anObject [
	globalSynthesizer := anObject
]

{ #category : #initialization }
VCComponentSynthesizer >> initialize [
	inputs := OrderedCollection new.
	outputs := OrderedCollection new.
	registers := OrderedCollection new.
	wires := OrderedCollection new.
	submodules := OrderedCollection new.
	instantiatedElements := Dictionary new.
	wireAssignments := OrderedCollection new.
	registerAssignments := OrderedCollection new.
	gensymCount := 0.
]

{ #category : #'code generation' }
VCComponentSynthesizer >> processOutputPin: outputPin [
	self setVariable: outputPin value: (self declareValue: outputPin value)
]

{ #category : #'code generation' }
VCComponentSynthesizer >> processPin: pin [
	instantiatedElements at: pin put: pin name.
	
	pin isOutput ifTrue: [ 
		outputs add: pin.
	] ifFalse: [ 
		pin isInput ifTrue: [ 
			inputs add: pin.
		].
	].

]

{ #category : #initialization }
VCComponentSynthesizer >> setVariable: variable value: value [
	| variableName |
	variableName := self getOrCreateVariableName: variable.
	variable isRegister ifTrue: [
		variable clock ifNil: [ self error: 'Cannot assign register without a connected clock.' ].
		self addRegister: variableName assignment: value onClock: (self declareValue: variable clock)
	] ifFalse: [
		self addWire: variableName assignment: value
	].

	^ variableName
]

{ #category : #'code generation' }
VCComponentSynthesizer >> synthesizeComponent: aComponent into: aModule [
	currentComponent := aComponent.
	currentModule := aModule.
	
	aComponent pins do: [ :pin | self processPin: pin ].
	outputs do: [ :pin | self processOutputPin: pin. ].
	
	aModule content: self emitFinalContent
	
]

{ #category : #visiting }
VCComponentSynthesizer >> visitBitExtract: bitExtract [
	^ self setVariable: bitExtract value: (self emitBit: bitExtract index count: bitExtract count extract: (self declareValue: bitExtract wire ))
]

{ #category : #visiting }
VCComponentSynthesizer >> visitBitPack: bitPack [
	^ self setVariable: bitPack value: (self emitBitPack: (bitPack wires collect: [ :wire | self declareValue: wire ]))
]

{ #category : #visiting }
VCComponentSynthesizer >> visitComponentInstance: instance [
	| component instanceVarName |
	component := globalSynthesizer synthesizeComponent: instance baseComponent.
	submodules add: instance.
	instanceVarName := self generateSymbolPrefix: component name.
	instantiatedElements at: instance baseComponent put: component.
	instantiatedElements at: instance put: instanceVarName.
	instance pins do: [ :pin | self declareValue: pin ].
	^ instanceVarName
]

{ #category : #visiting }
VCComponentSynthesizer >> visitInstanceInputPin: instanceInputPin [
	| instance varName |
	instance := self declareValue: instanceInputPin instance.
	instantiatedElements at: instanceInputPin ifPresent: [:result | ^ result].
	
	varName := instance , '_' , instanceInputPin name.
	wires add: instanceInputPin.
	instantiatedElements at: instanceInputPin put: varName.
	^ self setVariable: instanceInputPin value: (self declareValue: instanceInputPin value)
]

{ #category : #visiting }
VCComponentSynthesizer >> visitInstanceOutputPin: instanceOutputPin [
	| instance varName |
	instance := self declareValue: instanceOutputPin instance.
	instantiatedElements at: instanceOutputPin ifPresent: [:result | ^ result].
	
	varName := instance , '_' , instanceOutputPin name.
	wires add: instanceOutputPin.
	instantiatedElements at: instanceOutputPin put: varName.
	^ varName

	
]

{ #category : #visiting }
VCComponentSynthesizer >> visitLogicalOperation: logicalOperation [
	^ self
		setVariable: logicalOperation
		value: (self emitLogicalOperation: logicalOperation operation operands: (logicalOperation operands collect: [ :op | self declareValue: op ]))
]

{ #category : #visiting }
VCComponentSynthesizer >> visitRegister: register [
	^ self
		setVariable: register
		value: (self declareValue: register value)
]
