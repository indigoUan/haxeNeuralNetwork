package neuralnetwork;

class Layer {
	public var neurons:Array<Neuron>;

	public function new(inputSize:Int, neuronCount:Int) {
		neurons = new Array<Neuron>();
		if (neuronCount > 65535) {
			throw "Too many neurons in one layer";
		}
		for (i in 0...neuronCount) {
			var neuron:Neuron = {
				weights: new Array<Float>(),
				bias: Math.random(),
				activationFunction: Linear
			}
	
			for (i in 0...inputSize) {
				neuron.weights.push(Math.random());
			}
			neurons.push(neuron);
		}
	}

	public function forward(input:Array<Float>):Array<Float> {
		var output:Array<Float> = new Array<Float>();
		for (neuron in neurons) {
			output.push(activateNeuron(neuron, input));
		}
		return output;
	}

	private function activateNeuron(neuron:Neuron, input:Array<Float>):Float {
		var value:Float = neuron.bias;
		for (i in 0...input.length) {
			value += neuron.weights[i] * input[i];
		}

		switch (neuron.activationFunction) {
			case Linear: {
				return value;
			}
			case ReLU(minimum): {
				return Math.max(minimum, value);
			}
			case Sigmoid: {
				return 1.0 / (1.0 + Math.exp(-value));
			}
			case TanH: {
				var exp2x:Float = Math.exp(2 * value);
				return (exp2x - 1) / (exp2x + 1);
			}
			case LeakyReLU(leakiness): {
				return (value >= 0) ? value : leakiness * value;
			}
			case ELU(alpha): {
				return (value >= 0) ? value : alpha * (Math.exp(value) - 1);
			}
			case Swish(beta): {
				return value / (1 + Math.exp(-beta * value));
			}
		}
		return value;
	}
}
