import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../models/epoka_user.dart';
import '../../utils/user_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final _repository = UserRepository();

  @override
  AuthenticationState get initialState => AuthenticationState.initial();

  void onSignIn() {
    this.dispatch(SignInEvent());
  }

  void onSignOut() {
    this.dispatch(SignOutEvent());
  }

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is SignInEvent) {
      EpokaUser _user = await _repository.signIn();

      print('User: $_user');

      if (_user != null) {
        yield AuthenticationState.success(_user);
      } else {
        yield AuthenticationState.failure();
      }
    } else if (event is SignOutEvent) {
      _repository.signOut();
      yield AuthenticationState.initial();
    }
  }
}