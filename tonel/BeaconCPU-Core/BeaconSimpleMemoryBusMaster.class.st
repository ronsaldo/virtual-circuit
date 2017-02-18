Class {
	#name : #BeaconSimpleMemoryBusMaster,
	#superclass : #VCMemoryBusMaster,
	#instVars : [
		'readAddress',
		'readAddressValid',
		'readAddressReady',
		'readData',
		'readValid',
		'readReady',
		'writeAddress',
		'writeAddressValid',
		'writeAddressReady',
		'writeData',
		'writeValid',
		'writeReady',
		'writeStrobe',
		'readAction',
		'readActionCount',
		'writeAction',
		'writeActionCount'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusMaster class >> interfaceName [
	^ #BSM
]

{ #category : #'bus description' }
BeaconSimpleMemoryBusMaster class >> portDesc [
	"
		self rebuildPortConnections
	"
	^ #(

		"Read Address"
		(readAddress output S_BSM_ARADDR 64 (register))
		(readAddressValid output S_BSM_ARVALID 1 (register))
		(readAddressReady input S_BSM_ARREADY 1)
	
		"Read Data"	
		(readData input S_BSM_RDATA 64)
		(readValid input S_BSM_RVALID 1)
		(readReady output S_BSM_RREADY 1 (register))
		
		"Write Address"
		(writeAddress output S_BSM_AWADDR 64 (register))
		(writeAddressValid output S_BSM_AWVALID 1 (register))
		(writeAddressReady input S_BSM_AWREADY 1)
	
		"Write data"
		(writeData output S_BSM_WDATA 64 (register))
		(writeValid output S_BSM_WVALID 1 (register))
		(writeReady input S_BSM_WREADY 1)
		(writeStrobe output S_BSM_WSTRB 8 (register))
	)
]

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusMaster >> createController [
	readAddressReady whenTrueDo: {
		readAddressValid <== false
	}.
	
	readAction := builder register.
	readActionCount := 0.
	
	readValid whenTrueDo: {
		readReady <== 0.
		readAction <== 0
	}.
		
	writeAddressReady whenTrueDo: {
		writeAddressValid <== false
	}.
	
	writeAction := builder register.
	writeActionCount := 0.
	
	writeReady whenTrueDo: {
		writeValid <== 0.
		writeAction <== 0
	}.
]

{ #category : #ports }
BeaconSimpleMemoryBusMaster >> createPorts [
	readAddress := self outputRegister: (self makePortName: #S_BSM_ARADDR) bits: 64.
	readAddressValid := self outputRegister: (self makePortName: #S_BSM_ARVALID) bits: 1.
	readAddressReady := self input: (self makePortName: #S_BSM_ARREADY) bits: 1.
	readData := self input: (self makePortName: #S_BSM_RDATA) bits: 64.
	readValid := self input: (self makePortName: #S_BSM_RVALID) bits: 1.
	readReady := self outputRegister: (self makePortName: #S_BSM_RREADY) bits: 1.
	writeAddress := self outputRegister: (self makePortName: #S_BSM_AWADDR) bits: 64.
	writeAddressValid := self outputRegister: (self makePortName: #S_BSM_AWVALID) bits: 1.
	writeAddressReady := self input: (self makePortName: #S_BSM_AWREADY) bits: 1.
	writeData := self outputRegister: (self makePortName: #S_BSM_WDATA) bits: 64.
	writeValid := self outputRegister: (self makePortName: #S_BSM_WVALID) bits: 1.
	writeReady := self input: (self makePortName: #S_BSM_WREADY) bits: 1.
	writeStrobe := self outputRegister: (self makePortName: #S_BSM_WSTRB) bits: 8.

]

{ #category : #enumerating }
BeaconSimpleMemoryBusMaster >> createReadAction: anAction [
	readActionCount := readActionCount + 1.
	readActionCount highBit > readAction bits ifTrue: [ readAction bits: readAction bits + 1 ].
	(readValid & (readAction equals: readActionCount)) whenTrueDo: anAction.
	^ readActionCount
]

{ #category : #enumerating }
BeaconSimpleMemoryBusMaster >> createWriteAction: anAction [
	writeActionCount := writeActionCount + 1.
	writeActionCount highBit > writeAction bits ifTrue: [ writeAction bits: writeAction bits + 1 ].
	(writeReady & (writeAction equals: writeActionCount)) whenTrueDo: anAction.
	^ writeActionCount
]

{ #category : #enumerating }
BeaconSimpleMemoryBusMaster >> read: anAddress into: aRegister whenFinishedDo: readFinishAction [
	| readActionIndex |
	readActionIndex := self createReadAction: {
		aRegister <== readData.
		readFinishAction
	}.
	
	^ { 
		readAddress <== anAddress.
		readAddressValid <== true.
		readReady <== true.
		readAction <== readActionIndex.
	}.

]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readAddress [
	^ readAddress
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readAddressReady [
	^ readAddressReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readAddressValid [
	^ readAddressValid
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readData [
	^ readData
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readReady [
	^ readReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> readValid [
	^ readValid
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeAddress [
	^ writeAddress
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeAddressReady [
	^ writeAddressReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeAddressValid [
	^ writeAddressValid
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeData [
	^ writeData
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeReady [
	^ writeReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeStrobe [
	^ writeStrobe
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusMaster >> writeValid [
	^ writeValid
]
