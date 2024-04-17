import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter/tflite_flutter.dart';

class MlModel {
  late final Interpreter interpreter;

  // Creates a singleton.
  factory MlModel() => _shared;

  static final MlModel _shared = 
      MlModel._sharedInstance();

  MlModel._sharedInstance();

  Future<void> initializeModel() async {
    interpreter = await tfl.Interpreter.fromAsset('assets/model/MLModel.tflite');
  }

  List run(List input, int numOfTasks) {
    //shape eg (5, 4) --> 5 tasks, 4 categories
    // For ex: if input tensor shape [1,5] and type is float32
    // var input = [[2, 6, 4, 8], [4,1,7,5],[2,3,1,2],[9,3,3,4], [3,2,8,5]];

    // if output tensor shape [1,2] and type is float32
    var output = List.filled(numOfTasks, 0).reshape([numOfTasks, 1]);

    // inference
    interpreter.run(input, output);

    // return the output
    return output;
  }
}