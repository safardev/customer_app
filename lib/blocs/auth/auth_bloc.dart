import 'package:flutter_bloc/flutter_bloc.dart';


import 'auth.event.dart';
import 'auth_state.dart';




class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
  }

  void _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      if (event.email == 'user@maxmobility.in' && event.password == 'Abc@#123') {
        emit(AuthSuccess());
      } else {
        emit(const AuthFailure(error: 'Invalid email or password'));
      }
    } catch (e) {
      emit(const AuthFailure(error: 'An error occurred'));
    }
  }

}