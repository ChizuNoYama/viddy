import 'package:flutter_bloc/flutter_bloc.dart';

class UserSearchCubit extends Cubit<bool>{
  UserSearchCubit(super.initialState);

  void toggleIsSearchingUsers() =>  this.emit(!state);

}