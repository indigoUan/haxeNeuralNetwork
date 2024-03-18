package neuralnetwork;

private class LayerInstance {
	public var neurons:Array<Neuron>;

	@:arrayAccess function get(k:Int) {
	  return neurons[k];
	}
	@:arrayAccess function arrayWrite(k:Int, v:Neuron):Neuron {
		neurons[k] = v;
		return v;
	}

	public function new(inputSize:Int, neuronCount:Int) {
		neurons = new Array<Neuron>();
		for (i in 0...neuronCount) {
			neurons.push(new Neuron(inputSize));
		}
	}

	public function forward(input:Array<Float>):Array<Float> {
		var output:Array<Float> = new Array<Float>();
		for (neuron in neurons) {
			output.push(neuron.activate(input));
		}
		return output;
	}
}

@:forward
@:access(neuralnetwork.NeuralNetwork.LayerInstance)
abstract Layer(LayerInstance) from LayerInstance {
	public function new(inputSize:Int, neuronCount:Int):LayerInstance {
		this = new LayerInstance(inputSize, neuronCount);
	}

	public var length(get, never):Int;
	private function get_length():Int {
		return this.neurons.length;
	}

	@:arrayAccess public inline function get(id:Int) {
	  return this.neurons[id];
	}

	@:arrayAccess public inline function set(id:Int, neuron:Neuron) {
		this.neurons[id] = neuron;
		return neuron;
	}
}
