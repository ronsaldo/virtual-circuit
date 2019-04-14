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
		'registerAssignments',
		'ramModules',
		'assignedVariables'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #adding }
VCComponentSynthesizer >> addRegister: registerName bits: bits assignment: value onClock: clockName onReset: resetName resetActiveLow: resetActiveLow resetValue: resetValue [
	registerAssignments add: (VCSynthRegisterAssignment new
		name: registerName;
		bits: bits;
		value: value;
		clock: clockName;
		reset: resetName;
		resetActiveLow: resetActiveLow;
		resetValue: resetValue;
		yourself
	)
]

{ #category : #adding }
VCComponentSynthesizer >> addWire: wireName assignment: value [
	wireAssignments add: { wireName . value }
]

{ #category : #visiting }
VCComponentSynthesizer >> convertRAMPort: port [
	| portName |
	port isReadPort ifTrue: [ 
		portName := self getOrCreateVariableName: port.
		^ VCSRAMReadPortSynthesis new
			name: portName;
			address: (self declareValue: port address);
			depth: port ram depth;
			yourself
	].

	port isWritePort ifTrue: [
		^ VCSRAMWritePortSynthesis new
			address: (self declareValue: port address);
			enabled: (self declareValue: port enabled);
			value: (self declareValue: port value);
			depth: port ram depth;
			yourself
	].

	self error: 'Unsupported RAM port type.'
]

{ #category : #'code generation' }
VCComponentSynthesizer >> declareValue: value [
	value ifNil: [ ^ nil ].
	instantiatedElements at: value ifPresent: [ :varName | ^ varName ].
	value isVariable ifTrue: [ self getOrCreateVariableName: value ].
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
VCComponentSynthesizer >> emitFinalContent [
	self subclassResponsibility
]

{ #category : #'code generation' }
VCComponentSynthesizer >> emitSelectCondition: condition trueValue: trueValue falseValue: falseValue [
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
	
		self generateSymbolPrefix: (variable name ifNil: [self localPrefix , variable localPrefix])
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
	ramModules := OrderedCollection new.
	instantiatedElements := Dictionary new.
	wireAssignments := OrderedCollection new.
	registerAssignments := OrderedCollection new.
	assignedVariables := IdentitySet new.
	gensymCount := 0.
]

{ #category : #'code generation' }
VCComponentSynthesizer >> localPrefix [
	^ '_'
]

{ #category : #'code generation' }
VCComponentSynthesizer >> processOutputPin: outputPin [
	self setVariable: outputPin value: [self declareValue: outputPin value]
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
	| variableName assignedValue |
	(assignedVariables includes: variable) ifTrue: [ 
		self error: 'Assigning multiples values to variable ' , variable printString
	].
	assignedVariables add: variable.

	variableName := self getOrCreateVariableName: variable.
	
	assignedValue := value value.
	assignedValue ifNil: [ self error: 'expected a value to assign to a variable' ].
	
	variable isRegister ifTrue: [
		variable clock ifNil: [ self error: 'Cannot assign register without a connected clock.' ].
		self addRegister: variableName bits: variable bits assignment: assignedValue onClock: (self declareValue: variable clock)
		onReset: (variable reset ifNotNil: [ self declareValue: variable reset ])
		resetActiveLow: variable isResetActiveLow
		resetValue: (variable resetValue ifNotNil: [ self declareValue: variable resetValue ])
	] ifFalse: [
		self addWire: variableName assignment: assignedValue
	].

	^ variableName
]

{ #category : #visiting }
VCComponentSynthesizer >> setVariableExpression: anExpression value: aBlock [
	(assignedVariables includes: anExpression) ifTrue: [ ^ instantiatedElements at: anExpression ].
	^ self setVariable: anExpression value: aBlock.
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
	^ self setVariableExpression: bitExtract value: [self emitBit: bitExtract index count: bitExtract bits extract: (self declareValue: bitExtract wire )]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitBitPack: bitPack [
	^ self setVariableExpression: bitPack value: [self emitBitPack: (bitPack wires collect: [ :wire | self declareValue: wire ])]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitBitRepeat: bitRepeat [
	^ self setVariableExpression: bitRepeat value:
		[self emitBit: (self declareValue: bitRepeat wire) repeat: bitRepeat count]
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
	instance pins do: [ :pin | pin accept: self ].
	^ instanceVarName
]

{ #category : #visiting }
VCComponentSynthesizer >> visitConstantInteger: aConstant [
	^ self emitIntegerConstant: aConstant
]

{ #category : #visiting }
VCComponentSynthesizer >> visitInstanceInputPin: instanceInputPin [
	| instance |
	(assignedVariables includes: instanceInputPin) ifTrue: [
		^ instantiatedElements at: instanceInputPin
	].

	instance := self declareValue: instanceInputPin instance.
	^ self setVariableExpression: instanceInputPin value: [self declareValue: instanceInputPin value]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitInstanceOutputPin: instanceOutputPin [
	| instance |
	(assignedVariables includes: instanceOutputPin) ifTrue: [
		^ instantiatedElements at: instanceOutputPin
	].

	instance := self declareValue: instanceOutputPin instance.
	^ instanceOutputPin value ifNotNil: [
		self setVariableExpression: instanceOutputPin value: [self declareValue: instanceOutputPin value]
	] ifNil: [ 
		self declareValue: instanceOutputPin
	]
	
]

{ #category : #visiting }
VCComponentSynthesizer >> visitLogicalOperation: logicalOperation [
	^ self setVariableExpression: logicalOperation value: [ self emitLogicalOperation: logicalOperation operation operands: (logicalOperation operands collect: [ :op | self declareValue: op ]) ]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitRAMModule: ramModule [
	| ramModuleName ramPorts |
	ramModuleName := instantiatedElements at: ramModule ifAbsentPut: [
		self generateSymbolPrefix: (ramModule name ifNil: [ '_ram' ])
	].

	ramPorts := ramModule ports collect: [ :port | self convertRAMPort: port ].

	ramModules add: (VCSRAMModuleSynthesis new
		ram: ramModule;
		clock: (self declareValue: ramModule clock);
		memoryName: ramModuleName;
		ports: ramPorts;
		yourself
	).
	^ ramModuleName
]

{ #category : #visiting }
VCComponentSynthesizer >> visitRAMReadPort: readPort [
	| ram |
	ram := self declareValue: readPort ram.
	^ self getOrCreateVariableName: readPort
]

{ #category : #visiting }
VCComponentSynthesizer >> visitRegister: register [
	^ self
		setVariableExpression: register
		value: [self declareValue: register value]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitSelectCondition: selectCondition [
	^ self
		setVariableExpression: selectCondition
		value: [self
			emitSelectCondition: (self declareValue: selectCondition condition)
			trueValue: (self declareValue: selectCondition trueValue)
			falseValue: (self declareValue: selectCondition falseValue)]
]

{ #category : #visiting }
VCComponentSynthesizer >> visitVariable: variable [
	^ self
		setVariableExpression: variable
		value: [self declareValue: variable value]
]
