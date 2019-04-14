"
I hold the ISA for the Beacon virtualizing CPU. The Beacon CPU is an experimenta hibrid RISC/CISC architecture, which provides some facilities for easing the implementation of virtual machines, or emulating other CPU.

We are taking some inspiration in the Palo Alto used defined microcodes, the CPU where the original Smalltalk was run.

The core ISA contains a register file with several banks of 32 registers, where the 0 registers is hardcoded to the zero constant. The banks allowed for the virtual registers are the following:

Bank 2r00: User space bank.
Bank 2r01: User space interpreter bank.
Bank 2r10: Kernel space bank.
Bank 2r11: Kernel space interpreter bank.

This CPU has at least two vastly different modes of operation: native vs interpreter. In addition to these two modes of operation,  there are at least two different privilege levels: kernel and user space.
Each on of these operation modes has an associated register bank, and an associated PC counter registers, which is associated with the register R31.

"
Class {
	#name : #BeaconCPUISA,
	#superclass : #SharedPool,
	#classVars : [
		'A',
		'ADD',
		'AE',
		'ARSHIFT',
		'B',
		'BE',
		'BeaconCPUBootAddress',
		'BeaconConditionCodes',
		'BeaconInstructionTemplates',
		'BeaconIntegerRegisters',
		'BeaconOpcodeGroups',
		'BeaconOpcodes',
		'C',
		'DIV',
		'EQ',
		'FP',
		'GE',
		'GT',
		'HALT',
		'LDB',
		'LDQ',
		'LDS',
		'LDSPR',
		'LDW',
		'LDZB',
		'LDZQ',
		'LDZS',
		'LDZW',
		'LE',
		'LR',
		'LSHIFT',
		'LT',
		'MUL',
		'NA',
		'NAE',
		'NB',
		'NBE',
		'NC',
		'NCC',
		'NE',
		'NEQ',
		'NG',
		'NGE',
		'NL',
		'NLE',
		'NO',
		'NOP',
		'NP',
		'NS',
		'NZ',
		'NoConditionCode',
		'O',
		'P',
		'PC',
		'R0',
		'R1',
		'R10',
		'R11',
		'R12',
		'R13',
		'R14',
		'R15',
		'R16',
		'R17',
		'R18',
		'R19',
		'R2',
		'R20',
		'R21',
		'R22',
		'R23',
		'R24',
		'R25',
		'R26',
		'R27',
		'R28',
		'R3',
		'R4',
		'R5',
		'R6',
		'R7',
		'R8',
		'R9',
		'REM',
		'RSHIFT',
		'S',
		'SP',
		'STB',
		'STQ',
		'STS',
		'STSPR',
		'STW',
		'SUB',
		'SpecialRegister_Ticks',
		'Z'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-ISA'
}

{ #category : #registers }
BeaconCPUISA class >> FP [
		^ FP
]

{ #category : #registers }
BeaconCPUISA class >> LR [
		^ LR
]

{ #category : #registers }
BeaconCPUISA class >> PC [
		^ PC
]

{ #category : #registers }
BeaconCPUISA class >> R0 [
		^ R0
]

{ #category : #registers }
BeaconCPUISA class >> R1 [
		^ R1
]

{ #category : #registers }
BeaconCPUISA class >> R10 [
		^ R10
]

{ #category : #registers }
BeaconCPUISA class >> R11 [
		^ R11
]

{ #category : #registers }
BeaconCPUISA class >> R12 [
		^ R12
]

{ #category : #registers }
BeaconCPUISA class >> R13 [
		^ R13
]

{ #category : #registers }
BeaconCPUISA class >> R14 [
		^ R14
]

{ #category : #registers }
BeaconCPUISA class >> R15 [
		^ R15
]

{ #category : #registers }
BeaconCPUISA class >> R16 [
		^ R16
]

{ #category : #registers }
BeaconCPUISA class >> R17 [
		^ R17
]

{ #category : #registers }
BeaconCPUISA class >> R18 [
		^ R18
]

{ #category : #registers }
BeaconCPUISA class >> R19 [
		^ R19
]

{ #category : #registers }
BeaconCPUISA class >> R2 [
		^ R2
]

{ #category : #registers }
BeaconCPUISA class >> R20 [
		^ R20
]

{ #category : #registers }
BeaconCPUISA class >> R21 [
		^ R21
]

{ #category : #registers }
BeaconCPUISA class >> R22 [
		^ R22
]

{ #category : #registers }
BeaconCPUISA class >> R23 [
		^ R23
]

{ #category : #registers }
BeaconCPUISA class >> R24 [
		^ R24
]

{ #category : #registers }
BeaconCPUISA class >> R25 [
		^ R25
]

{ #category : #registers }
BeaconCPUISA class >> R26 [
		^ R26
]

{ #category : #registers }
BeaconCPUISA class >> R27 [
		^ R27
]

{ #category : #registers }
BeaconCPUISA class >> R3 [
		^ R3
]

{ #category : #registers }
BeaconCPUISA class >> R4 [
		^ R4
]

{ #category : #registers }
BeaconCPUISA class >> R5 [
		^ R5
]

{ #category : #registers }
BeaconCPUISA class >> R6 [
		^ R6
]

{ #category : #registers }
BeaconCPUISA class >> R7 [
		^ R7
]

{ #category : #registers }
BeaconCPUISA class >> R8 [
		^ R8
]

{ #category : #registers }
BeaconCPUISA class >> R9 [
		^ R9
]

{ #category : #registers }
BeaconCPUISA class >> SP [
		^ SP
]

{ #category : #registers }
BeaconCPUISA class >> SpecialRegister_Ticks [
		^ SpecialRegister_Ticks
]

{ #category : #opcodes }
BeaconCPUISA class >> add [
	^ ADD
]

{ #category : #opcodes }
BeaconCPUISA class >> arshift [
	^ ARSHIFT
]

{ #category : #initialization }
BeaconCPUISA class >> declareCondition: codeName code: value [
	(self hasClassVarNamed: codeName) ifFalse: [ 
		self addClassVarNamed: codeName.
	].

	self classVarNamed: codeName put: value.
	^ self classVarNamed: codeName
]

{ #category : #initialization }
BeaconCPUISA class >> declareIntegerRegister: registerIndex name: registerName [
	(self hasClassVarNamed: registerName) ifFalse: [ 
		self addClassVarNamed: registerName.
	].

	self classVarNamed: registerName put: (BeaconIntRegister new
		name: registerName;
		value: registerIndex;
		yourself).
	self declareRegisterAccessor: registerName.
	^ self classVarNamed: registerName
]

{ #category : #initialization }
BeaconCPUISA class >> declareOpcode: opcodeName type: opcodeType value: opcodeValue [
	(self hasClassVarNamed: opcodeName) ifFalse: [ 
		self addClassVarNamed: opcodeName.
	].

	self classVarNamed: opcodeName put: (
	(BeaconInstructionTemplates at: opcodeType) new
		opcode: opcodeValue;
		name: opcodeName;
		yourself).
	self class compile:
('{1}
	^ {2}' format: {opcodeName asLowercase . opcodeName }) classified: 'opcodes'.
	
	^ self classVarNamed: opcodeName
]

{ #category : #initialization }
BeaconCPUISA class >> declareRegisterAccessor: registerName [
	self class compile:
('{1}
		^ {1}' format: {registerName }) classified: 'registers'
]

{ #category : #initialization }
BeaconCPUISA class >> declareSpecialRegister: specialRegisterName value: registerIndex [
	| registerName |
	registerName := (#SpecialRegister_ , specialRegisterName) asSymbol.
	(self hasClassVarNamed: registerName) ifFalse: [ 
		self addClassVarNamed: registerName.
	].

	self classVarNamed: registerName put: registerIndex.
	self declareRegisterAccessor: registerName.
	^ self classVarNamed: registerName
]

{ #category : #opcodes }
BeaconCPUISA class >> div [
	^ DIV
]

{ #category : #opcodes }
BeaconCPUISA class >> halt [
	^ HALT
]

{ #category : #initialization }
BeaconCPUISA class >> initialize [
	self initializeRegisters.
	self initializeSpecialRegisters.
	self initializeConditionCodes.
	self initializeInstructionTemplates.
	self initializeOpcodes.
	self initializeConstants.
]

{ #category : #initialization }
BeaconCPUISA class >> initializeConditionCodes [
	BeaconConditionCodes := #(
		"=="
		(Z EQ)
		(NZ NE NEQ)
		
		"unsigned"
		(B NAE C)
		(BE NA)
		(A NBE)
		(AE NB NC)
		
		"signed"
		(LT NGE)
		(LE NG)
		(GT NLE)
		(GE NL)
		
		"Parity"
		(P)
		(NP)
		
		(O)
		(NO)
		
		(S)
		(NS)
	) collectWithIndex: [ :conditionCodeNames :value |
		conditionCodeNames collect: [ :codeName |
			self declareCondition: codeName code: value - 1
		]
	]
]

{ #category : #initialization }
BeaconCPUISA class >> initializeConstants [
	"BeaconCPUBootAddress := 16rFFFFFFFFFFFFFFF8."
	BeaconCPUBootAddress := 0.
]

{ #category : #initialization }
BeaconCPUISA class >> initializeInstructionTemplates [
	BeaconInstructionTemplates := IdentityDictionary new.
	BeaconCPUInstructionTemplate allSubclassesDo: [ :template |
		BeaconInstructionTemplates at: template instructionTemplateName put: template
	]
]

{ #category : #initialization }
BeaconCPUISA class >> initializeOpcodes [
	BeaconOpcodes :=#(
		"ALU opcode"
		(NOP alu)
		(ADD alu)
		(SUB alu)
		(MUL alu)
		(DIV alu)
		(REM alu)
		(ARSHIFT alu)
		(RSHIFT alu)
		(LSHIFT alu)
		
		"Memory Load/Store"
		(LDB memoryLoad)
		(LDZB memoryLoad)
		(LDS memoryLoad)
		(LDZS memoryLoad)
		(LDW memoryLoad)
		(LDZW memoryLoad)
		(LDQ memoryLoad)
		(LDZQ memoryLoad)
				
		(STB memoryStore)
		(STS memoryStore)
		(STW memoryStore)
		(STQ memoryStore)
		
		(LDSPR specialRegister)
		(STSPR specialRegister)
		
		"Low control"
		(HALT control)
	) collectWithIndex: [ :opcodeDefinition :index |
		self declareOpcode: opcodeDefinition first type: opcodeDefinition second value: index - 1
	].

	BeaconOpcodeGroups := BeaconOpcodes groupedBy: [ :op | op instructionTemplateName ].
]

{ #category : #initialization }
BeaconCPUISA class >> initializeRegisters [
	BeaconIntegerRegisters := (0 to: 27) collect: [ :i |
		self declareIntegerRegister: i name: ('R' , i asString) asSymbol
	].

	BeaconIntegerRegisters := BeaconIntegerRegisters , { 
		self declareIntegerRegister: 28 name: #LR.
		self declareIntegerRegister: 29 name: #FP.
		self declareIntegerRegister: 30 name: #SP.
		self declareIntegerRegister: 31 name: #PC.
	}

]

{ #category : #initialization }
BeaconCPUISA class >> initializeSpecialRegisters [
	#(
		Ticks
	) doWithIndex: [ :specialRegisterName :index |
		self declareSpecialRegister: specialRegisterName value: index - 1
	]
]

{ #category : #opcodes }
BeaconCPUISA class >> ldb [
	^ LDB
]

{ #category : #opcodes }
BeaconCPUISA class >> ldq [
	^ LDQ
]

{ #category : #opcodes }
BeaconCPUISA class >> lds [
	^ LDS
]

{ #category : #opcodes }
BeaconCPUISA class >> ldspr [
	^ LDSPR
]

{ #category : #opcodes }
BeaconCPUISA class >> ldw [
	^ LDW
]

{ #category : #opcodes }
BeaconCPUISA class >> ldzb [
	^ LDZB
]

{ #category : #opcodes }
BeaconCPUISA class >> ldzq [
	^ LDZQ
]

{ #category : #opcodes }
BeaconCPUISA class >> ldzs [
	^ LDZS
]

{ #category : #opcodes }
BeaconCPUISA class >> ldzw [
	^ LDZW
]

{ #category : #opcodes }
BeaconCPUISA class >> lshift [
	^ LSHIFT
]

{ #category : #opcodes }
BeaconCPUISA class >> mul [
	^ MUL
]

{ #category : #opcodes }
BeaconCPUISA class >> nop [
	^ NOP
]

{ #category : #opcodes }
BeaconCPUISA class >> rem [
	^ REM
]

{ #category : #opcodes }
BeaconCPUISA class >> rshift [
	^ RSHIFT
]

{ #category : #opcodes }
BeaconCPUISA class >> stb [
	^ STB
]

{ #category : #opcodes }
BeaconCPUISA class >> stq [
	^ STQ
]

{ #category : #opcodes }
BeaconCPUISA class >> sts [
	^ STS
]

{ #category : #opcodes }
BeaconCPUISA class >> stspr [
	^ STSPR
]

{ #category : #opcodes }
BeaconCPUISA class >> stw [
	^ STW
]

{ #category : #opcodes }
BeaconCPUISA class >> sub [
	^ SUB
]
