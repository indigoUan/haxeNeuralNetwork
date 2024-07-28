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

typedef Neuron = {
	weights:Array<Float>,
	bias:Float,
	activationFunction:ActivationMethod
}
