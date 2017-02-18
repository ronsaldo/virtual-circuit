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
		'writeStrobe'
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
