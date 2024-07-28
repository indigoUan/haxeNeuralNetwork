package;

import sys.io.File;
import neuralnetwork.NeuralNetwork;

class Test {
	public static function main():Void {
		var og:NeuralNetwork = new NeuralNetwork([100, 80, 80, 80, 1]);
		var clone1:NeuralNetwork = og.clone();
		var clone2:NeuralNetwork = clone1.clone();
		var clone3:NeuralNetwork = clone2.clone();
		var clone4:NeuralNetwork = clone3.clone();

		File.saveContent("parent.json", og.toJSON(true));
		File.saveContent("clone1.json", clone1.toJSON(true));
		File.saveContent("clone2.json", clone2.toJSON(true));
		File.saveContent("clone3.json", clone3.toJSON(true));
		File.saveContent("clone4.json", clone4.toJSON(true));
	}
}
