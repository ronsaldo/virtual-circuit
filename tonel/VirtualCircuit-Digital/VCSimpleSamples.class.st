Class {
	#name : #VCSimpleSamples,
	#superclass : #Object,
	#category : #'VirtualCircuit-Digital-Samples'
}

{ #category : #'as yet unclassified' }
VCSimpleSamples class >> exampleBlinkingLeds [
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
]

{ #category : #'see class side' }
VCSimpleSamples >> seeClassSide [
]
