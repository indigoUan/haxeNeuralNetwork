package neuralnetwork;

enum OutputActivationFunction {
	Linear;
	Softmax;
}

private class NeuralNetworkInstance {
	public var outputActivationFunction:OutputActivationFunction = Linear;
	public var layers:Array<Layer>;
	private var givenLayerSizes:Array<Int> = new Array();

	public function new(layerSizes:Array<Int>) {
		givenLayerSizes = layerSizes;
		layers = new Array<Layer>();
		if (layerSizes.length > 0) {
			for (i in 1...layerSizes.length) {
				layers.push(new Layer(layerSizes[i-1], layerSizes[i]));
			}
		}
	}

	public function forward(input:Array<Float>):Array<Float> {
		var output:Array<Float> = input;
		for (layer in layers) {
			output = layer.forward(output);
		}
		switch (outputActivationFunction) {
			case Linear: {
				return output;
			}
			case Softmax: {
				var exponentiated:Array<Float> = [];
				for (i in output) {
					exponentiated.push(Math.exp(i));
				}
		
				var normalBase:Float = 0;
				var normalValues:Array<Float> = [];

				for (i in exponentiated) {
					normalBase += i;
				}

				for (i in exponentiated) {
					normalValues.push(i / normalBase);
				}
		
				return normalValues;
			}
		}
	}
}

@:forward
@:access(neuralnetwork.NeuralNetwork.NeuralNetworkInstance)
abstract NeuralNetwork(NeuralNetworkInstance) from NeuralNetworkInstance {
	public function new(layerSizes:Array<Int>):NeuralNetworkInstance {
		this = new NeuralNetworkInstance(layerSizes);
	}

	public var length(get, never):Int;
	private function get_length():Int {
		return this.layers.length;
	}

	@:arrayAccess public inline function get(id:Int) {
	  return this.layers[id];
	}

	@:arrayAccess public inline function set(id:Int, layer:Layer) {
		this.layers[id] = layer;
		return layer;
	}
}
