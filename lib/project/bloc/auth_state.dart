import 'package:equatable/equatable.dart';

// Барлық auth күйлерінің ата-класы
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// Әлі ештеңе болған жоқ
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Тексеріп жатыр (спиннер көрсетеміз)
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Кіру сәтті өтті
class AuthSuccess extends AuthState {
  final String username;
  final String email;

  const AuthSuccess(this.username, this.email);

  @override
  List<Object> get props => [username, email];
}

// Қате: email немесе пароль дұрыс емес
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
