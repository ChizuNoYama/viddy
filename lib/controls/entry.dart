import 'package:flutter/material.dart';

class Entry extends StatefulWidget{
  Entry({this.onSubmitted, this.onChanged, this.isSecretText = false, bool this.hasSubmitIcon = false});

  final Function(String)? onSubmitted;
  final Function(String)? onChanged;
  final bool hasSubmitIcon;
  final bool isSecretText;
  final TextEditingController _controller = new TextEditingController();

  @override
  State<StatefulWidget> createState() => EntryState();
}

class EntryState extends State<Entry>{
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  
  Widget? showSuffixIcon(){
    if(this.widget.onSubmitted == null){
      return SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
        this.widget.onSubmitted!(this.widget._controller.text);
        this.widget._controller.clear();
      },
      child: Icon(
        Icons.send,
        size: 24.0
      )
    );
  }

  Widget build(BuildContext context) {
    return TextField(
      controller: this.widget._controller,
      textAlignVertical: TextAlignVertical.center,
      maxLines: this.widget.isSecretText ? 1 : null,
      obscureText: this.widget.isSecretText,
      decoration: InputDecoration(
        suffixIcon: this.showSuffixIcon(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
      ),
      onChanged: (text){
        if(this.widget.onChanged == null || text.length == 0){
          return;
        }
        this.widget.onChanged!(text);
      },
    );
  
  }
}