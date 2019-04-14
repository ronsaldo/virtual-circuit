Class {
	#name : #BeaconBoardIOMemorySpace,
	#superclass : #Object,
	#instVars : [
		'components'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-Board'
}

{ #category : #'as yet unclassified' }
BeaconBoardIOMemorySpace class >> artyBoard [
	^ self new
		addOutputPins: #led bits: 4 default: 0 constraints:
'set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L24N_T3_35 Sch=led[4]
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_25_35 Sch=led[5]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #IO_L24P_T3_A01_D17_14 Sch=led[6]
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #IO_L24N_T3_A00_D16_14 Sch=led[7]
';
		addOutputPins: #rgb_led bits: 12 default: 0 constraints:
'
set_property -dict { PACKAGE_PIN E1    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[0] }]; #IO_L18N_T2_35 Sch=led0_b
set_property -dict { PACKAGE_PIN F6    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[1] }]; #IO_L19N_T3_VREF_35 Sch=led0_g
set_property -dict { PACKAGE_PIN G6    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[2] }]; #IO_L19P_T3_35 Sch=led0_r
set_property -dict { PACKAGE_PIN G4    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[3] }]; #IO_L20P_T3_35 Sch=led1_b
set_property -dict { PACKAGE_PIN J4    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[4] }]; #IO_L21P_T3_DQS_35 Sch=led1_g
set_property -dict { PACKAGE_PIN G3    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[5] }]; #IO_L20N_T3_35 Sch=led1_r
set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[6] }]; #IO_L21N_T3_DQS_35 Sch=led2_b
set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[7] }]; #IO_L22N_T3_35 Sch=led2_g
set_property -dict { PACKAGE_PIN J3    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[8] }]; #IO_L22P_T3_35 Sch=led2_r
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[9] }]; #IO_L23P_T3_35 Sch=led3_b
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[10] }]; #IO_L24P_T3_35 Sch=led3_g
set_property -dict { PACKAGE_PIN K1    IOSTANDARD LVCMOS33 } [get_ports { rgb_led[11] }]; #IO_L23N_T3_35 Sch=led3_r
';
		addDebouncedInputPins: #buttons bits: 4 constraints:
'
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { buttons[0] }]; #IO_L6N_T0_VREF_16 Sch=btn[0]
set_property -dict { PACKAGE_PIN C9    IOSTANDARD LVCMOS33 } [get_ports { buttons[1] }]; #IO_L11P_T1_SRCC_16 Sch=btn[1]
set_property -dict { PACKAGE_PIN B9    IOSTANDARD LVCMOS33 } [get_ports { buttons[2] }]; #IO_L11N_T1_SRCC_16 Sch=btn[2]
set_property -dict { PACKAGE_PIN B8    IOSTANDARD LVCMOS33 } [get_ports { buttons[3] }]; #IO_L12P_T1_MRCC_16 Sch=btn[3]
';
		addInputPins: #switches bits: 4 constraints:
'set_property -dict { PACKAGE_PIN A8    IOSTANDARD LVCMOS33 } [get_ports { switches[0] }]; #IO_L12N_T1_MRCC_16 Sch=sw[0]
set_property -dict { PACKAGE_PIN C11   IOSTANDARD LVCMOS33 } [get_ports { switches[1] }]; #IO_L13P_T2_MRCC_16 Sch=sw[1]
set_property -dict { PACKAGE_PIN C10   IOSTANDARD LVCMOS33 } [get_ports { switches[2] }]; #IO_L13N_T2_MRCC_16 Sch=sw[2]
set_property -dict { PACKAGE_PIN A10   IOSTANDARD LVCMOS33 } [get_ports { switches[3] }]; #IO_L14P_T2_SRCC_16 Sch=sw[3]
';
	yourself

]

{ #category : #accessing }
BeaconBoardIOMemorySpace >> addComponent: aComponent [
	components add: aComponent
]

{ #category : #adding }
BeaconBoardIOMemorySpace >> addDebouncedInputPins: name bits: bits constraints: constraints [
	^ self addComponent: (BeaconBoardIOComponentDebouncedInputPins new
		portName: name;
		bits: bits;
		constraints: constraints;
		yourself)
]

{ #category : #adding }
BeaconBoardIOMemorySpace >> addInputPins: name bits: bits constraints: constraints [
	^ self addComponent: (BeaconBoardIOComponentInputPins new
		portName: name;
		bits: bits;
		constraints: constraints;
		yourself)
]

{ #category : #adding }
BeaconBoardIOMemorySpace >> addOutputPins: name bits: bits default: defaultValue constraints: constraints [
	^ self addComponent: (BeaconBoardIOComponentOutputPins new
		portName: name;
		bits: bits;
		default: defaultValue;
		constraints: constraints;
		yourself)
]

{ #category : #accessing }
BeaconBoardIOMemorySpace >> components [
	^ components
]

{ #category : #'as yet unclassified' }
BeaconBoardIOMemorySpace >> createWith: builder connectedTo: slaveBus [
	| registerOffset |
	registerOffset := 0.
	components do: [ :component |
		component createPortsWith: builder.
		component connectToSlave: slaveBus registerBase: registerOffset.
		registerOffset := registerOffset + component registerCount
	].


]

{ #category : #'as yet unclassified' }
BeaconBoardIOMemorySpace >> emitConstraintsInto: out [
	components do: [ :component | component emitConstraintsInto: out]
]

{ #category : #adding }
BeaconBoardIOMemorySpace >> initialize [
	super initialize.
	components := OrderedCollection new.
]
