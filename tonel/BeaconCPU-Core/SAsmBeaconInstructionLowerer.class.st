Class {
	#name : #SAsmBeaconInstructionLowerer,
	#superclass : #SAsmInstructionLowerer,
	#category : #'BeaconCPU-Core'
}

{ #category : #'abstract instruction generation' }
SAsmBeaconInstructionLowerer >> enterFrame [
	function callingConvention isNaked ifTrue: [ ^ self ].
	self enterFramefullMethod
]

{ #category : #'abstract instruction generation' }
SAsmBeaconInstructionLowerer >> leaveFrame [
	function callingConvention isNaked ifTrue: [ ^ self ].
	self leaveFramefullMethod.
]
