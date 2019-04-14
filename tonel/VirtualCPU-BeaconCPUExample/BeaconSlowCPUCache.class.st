Class {
	#name : #BeaconSlowCPUCache,
	#superclass : #VCComplexComponentDefinition,
	#instVars : [
		'cacheSize',
		'cacheLines',
		'cacheLineAlignmentBits',
		'cacheLineAddressBits',
		'cacheElementAddressBits',
		'cacheAddressTagBits',
		'cacheLineStateBits',
		'cacheLineTagBits',
		'addressComponents',
		'readAddress',
		'readAddressValid',
		'readData',
		'readDataReady',
		'writeAddress',
		'writeValue',
		'writeEnabled',
		'cacheLineMemory',
		'cacheLineReadAddress',
		'cacheLineReadPort',
		'cacheLineWritePort',
		'stateMachine',
		'missAddress',
		'missCacheReadAddress',
		'missCacheLineAddress',
		'missCacheLine',
		'missFetchLineIndex',
		'cacheLineTagMemory',
		'memoryBus',
		'inputBus'
	],
	#classVars : [
		'CacheAccessAlignmentBits',
		'CacheAccessGranularity',
		'CacheLineSize'
	],
	#pools : [
		'BeaconCPUISA'
	],
	#category : #'VirtualCPU-BeaconCPUExample-SlowCPU'
}

{ #category : #initialization }
BeaconSlowCPUCache class >> initialize [
	super initialize.
	CacheAccessGranularity := 8.
	CacheAccessAlignmentBits := (CacheAccessGranularity - 1) highBit.
	CacheLineSize := 64.
]

{ #category : #building }
BeaconSlowCPUCache >> build [
	builder autoClock; autoReset.
	
	self
		createIOPorts;
		createMemories;
		createStateMachine
]

{ #category : #'state machine' }
BeaconSlowCPUCache >> createGlobalStates [
	missCacheReadAddress := builder register: cacheLineMemory addressBits.
	missCacheLineAddress := builder register: 64 - cacheLineAddressBits.
	missCacheLine := builder register: cacheLineAddressBits.
	missFetchLineIndex := builder register: cacheLineAlignmentBits - CacheAccessAlignmentBits.
	missAddress := builder register: 64.
]

{ #category : #building }
BeaconSlowCPUCache >> createIOPorts [
	memoryBus := builder memoryBusMasterInterface: #BSM prefix: #MAIN_.
	memoryBus createPortsWithController.
	
	inputBus := builder memoryBusSlaveInterface: #BSM prefix: #CORE_.
	inputBus createPortsWithController.
	
	readAddress := inputBus readAddress.
	readAddressValid := inputBus readAddressValid.

	readData := inputBus readData.
	readDataReady := inputBus readReady.

	"Write through"
	writeAddress := inputBus writeAddress.
	writeValue := inputBus writeData.
	writeEnabled := inputBus writeValid.
]

{ #category : #building }
BeaconSlowCPUCache >> createMemories [
	cacheLineMemory := builder blockRam: cacheSize/CacheAccessGranularity depth: CacheAccessGranularity.
	cacheLineReadAddress := builder immediateVariable: cacheElementAddressBits.
	cacheLineReadAddress value: 0.
	cacheLineReadPort := cacheLineMemory read: cacheLineReadAddress.
	cacheLineWritePort := cacheLineMemory writePort.
	
	cacheLineTagMemory := builder distributedRam: cacheLines depth: cacheLineTagBits.
]

{ #category : #'state machine' }
BeaconSlowCPUCache >> createStateMachine [
	stateMachine := builder stateMachine.
	stateMachine
		states: #(flushAll flushLines idle miss missFetchWait missElementFetched);
		initial: #flushAll.
		
	self createGlobalStates.
	self
		flushStates;
		idleState;
		missState
]

{ #category : #'state machine' }
BeaconSlowCPUCache >> flushStates [
	| flushLineIndex flushLineCount flushLineElementIndex |
	flushLineIndex := builder register: cacheLineAddressBits.
	flushLineCount := builder register: cacheLineAddressBits.
	flushLineElementIndex := builder register: (CacheLineSize/CacheAccessGranularity - 1) highBit.

	stateMachine
		state: #flushAll do: {
			flushLineIndex <== 0.
			flushLineCount <== cacheLines.
			flushLineElementIndex <== 0.
			stateMachine <== #flushLines
		};
		state: #flushLines do: {
			(flushLineCount notEquals: 0) whenTrue: {
				(flushLineElementIndex equals: flushLineElementIndex maxValue) whenTrue: {
					flushLineIndex <== (flushLineIndex + 1).
					flushLineCount <== (flushLineCount - 1).
				}.
				flushLineElementIndex <== (flushLineElementIndex + 1).
				cacheLineWritePort at: (flushLineIndex , flushLineElementIndex) put: 0.
			} whenFalse: { 
				stateMachine <== #idle
			} 
		}
]

{ #category : #'state machine' }
BeaconSlowCPUCache >> idleState [
	| lastWasHit activeAddress activeAddressParts activeAddressLineElement activeAddressCacheLine activeAddressCacheAddress activeAddressTag activeLineTagValue activeLinePresent activeLineAddressTag activeAddressIsCached |
	lastWasHit := builder register.

	activeAddress := builder immediateVariable: 64.
	activeAddressParts := activeAddress splitBitsReverse: addressComponents.
		
	activeAddressLineElement := activeAddressParts second.
	activeAddressCacheLine := activeAddressParts third.
	activeAddressCacheAddress := activeAddressCacheLine , activeAddressLineElement.
	activeAddressTag := activeAddressParts fourth.
		
	activeLineTagValue := (cacheLineTagMemory read: activeAddressCacheLine) splitBits:
		{cacheAddressTagBits . cacheLineStateBits . }.
	activeLineAddressTag := activeLineTagValue first.
	activeLinePresent := activeLineTagValue second.
	activeAddressIsCached := activeLinePresent & (activeLineAddressTag equals: activeAddressTag).

	stateMachine 
		state: #idle do: {
			readDataReady <== lastWasHit.
			readData <== (lastWasHit ifTrue: cacheLineReadPort ifFalse: 0).
				lastWasHit <== false.
				stateMachine <== #idle.
				
			writeEnabled whenTrue: {
				activeAddress <== writeAddress.
				activeAddressIsCached whenTrue: {
					"Write to the cache"
					cacheLineWritePort at: activeAddressCacheAddress put: writeValue
				}
			} whenFalse: { 
				readAddressValid whenTrue: {
					activeAddress <== readAddress.
					activeAddressIsCached whenTrue: {
						"Read the address from the cache line"
						cacheLineReadAddress <== activeAddressCacheAddress.
						stateMachine <== #idle.
						lastWasHit <== true.
					} whenFalse: {
						"MISS"
						missAddress <== readAddress.
						missCacheReadAddress <== activeAddressCacheAddress.
						missCacheLineAddress <== (readAddress bit: 1 + cacheLineAddressBits count: 64 - cacheLineAddressBits).
						missCacheLine <== activeAddressCacheLine.
						missFetchLineIndex <== 0.
						stateMachine <== #miss
					} 
				}
			}.
		}.
]

{ #category : #initialization }
BeaconSlowCPUCache >> initialize [
	super initialize.
	self size: 4096.
	name := self class name.
]

{ #category : #'state machine' }
BeaconSlowCPUCache >> missState [
	| missFetchAddress missFetchedValue |
	missFetchAddress := builder register: 64.
	missFetchedValue := builder register: 64.
	
	stateMachine
		state: #missFetchWait do: {
			stateMachine <== #missFetchWait
		};
		state: #miss do: {
			stateMachine <== #missFetchWait.
			memoryBus read:
				(missFetchAddress <== (missCacheLineAddress , missFetchLineIndex , (builder const: 0 bits: CacheAccessAlignmentBits))) 
				into: missFetchedValue whenFinishedDo: stateMachine <== #missElementFetched.
		};
		state: #missElementFetched do: {
			(missFetchAddress equals: missAddress) whenTrue: {
				readData <== missFetchedValue.
				readDataReady <== true.
			}.
			(missFetchLineIndex equals: missFetchLineIndex maxValue) whenTrue: {
				stateMachine <== #idle
			} whenFalse: {
				stateMachine <== #miss
			}.
			
			cacheLineWritePort at: (missCacheLine , missFetchLineIndex) put: missFetchedValue.
			missFetchLineIndex <== (missFetchLineIndex + 1)
		}.
]

{ #category : #settings }
BeaconSlowCPUCache >> size: aCacheSize [
	cacheSize := aCacheSize.
	cacheLines := cacheSize / CacheLineSize.
	cacheLineAlignmentBits := (CacheLineSize - 1) highBit.
	cacheLineAddressBits := (cacheLines - 1) highBit.
	cacheElementAddressBits := (cacheSize / CacheAccessGranularity - 1) highBit.
	
	cacheAddressTagBits := 64 -  cacheLineAddressBits - cacheLineAlignmentBits.
	cacheLineStateBits := 1. "Present / Not present".
	cacheLineTagBits := cacheLineStateBits + cacheAddressTagBits.
	
	addressComponents := { CacheAccessAlignmentBits . cacheLineAlignmentBits - CacheAccessAlignmentBits . cacheLineAddressBits . cacheAddressTagBits }.
	self assert: addressComponents sum = 64.
]
