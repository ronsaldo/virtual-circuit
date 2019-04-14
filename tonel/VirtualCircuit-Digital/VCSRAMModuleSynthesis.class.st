Class {
	#name : #VCSRAMModuleSynthesis,
	#superclass : #Object,
	#instVars : [
		'ram',
		'memoryName',
		'ports',
		'clock'
	],
	#category : #'VirtualCircuit-Digital-Synthesis'
}

{ #category : #accessing }
VCSRAMModuleSynthesis >> clock [
	^ clock
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> clock: anObject [
	clock := anObject
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> memoryName [
	^ memoryName
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> memoryName: anObject [
	memoryName := anObject
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> ports [
	^ ports
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> ports: anObject [
	ports := anObject
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> ram [
	^ ram
]

{ #category : #accessing }
VCSRAMModuleSynthesis >> ram: anObject [
	ram := anObject
]
