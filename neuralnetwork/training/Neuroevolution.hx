package neuralnetwork.training;

class Neuroevolution {
	public static function createChildren(parent:NeuralNetwork, offspring:Int, biasMutationThreshold:Float, weightMutationThreshold:Float):Array<NeuralNetwork> {
		var children:Array<NeuralNetwork> = new Array();

		for (i in 0...offspring) {
			var child:NeuralNetwork = new NeuralNetwork(@:privateAccess parent.givenLayerSizes);
			for (l in 0...parent.layers.length) {
				for (n in 0...parent.layers[l].neurons.length) {
					child.layers[l].neurons[n].activationFunction = parent.layers[l].neurons[n].activationFunction;
					child.layers[l].neurons[n].bias = parent.layers[l].neurons[n].bias + (Math.random() - 0.5) * 2 * biasMutationThreshold;
					child.layers[l].neurons[n].weights = parent.layers[l].neurons[n].weights.copy();
					for (w in 0...child.layers[l].neurons[n].weights.length) {
						child.layers[l].neurons[n].weights[w] += (Math.random() - 0.5) * 2 * weightMutationThreshold;
					}
				}
			}
		}

		return children;
	}
}
