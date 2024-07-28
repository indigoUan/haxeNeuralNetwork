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

class NetworkGraphic {
	public var network:NeuralNetwork;

	public function new(network:NeuralNetwork) {
		this.network = network;
	}

	public function getPlot():NeuralNetworkGraphical {
		var res:NeuralNetworkGraphical = {
			lines: new Array(),
			dots: new Array()
		};

		var widthSpace:Float = 1 / network.layers.length;
		var prevX:Float = 0;
		var prevYs:Array<Float> = [];
		var bufferYs:Array<Float> = [];
		for (layer in 0...network.layers.length) {
			var heightSpace:Float = 1 / network.layers[layer].neurons.length;
			var x:Float = widthSpace * layer;
			for (neuron in 0...network.layers[layer].neurons.length) {
				var y:Float = heightSpace * neuron;
				bufferYs.push(y);

				for (Y in 0...prevYs.length) {
					res.lines.push({ x1: prevX, y1: prevYs[Y], x2: x, y2: y, value: network.layers[layer].neurons[neuron].weights[Y] });
				}
				res.dots.push({ x: x, y: y, value: network.layers[layer].neurons[neuron].bias });
			}
			prevX = x;
			prevYs = bufferYs.copy();
		}

		return res;
	}
}
