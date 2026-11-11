// ============================================================================
// SESSION STORAGE SERVICE (Penyimpanan Sementara Dalam Memori Aplikasi)
// Data tersimpan selama aplikasi belum ditutup / di-restart.
// ============================================================================

/// Model data akun yang didaftarkan oleh user
class RegisteredUser {
  final String email;
  final String password;
  final String role; // 'claimer' | 'resto'
  final String name;
  final String? phone;
  final String? category;
  final String? address;

  const RegisteredUser({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
    this.phone,
    this.category,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'name': name,
      'phone': phone,
      'category': category,
      'address': address,
    };
  }

  factory RegisteredUser.fromMap(Map<String, dynamic> map) {
    return RegisteredUser(
      email: map['email'] as String? ?? '',
      password: map['password'] as String? ?? '',
      role: map['role'] as String? ?? 'claimer',
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String?,
      category: map['category'] as String?,
      address: map['address'] as String?,
    );
  }
}

/// Implementasi sessionStorage in-memory
class SessionStorage {
  static final Map<String, dynamic> _storage = {};

  static void setItem(String key, dynamic value) {
    _storage[key] = value;
  }

  static dynamic getItem(String key) {
    return _storage[key];
  }

  static void removeItem(String key) {
    _storage.remove(key);
  }

  static void clear() {
    _storage.clear();
  }

  static bool containsKey(String key) {
    return _storage.containsKey(key);
  }

  static Map<String, dynamic> getAll() {
    return Map.unmodifiable(_storage);
  }
}

/// Helper Otentikasi Berbasis SessionStorage
class RebiteAuthSession {
  // Akun Default
  static const String defaultClaimerEmail = 'admin@rebite.com';
  static const String defaultClaimerPassword = '12345678';

  static const String defaultRestoEmail = 'adminResto@rebite.com';
  static const String defaultRestoPassword = '12345678';

  static const String _usersListKey = 'rebite_registered_users_list';

  /// Inisialisasi daftar user bawaan jika belum ada
  static void _ensureInitialized() {
    if (!SessionStorage.containsKey(_usersListKey)) {
      final initialUsers = <String, Map<String, dynamic>>{
        defaultClaimerEmail.toLowerCase(): const RegisteredUser(
          email: defaultClaimerEmail,
          password: defaultClaimerPassword,
          role: 'claimer',
          name: 'Admin Claimer Demo',
          phone: '081234567890',
        ).toMap(),
        defaultRestoEmail.toLowerCase(): const RegisteredUser(
          email: defaultRestoEmail,
          password: defaultRestoPassword,
          role: 'resto',
          name: 'Admin Resto Demo',
          category: 'Restoran / Rumah Makan',
          address: 'Jl. Pemuda No. 10, Medan',
        ).toMap(),
      };
      SessionStorage.setItem(_usersListKey, initialUsers);
    }
  }

  /// Pendaftaran User Baru ke sessionStorage
  static bool registerUser(RegisteredUser user) {
    _ensureInitialized();
    final usersMap = Map<String, dynamic>.from(
      SessionStorage.getItem(_usersListKey) as Map? ?? {},
    );

    final cleanEmail = user.email.trim().toLowerCase();
    usersMap[cleanEmail] = user.toMap();
    SessionStorage.setItem(_usersListKey, usersMap);

    // Simpan juga secara individual
    SessionStorage.setItem('user_$cleanEmail', user.toMap());
    return true;
  }

  /// Mengecek apakah email sudah terdaftar
  static bool isEmailRegistered(String email) {
    _ensureInitialized();
    final usersMap = Map<String, dynamic>.from(
      SessionStorage.getItem(_usersListKey) as Map? ?? {},
    );
    return usersMap.containsKey(email.trim().toLowerCase());
  }

  /// Validasi Login (Mendukung Akun Default & Akun Baru dari sessionStorage)
  static bool validateLogin(String email, String password, {String? role}) {
    _ensureInitialized();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    // 1. Cek dari sessionStorage
    final usersMap = Map<String, dynamic>.from(
      SessionStorage.getItem(_usersListKey) as Map? ?? {},
    );

    if (usersMap.containsKey(cleanEmail)) {
      final userData = Map<String, dynamic>.from(usersMap[cleanEmail] as Map);
      final registeredUser = RegisteredUser.fromMap(userData);

      if (registeredUser.password == cleanPassword) {
        if (role == null || registeredUser.role == role) {
          SessionStorage.setItem('current_logged_user', registeredUser.toMap());
          return true;
        }
      }
    }

    // 2. Fallback cek hardcoded default jika belum ada di list
    if (role == 'resto' || role == null) {
      if (cleanEmail == defaultRestoEmail.toLowerCase() && cleanPassword == defaultRestoPassword) {
        return true;
      }
    }
    if (role == 'claimer' || role == null) {
      if (cleanEmail == defaultClaimerEmail.toLowerCase() && cleanPassword == defaultClaimerPassword) {
        return true;
      }
    }

    return false;
  }

  /// Mengambil data user berdasarkan email
  static RegisteredUser? getUser(String email) {
    _ensureInitialized();
    final cleanEmail = email.trim().toLowerCase();
    final usersMap = Map<String, dynamic>.from(
      SessionStorage.getItem(_usersListKey) as Map? ?? {},
    );

    if (usersMap.containsKey(cleanEmail)) {
      final userData = Map<String, dynamic>.from(usersMap[cleanEmail] as Map);
      return RegisteredUser.fromMap(userData);
    }
    return null;
  }
}
