Class {
	#name : #VCAXI4LiteMemoryBusSlave,
	#superclass : #VCMemoryBusSlave,
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
		'writeStateMachine',
		'writeFinishedAction',
		'writingCondition',
		'writeAddressIsHandled',
		'currentWriteAddress',
		'currentWriteValue',
		'currentWriteStrobe',
		'currentAlignedWriteAddress',
		'currentReadAddress',
		'currentAlignedReadAddress',
		'readAddressIsHandled',
		'readStateMachine',
		'readingCondition',
		'readFinishedAction',
		'addressBusSize',
		'dataBusSize',
		'writeStrobeSize'
	],
	#category : #'VirtualCircuit-Digital-Bus'
}

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave class >> interfaceName [
	^ #AXI4Lite
]

{ #category : #'bus description' }
VCAXI4LiteMemoryBusSlave class >> portDesc [
	"
		self rebuildPortConnections
	"
	^ #(

		"Read Address"
		(readAddress input S_AXI_ARADDR addressBusSize)
		(readAddressValid input S_AXI_ARVALID 1)
		(readAddressReady output S_AXI_ARREADY 1 (register))
	
		"Read Data"	
		(readData output S_AXI_RDATA dataBusSize (register))
		(readValid output S_AXI_RVALID 1 (register))
		(readReady input S_AXI_RREADY 1)
		
		"Write Address"
		(writeAddress input S_AXI_AWADDR addressBusSize)
		(writeAddressValid input S_AXI_AWVALID 1)
		(writeAddressReady output S_AXI_AWREADY 1 (register))
	
		"Write data"
		(writeData input S_AXI_WDATA dataBusSize)
		(writeValid input S_AXI_WVALID 1)
		(writeReady output S_AXI_WREADY 1 (register))
		(writeStrobe input S_AXI_WSTRB writeStrobeSize)
	)
]

{ #category : #accessing }
VCAXI4LiteMemoryBusSlave >> addressBusSize [
	^ addressBusSize
]

{ #category : #accessing }
VCAXI4LiteMemoryBusSlave >> addressBusSize: anInteger [
	addressBusSize := anInteger
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave >> createController [
	self createReadController.
	self createWriteController.
]

{ #category : #ports }
VCAXI4LiteMemoryBusSlave >> createPorts [
	readAddress := self input: (self makePortName: #S_AXI_ARADDR) bits: addressBusSize.
	readAddressValid := self input: (self makePortName: #S_AXI_ARVALID) bits: 1.
	readAddressReady := self outputRegister: (self makePortName: #S_AXI_ARREADY) bits: 1.
	readData := self outputRegister: (self makePortName: #S_AXI_RDATA) bits: dataBusSize.
	readValid := self outputRegister: (self makePortName: #S_AXI_RVALID) bits: 1.
	readReady := self input: (self makePortName: #S_AXI_RREADY) bits: 1.
	writeAddress := self input: (self makePortName: #S_AXI_AWADDR) bits: addressBusSize.
	writeAddressValid := self input: (self makePortName: #S_AXI_AWVALID) bits: 1.
	writeAddressReady := self outputRegister: (self makePortName: #S_AXI_AWREADY) bits: 1.
	writeData := self input: (self makePortName: #S_AXI_WDATA) bits: dataBusSize.
	writeValid := self input: (self makePortName: #S_AXI_WVALID) bits: 1.
	writeReady := self outputRegister: (self makePortName: #S_AXI_WREADY) bits: 1.
	writeStrobe := self input: (self makePortName: #S_AXI_WSTRB) bits: writeStrobeSize.

]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave >> createReadController [
	currentReadAddress := builder register: 64.
	currentReadAddress name: #currentReadAddress.
		
	currentAlignedReadAddress := currentReadAddress bit: 4 count: 61.
	currentAlignedReadAddress name: #currentAlignedReadAddress.
	
	readAddressIsHandled := builder immediateVariable value: false.
	
	readStateMachine := builder stateMachine name: #slave_readStateMachine.
	readStateMachine states: #(waitAddress waitData readWaitReception);
		initial: #waitAddress;
		state: #waitAddress do: {
			readAddressReady <== true.
			readValid <== false.
			(readAddressValid & readAddressReady) whenTrue: {
				readAddressReady <== false.
				currentReadAddress <== readAddress.
				readStateMachine <== #waitData.
			}
		};
		state: #waitData do: {
			readAddressIsHandled whenTrue: { 
				readStateMachine <== #waitData
			} whenFalse: {
				readData <== 0.
				readValid <== true.
				readStateMachine <== #readWaitReception
			}.
		};
		state: #readWaitReception do: {
			readValid <== true.
			(readValid & readReady) whenTrue: {
				readValid <== false.
				readStateMachine <== #waitAddress.
			}
		}.
		
	readingCondition := (readStateMachine state: #waitData) condition.
	readFinishedAction := {
		readValid <== true.
		readStateMachine <== #readWaitReception
	}.


]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave >> createWriteController [
	currentWriteAddress := builder register: 64.
	currentWriteAddress name: #currentWriteAddress.
		
	currentAlignedWriteAddress := currentWriteAddress bit: 4 count: 61.
	currentAlignedWriteAddress name: #currentAlignedWriteAddress.
	
	currentWriteValue := builder register: 64.
	currentWriteValue name: #currentWriteValue.
	
	currentWriteStrobe := builder register: 8.
	currentWriteStrobe name: #currentWriteStrobe.
	
	writeAddressIsHandled := builder immediateVariable value: false.
	
	writeStateMachine := builder stateMachine name: #slave_writeStateMachine.
	writeStateMachine states: #(writeWait waitAddress waitData performWrite);
		initial: #waitAddress;
		state: #waitAddress do: {
			writeAddressReady <== true.
			writeReady <== false.
			(writeAddressValid & writeAddressReady) whenTrue: {
				writeAddressReady <== false.
				writeReady <== true.
				currentWriteAddress <== writeAddress.
				writeStateMachine <== #waitData.
			}
		};
		state: #waitData do: {
			(writeValid & writeReady) whenTrue: {
				writeReady <== false.
				currentWriteValue <== writeData.
				currentWriteStrobe <== writeStrobe.
				writeStateMachine <== #performWrite.
			}
		};
		state: #performWrite do: {
			writeAddressIsHandled whenTrue: {
				writeStateMachine <== #writeWait
			} whenFalse: {
				writeStateMachine <== #waitAddress
			}
		}.
		
	writingCondition := (writeStateMachine state: #performWrite) condition.
	
	writeFinishedAction := writeStateMachine <== #waitAddress.


]

{ #category : #accessing }
VCAXI4LiteMemoryBusSlave >> dataBusSize [
	^ dataBusSize
]

{ #category : #accessing }
VCAXI4LiteMemoryBusSlave >> dataBusSize: anInteger [
	dataBusSize := anInteger.
	writeStrobeSize := (dataBusSize + 7) // 8.
]

{ #category : #initialization }
VCAXI4LiteMemoryBusSlave >> initialize [
	super initialize.
	self
		addressBusSize: 32;
		dataBusSize: 32
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readAddress [
	^ readAddress
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readAddressReady [
	^ readAddressReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readAddressValid [
	^ readAddressValid
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readData [
	^ readData
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readReady [
	^ readReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> readValid [
	^ readValid
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave >> register: registerOffset onRead: aBlock [
	| registerReadCondition |
	registerReadCondition := (readingCondition & (currentAlignedReadAddress equals: registerOffset)).
 	registerReadCondition whenTrueDo: {
		readAddressIsHandled <== true
	}.
	
	aBlock value: registerReadCondition value: readData value: readFinishedAction
]

{ #category : #'as yet unclassified' }
VCAXI4LiteMemoryBusSlave >> register: registerOffset onWrite: aBlock [
	| registerWriteCondition |
	registerWriteCondition := (writingCondition & (currentAlignedWriteAddress equals: registerOffset)).
 	registerWriteCondition whenTrueDo: {
		writeAddressIsHandled <== true
	}.
	
	aBlock value: registerWriteCondition value: currentWriteValue value: currentWriteStrobe value: writeFinishedAction
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeAddress [
	^ writeAddress
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeAddressReady [
	^ writeAddressReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeAddressValid [
	^ writeAddressValid
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeData [
	^ writeData
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeReady [
	^ writeReady
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeStrobe [
	^ writeStrobe
]

{ #category : #'port accessors' }
VCAXI4LiteMemoryBusSlave >> writeValid [
	^ writeValid
]
