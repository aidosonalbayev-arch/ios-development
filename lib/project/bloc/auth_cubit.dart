import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    // 1) Жүктелу күйі
    emit(const AuthLoading());

    // 2) Серверге сұраныс жібергендей 2 секунд күтеміз
    await Future.delayed(const Duration(seconds: 2));

    // 3) Тексеру
    if (email.trim() == 'student@narxoz.kz' && password == '123456') {
      emit(const AuthSuccess('Student', 'student@narxoz.kz'));
    } else {
      emit(const AuthError('Wrong email or password'));
    }
  }

  void logout() {
    emit(const AuthInitial());
  }
}
