package;

import neuralnetwork.NeuralNetwork;

class Test {
	public static function main():Void {
		var network:NeuralNetwork = new NeuralNetwork([2, 3, 3, 1]);
		var json:String = network.toJSON(true);
		var loden:NeuralNetwork = NeuralNetwork.fromJSON(json);

		trace("original.json", json);
		trace("clone.json", loden.toJSON(true));
	}
}
