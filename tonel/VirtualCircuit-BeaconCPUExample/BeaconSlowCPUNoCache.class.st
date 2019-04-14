"
The beacon slow CPU is an implementation of the CPU without using a pipeline.
"
Class {
	#name : #BeaconSlowCPUNoCache,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'readRegisterAddress1',
		'readRegisterAddress2',
		'pcBank',
		'writeRegisterAddress',
		'writeRegisterValue',
		'writeRegisterEnabled',
		'readRegisterValue1',
		'readRegisterValue2',
		'memoryInterfaceType',
		'memoryBus',
		'stateMachine',
		'instructionAddress',
		'pc',
		'instructionData',
		'instructionOpcode',
		'specialRegisters'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-SlowCPU'
}

{ #category : #building }
BeaconSlowCPUNoCache >> addSpecial: index register: register readPermission: readPermission writePermission: writePermission [
	^ specialRegisters add: (BeaconCPUSpecialRegister new
		index: index;
		register: register;
		readPermission: readPermission;
		writePermission: writePermission;
		yourself)
]

{ #category : #building }
BeaconSlowCPUNoCache >> addSpecialReadOnly: index register: register [
	^ self addSpecial: index register: register
		readPermission: (builder const: true bits: 1)
		writePermission: [:value | builder const: false bits: 1]
]

{ #category : #building }
BeaconSlowCPUNoCache >> build [
	builder autoClock; autoReset.
	
	self
		createIOPorts;
		createRegisterFile;
		createCaches;
		createSpecialRegisters;
		createStateMachine
]

{ #category : #building }
BeaconSlowCPUNoCache >> createCaches [
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createDecodeState [
	| instructionType executeState |
	instructionOpcode := instructionData bit: 1 count: 8.
	instructionType := builder immediateVariable: stateMachine stateBits.
	"TODO: Build a trie or something to reduce the number of decisions for decoding the instruction type"
	BeaconOpcodes do: [ :opcode |
		executeState := stateMachine state: (#execute_ , opcode instructionTemplateName) asSymbol.
		(instructionOpcode equals: opcode opcode) whenTrueDo: {
			instructionType <== executeState value
		}
	].

	stateMachine
		state: #decode do: {
			"Increase the PC"
			writeRegisterEnabled <== true.
			writeRegisterAddress <== (pcBank , PC).
			writeRegisterValue <== (instructionAddress + 4).
			
			"Execute the instruction"
			stateMachine register <== instructionType
		}
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteAlu [
	| aluInstructions instructionParts rdest hasCC hasImmediate immediateOrRegister immediateSignExtension alu leftOperand fullImmediate rightOperand |
	aluInstructions := BeaconOpcodeGroups at: #alu.
	instructionParts := instructionData splitBitsReverse:
		{ "Opcode" 8 . "RD" 5 . "CC" 1 . "R1" 5. "HasImmediate" 1 . "Immediate" 12}.
	rdest := instructionParts second.
	hasCC := instructionParts third.
	hasImmediate := instructionParts fifth.
	immediateOrRegister := instructionParts sixth.
	
	leftOperand := readRegisterValue1.
	
	immediateSignExtension := instructionData lastBit repeat: 64 - immediateOrRegister bits.
	fullImmediate := immediateSignExtension , immediateOrRegister.
	rightOperand := (hasImmediate
		ifTrue: fullImmediate
		ifFalse: readRegisterValue2).
	
	alu := builder instance: BeaconSlowCPUALU new component.
	alu operation: ((instructionOpcode - aluInstructions first opcode) bit: 1 count: alu operation bits).
	alu left: leftOperand.
	alu right: rightOperand.
	
	stateMachine
		state: #execute_alu do: {
			readRegisterAddress1 <== (pcBank , instructionParts fourth).
			readRegisterAddress2 <== (pcBank , (immediateOrRegister bit: 1 count: 5)).
			
			writeRegisterEnabled <== true.
			writeRegisterAddress <== (pcBank , rdest).
			writeRegisterValue <== (alu result).

			stateMachine <== #fetch
	}.

]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteControl [
	stateMachine
		state: #execute_control do: {
			"TODO: Execute the Control instruction"
			stateMachine <== #fetch
	}.
	
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteMemoryLoad [
	| loadInstructions instructionParts destRegister baseRegister displacement displacementSignExtension fullDisplacement fullAddress readResultRegister |
	loadInstructions := BeaconOpcodeGroups at: #memoryLoad.
	instructionParts := instructionData splitBitsReverse:
		{ "Opcode" 8 . "RD" 5 . "CC" 1 . "R1" 5. "Reserved" 1 . "displacement" 12}.
	destRegister := instructionParts second.
	baseRegister := instructionParts fourth.
	displacement := instructionParts last.
	
	displacementSignExtension := instructionData lastBit repeat: 64 - displacement bits.
	fullDisplacement := displacementSignExtension , displacement.
	fullAddress := readRegisterValue1 + fullDisplacement.
	readResultRegister := builder register: 64.
	
	stateMachine
		state: #execute_memoryLoad do: {
			stateMachine <== #dataWait.
			readRegisterAddress1 <== (pcBank , baseRegister).
			(self dataBus) read: fullAddress into: readResultRegister whenFinishedDo: {
				writeRegisterAddress <== (pcBank , destRegister).
				writeRegisterValue <== readResultRegister.
				writeRegisterEnabled <== true.
				stateMachine <== #fetch.
		}.
	}.
	
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteMemoryStore [
	| loadInstructions instructionParts baseRegister displacement displacementSignExtension fullDisplacement valueRegister fullAddress |
	loadInstructions := BeaconOpcodeGroups at: #memoryStore.
	instructionParts := instructionData splitBitsReverse:
		{ "Opcode" 8 . "RD" 5 . "CC" 1 . "R1" 5. "Reserved" 1 . "displacement" 12}.
	valueRegister := instructionParts second.
	baseRegister := instructionParts fourth.
	displacement := instructionParts last.
	
	displacementSignExtension := instructionData lastBit repeat: 64 - displacement bits.
	fullDisplacement := displacementSignExtension , displacement.
	fullAddress := readRegisterValue1 + fullDisplacement.
	
	stateMachine
		state: #execute_memoryStore do: {
			stateMachine <== #dataWait.
			readRegisterAddress1 <== (pcBank , baseRegister).
			readRegisterAddress2 <== (pcBank , valueRegister).
			(self dataBus) write: fullAddress value: readRegisterValue2 whenFinishedDo: {
				stateMachine <== #fetch.
		}
	}.
	
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteSpecialRegister [
	| instructionParts opcode normalRegister specialRegister isLoad specialRegisterAccessCondition registerAccessCondition |
	instructionParts := instructionData splitBitsReverse:
		{ "Opcode" 8 . "normalRegister" 5 . "specialRegister" 19 . }.
	opcode := instructionParts first.
	normalRegister := instructionParts second.
	specialRegister := instructionParts third.
	
	isLoad := opcode equals: LDSPR opcode.
	
	stateMachine
		state: #execute_specialRegister do: {
			isLoad whenTrue: { 
				writeRegisterEnabled <== true.
				writeRegisterAddress <== (pcBank , normalRegister).
			} whenFalse: {
				readRegisterAddress1 <== (pcBank , normalRegister).
			}.
			
			stateMachine <== #fetch
	}.
	
	specialRegisterAccessCondition := (stateMachine state: #execute_specialRegister) condition.
	
	specialRegisters do: [ :special |
		registerAccessCondition := (specialRegister equals: special index) & specialRegisterAccessCondition.
		registerAccessCondition whenTrueDo: { 
			isLoad whenTrue: {
				special readPermission whenTrue: {
					special readInto: writeRegisterValue.
				} whenFalse: {
					stateMachine <== #trap_segmentation
				}
			} whenFalse: { 
				(special writePermission value: readRegisterValue1) whenTrue: {
					special write: readRegisterValue1.
				} whenFalse: {
					stateMachine <== #trap_segmentation
				}
			}
		}
	]
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createExecuteState [
	| selector |
	stateMachine
		state: #execute_illegal do: {
			"TODO: Trap the CPU"
			stateMachine <== #fetch
		}.
		
	BeaconInstructionTemplates keys do: [:key |
		selector := (#createExecute , key first asUppercase asString , key allButFirst) asSymbol.
		self perform: selector.
	]
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createFetchState [
	instructionAddress := builder register: 64.
	instructionAddress name: #instructionAddress.
	
	instructionData := builder register: 32.
	instructionData name: #instructionData.
	
	stateMachine 
		state: #fetchWait do: { 
		};
		state: #fetch do: {
			"Copy the instructin address"
			instructionAddress <== pc.
			
			"Fetch the instruction"
			stateMachine <== #fetchWait.
			(self instructionMemory) read: ((pc alignedDownTo: 4) bit: 1 count: 32) into: instructionData whenFinishedDo: {
				stateMachine <== #decode.
			}.
		}.
		
]

{ #category : #building }
BeaconSlowCPUNoCache >> createIOPorts [
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createInitialState [
	stateMachine
		state: #initial do: {
			pcBank <== 0.
			writeRegisterAddress <== PC value.
			writeRegisterValue <== BeaconCPUBootAddress.
			writeRegisterEnabled <== true.

			stateMachine <== #fetch
		}
]

{ #category : #building }
BeaconSlowCPUNoCache >> createRegisterFile [
	| registerFile |
	readRegisterAddress1 := (builder immediateVariable: 7) value: 0.
	readRegisterAddress2 := (builder immediateVariable: 7) value: 0.
	pcBank := builder register: 2.

	writeRegisterAddress := (builder immediateVariable:7) value: 0.
	writeRegisterValue := (builder immediateVariable:64) value: 0.
	writeRegisterEnabled := builder immediateVariable value: 0.
		
	registerFile := builder distributedRam: 32*4 depth: 64.
	
	registerFile write: writeRegisterAddress value: writeRegisterValue when: writeRegisterEnabled.
	
	readRegisterValue1 := self readRegister: readRegisterAddress1 registerFile: registerFile.
	readRegisterValue2 := self readRegister: readRegisterAddress2 registerFile: registerFile.
	pc := registerFile read: pcBank , PC
]

{ #category : #building }
BeaconSlowCPUNoCache >> createSpecialRegisters [
	self createTimeRegister
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createStateMachine [
	stateMachine := builder stateMachine name: #cpuState.
	stateMachine
			states: #(initial fetch fetchWait decode dataWait trap_halt trap_segmentation execute_illegal) , (BeaconOpcodeGroups keys collect: [:key | (#execute_ , key) asSymbol]);
			initial: #initial;
			state: #dataWait do: { 
			}. 
			
	self
		createInitialState;
		createFetchState;
		createDecodeState;
		createExecuteState;
		createTraps
]

{ #category : #building }
BeaconSlowCPUNoCache >> createTimeRegister [
	| ticks |
	ticks := builder register: 64.
	ticks name: #ticks.
	ticks value: ticks + 1.
	self addSpecialReadOnly: SpecialRegister_Ticks register: ticks
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> createTraps [
	self flag: 'Todo: Implement myself'
]

{ #category : #'state machine' }
BeaconSlowCPUNoCache >> dataBus [
	self subclassResponsibility
]

{ #category : #initialization }
BeaconSlowCPUNoCache >> initialize [
	super initialize.
	memoryInterfaceType := #BSM.
	specialRegisters := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
BeaconSlowCPUNoCache >> instructionMemory [
	self subclassResponsibility
]

{ #category : #initialization }
BeaconSlowCPUNoCache >> name [
	^ self class name
]

{ #category : #building }
BeaconSlowCPUNoCache >> readRegister: registerAddress registerFile: registerFile [
	^ ((registerAddress bit: 1 count: 5) equals: 0) ifTrue: 0 ifFalse: (registerFile read: registerAddress)
]
