package neuralnetwork.training;

class Neuroevolution {
	public static function createChildren(parent:NeuralNetwork, offspring:Int, biasMutationThreshold:Float, weightMutationThreshold:Float):Array<NeuralNetwork> {
		var children:Array<NeuralNetwork> = new Array();

		for (i in 0...offspring) {
			var child:NeuralNetwork = new NeuralNetwork(@:privateAccess parent.givenLayerSizes);
			for (l in 0...parent.length) {
				for (n in 0...parent[l].length) {
					child[l][n].activationFunction = parent[l][n].activationFunction;
					child[l][n].bias = parent[l][n].bias + (Math.random() - 0.5) * 2 * biasMutationThreshold;
					child[l][n].weights = parent[l][n].weights.copy();
					for (w in 0...child[l][n].weights.length) {
						child[l][n].weights[w] += (Math.random() - 0.5) * 2 * weightMutationThreshold;
					}
				}
			}
		}

		return children;
	}
}
