Class {
	#name : #VCBasicComponentLibrary,
	#superclass : #VCComponentLibrary,
	#category : #'VirtualCircuit-Core-Library'
}

{ #category : #arithmethic }
VCBasicComponentLibrary >> adder [
	| first second inputCarry halfSum |
	^ self componentBuild: [ :builder |
		first := builder input: #first.
		second := builder input: #second.
		inputCarry := builder input: #inputCarry.
	
		halfSum := first bitXor: second.
		builder
			output: #result value: (halfSum bitXor: inputCarry);
			output: #carry value: (first & second) | (inputCarry & halfSum);
			yourself
	].
 
]

{ #category : #arithmethic }
VCBasicComponentLibrary >> adder: bitCount [
	| adderComponent first second inputCarry adders |
	adderComponent := self adder.
	^ self componentBuild: [ :builder |
		first := builder input: #first bits: bitCount.
		second := builder input: #second bits: bitCount.
		inputCarry := builder input: #inputCarry.

		"Create the full adders"
		adders := (1 to: bitCount) collect: [ :i |
			(builder instance: adderComponent)
				first: (first bit: i);
				second: (second bit: i);
				yourself
		].
	
		"Connect the carries"
		adders doWithIndex: [ :adder :i |
			adder inputCarry: (i > 1
				ifTrue: [(adders at: i) carry ]
				ifFalse: [ inputCarry ])
		].
	
		builder
			output: #result pack: adders with: #result;
			output: #carry value: adders last carry
	]
]

{ #category : #arithmethic }
VCBasicComponentLibrary >> adderSubtractor: bitCount [
	| adderComponent first second inputCarry adders subtract |
	adderComponent := self adder.
	^ self componentBuild: [ :builder |
		first := builder input: #first bits: bitCount.
		second := builder input: #second bits: bitCount.
		subtract := builder input: #subtract.
		inputCarry := builder input: #inputCarry.

		"Create the full adders"
		adders := (1 to: bitCount) collect: [ :i |
			(builder instance: adderComponent)
				first: (first bit: i);
				second: ((second bit: i) bitXor: subtract);
				yourself
		].
	
		"Connect the carries"
		adders doWithIndex: [ :adder :i |
			adder inputCarry: (i > 1
				ifTrue: [(adders at: i) carry ]
				ifFalse: [ inputCarry bitXor: subtract])
		].
	
		builder
			output: #result pack: adders with: #result;
			output: #carry value: adders last carry
	]
]

{ #category : #'flip flops' }
VCBasicComponentLibrary >> data [
	^ self data: 1
]

{ #category : #'flip flops' }
VCBasicComponentLibrary >> data: bits [
	| d q nq reg |
	^ self componentBuild: [ :builder |
		builder autoClock.
		
		d := builder input: #d bits: bits.
		
		reg := builder register: bits.
		reg value: d.
		
		q := builder output: #q value: reg.
		nq := builder output: #nq value: reg not.
	]
]

{ #category : #'shift registers' }
VCBasicComponentLibrary >> latchedSipo: bitWidth [
	| input previousStage bits load latchedBits |
	^ self componentBuild: [ :builder |
		builder autoClock.
		
		input := builder input: #in.
	
		previousStage := input.
		bits := (1 to: bitWidth) collect: [ :i |
			previousStage := builder register value: previousStage.
		].
	
		load := builder input: #load.
		latchedBits := bits collect: [ :bit |
			builder register clock: load; value: bit; yourself.
		].
	
		builder
			output: #next value: previousStage;
			output: #out bits: bitWidth value: (builder pack: latchedBits).
	]
]

{ #category : #'shift registers' }
VCBasicComponentLibrary >> sipo: bitWidth [
	| input previousStage bits |
	^ self componentBuild: [ :builder |
		builder autoClock.
		
		input := builder input: #in.
	
		previousStage := input.
		bits := (1 to: bitWidth) collect: [ :i |
			previousStage := builder register value: previousStage.
		].
	
		builder
			output: #next value: previousStage;
			output: #out bits: bitWidth value: (builder pack: bits).
	]
]
