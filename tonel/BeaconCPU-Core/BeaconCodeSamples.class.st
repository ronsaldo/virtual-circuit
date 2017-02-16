Class {
	#name : #BeaconCodeSamples,
	#superclass : #Object,
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'BeaconCPU-Core'
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
	module inspect
	
]
