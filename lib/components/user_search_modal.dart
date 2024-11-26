import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/protocols/userProtocol.dart';

class AnimatedUsersSearchModal extends StatelessWidget{

  Widget presentUserList(AsyncSnapshot<List<String>> snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){
      return CircularProgressIndicator(color: Colors.purple[400]);
    }
    else{
      if(!snapshot.hasData || snapshot.data == null){
        return Center(
          child: Text("Search for users"),
        );
      }
      else{
        return Center(child: Text(snapshot.data![0]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: true, 
        child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 600),
          curve: Curves.easeOutExpo,
          tween: Tween<Offset>(
            begin: Offset(0.0, MediaQuery.sizeOf(context).height), 
            end: Offset(0.0, 0.0)),
          builder: (context, offset, child) => Transform.translate(
            offset: offset,
            child: Column(
              children: [
                Row(
                  children: [
                    BackButton(onPressed: null), // TOD: Close the Modal
                  ],
                ),
                Container(
                  color: Colors.black,
                  height: 1
                ),
                FutureBuilder(
                  future: Provider.of<UserProtocol>(context, listen: false).getListOfUsersAsync(),
                  builder: (context, snapshot) => Center(
                    child:  presentUserList(snapshot)
                  )
                )
              ],
            )
          )
        )
      )
    );
  }
}