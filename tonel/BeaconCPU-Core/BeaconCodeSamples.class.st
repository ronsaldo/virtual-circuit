Class {
	#name : #BeaconCodeSamples,
	#superclass : #Object,
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core-ISA'
}

{ #category : #examples }
BeaconCodeSamples class >> exampleAdd [
	<example>
	| module entry function |
	module := SAsmModule beacon.
	function := module build: #entry function: [ :functionBuilder |
		functionBuilder naked.
		entry := functionBuilder basicBlock: #entry build: [ :asm |
			asm
				beaconMove: 1 to: R1;
				beaconMove: 2 to: R2;
				beacon: ADD with: R1 with: R2 with: R3;
				beacon: HALT
		]
	].
	^ module
	
]

{ #category : #examples }
BeaconCodeSamples class >> exampleSetLeds [
	<example>
	| module entry function k m f periodBits |
	k := 1000.
	m := k*1000.
	f := 100*m.
	periodBits := (f *0.25) asInteger highBit.
	
	module := SAsmModule beacon.
	function := module build: #entry function: [ :functionBuilder |
		functionBuilder naked.
		entry := functionBuilder basicBlock: #entry build: [ :asm |
			asm
				"Set a static value for some leds"
				beacon: LDSPR with: R4 with: SpecialRegister_Ticks;
				beacon: RSHIFT with: R1 with: R4 with: periodBits;
				
				"Set some rgb leds with the button values"
				beacon: LDW into: R2 disp: 16;
				beacon: LDW into: R3 disp: 24;
				beacon: MUL with: R3 with: R3 with: 16;
				beacon: ADD with: R5 with: R2 with: R3;
				beacon: STW value: R5 disp: 8;

				"beaconMove: 2r0011 to: R1;"				
				beacon: ADD with: R1 with: R1 with: R5;
				beacon: STW value: R1 disp: 0;
				 
				beaconMove: 0 to: PC.
		]
	].
	^ module
	
]
