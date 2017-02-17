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
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster class >> interfaceName [
	^ #AXI
]

{ #category : #'as yet unclassified' }
VCAXIMemoryBusMaster >> createInterface [
	readAddress := builder outputRegister: #S_AXI_ARADDR bits: 32.
	readAddressValid := builder outputRegister: #S_AXI_ARVALID.
	readAddressReady := builder input: #S_AXI_ARREADY.
		
	readData := builder input: #S_AXI_RDADDR bits: 32.
	readValid := builder input: #S_AXI_RVALID.
	readReady := builder outputRegister: #S_AXI_RREADY.
	readResponse := builder input: #S_AXI_RRESP.
	
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
	

	writeAddress := builder outputRegister: #S_AXI_AWADDR bits: 32.
	writeAddressValid := builder outputRegister: #S_AXI_AWVALID.
	writeAddressReady := builder input: #S_AXI_AWREADY.
	
	writeData := builder outputRegister: #S_AXI_WDATA bits: 32.
	writeValid := builder outputRegister: #S_AXI_WVALID.
	writeReady := builder input: #S_AXI_WREADY.
	writeStrobe := builder outputRegister: #S_AXI_WSTRB bits: 4.
	
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

{ #category : #enumerating }
VCAXIMemoryBusMaster >> createReadAction: anAction [
	readActionCount := readActionCount + 1.
	readActionCount highBit > readAction bits ifTrue: [ readAction bits: readAction bits + 1 ].
	(readValid & readAction equals: readActionCount) whenTrueDo: anAction.
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
		aRegister <== readData 
	} , readFinishAction.
	
	^ builder actionList: { 
		readAddress <== anAddress.
		readAddressValid <== true.
		readReady <== true.
		readAction <== readActionIndex.
	}.

]
