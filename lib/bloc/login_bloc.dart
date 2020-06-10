import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/model/login.dart';
import 'package:flutter_info_app/repository/login_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository;
  final Storage _storage;

  LoginBloc(this._repository, this._storage);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    yield LoginLoadingState(true);
    try {
      final token = await _repository.login(Login(event.email, event.password));
      await _storage.save(token);
      yield LoginLoadingState(false);
      yield LoginSuccessState();
    } catch (error) {
      yield LoginFailureState(false, error.toString());
    }
  }

  @override
  LoginState get initialState => LoginLoadingState(false);
}

class LoginEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

abstract class LoginState {}

class LoginLoadingState extends LoginState {
  final bool isLoading;

  LoginLoadingState(this.isLoading);
}

class LoginSuccessState extends LoginState {
}

class LoginFailureState extends LoginState {
  final bool isLoading;
  final String error;

  LoginFailureState(this.isLoading, this.error);
}
