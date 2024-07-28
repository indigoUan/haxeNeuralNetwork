package neuralnetwork;

import neuralnetwork.Neuron.ActivationFunctionUtil;
import neuralnetwork.Neuron.ActivationFunction;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.Json;

enum OutputActivationFunction {
	Linear;
	Softmax;
}

class OutputActivationFunctionUtil {
	public static function fromInt(i:Int):OutputActivationFunction {
		return switch (i) {
			default: Linear;
			case 1: Softmax;
		}
	}

	public static function toInt(af:OutputActivationFunction):Int {
		return switch (af) {
			case Linear: 0;
			case Softmax: 1;
		}
	}
}

class NeuralNetwork {
	public var outputActivationFunction:OutputActivationFunction = Linear;
	public var layers:Array<Layer>;

	public function new(layerSizes:Array<Int>) {
		layers = new Array<Layer>();
		if (layerSizes.length > 255) {
			throw "Too many layers";
		}
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
		return NeuralNetwork.deserialize(serialize());
	}

	public function serialize():Bytes {
		var bytes:BytesBuffer = new BytesBuffer();

		bytes.addByte(OutputActivationFunctionUtil.toInt(outputActivationFunction));
		bytes.addByte(layers.length);

		for (layer in layers) {
			bytes.addInt32(layer.neurons.length);
			for (neuron in layer.neurons) {
				bytes.addByte(neuron.weights.length);

				var func = ActivationFunctionUtil.serialize(neuron.activationFunction);
				bytes.addByte(func.method);
				bytes.addDouble(func.argument);

				bytes.addDouble(neuron.bias);
				for (weight in neuron.weights) {
					bytes.addDouble(weight);
				}
			}
		}

		return bytes.getBytes();
	}

	public static function deserialize(input:Bytes):NeuralNetwork {
		var pos:Int = 0;
		var network:NeuralNetwork = new NeuralNetwork([]);

		network.outputActivationFunction = OutputActivationFunctionUtil.fromInt(input.get(pos));
		pos++;

		final layerCount:Int = input.get(pos);
		pos++;

		var inputSize:Int = -1;
		for (i in 0...layerCount) {
			var neuronCount:Int = input.getInt32(pos);
			pos += 4;
			var layer:Layer = new Layer(inputSize == -1? neuronCount : inputSize, 0);

			for (j in 0...neuronCount) {
				var weights:Array<Float> = new Array<Float>();
				var weightCount:Int = input.get(pos);
				pos++;

				var method:Int = input.get(pos);
				pos++;
				var argument:Float = input.getFloat(pos);
				pos += 8;
				var activationFunction:ActivationFunction = ActivationFunctionUtil.deserialize(method, argument);

				var bias:Float = input.getDouble(pos);
				pos += 8;

				for (k in 0...weightCount) {
					weights.push(input.getDouble(pos));
					pos += 8;
				}

				layer.neurons.push({
					bias: bias,
					weights: weights,
					activationFunction: activationFunction
				});
			}

			network.layers.push(layer);
			inputSize = neuronCount;
		}

		return network;
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
