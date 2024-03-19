package neuralnetwork;

typedef NeuralNetworkGraphical = {
	lines:Array<{
		x1:Float,
		y1:Float,
		x2:Float,
		y2:Float,
		value:Float
	}>,
	dots:Array<{
		x:Float,
		y:Float,
		value:Float
	}>
}

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

	public function graphicalMapping():NeuralNetworkGraphical {
		var res:NeuralNetworkGraphical = {
			lines: new Array(),
			dots: new Array()
		};

		var widthSpace:Float = 1 / layers.length;
		var prevX:Float = 0;
		var prevYs:Array<Float> = [];
		var bufferYs:Array<Float> = [];
		for (layer in 0...layers.length) {
			var heightSpace:Float = 1 / layers[layer].length;
			var x:Float = widthSpace * layer;
			for (neuron in 0...layers[layer].length) {
				var y:Float = heightSpace * neuron;
				bufferYs.push(y);

				for (Y in 0...prevYs.length) {
					res.lines.push({ x1: prevX, y1: prevYs[Y], x2: x, y2: y, value: layers[layer][neuron].weights[Y] });
				}
				res.dots.push({ x: x, y: y, value: layers[layer][neuron].bias });
			}
			prevX = x;
			prevYs = bufferYs.copy();
		}

		return res;
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
