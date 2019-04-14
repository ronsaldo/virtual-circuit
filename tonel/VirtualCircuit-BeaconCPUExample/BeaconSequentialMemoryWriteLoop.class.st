Class {
	#name : #BeaconSequentialMemoryWriteLoop,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'values',
		'memoryInterfaceType',
		'memoryBus',
		'stateMachine'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'VirtualCircuit-BeaconCPUExample-SlowCPU'
}

{ #category : #building }
BeaconSequentialMemoryWriteLoop >> build [
	builder autoClock; autoReset.
	
	self
		createIOPorts;
		writeValues
]

{ #category : #building }
BeaconSequentialMemoryWriteLoop >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: memoryInterfaceType.
	memoryBus createPortsWithController.
]

{ #category : #building }
BeaconSequentialMemoryWriteLoop >> initialize [
	super initialize.
	memoryInterfaceType := #BSM.
]

{ #category : #accessing }
BeaconSequentialMemoryWriteLoop >> values [
	^ values
]

{ #category : #accessing }
BeaconSequentialMemoryWriteLoop >> values: anObject [
	values := anObject
]

{ #category : #building }
BeaconSequentialMemoryWriteLoop >> writeValues [
	| addressIndexToWrite addressToWrite valueToWrite |
	addressIndexToWrite := builder register: (values size - 1) highBit.
	addressIndexToWrite name: #addressIndex.
	
	addressToWrite := builder const: 16rFFFFFFFFFFFFFFFF bits: 64.
	valueToWrite := builder const: 0 bits: 64.

	values doWithIndex: [ :value :index |
		| condition |
		condition := (addressIndexToWrite equals: index - 1).
		
		addressToWrite := condition ifTrue: (builder const: value key bits: 64) ifFalse: addressToWrite.
		valueToWrite := condition ifTrue: (builder const: value value bits: 64) ifFalse: valueToWrite.
	].

	stateMachine := builder stateMachine.
	stateMachine states: #(wait initial writeValue);
		initial: #initial;
		state: #initial do: {
			stateMachine <== #writeValue.
		};
		state: #writeValue do: {
			stateMachine <== #wait.
			memoryBus write: addressToWrite value: valueToWrite whenFinishedDo: {
				addressIndexToWrite <== (addressIndexToWrite + 1).
				stateMachine <== #writeValue.
			}
		}
]
