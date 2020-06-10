import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_info_app/common/storage.dart';
import 'package:flutter_info_app/repository/profile_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProfileRepository _repository;
  final Storage _storage;

  HomeBloc(this._repository, this._storage);

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeLoadProfileEvent) {
      yield HomeLoadingState(true);
      try {
        final profile = await _repository.getProfile();
        _storage.profile = profile;
        yield HomeLoadingState(false);
        yield ProfileSuccessState();
      } catch (error) {
        yield ProfileFailureState(false, error.toString());
      }
    } else if (event is HomeSelectedStubEvent) {
      yield HomeSelectedStubState(event.index);
    }
  }

  @override
  HomeState get initialState => HomeLoadingState(false);
}

abstract class HomeEvent {}

class HomeLoadProfileEvent extends HomeEvent {}

class HomeSelectedStubEvent extends HomeEvent {
  final int index;

  HomeSelectedStubEvent(this.index);
}

abstract class HomeState {}

class HomeSignOutEvent {}

class HomeLoadingState extends HomeState {
  final bool isLoading;

  HomeLoadingState(this.isLoading);
}

class HomeSelectedStubState extends HomeState {
  final int index;

  HomeSelectedStubState(this.index);
}

class ProfileSuccessState extends HomeState {}

class ProfileFailureState extends HomeState {
  final bool isLoading;
  final String error;

  ProfileFailureState(this.isLoading, this.error);
}
