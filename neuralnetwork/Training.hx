package neuralnetwork;

class Training {
	public static function generateFromParent(parent:NeuralNetwork, randomRange:Float, children:Int):Array<NeuralNetwork> {
		var kids:Array<NeuralNetwork> = [parent.clone()];
		for (i in 0...children) {
			var child:NeuralNetwork = parent.clone();
			for (layer in child.layers) {
				if (!layer.inputLayer) {
					for (neuron in layer.neuronGroup) {
						neuron.bias += randomRange * ((Math.random() - 0.5) * 2);
						for (weight in 0...neuron.weights.length) {
							neuron.weights[weight] += randomRange * ((Math.random() - 0.5) * 2);
						}
					}
				}
			}
			child.outputActivationFunction = parent.outputActivationFunction;
			kids.push(child);
		}
		return kids;
	}
}
