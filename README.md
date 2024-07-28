# How to use haxeNeuralNetwork
## Creating a blank NeuralNetwork
Once you include the library in your project, you can create a new network with
```haxe
var network:neuralnetwork.NeuralNetwork = new neuralnetwork.NeuralNetwork(array);
```
where `array` is an array of integers, where each integer represent a layer and its size.  
For instance, `[2, 3, 3, 1]` will have `2` (called "Input Size") input neurons, one `3`-neuron layer, another `3`-neuron layer, and finally a `1`-neuron (called "Output Size") output layer.  
  
Then you can call `network.process` passing a `Float` array of with a size euqual to Input Size, and it will return a `Float` array with a size equal to Output Size.  
## Creating a NeuralNetwork from JSON data
The class `neuralnetwork.NeuralNetwork` has a public static function named `fromJSON` which takes as argument one String value containing (hopefully) JSON data for the network's neurons.  
```haxe
var network:neuralnetwork.NeuralNetwork = neuralnetwork.NeuralNetwork.fromJSON(json_string_here);
```
## Creating JSON data from a NeuralNetwork instance
You can convert an existing `neuralnetwork.NeuralNetwork` instance to a JSON string by calling its `toJSON` method.  
```haxe
var json:String = network.toJSON();
```
`toJSON` may also take one boolean argument (defaulting to `false`), which tells whether the JSON string should be pretty-printed or not.  
## Creating a NeuralNetwork by cloning
A `neuralnetwork.NeuralNetwork` instance has a public method named `clone` which will return a perfect copy of that instance.  
```haxe
var clone:neuralnetwork.NeuralNetwork = network.clone();
```
# Training
## Creating a group of children from one NeuralNetwork with random mutations
As of the 28th July 2024, the package `neuralnetwork.training` only has the class `Neuroevolution` with the function `createChildren`, which takes as arguments `parent:NeuralNetwork`, `offspring:Int`, `biasMutationThreshold:Float`, `weightMutationThreshold:Float`.  
It returns an array of `neuralnetwork.NeuralNetwork` instances based on the arguments passed.  
### Arguments
`parent` is the NeuralNetwork you want to reproduce;  
`offspring` is the amont of NeuralNetworks you want to make;  
`biasMutationThreshold` is the range within which random mutation can affect a neuron's bias;  
`weightMutationThreshold` is the range within which random mutation can affect a neuron's weights;  
