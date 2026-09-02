import 'package:equatable/equatable.dart';

/// A user-safe description of something that went wrong. Repositories translate
/// low-level exceptions (network, platform, backend) into one of these so the
/// UI can render a graceful state without leaking internals.
sealed class Failure extends Equatable {
  const Failure(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, runtimeType];
}

class NetworkFailure extends Failure {
  const NetworkFailure({Object? cause})
      : super('No internet connection. Check your network and try again.',
            cause: cause);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.cause});
}

class PermissionFailure extends Failure {
  const PermissionFailure(super.message, {super.cause});
}

class ImageQualityFailure extends Failure {
  const ImageQualityFailure(super.message, {super.cause});
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message, {super.cause});
}

class ServerFailure extends Failure {
  const ServerFailure({Object? cause})
      : super('Something went wrong on our side. Please try again shortly.',
            cause: cause);
}

class UnknownFailure extends Failure {
  const UnknownFailure({Object? cause})
      : super('Unexpected error. Please try again.', cause: cause);
}
