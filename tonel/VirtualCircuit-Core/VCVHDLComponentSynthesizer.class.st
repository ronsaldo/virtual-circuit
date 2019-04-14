Class {
	#name : #VCVHDLComponentSynthesizer,
	#superclass : #VCComponentSynthesizer,
	#classVars : [
		'BinaryOperationMap',
		'UnaryOperationMap'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #'class initialization' }
VCVHDLComponentSynthesizer class >> initialize [
	super initialize.
	UnaryOperationMap := Dictionary newFromPairs: #(
		not ~
	).
	BinaryOperationMap := Dictionary newFromPairs: #(
		and and
		or or
		xor xor
		lshift <<
		lrshift >>
		arshift >>>
		equals =
		notEquals /=
		
		+ +
		- -
		* *
		/ /
	)
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitBit: index count: count extract: wire [
	^ ByteString streamContents: [ :out |
		out nextPutAll: wire; nextPut: $(.
		count > 1 ifTrue: [
			out print: index + count - 2; nextPutAll: ' downto '; print: index - 1
		] ifFalse: [ 
			out print: index - 1
		].
		out nextPut: $).
	]
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitDeclarationsOf: elements into: out. [
	elements do: [ :wire |
		out tab; nextPutAll: 'signal '; nextPutAll: (instantiatedElements at: wire); nextPutAll: ' : '.
		self emitVHDLTypeFor: wire into: out.
		out nextPut: $;; lf
	].
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitFinalContent [
	^ ByteString streamContents: [ :out |

		out nextPutAll: '-- Module '; nextPutAll: currentModule name; lf.
		out nextPutAll: 'entity '; nextPutAll: currentModule name; nextPutAll: ' is'; lf;
			tab; nextPutAll: 'port ('; lf.

		currentComponent pins values doWithIndex: [ :value :index |
			index > 1 ifTrue: [ out nextPutAll: ';'; lf].
			out tab; 	nextPutAll: value name;
				nextPutAll: ' : '.
			(value isInput and: [value isOutput]) ifTrue: [ 
				value isInput ifTrue: [ out nextPutAll: 'inout ' ].
			] ifFalse: [ 
				value isInput ifTrue: [ out nextPutAll: 'in ' ].
				value isOutput ifTrue: [ out nextPutAll: 'out ' ].
			].
			self emitVHDLTypeFor: value into: out
		].
		out nextPutAll: ');';lf.
		out nextPutAll: 'end entity '; nextPutAll: currentModule name; nextPut: $;; lf.
		out lf.

		out nextPutAll: 'architecture RTL of '; nextPutAll: currentModule name; nextPutAll: ' is'; lf.
		self emitWires: out.
		self emitRegisters: out.
"		self emitSubmodules: out.
		self emitRamModules: out.
"
		out nextPutAll: 'begin'; lf.
		self emitWireAssignments: out.
		self emitRegisterAssignments: out.
		
		out nextPutAll: 'end architecture RTL;'; lf
	]


]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitIntegerConstant: aConstant [
	self assert: aConstant bits > 0.
	
	aConstant bits = 1 ifTrue: [
		^ (aConstant value & 1) = 1 ifTrue: [ '''1'''] ifFalse: [ '''0''' ]
	].

	(aConstant bits % 4) = 0 ifTrue: [ 
		^ 'std_logic_vector''(x"' , (aConstant value printPaddedWith: $0 to: aConstant bits // 4 base: 16) , '")'
	].

	^ 'std_logic_vector''(b"' , (aConstant value printPaddedWith: $0 to: aConstant bits base: 2) , '")'

]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitLogicalOperation: operation operands: operands [
	operands size = 1 ifTrue: [ 
		^ (UnaryOperationMap at: operation) , operands first
	].
	operands size = 2 ifTrue: [ 
		(#(+ - * /) includes: operation) ifTrue: [ 
			^ 'std_logic_vector(unsigned({1}) {2} unsigned({3}))' format: { 
				operands first . BinaryOperationMap at: operation . operands second
			}
		].
		^ operands first , ' ' , (BinaryOperationMap at: operation) , ' ' , operands second
	].
	self error: 'Unsupported logical operation arity.'
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRegisterAssignments: out [
	| allClockAndResetPins |
	registerAssignments ifEmpty: [ ^ self ].
	
	allClockAndResetPins := OrderedCollection new.
	self flag: 'TODO: Use an ordered set.'.
	registerAssignments do: [ :registerAssignment |
		(allClockAndResetPins includes: registerAssignment clock) ifFalse: [ 
			allClockAndResetPins add: registerAssignment clock
		].
		registerAssignment reset ifNotNil: [ 
			(allClockAndResetPins includes: registerAssignment reset) ifFalse: [ 
				allClockAndResetPins add: registerAssignment reset
			]
		].
	].

	out tab; nextPutAll: 'process ('.
	allClockAndResetPins	doWithIndex: [ :pin :index |
		index > 1 ifTrue: [ out nextPutAll: ', ' ].
		out nextPutAll: pin
	].
	out
		nextPutAll: ')'; lf;
		tab; nextPutAll: 'begin'; lf.

	registerAssignments do: [ :registerAssignment |
		registerAssignment reset ifNotNil: [ 
			registerAssignment resetActiveLow ifTrue: [
				out tab; tab;
					nextPutAll: 'if '; nextPutAll: registerAssignment reset;
					nextPutAll: ' = ''0'' then'; lf.
			] ifFalse: [
				out tab; tab;
					nextPutAll: 'if '; nextPutAll: registerAssignment reset;
					nextPutAll: ' = ''1'' then' ; lf.
			].
		
			out
				tab; tab; tab; nextPutAll: registerAssignment name;
				nextPutAll: ' <= ';
				nextPutAll: (registerAssignment resetValue ifNil: [
						self zeroConstantOfSize: registerAssignment bits
				]);
				nextPutAll: ';';
				lf.
		].

		out tab; tab; nextPutAll: (registerAssignment reset ifNil: ['if'] ifNotNil: ['elsif']);
			nextPutAll: ' rising_edge('; nextPutAll: registerAssignment clock;
			nextPutAll: ') then'; lf.
	
		out tab; tab; tab;
			nextPutAll: registerAssignment name;
			nextPutAll: ' <= ';
			nextPutAll: registerAssignment value;
			nextPutAll: ';';
			lf.
		out tab; tab; nextPutAll: 'end if;'; lf
	].

	out tab nextPutAll: 'end process;'; lf

]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRegisters: out [
	registers ifNotNil: [ 
		out tab; nextPutAll: '-- Registers'; lf
	].

	self emitDeclarationsOf: registers into: out.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitVHDLTypeFor: value into: out [
	value bits > 1 ifTrue: [
		out nextPutAll: 'std_logic_vector('; nextPutAll: (value bits - 1) asString; nextPutAll: ' downto 0)'
	] ifFalse: [ 
		out nextPutAll: 'std_logic'
	].

]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitWireAssignments: out [
	wireAssignments ifEmpty: [
		out tab; nextPutAll: '-- Wire assignments.'; lf.
	].
	wireAssignments do: [ :wireAssignment |
		out tab;
		nextPutAll: wireAssignment first;
		nextPutAll: ' <= ';
		nextPutAll: wireAssignment second;
		nextPut: $;;
		lf
	].

]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitWires: out [
	wires ifNotNil: [ 
		out tab; nextPutAll: '-- Wires'; lf
	].
	self emitDeclarationsOf: wires into: out.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> localPrefix [
	^ 'ls_'
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> zeroConstantOfSize: bits [
	^ bits > 1 ifTrue: [
		^ ByteString streamContents: [ :out |
			out nextPutAll: 'std_logic_vector''(b"'.
			1 to: bits do: [ :i | out nextPut: $0 ].
			out nextPutAll: '")'.
		]
	] ifFalse: [
		^ '''0'''
	].

]
