package neuralnetwork;

class HaxeAiMath {
    public static function dot(a:Array<Float>, b:Array<Float>):Float {
        var result:Float = 0;

        for (i in 0...a.length) {
            for (j in 0...b.length) {
                result += a[i] * b[j];
            }
        }

        return result;
    }

    public static function arraySum(array:Array<Float>):Float {
        var result:Float = 0;
        for (i in array) {
            result += i;
        }
        return result;
    }
}
