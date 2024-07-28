package;

import sys.io.File;
import haxe.io.Bytes;
import neuralnetwork.NeuralNetwork;

class Test {
	public static function main():Void {
		var network:NeuralNetwork = new NeuralNetwork([2, 3, 3, 1]);
		var bytes:Bytes = network.serialize();
		var loden:NeuralNetwork = NeuralNetwork.deserialize(bytes);

		File.saveBytes("original.nnw", bytes);
		File.saveBytes("clone.nnw", loden.serialize());

		File.saveContent("original.json", network.toJSON());
		File.saveContent("clone.json", loden.toJSON());
	}
}
