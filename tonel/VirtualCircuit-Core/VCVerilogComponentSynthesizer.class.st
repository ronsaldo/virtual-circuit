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
VCVerilogComponentSynthesizer >> emitLogicalOperation: operation operands: operands [
	operands size = 1 ifTrue: [ 
		^ (UnaryOperationMap at: operation) , operands first
	].
	operands size = 2 ifTrue: [ 
		^ operands first , (BinaryOperationMap at: operation) , operands second
	].
	operands size = 3 ifTrue: [ 
		self halt.
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
VCVerilogComponentSynthesizer >> emitRegisterAssignments: out [
	registerAssignments ifEmpty: [ ^ self ].
	
	registerAssignments do: [ :registerAssignment |
		out tab;
			nextPutAll: 'always @(posedge ';
			nextPutAll: registerAssignment third;
			nextPutAll: ') ';
			nextPutAll: registerAssignment first;
			nextPutAll: ' <= ';
			nextPutAll: registerAssignment second;
			nextPutAll: ';';
			lf
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
	submodule needsClock ifTrue: [ self halt ].
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
