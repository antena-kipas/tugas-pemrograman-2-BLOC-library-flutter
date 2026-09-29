import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    // Validasi input kosong
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const AuthFailure("Email dan Password harus diisi"));
      return;
    }

    emit(AuthLoading());

    // Simulasi loading/delay jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Dummy validasi sesuai instruksi praktikum
    if (event.email == 'praktikum@gmail.com' && event.password == '12345678') {
      emit(AuthSuccess());
    } else {
      emit(const AuthFailure("Email atau password salah!"));
    }
  }
}