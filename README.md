# How to use Network
## Creating a blank Network
Once you include the library in your project, you can create a new network with
```haxe
  // feel free to set your own numbers and names (please for the love of god do not use these long-ass names) 
  var quantity_of_numbers_you_wanna_feed_it:Int = 2;
  var quantity_of_layers:Int = 4;
  var quantity_of_neurons_per_layers:Int = 3;
  var quantity_of_numbers_you_want_it_to_return:Int = 1;

  var network:neuralnetwork.NeuralNetwork = new neuralnetwork.NeuralNetwork(quantity_of_numbers_you_wanna_feed_it, quantity_of_layers, quantity_of_neurons_per_layers, quantity_of_numbers_you_want_it_to_return);
```
Then you can call `network.execute` passing a Float array of `quantity_of_numbers_you_wanna_feed_it` size and it will return a Float array of `quantity_of_numbers_you_want_it_to_return` size.
## Creating a Network from JSON data
The class `neuralnetwork.NeuralNetwork` has a public static function named `fromJSON` which takes as argument one String value containing (hopefully) JSON data for the Network's neurons.  
You can convert an existing `neuralnetwork.NeuralNetwork` instance to a JSON string with the `neuralnetwork.NeuralNetwork.toJSON` method.
## Creating a Network by cloning
A `neuralnetwork.NeuralNetwork` instance has a public method named `clone` which will return a perfect copy of that instance.  
Not sure in what instances you might need that, but if you do, you're welcome.
# How to use Training
## Creating a group of children from one Network
As of 13 Jan 2024, the class `neuralnetwork.Training` only has the function `generateFromParent`, which takes as arguments `parent:NeuralNetwork, randomRange:Float, children:Int`.  
It returns an array of `neuralnetwork.NeuralNetwork` instances based on the arguments passed.  
`parent` is the Network you want to reproduce;  
`randomRange` is the range within which each neuron will alter its bias randomly;  
`children` is the amount of Networks you want to create.  
