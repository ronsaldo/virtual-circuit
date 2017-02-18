Class {
	#name : #BeaconSlowCPU,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'instructionCacheSize',
		'dataCacheSize',
		'readRegisterAddress1',
		'readRegisterAddress2',
		'pcBank',
		'writeRegisterAddress',
		'writeRegisterValue',
		'writeRegisterEnabled',
		'readRegisterValue1',
		'readRegisterValue2',
		'instructionCache',
		'dataCache',
		'memoryInterfaceType',
		'memoryBus',
		'stateMachine',
		'instructionAddress',
		'pc',
		'instructionData',
		'instructionCacheBus',
		'dataCacheBus',
		'cacheMemoryBusMux',
		'instructionOpcode'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #building }
BeaconSlowCPU >> build [
	builder autoClock; autoReset.
	
	self
		createIOPorts;
		createRegisterFile;
		createCaches;
		createStateMachine
]

{ #category : #building }
BeaconSlowCPU >> createCaches [
	instructionCache := builder instance: (BeaconSlowCPUCache new
		name: #BeaconSlowCPUInstructionCache;
		size: instructionCacheSize;
		component).
	instructionCacheBus := instructionCache memoryBusMasterInterface: #BSM prefix: #CORE_.
	instructionCacheBus createControllerWithBuilder: builder.
		
	dataCache := builder instance: (BeaconSlowCPUCache new
		name: #BeaconSlowCPUDataCache;
		size: dataCacheSize;
		component).
	dataCacheBus := dataCache memoryBusMasterInterface: #BSM prefix: #CORE_.
	dataCacheBus createControllerWithBuilder: builder.

	cacheMemoryBusMux := builder instance: (BeaconSlowCPUCacheMemoryMux new component).
	(cacheMemoryBusMux memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: memoryBus.
	(instructionCache memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: (cacheMemoryBusMux memoryBusSlaveInterface: #BSM prefix: #INSTRUCTION_).
	(dataCache memoryBusMasterInterface: #BSM prefix: #MAIN_) connectWith: (cacheMemoryBusMux memoryBusSlaveInterface: #BSM prefix: #DATA_).

]

{ #category : #'state machine' }
BeaconSlowCPU >> createDecodeState [
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
BeaconSlowCPU >> createExecuteAlu [
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
			readRegisterAddress1 <== instructionParts fourth.
			readRegisterAddress2 <== (immediateOrRegister bit: 1 count: 5).
			
			writeRegisterEnabled <== true.
			writeRegisterAddress <== rdest.
			writeRegisterValue <== (alu result).

			stateMachine <== #fetch
	}.

]

{ #category : #'state machine' }
BeaconSlowCPU >> createExecuteControl [
	stateMachine
		state: #execute_control do: {
			"TODO: Execute the Control instruction"
			stateMachine <== #fetch
	}.
	
]

{ #category : #'state machine' }
BeaconSlowCPU >> createExecuteState [
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
BeaconSlowCPU >> createFetchState [
	| instructionFullData |
	instructionAddress := builder register: 64.
	instructionFullData := builder register: 64.
	instructionData := (instructionAddress bit: 3)
		ifTrue: (instructionFullData bit: 33 count: 32)
		ifFalse: (instructionFullData bit: 1 count: 32).
	
	stateMachine 
		state: #fetchWait do: { 
		};
		state: #fetch do: {
			instructionAddress <== pc.
			stateMachine <== #fetchWait.
			instructionCacheBus read: (pc alignedDownTo: 4) into: instructionFullData whenFinishedDo: {
				stateMachine <== #decode.
			}.
		}.
		
]

{ #category : #building }
BeaconSlowCPU >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: memoryInterfaceType.
	memoryBus createPortsWithoutController.
]

{ #category : #'state machine' }
BeaconSlowCPU >> createInitialState [
	stateMachine
		state: #initial do: {
			pcBank <== 0.
			stateMachine <== #fetch
		}
]

{ #category : #building }
BeaconSlowCPU >> createRegisterFile [
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

{ #category : #'state machine' }
BeaconSlowCPU >> createStateMachine [
	stateMachine := builder stateMachine.
	stateMachine
			states: #(initial fetch fetchWait decode execute_illegal) , (BeaconOpcodeGroups keys collect: [:key | (#execute_ , key) asSymbol]);
			initial: #initial.
			
	self
		createInitialState;
		createFetchState;
		createDecodeState;
		createExecuteState
]

{ #category : #building }
BeaconSlowCPU >> initialize [
	super initialize.
	instructionCacheSize := 4096.
	dataCacheSize := 4096.
	memoryInterfaceType := #BSM.
]

{ #category : #initialization }
BeaconSlowCPU >> name [
	^ self class name
]

{ #category : #building }
BeaconSlowCPU >> readRegister: registerAddress registerFile: registerFile [
	^ ((registerAddress bit: 1 count: 5) equals: 0) ifTrue: 0 ifFalse: (registerFile read: registerAddress)
]
