# VirtualCircuit
### An experiment DSL for logic circuits in Pharo and generating code for FPGAs

## Description
This is the code of an experiment for trying to replicate the work Chisel by
Bachrach et al ([Chisel: Constructing Hardware in a Scala Embedded Language.](https://chisel.eecs.berkeley.edu/chisel-dac2012.pdf Chisel paper))
in Pharo.

## Loading

VirtualCircuit can be loaded in a Pharo 7 image by running the following script in a
playground:

```smalltalk
Metacello new
   baseline: 'VirtualCircuit';
   repository: 'github://ronsaldo/virtual-circuit/tonel';
   load
```

## Examples
### Blinking leds circuit
There is a blinking leds example at VCSimpleSamples class >> exampleBlinkingLeds:

```smalltalk
exampleBlinkingLeds
	| k m f periodBits count component |
	k := 1000.
	m := k*1000.
	f := 100*m.

	periodBits := (f *0.25) asInteger highBit.

	component := VCComponent name: #blinking build: [ :builder |
		builder autoClock; autoReset.

		count := builder register: 32.
		count value: count value + 1.

		builder output: #led bits: 4 value: (count bit: 1 + periodBits count: 4)
	].

	component
		vhdlToFileNamed: 'blinkingLeds.vhdl';
		verilogToFileNamed: 'blinkingLeds.v'
```

A video of this example running in the original Digilent Arty rev C board is available at: https://youtu.be/F1S18aNiXh8

### 64 bits simplistic CPU construction

A more complicated example in **BeaconSamples class >> exampleSetLeds** is the
attempt on constructing a simplistic CPU:

```smalltalk
BeaconCodeSamples class >> exampleSetLeds
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

				beacon: ADD with: R1 with: R1 with: R5;
				beacon: STW value: R1 disp: 0;

				beaconMove: 0 to: PC.
		]
	].
	^ module

BeaconSamples class >> exampleSetLeds
	| romCode rom cpu board |
	romCode := BeaconCodeSamples exampleSetLeds asOptimizedBinaryObject generateBinaryWithBase: 0.
	rom := VCROM content: romCode wordSize: 32.

	cpu := (BeaconSlowCPUEmbedded new instructionMemory: rom;
		component).

	board := BeaconBoard artyBoard.
	board cpu: cpu.
	board saveConstraintsTo: 'beaconBoard.xdc'.

	board component
		vhdlToFileNamed: 'beaconBoard.vhdl';
		verilogToFileNamed: 'beaconBoard.v'
```

This example show how Virtual Circuit can be connected with SAsm to assist in:
- The definition of the CPU ISA.
- The implementation of the CPU ISA.
- The assembling and generation of code the CPU.

This CPU is implemented as a single stage, non-pipelining and mostly sequential
logic for control flow. This is not meant to be used in production, and currently
Vivado gives critical timing warnings on synthesis. However the set leds
examples is tested on the original Arty board rev C by Digilent, with both the Verilog
and the VHDL code generator.

## Problems and limitations
The main problem of this project is that the Verilog and VHDL code that is generated by
this DSL can be hard to read, and hard to debug. Another problem with this
project is the lack of facilities for simulating and debug the circuits inside
the Pharo image enviornment.
