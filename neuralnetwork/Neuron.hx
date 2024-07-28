package neuralnetwork;

enum ActivationFunction {
	Linear;
	ReLU(minimum:Float);
	Sigmoid;
	TanH;
	LeakyReLU(leakiness:Float);
	ELU(alpha:Float);
	Swish(beta:Float);
}

class ActivationFunctionUtil {
	public static function fromInt(method:Int, argument:Float):ActivationFunction {
		return switch (method) {
			default: Linear;
			case 1: ReLU(argument);
			case 2: Sigmoid;
			case 3: TanH;
			case 4: LeakyReLU(argument);
			case 5: ELU(argument);
			case 6: Swish(argument);
		}
	}

	public static function toInt(af:ActivationFunction):{ method:Int, argument:Float } {
		return switch (af) {
			case Linear:				{ method: 0, argument: 0 }
			case ReLU(minimum):			{ method: 1, argument: minimum }
			case Sigmoid:				{ method: 2, argument: 0 }
			case TanH:					{ method: 3, argument: 0 }
			case LeakyReLU(leakiness):	{ method: 4, argument: leakiness }
			case ELU(alpha):			{ method: 5, argument: alpha }
			case Swish(beta):			{ method: 6, argument: beta }
		}
	}
}

typedef Neuron = {
	weights:Array<Float>,
	bias:Float,
	activationFunction:ActivationFunction
}
