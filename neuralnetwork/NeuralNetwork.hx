package neuralnetwork;

import haxe.Json;

enum OutputActivationFunction {
	Linear;
	Softmax;
}

class NeuralNetwork {
	public var outputActivationFunction:OutputActivationFunction = Linear;
	public var layers:Array<Layer>;
	private var givenLayerSizes:Array<Int> = new Array();

	public function new(layerSizes:Array<Int>) {
		givenLayerSizes = layerSizes;
		layers = new Array<Layer>();
		if (layerSizes.length > 0) {
			layers.push(new Layer(layerSizes[0], layerSizes[0]));
			for (i in 1...layerSizes.length) {
				layers.push(new Layer(layerSizes[i-1], layerSizes[i]));
			}
		}
	}

	public function process(input:Array<Float>):Array<Float> {
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
		return output;
	}

	public function clone():NeuralNetwork {
		return NeuralNetwork.fromJSON(toJSON());
	}

	public function toJSON(pretty:Bool = false):String {
		var Ls:Array<Dynamic> = new Array<Dynamic>();
		for (layer in layers) {
			Ls.push(layer.neurons);
		}
		return Json.stringify(Ls, pretty? "\t" : null);
	}

	public static function fromJSON(json:String):NeuralNetwork {
		var layers:Array<Dynamic> = Json.parse(json);
		if (layers.length > 0) {
			var sizes:Array<Int> = new Array<Int>();
			for (layer in layers) {
				sizes.push(layer.length);
			}
			var network:NeuralNetwork = new NeuralNetwork(sizes);
			for (i in 0...layers.length) {
				network.layers[i].neurons = layers[i];
			}
			return network;
		}
		return new NeuralNetwork([]);
	}
}
