// signup_state.dart
import 'package:equatable/equatable.dart';

enum SignupStatus { initial, loading, success, failure }

class SignupState extends Equatable {
  final SignupStatus status;
  final String? errorMessage;
  final String mobile;
  const SignupState({
    this.status = SignupStatus.initial,
    this.errorMessage,
    this.mobile = "",
  });

  SignupState copyWith({
    SignupStatus? status,
    String? errorMessage,
    String? mobile,
  }) {
    return SignupState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      mobile: mobile ?? this.mobile,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
