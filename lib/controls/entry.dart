import 'package:flutter/material.dart';

// class Entry extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() => EntryState();
// }

class Entry extends StatelessWidget{
  Entry({this.onSubmitted, this.onChanged, this.isSecretText = false, this.shouldResetTextOnFinish = false});

  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
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
      onChanged: (text){
        if(this.onChanged == null){
          return;
        }
        this.onChanged!(text);
      },
      onSubmitted: (value){
        if(this.shouldResetTextOnFinish){
          _controller.text = "";
        }
        if(onSubmitted == null){
          return;
        }
        this.onSubmitted!(value);
        // Dismiss the keyboard
      }
    );
  }
}