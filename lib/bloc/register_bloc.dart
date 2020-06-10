import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/model/profile.dart';
import 'package:flutter_info_app/repository/register_repository.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _repository;
  final Storage _storage;

  RegisterBloc(this._repository, this._storage);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    yield RegisterLoadingState(true);
    try {
      final token = await _repository.register(Profile(
          event.name, event.email, event.password, event.gender, event.age));
      await _storage.save(token);
      yield RegisterLoadingState(false);
      yield RegisterSuccessState();
    } catch (error) {
      yield RegisterFailureState(false, 'ERR');
    }
  }

  @override
  RegisterState get initialState => RegisterLoadingState(false);
}

class RegisterEvent {
  final String name;
  final String email;
  final String password;
  final int gender;
  final int age;

  RegisterEvent(this.name, this.email, this.password, this.gender, this.age);
}

abstract class RegisterState {}

class RegisterLoadingState extends RegisterState {
  final bool isLoading;

  RegisterLoadingState(this.isLoading);
}

class RegisterSuccessState extends RegisterState {}

class RegisterFailureState extends RegisterState {
  final bool isLoading;
  final String error;

  RegisterFailureState(this.isLoading, this.error);
}
