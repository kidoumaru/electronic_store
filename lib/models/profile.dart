/// Model profile user.
///
/// Data ini berasal dari tabel public.profiles,
/// bukan langsung dari auth.users.
class Profile {
  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String? address;
  final String? avatarUrl;
  final String role;

  const Profile({
    required this.id,
    required this.fullName,
    this.email,
    this.phone,
    this.address,
    this.avatarUrl,
    required this.role,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'] as String,
      fullName: (map['full_name'] as String?) ?? '',
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      address: map['address'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      role: (map['role'] as String?) ?? 'customer',
    );
  }

  bool get isAdmin => role == 'admin';

  bool get isCustomer => role == 'customer';
}
