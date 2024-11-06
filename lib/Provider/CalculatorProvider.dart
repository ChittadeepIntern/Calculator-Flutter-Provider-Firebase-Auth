import 'package:flutter/material.dart';
import 'package:function_tree/function_tree.dart';

class CalculatorProvider extends ChangeNotifier {
  final textEditingController = TextEditingController();

//called whenever any button of the calculator is pressed
  void setValue(String value) {
    switch (value) {
      case "C":
        textEditingController.clear();
        break;
      case "AC":
        textEditingController.text = textEditingController.text
            .substring(0, textEditingController.text.length - 1);
        break;
      case "+":
        textEditingController.text += "+";
        break;
      case "-":
        textEditingController.text += "-";
        break;
      case "*":
        textEditingController.text += "*";
        break;
      case "/":
        textEditingController.text += "/";
        break;
      case "%":
        textEditingController.text += "%";
        break;
      case "=":
        textEditingController.text =
            textEditingController.text.interpret().toString();
        break;
      default:
        textEditingController.text += value;

        notifyListeners();
    }

//code to set the cursor to the end after writing anything in the text field
    textEditingController.selection = TextSelection.fromPosition(
        TextPosition(offset: textEditingController.text.length));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
