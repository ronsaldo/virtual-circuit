Extension { #name : #SAsmStreamBuilder }

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode [
	^ self beacon: opcode withOperands: #()
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: opcode with: dest with: rl with: rr [
	^ self beacon: opcode withOperands: { dest asSAsmInstructionOperand . rl asSAsmInstructionOperand . rr asSAsmInstructionOperand}
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beacon: operation withOperands: operands [
	^ self add: (
		SAsmInstruction new
			template: operation;
			arguments: operands;
			yourself)
]

{ #category : #'*BeaconCPU-Core' }
SAsmStreamBuilder >> beaconMove: source to: target [
	^ self beacon: BeaconCPUISA add with: target asSAsmInstructionOperand with: BeaconCPUISA R0 with: source asSAsmInstructionOperand
]
