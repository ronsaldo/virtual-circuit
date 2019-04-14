Class {
	#name : #VCSequentialActionList,
	#superclass : #VCSequentialAction,
	#instVars : [
		'list'
	],
	#category : #'VirtualCircuit-Digital-Circuit'
}

{ #category : #accessing }
VCSequentialActionList >> list [
	^ list
]

{ #category : #accessing }
VCSequentialActionList >> list: anObject [
	list := anObject
]

{ #category : #'as yet unclassified' }
VCSequentialActionList >> on: condition applyInComponent: component [
	list do: [ :each | each on: condition applyInComponent: component ]
]
