Class {
	#name : #BeaconSimpleMemoryBusSlave,
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
		'readFinishedAction'
	],
	#category : #'BeaconCPU-Core-SlowCPU'
}

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave class >> interfaceName [
	^ #BSM
]

{ #category : #'bus description' }
BeaconSimpleMemoryBusSlave class >> portDesc [
	"
		self rebuildPortConnections
	"
	^ #(

		"Read Address"
		(readAddress input S_BSM_ARADDR 64)
		(readAddressValid input S_BSM_ARVALID 1)
		(readAddressReady output S_BSM_ARREADY 1 (register))
	
		"Read Data"	
		(readData output S_BSM_RDATA 64 (register))
		(readValid output S_BSM_RVALID 1 (register))
		(readReady input S_BSM_RREADY 1)
		
		"Write Address"
		(writeAddress input S_BSM_AWADDR 64)
		(writeAddressValid input S_BSM_AWVALID 1)
		(writeAddressReady output S_BSM_AWREADY 1 (register))
	
		"Write data"
		(writeData input S_BSM_WDATA 64)
		(writeValid input S_BSM_WVALID 1)
		(writeReady output S_BSM_WREADY 1 (register))
		(writeStrobe input S_BSM_WSTRB 8)
	)
]

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave >> createController [
	self createReadController.
	self createWriteController.
]

{ #category : #ports }
BeaconSimpleMemoryBusSlave >> createPorts [
	readAddress := self input: (self makePortName: #S_BSM_ARADDR) bits: 64.
	readAddressValid := self input: (self makePortName: #S_BSM_ARVALID) bits: 1.
	readAddressReady := self outputRegister: (self makePortName: #S_BSM_ARREADY) bits: 1.
	readData := self outputRegister: (self makePortName: #S_BSM_RDATA) bits: 64.
	readValid := self outputRegister: (self makePortName: #S_BSM_RVALID) bits: 1.
	readReady := self input: (self makePortName: #S_BSM_RREADY) bits: 1.
	writeAddress := self input: (self makePortName: #S_BSM_AWADDR) bits: 64.
	writeAddressValid := self input: (self makePortName: #S_BSM_AWVALID) bits: 1.
	writeAddressReady := self outputRegister: (self makePortName: #S_BSM_AWREADY) bits: 1.
	writeData := self input: (self makePortName: #S_BSM_WDATA) bits: 64.
	writeValid := self input: (self makePortName: #S_BSM_WVALID) bits: 1.
	writeReady := self outputRegister: (self makePortName: #S_BSM_WREADY) bits: 1.
	writeStrobe := self input: (self makePortName: #S_BSM_WSTRB) bits: 8.

]

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave >> createReadController [
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
BeaconSimpleMemoryBusSlave >> createWriteController [
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

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readAddress [
	^ readAddress
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readAddressReady [
	^ readAddressReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readAddressValid [
	^ readAddressValid
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readData [
	^ readData
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readReady [
	^ readReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> readValid [
	^ readValid
]

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave >> register: registerOffset onRead: aBlock [
	| registerReadCondition |
	registerReadCondition := (readingCondition & (currentAlignedReadAddress equals: registerOffset)).
 	registerReadCondition whenTrueDo: {
		readAddressIsHandled <== true
	}.
	
	aBlock value: registerReadCondition value: readData value: readFinishedAction
]

{ #category : #'as yet unclassified' }
BeaconSimpleMemoryBusSlave >> register: registerOffset onWrite: aBlock [
	| registerWriteCondition |
	registerWriteCondition := (writingCondition & (currentAlignedWriteAddress equals: registerOffset)).
 	registerWriteCondition whenTrueDo: {
		writeAddressIsHandled <== true
	}.
	
	aBlock value: registerWriteCondition value: currentWriteValue value: currentWriteStrobe value: writeFinishedAction
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeAddress [
	^ writeAddress
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeAddressReady [
	^ writeAddressReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeAddressValid [
	^ writeAddressValid
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeData [
	^ writeData
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeReady [
	^ writeReady
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeStrobe [
	^ writeStrobe
]

{ #category : #'port accessors' }
BeaconSimpleMemoryBusSlave >> writeValid [
	^ writeValid
]
