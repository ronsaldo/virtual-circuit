Class {
	#name : #VCComponentLibrary,
	#superclass : #Object,
	#classInstVars : [
		'componentsCache'
	],
	#category : #'VirtualCircuit-Core-Library'
}

{ #category : #'component cache' }
VCComponentLibrary class >> componentsCache [
	^ componentsCache ifNil: [ componentsCache := Dictionary new ]
]

{ #category : #'component cache' }
VCComponentLibrary class >> flushAllComponentsCache [
	self withAllSubclassesDo: #flushComponentCache
]

{ #category : #'component cache' }
VCComponentLibrary class >> flushComponentCache [
	componentsCache := Dictionary new.
]

{ #category : #'as yet unclassified' }
VCComponentLibrary class >> flushComponentSelector: aSelector [
	| cache components |
	cache := self componentsCache.
	(cache includesKey: aSelector) ifFalse: [ ^ self ].
	
	components := cache at: aSelector.
	cache removeKey: aSelector.
	components isDictionary ifTrue: [
		components valuesDo: #flushCache
	] ifFalse: [
		components flushCache
	]
]

{ #category : #'as yet unclassified' }
VCComponentLibrary class >> noteCompilationOf: aSelector meta: isMeta [
	isMeta ifFalse: [
		self flushComponentSelector: aSelector
	]
]

{ #category : #'as yet unclassified' }
VCComponentLibrary >> componentBuild: aBlock [
	| senderContext argumentCount selector arguments components componentInstances fullName |
	senderContext := thisContext sender.
	argumentCount := senderContext method numArgs.
	selector := senderContext selector.

	components := self class componentsCache.
	
	argumentCount == 0 ifTrue: [
		^ components at: selector ifAbsentPut: [
			VCComponent name: selector cacheClass: self class cacheSelector: selector build: aBlock ]
	] ifFalse: [ 
		arguments := (1 to: argumentCount) collect: [ :i | senderContext tempAt: i ].
		componentInstances := components at: selector ifAbsentPut: [ Dictionary new ].
		^ componentInstances at: arguments ifAbsentPut: [
			fullName := ByteString streamContents: [ :out |
				out nextPutAll: selector.
				arguments do: [ :arg | out space; print: arg ]
			].
		
			VCComponent name: fullName asSymbol cacheClass: self class cacheSelector: selector build: aBlock
		]
	]

]
