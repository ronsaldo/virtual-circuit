Class {
	#name : #VCVHDLComponentSynthesizer,
	#superclass : #VCComponentSynthesizer,
	#classVars : [
		'BinaryOperationMap',
		'UnaryOperationMap'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #'class initialization' }
VCVHDLComponentSynthesizer class >> initialize [
	super initialize.
	UnaryOperationMap := Dictionary newFromPairs: #(
		not not
	).
	BinaryOperationMap := Dictionary newFromPairs: #(
		and and
		or or
		xor xor
		lshift shift_left
		lrshift shift_right
		arshift shift_right
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
VCVHDLComponentSynthesizer >> emitBit: bit repeat: count [
	^ '(0 to {1} => {2})' format: { (count - 1) asString. bit }
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitBitPack: values [
	^ ByteString streamContents: [ :out |
		out nextPut: $(.
		values doWithIndex: [ :value :index |
			index > 1 ifTrue: [ out nextPutAll: ' & '. ].
			out nextPutAll: value.
		].
		out nextPut: $).
	]
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitClockedProcesses: out [
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

	self
		emitRamProcesses: out;
		emitRegisterAssignments: out.

	out tab nextPutAll: 'end process;'; lf

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

		out
			nextPutAll: '-- Module '; nextPutAll: currentModule name; lf;
			nextPutAll: 'library IEEE;'; lf;
			nextPutAll: 'use IEEE.std_logic_1164.all;'; lf;
			nextPutAll: 'use IEEE.numeric_std.all;'; lf;
			lf.
			
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
		self emitRamDeclarations: out.

		out nextPutAll: 'begin'; lf.
		self
			emitSubmodules: out;
			emitRamWiring: out;
			emitWireAssignments: out;
			emitClockedProcesses: out.
		
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
	| format |
	operands size = 1 ifTrue: [ 
		^ (UnaryOperationMap at: operation) , ' ' , (self declareValue: operands first)
	].
	operands size = 2 ifTrue: [
		format := '{1} {2} {3}'.
		(#(+ - * /) includes: operation) ifTrue: [
			operation = #* ifTrue: [ 
				self flag: 'FIXME: Use the actual number of expected result bits here.'.
				format := 'std_logic_vector(resize(unsigned({1}) {2} unsigned({3}), ' , operands first bits asString , '))'
			] ifFalse: [ 
				format := 'std_logic_vector(unsigned({1}) {2} unsigned({3}))'
			]
		].
	
		(#(lshift lrshift) includes: operation) ifTrue: [ 
			format := 'std_logic_vector({2}(unsigned({1}), to_integer(unsigned({3}))))'
		].

		(#arshift = operation) ifTrue: [ 
			format := 'std_logic_vector({2}(signed({1}), to_integer(unsigned({3}))))'
		].

		(#(equals notEquals) includes: operation) ifTrue: [
			format := '''1'' when {1} {2} {3} else ''0'''
		].

		^ format format: { 
				self declareValue: operands first .
				BinaryOperationMap at: operation .
				self declareValue: operands second
			}.
	].
	self error: 'Unsupported logical operation arity.'
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRAMReadPort: port clockedImplementationFor: ramModule into: out [
	ramModule ram distributed ifFalse: [
		out tab; tab; tab; nextPutAll: port name; nextPutAll: '_address <= '; nextPutAll: port address; nextPut: $;; lf.
	].
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRAMReadPort: port unclockedImplementationFor: ram into: out [
	out tab; nextPutAll: ('{1} <= {2}(to_integer(unsigned({3})));' format: {port name . ram memoryName .
		ram ram distributed ifTrue: [ port address ] ifFalse: [port name , '_address']}); lf.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRAMWritePort: port clockedImplementationFor: ram into: out [
	out tab; tab; tab; nextPutAll: 'if '; nextPutAll: port enabled; nextPutAll: ' = ''1'' then'; lf.
	out tab; tab; tab; tab; nextPutAll: ('{1}(to_integer(unsigned({2}))) <= {3};' format: {ram memoryName . port address . port value}); lf.
	out tab; tab; tab; nextPutAll: 'end if;'; lf
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRAMWritePort: port unclockedImplementationFor: ramModule into: out [
	
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRamDeclarations: out [
	ramModules ifEmpty: [ ^ self ].
	
	out tab; nextPutAll: '-- RAM Modules'; lf.
	out tab; nextPutAll: 'attribute ram_style: string;'; lf.
	
	ramModules do: [ :ramModule |
		out tab; nextPutAll: ('type {1}_t is array (0 to {2}) of std_logic_vector({3} downto 0);'
			format: {
				ramModule memoryName.
				ramModule ram size.
				ramModule ram depth - 1.
			}); lf.
		out tab; nextPutAll: ('signal {1} : {1}_t := (others => (others => ''0''));' format: {ramModule memoryName}); lf.
		out tab; nextPutAll: ('attribute ram_style of {1} : signal is "{2}";' format: {
			ramModule memoryName.
			ramModule ram distributed ifTrue: [ 'distributed' ] ifFalse: [ 'block' ]
		}); lf 
	]
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRamProcesses: out [
	ramModules do: [ :ramModule |
		out tab; tab; nextPutAll: 'if rising_edge( '; nextPutAll: ramModule clock; nextPutAll: ') then'; lf.
		ramModule ports do: [ :port |
			port emitClockedImplementationWith: self for: ramModule into: out
		].
		out tab; tab; nextPutAll: 'end if;'; lf.
	].
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRamWiring: out [
	ramModules do: [ :ramModule |
		ramModule ports do: [ :port |
			port emitUnclockedImplementationWith: self for: ramModule into: out
		].
	].
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRegisterAssignments: out [
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

]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitRegisters: out [
	registers ifNotEmpty: [ 
		out tab; nextPutAll: '-- Registers'; lf
	].

	self emitDeclarationsOf: registers into: out.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitSelectCondition: condition trueValue: trueValue falseValue: falseValue [
	^ '{2} when {1} = ''1'' else {3}' format: { condition . trueValue . falseValue }
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitSubmodule: submodule into: out [
	| instanceName module |
	module := instantiatedElements at: submodule baseComponent.
	instanceName := instantiatedElements at: submodule.
	out nextPutAll: instanceName; nextPutAll: ' : entity work.'; nextPutAll: module name;
		nextPutAll: ' port map('; lf.
		
	submodule pins doWithIndex: [ :pin :index|
		index > 1 ifTrue: [ out nextPut: $,; lf ].
		out tab; tab; nextPutAll: pin name; nextPutAll: ' => '; nextPutAll: (instantiatedElements at: pin)
	].
	out nextPutAll: ');'; lf.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> emitSubmodules: out [
	submodules do: [ :submodule |
		self emitSubmodule: submodule into: out
	].
	submodules ifNotEmpty: [ out lf ].

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
	wires ifNotEmpty: [ 
		out tab; nextPutAll: '-- Wires'; lf
	].
	self emitDeclarationsOf: wires into: out.
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> localPrefix [
	^ 'ls_'
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> localRamModuleNamePrefix [
	^ 'localRamModule_'
]

{ #category : #'code generation' }
VCVHDLComponentSynthesizer >> zeroConstantOfSize: bits [
	^ bits > 1 ifTrue: [
		(bits % 4) = 0 ifTrue: [ 
			^ ByteString streamContents: [ :out |
				out nextPutAll: 'std_logic_vector''(x"'.
				1 to: bits//4 do: [ :i | out nextPut: $0 ].
				out nextPutAll: '")'.
			].
		].
		^ ByteString streamContents: [ :out |
			out nextPutAll: 'std_logic_vector''(b"'.
			1 to: bits do: [ :i | out nextPut: $0 ].
			out nextPutAll: '")'.
		]
	] ifFalse: [
		^ '''0'''
	].

]
