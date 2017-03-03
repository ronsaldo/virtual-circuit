Class {
	#name : #BeaconBoard,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'clockName',
		'resetName',
		'ioMemorySpace',
		'globalConstraints',
		'cpu',
		'cpuInstance',
		'cpuBus'
	],
	#category : #'BeaconCPU-Core-Board'
}

{ #category : #'as yet unclassified' }
BeaconBoard class >> artyBoard [
	^ self new
		clockName: #clock;
		resetName: #reset;
		globalConstraints: '
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clock }]; #IO_L12P_T1_MRCC_35 Sch=gclk[100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clock }];

set_property -dict { PACKAGE_PIN C2    IOSTANDARD LVCMOS33 } [get_ports { reset }]; #IO_L16P_T2_35 Sch=ck_rst
';
		ioMemorySpace: BeaconBoardIOMemorySpace artyBoard;
		yourself
]

{ #category : #building }
BeaconBoard >> build [
	builder autoReset; autoClock.
	self createCPU.
	self createIOPorts.
]

{ #category : #accessing }
BeaconBoard >> clockName [
	^ clockName
]

{ #category : #accessing }
BeaconBoard >> clockName: anObject [
	clockName := anObject
]

{ #category : #accessing }
BeaconBoard >> constraints [
	^ ByteString streamContents: [ :out |
		self emitConstraintsInto: out
	]
]

{ #category : #accessing }
BeaconBoard >> cpu [
	^ cpu
]

{ #category : #accessing }
BeaconBoard >> cpu: anObject [
	cpu := anObject
]

{ #category : #building }
BeaconBoard >> createCPU [
	cpuInstance := builder instance: cpu.
	cpuBus := cpuInstance memoryBusSlaveInterface: #BSM.
	cpuBus builder: builder.
	cpuBus createPortsWithController.
]

{ #category : #building }
BeaconBoard >> createIOPorts [
	ioMemorySpace createWith: builder connectedTo: cpuBus.
]

{ #category : #accessing }
BeaconBoard >> emitConstraintsInto: out [
	out nextPutAll: globalConstraints.
	ioMemorySpace emitConstraintsInto: out

]

{ #category : #accessing }
BeaconBoard >> globalConstraints [
	^ globalConstraints
]

{ #category : #accessing }
BeaconBoard >> globalConstraints: anObject [
	globalConstraints := anObject
]

{ #category : #initialization }
BeaconBoard >> initialize [
	super initialize..
	globalConstraints := ''.
]

{ #category : #accessing }
BeaconBoard >> ioMemorySpace [
	^ ioMemorySpace
]

{ #category : #accessing }
BeaconBoard >> ioMemorySpace: anObject [
	ioMemorySpace := anObject
]

{ #category : #accessing }
BeaconBoard >> resetName [
	^ resetName
]

{ #category : #accessing }
BeaconBoard >> resetName: anObject [
	resetName := anObject
]

{ #category : #accessing }
BeaconBoard >> saveConstraintsTo: fileName [
	fileName asFileReference writeStreamDo: [ :out |
		out truncate.
		self emitConstraintsInto: out
	]
]
