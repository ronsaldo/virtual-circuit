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
		'writeActionCount',
		'writeDone',
		'writeStateMachine',
		'readDone',
		'readStateMachine'
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
	self createReadController.
	self createWriteController.
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
	(readDone & (readAction equals: readActionCount)) whenTrueDo: anAction.
	^ readActionCount
]

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster >> createReadController [
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
VCAXIMemoryBusMaster >> createWriteAction: anAction [
	writeActionCount := writeActionCount + 1.
	writeActionCount highBit > writeAction bits ifTrue: [ writeAction bits: writeAction bits + 1 ].
	(writeDone & (writeAction equals: writeActionCount)) whenTrueDo: anAction.
	^ writeActionCount
]

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster >> createWriteController [
	writeDone := builder immediateVariable value: false.
	
	writeStateMachine := builder stateMachine.
	writeStateMachine states: #(waitAddress waitWrite);
		initial: #waitAddress;
		state: #waitAddress do: {
			writeValid <== false.
			writeAddressValid & writeAddressReady whenTrue: { 
				writeStateMachine <== #waitWrite
			}
		};
		state: #waitWrite do: { 
			writeAddressValid <== false.
			writeValid <== true.
			
			writeValid & writeReady whenTrue: {
				writeDone <== true.
				writeValid <== false.
				writeStateMachine <== #waitAddress
			}
		}.
	
	writeAction := builder register name: #memWriteAction.
	writeActionCount := 0.
	
	writeDone whenTrueDo: {
		writeAction <== 0
	}.
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

{ #category : #enumerating }
VCAXIMemoryBusMaster >> write: anAddress value: value strobe: strobe whenFinishedDo: writeFinishAction [
	^ self write: anAddress value: value strobe: 2r1111 whenFinishedDo: writeFinishAction
]

{ #category : #enumerating }
VCAXIMemoryBusMaster >> write: anAddress value: value whenFinishedDo: writeFinishAction [
	| writeActionIndex |
	writeActionIndex := self createWriteAction: {
		writeFinishAction
	}.
	
	^ { 
		writeAddress <== anAddress.
		writeAddressValid <== true.
		writeData <== value.
		writeAction <== writeActionIndex.
	}.

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
