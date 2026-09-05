import 'package:equatable/equatable.dart';

/// The authenticated user. `isAnonymous` covers "explore before signing up"
/// (product spec §24) — those users can scan but their data is device-local
/// until they upgrade to a real account.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.isAnonymous,
    this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  final String id;
  final bool isAnonymous;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  String get initials {
    final source = (displayName?.trim().isNotEmpty ?? false)
        ? displayName!.trim()
        : (email ?? '?');
    final parts =
        source.split(RegExp(r'[ @._-]')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }

  AppUser copyWith({String? email, String? displayName, String? photoUrl}) {
    return AppUser(
      id: id,
      isAnonymous: isAnonymous,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
    );
  }

  @override
  List<Object?> get props => [id, isAnonymous, email, displayName, photoUrl];
}
