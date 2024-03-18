package neuralnetwork;

enum ActivationMethod {
	Linear;
	ReLU(minimum:Float);
	Sigmoid;
	TanH;
	LeakyReLU(leakiness:Float);
	ELU(alpha:Float);
	Swish(beta:Float);
}

private class NeuronInstance {
	public var weights:Array<Float>;
	public var bias:Float;

	public var activationFunction:ActivationMethod = Linear;

	public function new(inputSize:Int) {
		weights = new Array<Float>();
		for (i in 0...inputSize) {
			weights.push(Math.random());
		}
		bias = Math.random();
	}

	public function activate(input:Array<Float>):Float {
		var value:Float = bias;
		for (i in 0...input.length) {
			value += weights[i] * input[i];
		}

		switch (activationFunction) {
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
	}
}

@:forward
@:access(neuralnetwork.Neuron.NeuronInstance)
abstract Neuron(NeuronInstance) from NeuronInstance {
	public function new(inputSize:Int):NeuronInstance {
		this = new NeuronInstance(inputSize);
	}
}
