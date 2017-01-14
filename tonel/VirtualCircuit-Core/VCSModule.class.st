Class {
	#name : #VCSModule,
	#superclass : #Object,
	#instVars : [
		'name',
		'content'
	],
	#category : #'VirtualCircuit-Core-Synthesis'
}

{ #category : #accessing }
VCSModule >> content [
	^ content
]

{ #category : #accessing }
VCSModule >> content: anObject [
	content := anObject
]

{ #category : #accessing }
VCSModule >> name [
	^ name
]

{ #category : #accessing }
VCSModule >> name: anObject [
	name := anObject
]
