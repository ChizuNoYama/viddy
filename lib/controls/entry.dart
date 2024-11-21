import 'package:flutter/material.dart';

// class Entry extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => EntryState();
// }

class Entry extends StatelessWidget{
  Entry({this.onFinished, this.isSecretText = false, this.shouldResetTextOnFinish = false});

  final Function(String)? onFinished;
  final TextEditingController _controller = new TextEditingController();
  final bool isSecretText;
  final shouldResetTextOnFinish;

  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: this.isSecretText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
      ),
      onTapOutside: (event){
        if(this.onFinished != null){
          this.onFinished!(_controller.text);
        }
      },
      onSubmitted: (value){
        if(this.shouldResetTextOnFinish){
          _controller.text = "";
        }
        if(onFinished == null){
          return;
        }
        this.onFinished!(value);
        // Dismiss the keyboard
      }
    );
  }
}