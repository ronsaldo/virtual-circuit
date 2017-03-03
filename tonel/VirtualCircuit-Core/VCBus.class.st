Class {
	#name : #VCBus,
	#superclass : #Object,
	#instVars : [
		'builder',
		'instance',
		'busPrefix',
		'busSuffix',
		'ports',
		'hasController'
	],
	#category : #'VirtualCircuit-Core-Bus'
}

{ #category : #'bus description' }
VCBus class >> createPortVariable: variableName [
	(self hasInstVarNamed: variableName) ifFalse: [
		self addInstVarNamed: variableName
	].
	self compile: (
'{1}
	^ {1}' format: { variableName }) classified: 'port accessors'
]

{ #category : #'bus description' }
VCBus class >> makePortName: baseName [
	^ '(self makePortName: {1})' format: {baseName printString}
]

{ #category : #parsing }
VCBus class >> parsePortDesc: desc [
	^ VCBusPortDescription new
			variableName: desc first;
			direction: desc second;
			portName: desc third;
			bits: desc fourth;
			options: (desc size > 4 ifTrue: [ desc fifth ] ifFalse: [#()])
]

{ #category : #'bus description' }
VCBus class >> portDesc [
	^ #()
]

{ #category : #'bus description' }
VCBus class >> portSpec [
	^ self portDesc collect: [ :desc | self parsePortDesc: desc ]
]

{ #category : #'bus description' }
VCBus class >> rebuildPortConnections [
	| portSpec createPortsSource |
	portSpec := self portSpec.
	createPortsSource := ByteString streamContents: [ :out |
		out nextPutAll: 'createPorts'; cr.
		
		portSpec do: [ :port |
			"Create the instance variable name"
			self createPortVariable: port variableName.
		
			"Assign the variable"
			out tab; nextPutAll: port variableName ; nextPutAll: ' := '.
			port direction == #input ifTrue: [
				out nextPutAll: 'self input: '; nextPutAll: (self makePortName: port portName);
					nextPutAll: ' bits: '; nextPutAll: port bits printString.  
			].

			port direction == #output ifTrue: [
				out nextPutAll: 'self output';
					nextPutAll: ((port options includes: #register) ifTrue: [ 'Register: ' ] ifFalse: ': ');
					nextPutAll: (self makePortName: port portName);
					nextPutAll: ' bits: '; nextPutAll: port bits printString.  
				(port options includes: #register) ifTrue: [ 
				]
			].
			out nextPutAll: '.'; cr.
		]
	].

	self compile: createPortsSource classified: 'ports'
]

{ #category : #ports }
VCBus >> addPort: port [
	^ ports add: port
]

{ #category : #accessing }
VCBus >> builder [
	^ builder
]

{ #category : #accessing }
VCBus >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
VCBus >> busPrefix [
	^ busPrefix
]

{ #category : #accessing }
VCBus >> busPrefix: anObject [
	busPrefix := anObject
]

{ #category : #accessing }
VCBus >> busSuffix [
	^ busSuffix
]

{ #category : #accessing }
VCBus >> busSuffix: anObject [
	busSuffix := anObject
]

{ #category : #'as yet unclassified' }
VCBus >> connectWith: anotherBus [
	self assert: ports size = anotherBus ports size.
	ports doWithIndex: [ :port :index |
		port connectWith: (anotherBus ports at: index)
	]
]

{ #category : #'as yet unclassified' }
VCBus >> createController [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
VCBus >> createControllerWithBuilder: aBuilder [
	hasController := true.
	builder := aBuilder.
	ports removeAll.
	self createPorts;
		createController
]

{ #category : #ports }
VCBus >> createPorts [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
VCBus >> createPortsWithController [
	hasController := true.
	ports removeAll.
	self createPorts;
		createController
]

{ #category : #'as yet unclassified' }
VCBus >> createPortsWithoutController [
	hasController := false.
	ports removeAll.
	self createPorts.
]

{ #category : #initialization }
VCBus >> initialize [
	super initialize.
	busPrefix := ''.
	busSuffix := ''.
	ports := OrderedCollection new.
]

{ #category : #ports }
VCBus >> input: portName bits: bitCount [
	instance ifNotNil: [
		^ self addPort: (instance pin: portName asSymbol)
	].
	^ self addPort: (builder input: portName bits: bitCount)
]

{ #category : #accessing }
VCBus >> instance [
	^ instance
]

{ #category : #accessing }
VCBus >> instance: anObject [
	instance := anObject
]

{ #category : #initialization }
VCBus >> makePortName: baseName [
	^ busPrefix , baseName , busSuffix
]

{ #category : #ports }
VCBus >> output: portName bits: bitCount [
	instance ifNotNil: [
		^ self addPort: (instance pin: portName asSymbol)
	].
	^ self addPort: (builder output: portName bits: bitCount)
]

{ #category : #ports }
VCBus >> outputRegister: portName bits: bitCount [
	| result |
	instance ifNotNil: [
		(builder isNotNil and: [ hasController]) ifTrue: [ 
			result := builder register: bitCount.
			result name: (portName , #_reg) asSymbol.
			instance pin: portName asSymbol value: result.
			^ self addPort: result
		].
		^ self addPort: (instance pin: portName asSymbol)
	].
	hasController ifFalse: [
		^ self addPort: (builder output: portName bits: bitCount)
	].
	^ self addPort: (builder outputRegister: portName bits: bitCount)
]

{ #category : #accessing }
VCBus >> ports [
	^ ports
]
