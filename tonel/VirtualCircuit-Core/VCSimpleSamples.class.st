Class {
	#name : #VCSimpleSamples,
	#superclass : #Object,
	#category : #'VirtualCircuit-Core-Samples'
}

{ #category : #'as yet unclassified' }
VCSimpleSamples >> blinkingLeds [
	| k m f periodBits count component |
	k := 1000.
	m := k*1000.
	f := 100*m.

	periodBits := (f *0.25) asInteger highBit.

	component := VCComponent name: #blinking build: [ :builder |
		builder autoClock; autoReset.
	
		count := builder register: 32.
		count value: count value + 1.

		builder output: #leds bits: 4 value: (count bit: 1 + periodBits count: 4)
	].

	component verilogToFileNamed: 'blinkingLeds.v'
]
