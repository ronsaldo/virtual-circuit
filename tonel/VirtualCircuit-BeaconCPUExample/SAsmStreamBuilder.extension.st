Extension { #name : #SAsmStreamBuilder }

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode [
	^ self beacon: opcode withOperands: #()
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode into: result base: base disp: disp [
	^ self beacon: opcode with: result with: base with: disp
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode into: result disp: disp [
	^ self beacon: opcode into: result base: BeaconCPUISA R0 disp: disp
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode value: value base: base disp: disp [
	^ self beacon: opcode with: value with: base with: disp
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode value: value disp: disp [
	^ self beacon: opcode value: value base: BeaconCPUISA R0 disp: disp
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode with: dest with: rl [
	^ self beacon: opcode withOperands: { dest asSAsmInstructionOperand . rl asSAsmInstructionOperand}
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: opcode with: dest with: rl with: rr [
	^ self beacon: opcode withOperands: { dest asSAsmInstructionOperand . rl asSAsmInstructionOperand . rr asSAsmInstructionOperand}
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beacon: operation withOperands: operands [
	^ self add: (
		SAsmInstruction new
			template: operation;
			arguments: operands;
			validate;
			yourself)
]

{ #category : #'*VirtualCircuit-BeaconCPUExample' }
SAsmStreamBuilder >> beaconMove: source to: target [
	^ self beacon: BeaconCPUISA add with: target asSAsmInstructionOperand with: BeaconCPUISA R0 with: source asSAsmInstructionOperand
]
