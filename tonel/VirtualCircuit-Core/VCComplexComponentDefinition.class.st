Class {
	#name : #VCComplexComponentDefinition,
	#superclass : #Object,
	#instVars : [
		'builder',
		'component',
		'built',
		'name'
	],
	#category : #'VirtualCircuit-Core-Library'
}

{ #category : #building }
VCComplexComponentDefinition >> build [
	self subclassResponsibility
]

{ #category : #building }
VCComplexComponentDefinition >> component [
	built ifFalse: [
		component build: [ :aBuilder |
			builder := aBuilder.
			self
				build
		].
		built := true
	].
	^ component
]

{ #category : #initialization }
VCComplexComponentDefinition >> initialize [
	super initialize.
	name := self class name.
	component := VCComponent new name: self name.
	built := false
	
]

{ #category : #accessing }
VCComplexComponentDefinition >> name [
	^ name
]

{ #category : #accessing }
VCComplexComponentDefinition >> name: aName [
	name := aName.
	component ifNotNil: [ component name: aName ].
]
