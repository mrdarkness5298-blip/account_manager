class Account {
  String id;
  String email;
  String password;
  String country;
  
  SocialMedia xTwitter;
  SocialMedia facebook;
  SocialMedia instagram;
  SocialMedia linkedin;
  SocialMedia tiktok;

  Account({
    required this.id,
    required this.email,
    required this.password,
    required this.country,
    required this.xTwitter,
    required this.facebook,
    required this.instagram,
    required this.linkedin,
    required this.tiktok,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password, // Will be encrypted before storing
      'country': country,
      'xTwitter': xTwitter.toMap(),
      'facebook': facebook.toMap(),
      'instagram': instagram.toMap(),
      'linkedin': linkedin.toMap(),
      'tiktok': tiktok.toMap(),
    };
  }

  factory Account.fromMap(Map<String, dynamic> map, String id) {
    return Account(
      id: id,
      email: map['email'] ?? '',
      password: map['password'] ?? '', // Will be decrypted after reading
      country: map['country'] ?? '',
      xTwitter: SocialMedia.fromMap(map['xTwitter'] ?? {}),
      facebook: SocialMedia.fromMap(map['facebook'] ?? {}),
      instagram: SocialMedia.fromMap(map['instagram'] ?? {}),
      linkedin: SocialMedia.fromMap(map['linkedin'] ?? {}),
      tiktok: SocialMedia.fromMap(map['tiktok'] ?? {}),
    );
  }
}

class SocialMedia {
  String username;
  String password;

  SocialMedia({required this.username, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory SocialMedia.fromMap(Map<String, dynamic> map) {
    return SocialMedia(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }
}
