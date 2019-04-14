Class {
	#name : #VCAXI4LiteMemoryBusMaster,
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
		'writeActionCount',
		'writeDone',
		'writeStateMachine',
		'readDone',
		'readStateMachine',
		'addressBusSize',
		'dataBusSize',
		'writeStrobeSize'
	],
	#category : #'VirtualCircuit-Digital-Bus'
}

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusMaster class >> interfaceName [
	^ #AXI4Lite
]

{ #category : #'bus description' }
VCAXI4LiteMemoryBusMaster class >> portDesc [
	"
		self rebuildPortConnections
	"
	^ #(
		"TODO: Add AWPROT ARPROT ACLK ARESETn"

		"Read Address"
		(readAddress output S_AXI_ARADDR addressBusSize (register))
		(readAddressValid output S_AXI_ARVALID 1 (register))
		(readAddressReady input S_AXI_ARREADY 1)
	
		"Read Data"	
		(readData input S_AXI_RDATA dataBusSize)
		(readValid input S_AXI_RVALID 1)
		(readReady output S_AXI_RREADY 1 (register))
		
		"Write Address"
		(writeAddress output S_AXI_AWADDR addressBusSize (register))
		(writeAddressValid output S_AXI_AWVALID 1 (register))
		(writeAddressReady input S_AXI_AWREADY 1)
	
		"Write data"
		(writeData output S_AXI_WDATA dataBusSize (register))
		(writeValid output S_AXI_WVALID 1 (register))
		(writeReady input S_AXI_WREADY 1)
		(writeStrobe output S_AXI_WSTRB writeStrobeSize (register))
	)
]

{ #category : #accessing }
VCAXI4LiteMemoryBusMaster >> addressBusSize [
	^ addressBusSize
]

{ #category : #accessing }
VCAXI4LiteMemoryBusMaster >> addressBusSize: anInteger [
	addressBusSize := anInteger
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusMaster >> createController [
	self createReadController.
	self createWriteController.
]

{ #category : #ports }
VCAXI4LiteMemoryBusMaster >> createPorts [
	readAddress := self outputRegister: (self makePortName: #S_AXI_ARADDR) bits: addressBusSize.
	readAddressValid := self outputRegister: (self makePortName: #S_AXI_ARVALID) bits: 1.
	readAddressReady := self input: (self makePortName: #S_AXI_ARREADY) bits: 1.
	readData := self input: (self makePortName: #S_AXI_RDATA) bits: dataBusSize.
	readValid := self input: (self makePortName: #S_AXI_RVALID) bits: 1.
	readReady := self outputRegister: (self makePortName: #S_AXI_RREADY) bits: 1.
	writeAddress := self outputRegister: (self makePortName: #S_AXI_AWADDR) bits: addressBusSize.
	writeAddressValid := self outputRegister: (self makePortName: #S_AXI_AWVALID) bits: 1.
	writeAddressReady := self input: (self makePortName: #S_AXI_AWREADY) bits: 1.
	writeData := self outputRegister: (self makePortName: #S_AXI_WDATA) bits: dataBusSize.
	writeValid := self outputRegister: (self makePortName: #S_AXI_WVALID) bits: 1.
	writeReady := self input: (self makePortName: #S_AXI_WREADY) bits: 1.
	writeStrobe := self outputRegister: (self makePortName: #S_AXI_WSTRB) bits: writeStrobeSize.

]

{ #category : #enumerating }
VCAXI4LiteMemoryBusMaster >> createReadAction: anAction [
	readActionCount := readActionCount + 1.
	readActionCount highBit > readAction bits ifTrue: [ readAction bits: readAction bits + 1 ].
	(readDone & (readAction equals: readActionCount)) whenTrueDo: anAction.
	^ readActionCount
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusMaster >> createReadController [
	readDone := builder immediateVariable value: false.
	
	readStateMachine := builder stateMachine.
	readStateMachine states: #(waitAddress waitRead);
		initial: #waitAddress;
		state: #waitAddress do: {
			readReady <== false.
			readAddressValid & readAddressReady whenTrue: { 
				readStateMachine <== #waitRead
			}
		};
		state: #waitRead do: { 
			readAddressValid <== false.
			readReady <== true.
			
			readValid & readReady whenTrue: {
				readDone <== true.
				readReady <== false.
				readStateMachine <== #waitAddress
			}
		}.
	
	readAction := builder register name: #memReadAction.
	readActionCount := 0.
	
	readDone whenTrueDo: {
		readAction <== 0
	}.
		
]

{ #category : #enumerating }
VCAXI4LiteMemoryBusMaster >> createWriteAction: anAction [
	writeActionCount := writeActionCount + 1.
	writeActionCount highBit > writeAction bits ifTrue: [ writeAction bits: writeAction bits + 1 ].
	(writeDone & (writeAction equals: writeActionCount)) whenTrueDo: anAction.
	^ writeActionCount
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusMaster >> createWriteController [
	writeDone := builder immediateVariable value: false.
	writeDone name: #writeDone.
	
	writeStateMachine := builder stateMachine name: #master_writeStateMachine.
	writeStateMachine states: #(waitAddress waitWrite);
		initial: #waitAddress;
		state: #waitAddress do: {
			writeValid <== false.
			writeAddressValid & writeAddressReady whenTrue: {
				writeAddressValid <== false.
				writeValid <== true.
				writeStateMachine <== #waitWrite
			}
		};
		state: #waitWrite do: { 
			writeValid & writeReady whenTrue: {
				writeValid <== false.
				writeDone <== true.
				writeStateMachine <== #waitAddress
			}
		}.
	
	writeAction := builder register name: #memWriteAction.
	writeActionCount := 0.
	
	writeDone whenTrueDo: {
		writeAction <== 0
	}.
]

{ #category : #accessing }
VCAXI4LiteMemoryBusMaster >> dataBusSize [
	^ dataBusSize
]

{ #category : #accessing }
VCAXI4LiteMemoryBusMaster >> dataBusSize: anInteger [
	dataBusSize := anInteger.
	writeStrobeSize := (dataBusSize + 7) // 8.
]

{ #category : #initialization }
VCAXI4LiteMemoryBusMaster >> initialize [
	super initialize.
	self
		addressBusSize: 32;
		dataBusSize: 32
]

{ #category : #enumerating }
VCAXI4LiteMemoryBusMaster >> read: anAddress into: aRegister whenFinishedDo: readFinishAction [
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
VCAXI4LiteMemoryBusMaster >> readAddress [
	^ readAddress
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> readAddressReady [
	^ readAddressReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> readAddressValid [
	^ readAddressValid
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> readData [
	^ readData
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> readReady [
	^ readReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> readValid [
	^ readValid
]

{ #category : #enumerating }
VCAXI4LiteMemoryBusMaster >> write: anAddress value: value strobe: strobe whenFinishedDo: writeFinishAction [
	| writeActionIndex |
	writeActionIndex := self createWriteAction: {
		writeFinishAction
	}.
	
	^ { 
		writeAddress <== anAddress.
		writeAddressValid <== true.
		writeData <== value.
		writeStrobe <== strobe.
		writeAction <== writeActionIndex.
	}.

]

{ #category : #enumerating }
VCAXI4LiteMemoryBusMaster >> write: anAddress value: value whenFinishedDo: writeFinishAction [
	^ self write: anAddress value: value strobe: (1<< writeStrobeSize) - 1 whenFinishedDo: writeFinishAction
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeAddress [
	^ writeAddress
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeAddressReady [
	^ writeAddressReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeAddressValid [
	^ writeAddressValid
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeData [
	^ writeData
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeReady [
	^ writeReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeStrobe [
	^ writeStrobe
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusMaster >> writeValid [
	^ writeValid
]
