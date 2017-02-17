Class {
	#name : #VCStateMachineBuilder,
	#superclass : #Object,
	#instVars : [
		'builder',
		'initial',
		'states',
		'register'
	],
	#category : #'VirtualCircuit-Core-Circuit'
}

{ #category : #accessing }
VCStateMachineBuilder >> <== aStateName [
	^ register <== ((states at: aStateName) value)
]

{ #category : #accessing }
VCStateMachineBuilder >> builder [
	^ builder
]

{ #category : #accessing }
VCStateMachineBuilder >> builder: anObject [
	builder := anObject
]

{ #category : #accessing }
VCStateMachineBuilder >> initial [
	^ initial
]

{ #category : #accessing }
VCStateMachineBuilder >> initial: aStateName [
	initial := self states at: aStateName.
	register resetValue: initial value
]

{ #category : #initialization }
VCStateMachineBuilder >> initialize [
	super initialize.
	states := Dictionary new.
]

{ #category : #accessing }
VCStateMachineBuilder >> register [
	^ register
]

{ #category : #accessing }
VCStateMachineBuilder >> state: state do: actions [
	(states at: state) do: actions
]

{ #category : #accessing }
VCStateMachineBuilder >> states [
	^ states
]

{ #category : #accessing }
VCStateMachineBuilder >> states: anArray [
	| stateBits |
	anArray assert: anArray isNotEmpty.
	states := IdentityDictionary new.
	stateBits := anArray size - 1 highBit.
	register := builder register: stateBits.
	
	anArray doWithIndex: [ :stateName :index |
		states at: stateName put: (VCStateMachineState new
			name: stateName;
			value: index - 1;
			condition: (register equals: index - 1);
			component: builder component;
			yourself)
	].
]
