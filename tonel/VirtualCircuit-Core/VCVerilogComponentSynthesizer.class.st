Class {
	#name : #VCVerilogComponentSynthesizer,
	#superclass : #VCComponentSynthesizer,
	#classVars : [
		'BinaryOperationMap',
		'UnaryOperationMap'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #'class initialization' }
VCVerilogComponentSynthesizer class >> initialize [
	super initialize.
	UnaryOperationMap := Dictionary newFromPairs: #(
		not ~
	).
	BinaryOperationMap := Dictionary newFromPairs: #(
		and &
		or |
		xor ^
		lshift <<
		lrshift >>
		equals ==
		notEquals !=
		
		+ +
		- -
		* *
		/ /
	)
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> bitCountFor: variable [
	variable bits > 1 ifTrue: [
		^ '[' , ((variable bits - 1) asString) , ':0] '
	] ifFalse: [
		^ ''
	]
]

{ #category : #'as yet unclassified' }
VCVerilogComponentSynthesizer >> clockVariableName [
	^ #_clock_
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitBit: index count: count extract: wire [
	^ ByteString streamContents: [ :out |
		out nextPutAll: wire; nextPut: $[.
		count > 1 ifTrue: [
			out print: index + count - 1; nextPut: $:; print: index - 1
		] ifFalse: [ 
			out print: index - 1
		].
		out nextPut: $].
	]
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitBitPack: values [
	^ ByteString streamContents: [ :out |
		out nextPut: ${.
		values doWithIndex: [ :value :index |
			index > 1 ifTrue: [ out nextPutAll: ', ' ].
			out nextPutAll: value
		].
	
		out nextPut: $}
	]
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitFinalContent [
	^ ByteString streamContents: [ :out |
		out nextPutAll: 'module '; nextPutAll: currentModule name;
			nextPutAll: '('.
		currentComponent pins values doWithIndex: [ :value :index |
			index > 1 ifTrue: [ out nextPutAll: ', ' ].
			out nextPutAll: value name
		].
		out nextPutAll: ');';
			lf.
		self emitInputsInto: out.
		self emitOutputsInto: out.
		self emitRegisters: out.
		self emitWires: out.
		self emitSubmodules: out.
		self emitRamModules: out.
		self emitWireAssignments: out.
		self emitRegisterAssignments: out.
		
		out nextPutAll: 'endmodule'; lf
	]


]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitInputsInto: out [
	inputs do: [ :input |
		out tab; nextPutAll: 'input '; nextPutAll: (self bitCountFor: input); nextPutAll: input name; nextPut: $;; lf.
	].
	inputs ifNotEmpty: [ out lf ].

]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitIntegerConstant: aConstant [
	self assert: aConstant bits > 0.
	^ (aConstant bits printString) , '''d' , (aConstant value printString)
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitLogicalOperation: operation operands: operands [
	operands size = 1 ifTrue: [ 
		^ (UnaryOperationMap at: operation) , operands first
	].
	operands size = 2 ifTrue: [ 
		^ operands first , (BinaryOperationMap at: operation) , operands second
	].
	self error: 'Unsupported logical operation arity.'
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitOutputsInto: out [
	outputs do: [ :output |
		out tab; nextPutAll: 'output '; nextPutAll: (self bitCountFor: output); nextPutAll: output name; nextPut: $;; lf.
	].
	outputs ifNotEmpty: [ out lf ].

]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMReadPort: port clockedImplementationFor: ram into: out [
	ram ram distributed ifFalse: [
		out tab; tab; nextPutAll: port name; nextPutAll: '_address <= '; nextPutAll: port address; nextPut: $;; lf.
	].
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMReadPort: port unclockedImplementationFor: ram into: out [
	out tab; nextPutAll: ('assign {1} = {2}[{3}];' format: {port name . ram memoryName .
		ram ram distributed ifTrue: [ port address ] ifFalse: [port name , '_address']}); lf.
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMReadPortDeclaration: port for: ram into: out [
	out tab; nextPutAll: ('wire [{2}:0] {1};' format: {port name . port depth}); lf.
	ram ram distributed ifFalse: [
		out tab; nextPutAll: ('reg [{2}:0] {1}_address;' format: {port name . port depth}); lf.
	]
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMWritePort: port clockedImplementationFor: ram into: out [
	out tab; tab; nextPutAll: 'if ('; nextPutAll: port enabled; nextPutAll: ') begin'; lf.
	out tab; tab; tab; nextPutAll: ('{1}[{2}] <= {3};' format: {ram memoryName . port address . port value}); lf.
	out tab; tab; nextPutAll: 'end'; lf
	
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMWritePort: port unclockedImplementationFor: ram into: out [

]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRAMWritePortDeclaration: port for: ram into: out [
	"Nothing required"
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRamModule: ramModule into: out [
	"
	http://www.dilloneng.com/inferring-block-ram-vs-distributed-ram-in-xst-and-precision.html#/
	"
	out tab; nextPutAll: ('//synthesis attribute ram_style of {1} is {2}' format: {ramModule memoryName . ramModule ram distributed ifTrue: [ 'distributed' ] ifFalse: ['block']}); lf.

	out tab; nextPutAll: ('reg [{2}:0] {1} [{3}:0];' format: {ramModule memoryName . ramModule ram depth - 1 . ramModule ram size - 1 }); lf.
	ramModule ports do: [ :port |
		port emitDeclarationWith: self for: ramModule into: out
	].

	out lf.
	out tab; nextPutAll: 'always @(posedge '; nextPutAll: ramModule clock; nextPutAll: ') begin'; lf.
	ramModule ports do: [ :port |
		port emitClockedImplementationWith: self for: ramModule into: out
	].
	out tab; nextPutAll: 'end'; lf.
	ramModule ports do: [ :port |
		port emitUnclockedImplementationWith: self for: ramModule into: out
	].
	out lf.
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRamModules: out [
	ramModules ifEmpty: [ ^ self ].
	
	ramModules do: [ :ramModule | self emitRamModule: ramModule into: out ]
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRegisterAssignments: out [
	registerAssignments ifEmpty: [ ^ self ].
	
	registerAssignments do: [ :registerAssignment |
		registerAssignment reset ifNotNil: [ 
			out tab;
				nextPutAll: 'always @(posedge ';
				nextPutAll: registerAssignment clock.
				
			registerAssignment resetActiveLow ifTrue: [
				out
					nextPutAll: ' or negedge ';
					nextPutAll: registerAssignment reset;
					nextPutAll: ') begin';
					lf;
					tab; tab; nextPutAll: 'if (!'; nextPutAll:  registerAssignment reset;
					nextPut: $); lf
			] ifFalse: [
				out
					nextPutAll: ' or posedge ';
					nextPutAll: registerAssignment reset;
					nextPutAll: ') begin';
					lf;
					tab; tab; nextPutAll: 'if ('; nextPutAll:  registerAssignment reset;
					nextPut: $); lf
			].
		
			out
				tab; tab; tab; nextPutAll: registerAssignment name;
				nextPutAll: ' <= ';
				nextPutAll: (registerAssignment resetValue ifNil: ['0']);
				nextPutAll: ';';
				lf;
				
				tab; tab; nextPutAll: 'else';
				lf;
				
				tab; tab; tab; nextPutAll: registerAssignment name;
				nextPutAll: ' <= ';
				nextPutAll: registerAssignment value;
				nextPutAll: ';';
				lf;
				
				tab; nextPutAll: 'end';
				lf
		] ifNil: [
			out tab;
				nextPutAll: 'always @(posedge ';
				nextPutAll: registerAssignment clock;
				nextPutAll: ') ';
				nextPutAll: registerAssignment name;
				nextPutAll: ' <= ';
				nextPutAll: registerAssignment value;
				nextPutAll: ';';
				lf
		]
	].

	out lf.
	 
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitRegisters: out [
	registers do: [ :register |
		out tab; nextPutAll: 'reg '; nextPutAll: (self bitCountFor: register); nextPutAll: (instantiatedElements at: register); nextPut: $;; lf.
	].
	registers ifNotEmpty: [ out lf ].
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitSelectCondition: condition trueValue: trueValue falseValue: falseValue [
	^ ByteString streamContents: [ :out |
		out nextPutAll: '(';
			nextPutAll: condition;
			nextPutAll: ') ? (';
			nextPutAll: trueValue;
			nextPutAll: ') : (';
			nextPutAll: falseValue;
			nextPutAll: ')'
	]
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitSubmodule: submodule into: out [
	| instanceName module |
	module := instantiatedElements at: submodule baseComponent.
	instanceName := instantiatedElements at: submodule.
	out tab; nextPutAll: module name; space; nextPutAll: instanceName ; nextPutAll: ' ('; lf.
	submodule pins doWithIndex: [ :pin :index|
		out tab; tab; nextPut: $.; nextPutAll: pin name;
			nextPut: $(; nextPutAll: (instantiatedElements at: pin); nextPut: $).
		index < submodule pins size ifTrue: [ out nextPut: $, ].
		out lf.
	].
	out tab; nextPutAll: ');'; lf.
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitSubmodules: out [
	submodules do: [ :submodule |
		self emitSubmodule: submodule into: out
	].
	submodules ifNotEmpty: [ out lf ].

]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitWireAssignments: out [
	wireAssignments ifEmpty: [ ^ self ].
	
	wireAssignments do: [ :wireAssignment |
		out tab; nextPutAll: 'assign ';
		nextPutAll: wireAssignment first;
		nextPutAll: ' = ';
		nextPutAll: wireAssignment second;
		nextPut: $;;
		lf
	].

	out lf.
	 
]

{ #category : #'code generation' }
VCVerilogComponentSynthesizer >> emitWires: out [
	wires do: [ :wire |
		out tab; nextPutAll: 'wire '; nextPutAll: (self bitCountFor: wire); nextPutAll: (instantiatedElements at: wire); nextPut: $;; lf.
	].
	wires ifNotEmpty: [ out lf ].

]
