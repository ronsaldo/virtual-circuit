Class {
	#name : #BeaconSamples,
	#superclass : #Object,
	#category : #'BeaconCPU-Core-Samples'
}

{ #category : #examples }
BeaconSamples class >> exampleSetLeds [
	| romCode rom cpu board |
	romCode := BeaconCodeSamples exampleSetLeds asOptimizedBinaryObject generateBinaryWithBase: 0.
	rom := VCROM content: romCode wordSize: 32.

	cpu := (BeaconSlowCPUEmbedded new instructionMemory: rom;
		component).

	"cpu := BeaconSequentialMemoryWriteLoop new
		values: { 
			0 -> 2r0011.
			8 -> 2r11000.
			16 -> 255.
		};
		component.
	cpu verilog."

	board := BeaconBoard artyBoard.
	board cpu: cpu.
	board saveConstraintsTo: 'beaconBoard.xdc'.

	board component
		vhdlToFileNamed: 'beaconBoard.vhdl';
		verilogToFileNamed: 'beaconBoard.v'
	
]

{ #category : #'see class side' }
BeaconSamples >> seeClassSide [
]
