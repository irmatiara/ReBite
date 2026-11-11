import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'session_storage.dart';
import 'rebite_claimer_dashboard_map.dart' show RebiteClaimerDashboardMap;
import 'rebite_restaurant_dashboard.dart' show RebiteRestaurantDashboard;
import 'rebite_login.dart' show RebiteLoginPage;
import 'rebite_partner_login.dart' show RebitePartnerLoginPage;
import 'rebite_onboarding.dart' show RebiteOnboarding;

// ============================================================================
// 4. TEMA DAN PALET WARNA RESMI REBITE (Sesuai rebite_partner_claimer_signup.html)
// ============================================================================
const Color _kDarkBrown     = Color(0xFF2E2910); // --c-dark-brown: #2E2910
const Color _kBrunswick     = Color(0xFF2C5745); // --c-brunswick: #2C5745
const Color _kBrunswickDark = Color(0xFF1E3F32); // --c-brunswick-dark: #1E3F32
const Color _kTangerine     = Color(0xFFEB7D00); // --c-tangerine: #EB7D00
const Color _kVanilla       = Color(0xFFEBE3A7); // --c-vanilla: #EBE3A7
const Color _kVanillaSoft   = Color(0xFFFAF7E8); // --c-vanilla-soft: #FAF7E8
const Color _kBgLight       = Color(0xFFF7F5EB); // --c-bg-light: #F7F5EB
const Color _kWhite         = Color(0xFFFFFFFF); // --c-white: #FFFFFF
const Color _kTextMuted     = Color(0xFF6B654C); // --c-text-muted: #6B654C
const Color _kBorder        = Color(0xFFD8D0A8); // --c-border: #D8D0A8

// ============================================================================
// ENTRY POINT MANDIRI (Dapat Dijalankan Terpisah)
// ============================================================================
void main() {
  runApp(const RebiteSignupApp());
}

class RebiteSignupApp extends StatelessWidget {
  final String initialRole;

  const RebiteSignupApp({super.key, this.initialRole = 'claimer'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebite - Pendaftaran Mitra & Claimer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _kBgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _kBrunswick,
          primary: _kBrunswick,
          secondary: _kTangerine,
          surface: _kBgLight,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: RebitePartnerClaimerSignupPage(initialRole: initialRole),
    );
  }
}

// ============================================================================
// ALIAS KEMUDAHAN NAVIGASI: KHUSUS REGISTER MITRA & KHUSUS REGISTER CLAIMER
// ============================================================================
class RebitePartnerSignupPage extends StatelessWidget {
  const RebitePartnerSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RebitePartnerClaimerSignupPage(initialRole: 'resto');
  }
}

class RebiteClaimerSignupPage extends StatelessWidget {
  const RebiteClaimerSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RebitePartnerClaimerSignupPage(initialRole: 'claimer');
  }
}

// ============================================================================
// 1. STRUKTUR APLIKASI: StatelessWidget & Scaffold
// ============================================================================
class RebitePartnerClaimerSignupPage extends StatelessWidget {
  final String initialRole;

  const RebitePartnerClaimerSignupPage({
    super.key,
    this.initialRole = 'claimer',
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    return Scaffold(
      backgroundColor: const Color(0xFFE2DFD2), // Latar luar kanvas
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 520;
            final isLandscape = orientation == Orientation.landscape;

            return Center(
              child: Container(
                width: isDesktop ? 460 : double.infinity,
                height: isDesktop && !isLandscape ? 940 : double.infinity,
                decoration: BoxDecoration(
                  color: _kBgLight,
                  borderRadius: isDesktop ? BorderRadius.circular(24) : BorderRadius.zero,
                  border: isDesktop ? Border.all(color: _kBorder, width: 1) : null,
                  boxShadow: isDesktop
                      ? const [
                          BoxShadow(
                            color: Color(0x142E2910),
                            blurRadius: 48,
                            offset: Offset(0, 20),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: isDesktop ? BorderRadius.circular(24) : BorderRadius.zero,
                  child: Stack(
                    children: [
                      // Dekorasi Ambient Glow (.bg-decorations)
                      const IgnorePointer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: -100,
                              right: -80,
                              child: _AmbientDecorBlob(
                                size: 420,
                                color: Color(0x1FEB7D00), // rgba(235, 125, 0, 0.12)
                              ),
                            ),
                            Positioned(
                              bottom: -120,
                              left: -80,
                              child: _AmbientDecorBlob(
                                size: 480,
                                color: Color(0x1F2C5745), // rgba(44, 87, 69, 0.12)
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Tampilan Form Pendaftaran
                      PartnerClaimerSignupFormView(initialRole: initialRole),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// FORM UTAMA PENDAFTARAN DENGAN INTEGRASI SESSION STORAGE
// ============================================================================
class PartnerClaimerSignupFormView extends StatefulWidget {
  final String initialRole;

  const PartnerClaimerSignupFormView({
    super.key,
    required this.initialRole,
  });

  @override
  State<PartnerClaimerSignupFormView> createState() => _PartnerClaimerSignupFormViewState();
}

class _PartnerClaimerSignupFormViewState extends State<PartnerClaimerSignupFormView> {
  late String _selectedRole; // 'claimer' | 'resto'
  bool _obscurePassword = true;
  bool _acceptTerms = false;
  String? _errorMessage;

  // Controllers Khusus Claimer
  final TextEditingController _claimerNameController  = TextEditingController();
  final TextEditingController _claimerPhoneController = TextEditingController();

  // Controllers Khusus Restoran
  final TextEditingController _restoNameController    = TextEditingController();
  final TextEditingController _restoAddressController = TextEditingController();
  String _selectedCategory = 'Restoran / Rumah Makan';

  final List<String> _restoCategories = const [
    'Restoran / Rumah Makan',
    'Bakery & Toko Roti',
    'Jasa Katering',
    'Supermarket / Toko Buah',
    'Penyedia Pakan / Lainnya',
  ];

  // Controllers Bersama
  final TextEditingController _emailController    = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole == 'resto' ? 'resto' : 'claimer';
  }

  @override
  void dispose() {
    _claimerNameController.dispose();
    _claimerPhoneController.dispose();
    _restoNameController.dispose();
    _restoAddressController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Notifikasi Toast Kustom
  void _showCustomToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
        duration: const Duration(seconds: 3),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: _kDarkBrown,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kTangerine, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline_rounded, color: _kTangerine, size: 18),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    message,
                    style: GoogleFonts.plusJakartaSans(
                      color: _kVanilla,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Logika Pendaftaran User dengan sessionStorage
  void _handleSignup() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _errorMessage = null;
    });

    // Validasi Kolom Bersama
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Harap masukkan email akun.');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() => _errorMessage = 'Format email tidak valid.');
      return;
    }

    if (password.length < 8) {
      setState(() => _errorMessage = 'Kata sandi minimal 8 karakter.');
      return;
    }

    // Validasi Spesifik Peran
    if (_selectedRole == 'claimer') {
      final name = _claimerNameController.text.trim();
      final phone = _claimerPhoneController.text.trim();

      if (name.isEmpty) {
        setState(() => _errorMessage = 'Harap isi nama lengkap Anda.');
        return;
      }
      if (phone.isEmpty) {
        setState(() => _errorMessage = 'Harap isi nomor WhatsApp/HP.');
        return;
      }

      if (!_acceptTerms) {
        setState(() => _errorMessage = 'Harap setujui Syarat & Ketentuan.');
        return;
      }

      // Cek apakah email sudah terdaftar di sessionStorage
      if (RebiteAuthSession.isEmailRegistered(email)) {
        setState(() => _errorMessage = 'Email $email sudah terdaftar dalam sesi ini!');
        return;
      }

      // Simpan User Baru ke SessionStorage
      final newUser = RegisteredUser(
        email: email,
        password: password,
        role: 'claimer',
        name: name,
        phone: phone,
      );

      RebiteAuthSession.registerUser(newUser);

      _showCustomToast('Pendaftaran Claimer berhasil! Mengalihkan ke dashboard...');

      // Navigasi ke Dashboard Claimer dengan Navigator.push
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RebiteClaimerDashboardMap(),
          ),
        );
      });
    } else {
      // Peran: Mitra Restoran
      final restoName = _restoNameController.text.trim();
      final address = _restoAddressController.text.trim();

      if (restoName.isEmpty) {
        setState(() => _errorMessage = 'Harap isi nama restoran / toko.');
        return;
      }
      if (address.isEmpty) {
        setState(() => _errorMessage = 'Harap isi alamat lengkap usaha.');
        return;
      }

      if (!_acceptTerms) {
        setState(() => _errorMessage = 'Harap setujui Syarat & Ketentuan.');
        return;
      }

      // Cek apakah email sudah terdaftar di sessionStorage
      if (RebiteAuthSession.isEmailRegistered(email)) {
        setState(() => _errorMessage = 'Email $email sudah terdaftar dalam sesi ini!');
        return;
      }

      // Simpan Mitra Restoran Baru ke SessionStorage
      final newUser = RegisteredUser(
        email: email,
        password: password,
        role: 'resto',
        name: restoName,
        category: _selectedCategory,
        address: address,
      );

      RebiteAuthSession.registerUser(newUser);

      _showCustomToast('Pendaftaran Mitra Restoran berhasil! Mengalihkan ke dashboard...');

      // Navigasi ke Dashboard Mitra Restoran dengan Navigator.push
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const RebiteRestaurantDashboard(),
          ),
        );
      });
    }
  }

  // Navigasi ke Portal Login Sesuai Peran yang Dipilih
  void _navigateToLogin() {
    if (_selectedRole == 'resto') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RebitePartnerLoginPage(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RebiteLoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isResto = _selectedRole == 'resto';

    return ListView(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      children: [
        // ── 1. Hero Header Banner + Logo Mengambang (.hero-banner) ──
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            const _SignupHeroBanner(),
            Positioned(
              bottom: -44,
              child: _SignupLogoAvatar(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RebiteOnboarding(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // ── 2. Content Body Form Area (.content-body) ──
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Header
              Column(
                children: [
                  Text(
                    'CREATE YOUR ACCOUNT',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _kTangerine,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isResto ? 'Daftar Mitra Restoran' : 'Daftar sebagai Claimer',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _kDarkBrown,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Role Switcher (.role-switch-container) ──
              _SignupRoleSwitcher(
                selectedRole: _selectedRole,
                onRoleChanged: (role) {
                  setState(() {
                    _selectedRole = role;
                    _errorMessage = null;
                  });
                },
              ),

              const SizedBox(height: 20),

              // ── Informational Box (.info-box) ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _kVanillaSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border(
                    left: BorderSide(color: _kTangerine, width: 3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 18, color: _kTangerine),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isResto
                            ? 'Daftarkan usaha Anda untuk mengelola kuota surplus makanan, jadwalkan donasi homeless, atau distribusikan pakan ternak.'
                            : 'Dapatkan akses peta food bank terdekat, notifikasi diskon besar & makanan gratis, serta kesempatan sidejob antar makanan.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kDarkBrown,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Pesan Error Jika Validasi Gagal
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF5A3A0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Color(0xFFD32F2F), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFFB71C1C),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // ── KOLOM KHUSUS CLAIMER (#sectionClaimer) ──
              if (!isResto) ...[
                _SignupInputField(
                  label: 'Nama Lengkap',
                  hintText: 'Nama sesuai identitas',
                  controller: _claimerNameController,
                  prefixIcon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),
                _SignupInputField(
                  label: 'Nomor WhatsApp / HP',
                  hintText: '08123456789',
                  controller: _claimerPhoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                ),
                const SizedBox(height: 16),
              ],

              // ── KOLOM KHUSUS RESTORAN (#sectionResto) ──
              if (isResto) ...[
                _SignupInputField(
                  label: 'Nama Restoran / Toko',
                  hintText: 'Contoh: Dapur Kebajikan',
                  controller: _restoNameController,
                  prefixIcon: Icons.storefront_outlined,
                ),
                const SizedBox(height: 16),

                // Dropdown Kategori Usaha (.select-field)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KATEGORI USAHA',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: _kDarkBrown,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: _kWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _kBorder, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.description_outlined, color: _kTextMuted, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: const Icon(Icons.expand_more_rounded, color: _kTextMuted),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                  color: _kDarkBrown,
                                ),
                                items: _restoCategories.map((cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat,
                                    child: Text(cat),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _selectedCategory = value);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _SignupInputField(
                  label: 'Alamat Lengkap Usaha',
                  hintText: 'Jl. Sudirman No. 12, Medan',
                  controller: _restoAddressController,
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 16),
              ],

              // ── KOLOM BERSAMA (Email & Password) ──
              _SignupInputField(
                label: 'Email Akun',
                hintText: 'email@rebite.id',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),

              const SizedBox(height: 16),

              _SignupInputField(
                label: 'Kata Sandi',
                hintText: 'Minimal 8 karakter',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: _kTextMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),

              const SizedBox(height: 14),

              // ── Checkbox Syarat & Ketentuan (.terms-wrapper) ──
              InkWell(
                onTap: () {
                  setState(() => _acceptTerms = !_acceptTerms);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _acceptTerms ? _kBrunswick : _kWhite,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _acceptTerms ? _kBrunswick : _kBorder,
                          width: 2,
                        ),
                      ),
                      child: _acceptTerms
                          ? const Icon(Icons.check, size: 12, color: _kVanilla)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _kTextMuted,
                            height: 1.4,
                          ),
                          children: [
                            const TextSpan(text: 'Saya menyetujui '),
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                color: _kTangerine,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(text: ' serta Kebijakan Privasi Rebite.'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ── Tombol Submit Pendaftaran (.btn-submit) ──
              ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBrunswick,
                  foregroundColor: _kVanilla,
                  elevation: 6,
                  shadowColor: const Color(0x402C5745),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isResto ? 'Daftar sebagai Mitra Restoran' : 'Buat Akun Claimer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Footer Note Link Login (.footer-note) ──
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kTextMuted,
                    ),
                    children: [
                      const TextSpan(text: 'Sudah memiliki akun? '),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: _navigateToLogin,
                          child: Text(
                            'Masuk Ke Portal Login',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _kDarkBrown,
                              decoration: TextDecoration.underline,
                              decorationColor: _kTangerine,
                              decorationThickness: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// SUB-WIDGETS SESUAI DESAIN HTML
// ============================================================================

/// Hero Header Banner
class _SignupHeroBanner extends StatelessWidget {
  const _SignupHeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 64),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_kBrunswick, _kBrunswickDark],
        ),
      ),
      child: Column(
        children: [
          // Hero Badge (.hero-badge)
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0x33EB7D00), // rgba(235, 125, 0, 0.2)
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x66EB7D00)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_alt_1_rounded, size: 14, color: _kTangerine),
                  const SizedBox(width: 8),
                  Text(
                    'PENDAFTARAN REBITE',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: _kVanilla,
                      letterSpacing: 0.9,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Hero Title (.hero-title)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _kWhite,
                height: 1.25,
              ),
              children: [
                const TextSpan(text: 'Bergabung dalam Ekosistem '),
                TextSpan(
                  text: 'Penyelamat Makanan.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: _kVanilla,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Logo Avatar Mengambang (.logo-wrapper)
class _SignupLogoAvatar extends StatelessWidget {
  final VoidCallback onTap;

  const _SignupLogoAvatar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: _kVanilla,
          shape: BoxShape.circle,
          border: Border.all(color: _kBgLight, width: 4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x262E2910),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 40,
          backgroundColor: _kVanilla,
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.png',
              width: 60,
              height: 60,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.restaurant_rounded,
                size: 38,
                color: _kBrunswick,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Role Switcher (Claimer vs Mitra Restoran)
class _SignupRoleSwitcher extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const _SignupRoleSwitcher({
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isClaimer = selectedRole == 'claimer';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kVanilla,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          // Tombol Claimer
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('claimer'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isClaimer ? _kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isClaimer
                      ? const [
                          BoxShadow(
                            color: Color(0x382C5745),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: 17,
                      color: isClaimer ? _kVanilla : _kTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Claimer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isClaimer ? _kVanilla : _kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Mitra Restoran
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('resto'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: !isClaimer ? _kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !isClaimer
                      ? const [
                          BoxShadow(
                            color: Color(0x382C5745),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 17,
                      color: !isClaimer ? _kVanilla : _kTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mitra Restoran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: !isClaimer ? _kVanilla : _kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Input Field Kustom (.input-field)
class _SignupInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final Widget? suffixIcon;

  const _SignupInputField({
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _kDarkBrown,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _kBorder, width: 2),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _kDarkBrown,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFA39D83),
              ),
              prefixIcon: Icon(prefixIcon, color: _kTextMuted, size: 20),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _kTangerine, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// Ambient Glow Blob
class _AmbientDecorBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _AmbientDecorBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0.0)],
        ),
      ),
    );
  }
}
