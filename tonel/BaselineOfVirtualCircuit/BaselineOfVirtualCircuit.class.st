Class {
	#name : #BaselineOfVirtualCircuit,
	#superclass : #BaselineOf,
	#category : #BaselineOfVirtualCircuit
}

{ #category : #baselines }
BaselineOfVirtualCircuit >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec baseline: 'SAsm' with: [
				spec
					repository: 'github://ronsaldo/sasm/tonel'].
		spec 
			package: 'VirtualCircuit-Analog';
			package: 'VirtualCircuit-Digital';
			package: 'VirtualCircuit-BeaconCPUExample' with: [
				spec required: #('SAsm')]
	]
]
