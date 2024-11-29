import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'package:viddy/core/assumptions.dart';
import 'package:viddy/models/user.dart';

class UserSearchCubit extends Cubit<List<User>?>{
  UserSearchCubit(super.initialState);

  Future<void> getListOfUsersAsync(String currentUserID) async{
    print("*getListOfUsers()* is being called");
    List<User> listOfUsers = List.empty(growable: true);
    
    List<Map<String, dynamic>> response = await supa.Supabase.instance.client.from("Users").select("${Assumptions.ID_KEY}, ${Assumptions.USER_NAME_KEY}");
    response.forEach((map) {
      User resUser = User.toAppModel(map);
      if(resUser.userId != currentUserID){
        listOfUsers.add(resUser);
      }
    });

    emit(listOfUsers);
  }
}