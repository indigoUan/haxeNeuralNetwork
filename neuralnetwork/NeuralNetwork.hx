package neuralnetwork;

enum ActivationMethod {
    Linear;
    ReLU(minimum:Float);
    Sigmoid;
    TanH;
    LeakyReLU(leakiness:Float);
    ELU(alpha:Float);
    Swish(beta:Float);
}

enum OutputActivationMethod {
    Linear;
    Softmax;
}

class NeuralNetwork {
    public var layers:Array<Layer> = [];

    public var outputActivationFunction:OutputActivationMethod = Linear;

    public function new(inputsQuantity:Int, hiddenLayersSize:Int, hiddenLayersQuantity:Int, outputsQuantity:Int) {
        // input layer 
        layers.push(new Layer(true, inputsQuantity, inputsQuantity));

        // input-to-hidden hidden layer 
        layers.push(new Layer(false, inputsQuantity, hiddenLayersSize));

        // hidden layers 
        for (i in 0...hiddenLayersQuantity - 1) {
            layers.push(new Layer(false, hiddenLayersSize, hiddenLayersSize));
        }

        // hidden-to-output output layer 
        layers.push(new Layer(false, hiddenLayersSize, outputsQuantity));
    }

    public function execute(inputs:Array<Float>):Array<Float> {
        if (inputs.length > layers[0].inputs) throw "too many inputs";
        if (inputs.length < layers[0].inputs) throw "not enough inputs";

        for (i in layers) {
            inputs = i.forward(inputs);
        }

        return activate(inputs);
    }

    private function activate(inputs:Array<Float>):Array<Float> {
        switch (outputActivationFunction) {
            case Linear: {
                return inputs;
            }
            case Softmax: {
                var exponentiated:Array<Float> = [];
                for (i in inputs) {
                    exponentiated.push(Math.exp(i));
                }
        
                var normalBase:Float = HaxeAiMath.arraySum(exponentiated);
                var normalValues:Array<Float> = [];
                
                for (i in exponentiated) {
                    normalValues.push(i / normalBase);
                }
        
                return normalValues;
            }
        }
    }

	public function clone():NeuralNetwork {
		return fromJSON(toJSON(this, ""));
	}

    public static function toJSON(network:NeuralNetwork, space:String = "\t"):String {
        var arr:Array<Array<{ weights:Array<Float>, bias:Float }>> = [];
        @:privateAccess {
            for (layer in network.layers) {
                var l:Array<{ weights:Array<Float>, bias:Float }> = [];
                for (neuron in layer.neuronGroup) {
                    l.push({ weights: neuron.weights, bias: neuron.bias });
                }
                arr.push(l);
            }
        }
        return haxe.Json.stringify({ layers: arr }, space);
    }

    public static function fromJSON(json:String):Null<NeuralNetwork> {
        var brain:Null<NeuralNetwork> = null;
        var arr:Array<Array<{ weights:Array<Float>, bias:Float }>> = [];
        try {
            arr = haxe.Json.parse(json).layers;
        } catch (e) { arr = []; }
        if (arr.length > 0) {
            brain = new NeuralNetwork(arr[0].length, arr[1].length, arr.length - 2, arr[arr.length - 1].length);
            @:privateAccess {
                for (i in 0...arr.length) {
                    for (j in 0...arr[i].length) {
                        brain.layers[i].neuronGroup[j].weights = arr[i][j].weights;
                        brain.layers[i].neuronGroup[j].bias = arr[i][j].bias;
                    }
                }
            }
        }
        return brain;
    }
}

private class Layer {
    public var neuronGroup:Array<Neuron> = [];

    public var inputs:Int = -1;
    public var neurons:Int = -1;

    public var inputLayer:Bool = false;

    public function new(inputLayer:Bool, inputQuantity:Int, neuronsQuantity:Int) {
        this.inputLayer = inputLayer;
        inputs = inputQuantity;
        neurons = neuronsQuantity;
        for (i in 0...neuronsQuantity) {
            neuronGroup.push(new Neuron(inputLayer, inputQuantity));
        }
    }

    public function forward(inputs:Array<Float>):Array<Float> {
        if (inputLayer) { return inputs; }
        var outputs:Array<Float> = [];
        for (i in neuronGroup) {
            outputs.push(i.getOutput(inputs));
        }
        return outputs;
    }
}

private class Neuron {
    public var weights:Array<Float> = [];
    public var bias:Float = 0;

    public var activationFunction:ActivationMethod = ReLU(0.0);

    public function new(inputNeuron:Bool, inputCount:Int) {
        if (inputNeuron) {
            for (i in 0...inputCount) { weights.push(1); }
        } else {
            for (i in 0...inputCount) {
                weights.push((Math.random() - 0.5) * 2);
            }
            bias = Math.random() * 4;
        }
    }

    private function activate(value:Float):Float {
        switch (activationFunction) {
            case Linear: {
                return value;
            }
            case ReLU(minimum): {
                return Math.max(minimum, value);
            }
            case Sigmoid: {
                return 1.0 / (1.0 + Math.exp(-value));
            }
            case TanH: {
                var exp2x:Float = Math.exp(2 * value);
                return (exp2x - 1) / (exp2x + 1);
            }
            case LeakyReLU(leakiness): {
                return (value >= 0) ? value : leakiness * value;
            }
            case ELU(alpha): {
                return (value >= 0) ? value : alpha * (Math.exp(value) - 1);
            }
            case Swish(beta): {
                return value / (1 + Math.exp(-beta * value));
            }
        }
    }

    public function getOutput(inputs:Array<Float>):Float {
        var result:Float = 0;
        for (i in 0...inputs.length) {
            result += inputs[i] * weights[i];
        }
        result += bias;
        return activate(result);
    }
}
