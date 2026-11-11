import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rebite_partner_login.dart' show RebitePartnerLoginPage;
import 'session_storage.dart';
import 'rebite_partner_claimer_signup.dart' show RebitePartnerClaimerSignupPage;

// ============================================================================
// 1. PALET WARNA RESMI REBITE (Sesuai rebite_professional_login_page.html)
// ============================================================================
const Color kDarkBrown = Color(0xFF2E2910);
const Color kBrunswick = Color(0xFF2C5745);
const Color kBrunswickDark = Color(0xFF1E3F32);
const Color kVanilla = Color(0xFFEBE3A7);
const Color kTangerine = Color(0xFFEB7D00);
const Color kBgLight = Color(0xFFF7F5EB);
const Color kWhite = Color(0xFFFFFFFF);
const Color kMuted = Color(0xFF736E58);
const Color kBorder = Color(0xFFD1C9A0);

// ============================================================================
// ENTRY POINT MANDIRI (Dapat dijalankan langsung secara terisolasi)
// ============================================================================
void main() {
  runApp(const RebiteLoginApp());
}

class RebiteLoginApp extends StatelessWidget {
  const RebiteLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReBite — Login Claimer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBgLight,
        colorScheme: ColorScheme.fromSeed(
          seedColor: kBrunswick,
          primary: kBrunswick,
          secondary: kTangerine,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const RebiteLoginPage(),
    );
  }
}

// ============================================================================
// 1. STRUKTUR APLIKASI: StatelessWidget & Scaffold
// ============================================================================
class RebiteLoginPage extends StatelessWidget {
  const RebiteLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Responsive Design: MediaQuery & Orientation
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    return Scaffold(
      backgroundColor: const Color(0xFFE2DFD2), // Latar luar kanvas
      body: SafeArea(
        top: false,
        bottom: false,
        // 5. Responsive Design: LayoutBuilder
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 520;
            final isLandscape = orientation == Orientation.landscape;

            // 3. Single-Child Widget: Center & Container (Frame App 440px)
            return Center(
              child: Container(
                width: isDesktop ? 440 : double.infinity,
                height: isDesktop && !isLandscape ? 900 : double.infinity,
                decoration: BoxDecoration(
                  color: kBgLight,
                  borderRadius: isDesktop ? BorderRadius.circular(32) : BorderRadius.zero,
                  border: isDesktop ? Border.all(color: kBorder, width: 1.2) : null,
                  boxShadow: isDesktop
                      ? const [
                          BoxShadow(
                            color: Color(0x222E2910),
                            blurRadius: 40,
                            offset: Offset(0, 16),
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: isDesktop ? BorderRadius.circular(32) : BorderRadius.zero,
                  // 3. Multi-Child Widget: Stack (Dekorasi Ambient & Konten)
                  child: const Stack(
                    children: [
                      // Dekorasi Blob Ambient Latar Belakang
                      IgnorePointer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: -100,
                              right: -80,
                              child: _AmbientDecorBlob(
                                size: 340,
                                color: Color(0x22EB7D00),
                              ),
                            ),
                            Positioned(
                              bottom: -120,
                              left: -100,
                              child: _AmbientDecorBlob(
                                size: 360,
                                color: Color(0x1C2C5745),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Konten Form Interaktif Login
                      RebiteLoginFormView(),
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
// KONTEN FORM LOGIN (StatefulWidget untuk Interaksi & Validasi Akun Default)
// ============================================================================
class RebiteLoginFormView extends StatefulWidget {
  const RebiteLoginFormView({super.key});

  @override
  State<RebiteLoginFormView> createState() => _RebiteLoginFormViewState();
}

class _RebiteLoginFormViewState extends State<RebiteLoginFormView> {
  // Akun Default Sesuai Instruksi (Sudah diisi otomatis untuk kenyamanan)
  static const String kDefaultEmail = 'admin@rebite.com';
  static const String kDefaultPassword = '12345678';

  // Controller untuk Form Input
  final TextEditingController _emailController = TextEditingController(text: kDefaultEmail);
  final TextEditingController _passwordController = TextEditingController(text: kDefaultPassword);

  // State
  String _selectedRole = 'claimer'; // 'claimer' atau 'resto'
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Isi Otomatis Akun Demo Default
  void _fillDefaultCredentials() {
    setState(() {
      _emailController.text = kDefaultEmail;
      _passwordController.text = kDefaultPassword;
      _errorMessage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: kBrunswick,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(
          'Akun default admin@rebite.com berhasil diisi!',
          style: GoogleFonts.plusJakartaSans(color: kVanilla, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Logika Login
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi email dan kata sandi.';
      });
      return;
    }

    // Validasi akun (mendukung default & session storage)
    final isAuthValid = RebiteAuthSession.validateLogin(email, password, role: 'claimer') ||
        (email == kDefaultEmail && password == kDefaultPassword);

    if (isAuthValid) {
      setState(() {
        _errorMessage = null;
      });

      // 6. Navigasi Menggunakan Navigator.push()
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginSuccessDestinationPage(
            role: _selectedRole,
            userEmail: email,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = 'Email atau kata sandi salah!\nGunakan: $kDefaultEmail / $kDefaultPassword';
      });
    }
  }

  void _onRoleChanged(String newRole) {
    if (newRole == _selectedRole) return;

    setState(() {
      _selectedRole = newRole;
    });

    if (newRole == 'resto') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: kDarkBrown,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Text(
            'Beralih ke Portal Mitra Restoran...',
            style: GoogleFonts.plusJakartaSans(color: kVanilla, fontWeight: FontWeight.w600),
          ),
          duration: const Duration(milliseconds: 1500),
        ),
      );

      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RebitePartnerLoginPage(),
          ),
        ).then((_) {
          if (mounted) {
            setState(() {
              _selectedRole = 'claimer';
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3. Multi-Child Widget: SingleChildScrollView dengan ClampingScrollPhysics
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Hero Banner Header + Brand Logo menindih rapi via Stack
          // Tidak ada jarak berlebih di atas badge maupun di bawah logo
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              const LoginHeroBanner(),
              const Positioned(
                bottom: -46,
                child: BrandLogoAvatar(),
              ),
            ],
          ),

          // Jarak presisi untuk tonjolan logo (46px) + jarak pas ke welcome text (14px)
          const SizedBox(height: 60),

          // 2. Area Body Konten Form (Ukuran Sesuai Desain Asli HTML)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Text
                const WelcomeHeaderSection(),

                const SizedBox(height: 18),

                // 2. Reusable Widget: Role Switcher (Pencari / Claimer vs Mitra Resto)
                RoleSwitcherPill(
                  selectedRole: _selectedRole,
                  onRoleChanged: _onRoleChanged,
                ),

                const SizedBox(height: 18),

                // Pesan Error Jika Validasi Gagal
                if (_errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 14),
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

                // Form Input 1: Email / Username
                CustomInputField(
                  label: 'Email / Username',
                  hintText: 'nama@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.mail_outline_rounded,
                ),

                const SizedBox(height: 14),

                // Form Input 2: Kata Sandi (Password)
                CustomInputField(
                  label: 'Kata Sandi',
                  hintText: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: kMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // 3. Multi-Child Widget: Row (Ingat Saya & Lupa Sandi)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Checkbox Ingat Saya
                    InkWell(
                      onTap: () {
                        setState(() {
                          _rememberMe = !_rememberMe;
                        });
                      },
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: _rememberMe ? kBrunswick : kWhite,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: _rememberMe ? kBrunswick : kBorder,
                                width: 1.8,
                              ),
                            ),
                            child: _rememberMe
                                ? const Icon(Icons.check, size: 14, color: kVanilla)
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Ingat Saya',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: kMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Link Lupa Sandi
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: kDarkBrown,
                            content: Text(
                              'Fitur reset sandi: Tautan telah dikirimkan ke email terdaftar.',
                              style: GoogleFonts.plusJakartaSans(color: kVanilla),
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Lupa Sandi?',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: kTangerine,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Tombol Submit Utama ("Masuk sebagai Claimer")
                ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBrunswick,
                    foregroundColor: kVanilla,
                    elevation: 5,
                    shadowColor: const Color(0x502C5745),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedRole == 'claimer'
                            ? 'Masuk sebagai Claimer'
                            : 'Masuk sebagai Mitra Restoran',
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

                const SizedBox(height: 12),

                // Baris Ringkas Akun Demo Default
                DefaultAccountQuickBar(onAutoFill: _fillDefaultCredentials),

                const SizedBox(height: 18),

                // 2. Komponen Dasar: RichText Footer (Belum punya akun? Daftar)
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: kMuted,
                      ),
                      children: [
                        const TextSpan(text: 'Belum memiliki akun Rebite? '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RebitePartnerClaimerSignupPage(initialRole: 'claimer'),
                                ),
                              );
                            },
                            child: Text(
                              'Daftar Akun',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: kDarkBrown,
                                decoration: TextDecoration.underline,
                                decorationColor: kTangerine,
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
      ),
    );
  }
}

// ============================================================================
// 2 & 3. REUSABLE WIDGETS: HERO BANNER HEADER
// ============================================================================
class LoginHeroBanner extends StatelessWidget {
  const LoginHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Padding atas hanya 18px agar badge 'Food Rescue Platform' pas dan tidak terlalu jauh dari atas
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 52),
      decoration: const BoxDecoration(
        color: kTangerine,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF28B1A),
            kTangerine,
            Color(0xFFD66F00),
          ],
        ),
      ),
      child: Column(
        children: [
          // 3. Single-Child Widget: Alignment
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: kDarkBrown.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.volunteer_activism_rounded, size: 14, color: kVanilla),
                  const SizedBox(width: 6),
                  Text(
                    'FOOD RESCUE PLATFORM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: kVanilla,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 2. Komponen Dasar: RichText Judul Hero (Playfair Display 24pt Sesuai Desain HTML Asli)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: kWhite,
                height: 1.25,
              ),
              children: [
                const TextSpan(text: 'Every Meal Deserves a '),
                TextSpan(
                  text: 'Second Chance.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: kVanilla,
                    height: 1.25,
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

// ============================================================================
// 2. REUSABLE WIDGET: BRAND LOGO AVATAR (Ukuran Asli 92x92 Sesuai Desain HTML)
// ============================================================================
class BrandLogoAvatar extends StatelessWidget {
  const BrandLogoAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      decoration: BoxDecoration(
        color: kVanilla,
        shape: BoxShape.circle,
        border: Border.all(color: kBgLight, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x242E2910),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      // 2. Komponen Dasar: CircleAvatar & Image
      child: CircleAvatar(
        radius: 42,
        backgroundColor: kVanilla,
        child: ClipOval(
          child: Image.asset(
            'assets/images/logo.png',
            width: 64,
            height: 64,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.restaurant_rounded,
              size: 42,
              color: kBrunswick,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// REUSABLE WIDGET: WELCOME HEADER SECTION (Ukuran Asli Sesuai Desain HTML)
// ============================================================================
class WelcomeHeaderSection extends StatelessWidget {
  const WelcomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'HI THERE, WELCOME BACK',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: kBrunswick,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Siap Menyelamatkan Makanan Hari Ini?',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
            height: 1.28,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// 2. REUSABLE WIDGET: ROLE SWITCHER PILL (Claimer vs Mitra Restoran)
// ============================================================================
class RoleSwitcherPill extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const RoleSwitcherPill({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isClaimer = selectedRole == 'claimer';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: kVanilla,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Row(
        children: [
          // Tombol Peran: Pencari / Claimer
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('claimer'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isClaimer ? kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isClaimer
                      ? const [
                          BoxShadow(
                            color: Color(0x302C5745),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: isClaimer ? kVanilla : kMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pencari / Claimer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isClaimer ? kVanilla : kMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tombol Peran: Mitra Restoran
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('resto'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: !isClaimer ? kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !isClaimer
                      ? const [
                          BoxShadow(
                            color: Color(0x302C5745),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.storefront_rounded,
                      size: 18,
                      color: !isClaimer ? kVanilla : kMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mitra Restoran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: !isClaimer ? kVanilla : kMuted,
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

// ============================================================================
// 2. REUSABLE WIDGET: CUSTOM INPUT FIELD
// ============================================================================
class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
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
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: kDarkBrown,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorder, width: 1.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x082E2910),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: kDarkBrown,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFA09A82),
              ),
              prefixIcon: Icon(prefixIcon, color: kMuted, size: 21),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// REUSABLE WIDGET: DEFAULT ACCOUNT QUICK BAR (Bantuan Akun Default 1 Baris)
// ============================================================================
class DefaultAccountQuickBar extends StatelessWidget {
  final VoidCallback onAutoFill;

  const DefaultAccountQuickBar({super.key, required this.onAutoFill});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAutoFill,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: kVanilla.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.key_rounded, size: 14, color: kBrunswick),
            const SizedBox(width: 8),
            Text(
              'Akun Demo: admin@rebite.com | 12345678 (Klik Isi Cepat)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: kBrunswick,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// DEKORASI AMBIENT BLOB
// ============================================================================
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
          colors: [
            color,
            color.withValues(alpha: 0.0),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// 6. HALAMAN DESTINASI LOGIN SUKSES (Menggunakan Navigator.push)
// ============================================================================
class LoginSuccessDestinationPage extends StatelessWidget {
  final String role;
  final String userEmail;

  const LoginSuccessDestinationPage({
    super.key,
    required this.role,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x142E2910),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: kVanilla,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 48,
                      color: kBrunswick,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Login Berhasil!',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: kDarkBrown,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selamat datang kembali di Platform ReBite Food Rescue.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: kMuted,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: kVanilla.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Peran: ${role == 'claimer' ? 'Pencari / Claimer' : 'Mitra Restoran'}\nAkun: $userEmail',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: kDarkBrown,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // 6. Navigasi Kembali
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(
                        'Keluar / Kembali ke Login',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kBrunswick,
                        foregroundColor: kVanilla,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN DESTINASI DAFTAR BARU (Placeholder)
// ============================================================================
class SimpleRegisterPlaceholder extends StatelessWidget {
  const SimpleRegisterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgLight,
      appBar: AppBar(
        backgroundColor: kBgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kDarkBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Daftar Akun Baru',
          style: GoogleFonts.plusJakartaSans(
            color: kDarkBrown,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add_alt_1_rounded, size: 64, color: kBrunswick),
              const SizedBox(height: 16),
              Text(
                'Registrasi Pengguna Baru',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: kDarkBrown,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Form pendaftaran akun ReBite Claimer & Mitra Resto.',
                style: GoogleFonts.plusJakartaSans(color: kMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
