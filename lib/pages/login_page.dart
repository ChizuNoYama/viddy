import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viddy/controls/entry.dart';
import 'package:viddy/pages/home_page.dart';
import 'package:viddy/protocols/userProtocol.dart';

class LoginPage extends StatelessWidget{

  Future<void> _loginOrRegisterUser(BuildContext context, UserProtocol userProtocol, {bool isNewUser = false}) async{
    bool success = await userProtocol.loginOrRegisterUser(isNewUser: isNewUser);
    if(success){
      Navigator.of(context).push(new MaterialPageRoute(builder: (context) => HomePage()));
    }
    else{
      showDialog(context: context, builder: (context) {
        return SimpleDialog(
          alignment: Alignment.center,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          children: [
            Text("User not found. Email or Password is incorrect. Try again."),
            SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Close"))
          ],
        );
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProtocol>(
        builder: (_, userProtocol, __) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Email"),
                SizedBox(width:0, height:16),
                Entry(onChanged: (text) => userProtocol.registerInfo.email = text), // Email
                SizedBox(width:0, height:16),
                Text("Password"),
                SizedBox(width:0, height:16),
                Entry(
                  isSecretText: true,
                  onChanged: (text) => userProtocol.registerInfo.password = text
                ), // Paswword
                SizedBox(width:0, height: 16),
                OutlinedButton(
                  onPressed: () async => await _loginOrRegisterUser(context, userProtocol, ),
                  child: Text("Login"),
                  
                ),
                Text("- or -"),
                SizedBox(width:0, height:16),
                OutlinedButton(
                  onPressed: (() async => _loginOrRegisterUser(context, userProtocol, isNewUser: true)),
                  child: Text("Register")
                )
              ],
            )
          )
        )
      )
    );
  }
}