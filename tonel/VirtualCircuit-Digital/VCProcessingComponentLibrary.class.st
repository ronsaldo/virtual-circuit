Class {
	#name : #VCProcessingComponentLibrary,
	#superclass : #VCComponentLibrary,
	#category : #'VirtualCircuit-Digital-Library'
}

{ #category : #'as yet unclassified' }
VCProcessingComponentLibrary >> register2x1: depth fileSize: fileSize [
	| readAddress1 readAddress2 writeAddress writeValue writeEnabled memory addressDepth |
	^ self componentBuild: [ :builder |
		builder autoClock.
		
		addressDepth := (fileSize - 1) highBit.
		
		readAddress1 := builder input: #readAddress1 bits: addressDepth.
		readAddress2 := builder input: #readAddress2 bits: addressDepth.

		writeAddress := builder input: #writeAddress bits: addressDepth.
		writeValue := builder input: #writeValue bits: depth.
		writeEnabled := builder input: #writeEnabled.
		
		memory := builder distributedRam: fileSize depth: depth.
		
		memory write: writeAddress value: writeValue when: writeEnabled.
		builder output: #read1 bits: depth value: (memory read: readAddress1).
		builder output: #read2 bits: depth value: (memory read: readAddress2).
	].

]
