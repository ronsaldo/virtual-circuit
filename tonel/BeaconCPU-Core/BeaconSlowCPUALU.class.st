Class {
	#name : #BeaconSlowCPUALU,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'aluInstructions',
		'aluInstructionsBits',
		'operation',
		'left',
		'result',
		'right'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #building }
BeaconSlowCPUALU >> build [
	self createIOPorts.
	self createOperations
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationADD [
	^ left + right
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationARSHIFT [
	^ left bitArithmeticRightShift: (right bit: 1 count: 6)
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationDIV [
	^ left "/ right"
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationLSHIFT [
	^ left << (right bit: 1 count: 6)
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationMUL [
	^ left * right
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationNOP [
	^ 0
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationREM [
	^ 0
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationRSHIFT [
	^ left bitLogicalRightShift: (right bit: 1 count: 6)
]

{ #category : #operations }
BeaconSlowCPUALU >> computeOperationSUB [
	^ left - right
]

{ #category : #building }
BeaconSlowCPUALU >> createIOPorts [
	aluInstructions := BeaconOpcodeGroups at: #alu.
	aluInstructionsBits := (aluInstructions size - 1) highBit.
	
	operation := builder input: #operation bits: aluInstructionsBits.
	left := builder input: #left bits: 64.
	right := builder input: #right bits: 64.
	result := builder output: #result bits: 64 value: 0.
]

{ #category : #building }
BeaconSlowCPUALU >> createOperations [
	| operationBase |
	operationBase := aluInstructions first opcode.
	aluInstructions do: [ :instruction |
		(operation equals: (instruction opcode  - operationBase)) whenTrueDo: {
			result <== (self perform: (#computeOperation , instruction name) asSymbol)
		}
	]
]
