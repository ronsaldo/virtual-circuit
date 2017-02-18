Class {
	#name : #VCAXIMemoryBusMaster,
	#superclass : #VCMemoryBusMaster,
	#instVars : [
		'readAddress',
		'readAddressValid',
		'readAddressReady',
		'writeData',
		'writeValid',
		'writeReady',
		'writeStrobe',
		'readData',
		'readValid',
		'readReady',
		'readResponse',
		'readAction',
		'readActionCount',
		'writeAddress',
		'writeAddressValid',
		'writeAddressReady',
		'writeAction',
		'writeActionCount'
	],
	#category : #'VirtualCircuit-Core-Bus'
}

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster class >> interfaceName [
	^ #AXI
]

{ #category : #'bus description' }
VCAXIMemoryBusMaster class >> portDesc [
	"
		self rebuildPortConnections
	"
	^ #(

		"Read Address"
		(readAddress output S_AXI_ARADDR 32 (register))
		(readAddressValid output S_AXI_ARVALID 1 (register))
		(readAddressReady input S_AXI_ARREADY 1)
	
		"Read Data"	
		(readData input S_AXI_RDADDR 32)
		(readValid input S_AXI_RVALID 1)
		(readReady output S_AXI_RREADY 1 (register))
		(readResponse input S_AXI_RRESP 1)
		
		"Write Address"
		(writeAddress output S_AXI_AWADDR 32 (register))
		(writeAddressValid output S_AXI_AWVALID 1 (register))
		(writeAddressReady input S_AXI_AWREADY 1)
	
		"Write data"
		(writeData output S_AXI_WDATA 32 (register))
		(writeValid output S_AXI_WVALID 1 (register))
		(writeReady input S_AXI_WREADY 1)
		(writeStrobe output S_AXI_WSTRB 4 (register))
	)
]

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster >> createController [
	"Read only one address at time."
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
VCAXIMemoryBusMaster >> createPorts [
	readAddress := self outputRegister: (self makePortName: #S_AXI_ARADDR) bits: 32.
	readAddressValid := self outputRegister: (self makePortName: #S_AXI_ARVALID) bits: 1.
	readAddressReady := self input: (self makePortName: #S_AXI_ARREADY) bits: 1.
	readData := self input: (self makePortName: #S_AXI_RDADDR) bits: 32.
	readValid := self input: (self makePortName: #S_AXI_RVALID) bits: 1.
	readReady := self outputRegister: (self makePortName: #S_AXI_RREADY) bits: 1.
	readResponse := self input: (self makePortName: #S_AXI_RRESP) bits: 1.
	writeAddress := self outputRegister: (self makePortName: #S_AXI_AWADDR) bits: 32.
	writeAddressValid := self outputRegister: (self makePortName: #S_AXI_AWVALID) bits: 1.
	writeAddressReady := self input: (self makePortName: #S_AXI_AWREADY) bits: 1.
	writeData := self outputRegister: (self makePortName: #S_AXI_WDATA) bits: 32.
	writeValid := self outputRegister: (self makePortName: #S_AXI_WVALID) bits: 1.
	writeReady := self input: (self makePortName: #S_AXI_WREADY) bits: 1.
	writeStrobe := self outputRegister: (self makePortName: #S_AXI_WSTRB) bits: 4.

]

{ #category : #enumerating }
VCAXIMemoryBusMaster >> createReadAction: anAction [
	readActionCount := readActionCount + 1.
	readActionCount highBit > readAction bits ifTrue: [ readAction bits: readAction bits + 1 ].
	(readValid & (readAction equals: readActionCount)) whenTrueDo: anAction.
	^ readActionCount
]

{ #category : #enumerating }
VCAXIMemoryBusMaster >> createWriteAction: anAction [
	writeActionCount := writeActionCount + 1.
	writeActionCount highBit > writeAction bits ifTrue: [ writeAction bits: writeAction bits + 1 ].
	(writeReady & writeAction equals: writeActionCount) whenTrueDo: anAction.
	^ writeActionCount
]

{ #category : #enumerating }
VCAXIMemoryBusMaster >> read: anAddress into: aRegister whenFinishedDo: readFinishAction [
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
VCAXIMemoryBusMaster >> readAddress [
	^ readAddress
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readAddressReady [
	^ readAddressReady
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readAddressValid [
	^ readAddressValid
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readData [
	^ readData
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readReady [
	^ readReady
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readResponse [
	^ readResponse
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> readValid [
	^ readValid
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeAddress [
	^ writeAddress
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeAddressReady [
	^ writeAddressReady
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeAddressValid [
	^ writeAddressValid
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeData [
	^ writeData
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeReady [
	^ writeReady
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeStrobe [
	^ writeStrobe
]

{ #category : #'port accessors' }
VCAXIMemoryBusMaster >> writeValid [
	^ writeValid
]
