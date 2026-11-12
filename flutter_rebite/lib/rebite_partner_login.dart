
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'session_storage.dart';
import 'rebite_route_tracker.dart';
import 'rebite_partner_claimer_signup.dart'
    show RebitePartnerClaimerSignupPage;
import 'rebite_login.dart' show RebiteLoginPage;
import 'rebite_onboarding.dart' show RebiteOnboarding;

// ============================================================================
// 4. TEMA DAN DESAIN (Material Design 3 & Palet Warna rebite_partner_login.html)
// ============================================================================
const Color _kDarkBrown = Color(0xFF2E2910);
const Color _kBrunswick = Color(0xFF2C5745);
const Color _kBrunswickDark = Color(0xFF1E3F32);
const Color _kTangerine = Color(0xFFEB7D00);
const Color _kTangerineHover = Color(0xFFD47000);
const Color _kVanilla = Color(0xFFEBE3A7);
const Color _kVanillaSoft = Color(0xFFFAF7E8);
const Color _kBgLight = Color(0xFFF7F5EB);
const Color _kWhite = Color(0xFFFFFFFF);
const Color _kTextMuted = Color(0xFF6B654C);
const Color _kBorder = Color(0xFFD8D0A8);
const Color _kBorderFocus = Color(0xFFEB7D00);

// ============================================================================
// ENTRY POINT MANDIRI (Dapat Dijalankan Terpisah)
// ============================================================================
void main() {
  runApp(const RebitePartnerLoginApp());
}

class RebitePartnerLoginApp extends StatelessWidget {
  const RebitePartnerLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rebite - Portal Mitra Restoran',
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
      home: const RebitePartnerLoginPage(),
    );
  }
}

// ============================================================================
// 1. STRUKTUR APLIKASI: StatelessWidget & Scaffold
// ============================================================================
class RebitePartnerLoginPage extends StatelessWidget {
  const RebitePartnerLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final orientation = mediaQuery.orientation;

    return Scaffold(
      backgroundColor: const Color(0xFFE2DFD2),
      body: SafeArea(
        top: false,
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth > 520;
            final isLandscape = orientation == Orientation.landscape;

            return Center(
              child: Container(
                width: isDesktop ? 440 : double.infinity,
                height: isDesktop && !isLandscape ? 920 : double.infinity,
                decoration: BoxDecoration(
                  color: _kBgLight,
                  borderRadius:
                      isDesktop ? BorderRadius.circular(24) : BorderRadius.zero,
                  border: isDesktop
                      ? Border.all(color: _kBorder, width: 1)
                      : null,
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
                  borderRadius:
                      isDesktop ? BorderRadius.circular(24) : BorderRadius.zero,
                  child: const Stack(
                    children: [
                      IgnorePointer(
                        child: Stack(
                          children: [
                            Positioned(
                              top: -100,
                              right: -80,
                              child: _AmbientDecorBlob(
                                size: 400,
                                color: Color(0x1FEB7D00),
                              ),
                            ),
                            Positioned(
                              bottom: -120,
                              left: -80,
                              child: _AmbientDecorBlob(
                                size: 450,
                                color: Color(0x1F2C5745),
                              ),
                            ),
                          ],
                        ),
                      ),
                      PartnerLoginFormView(),
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
// KONTEN FORM LOGIN MITRA RESTORAN
// ============================================================================
class PartnerLoginFormView extends StatefulWidget {
  const PartnerLoginFormView({super.key});

  @override
  State<PartnerLoginFormView> createState() =>
      _PartnerLoginFormViewState();
}

class _PartnerLoginFormViewState extends State<PartnerLoginFormView> {
  static const String _kDefaultEmail = 'adminResto@rebite.com';
  static const String _kDefaultPassword = '12345678';

  final TextEditingController _emailController =
      TextEditingController(text: _kDefaultEmail);
  final TextEditingController _passwordController =
      TextEditingController(text: _kDefaultPassword);

  String _selectedRole = 'resto';
  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _fillDefaultCredentials() {
    setState(() {
      _emailController.text = _kDefaultEmail;
      _passwordController.text = _kDefaultPassword;
      _errorMessage = null;
    });

    _showCustomToast(
      context,
      'Akun demo adminResto@rebite.com berhasil diisi!',
    );
  }

  void _showCustomToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(
          bottom: 24,
          left: 16,
          right: 16,
        ),
        duration: const Duration(seconds: 3),
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
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
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: _kTangerine,
                  size: 18,
                ),
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

  // ==========================================================================
  // LOGIKA LOGIN MITRA RESTORAN
  // ==========================================================================
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Harap isi email restoran dan kata sandi.';
      });
      return;
    }

    final isAuthValid =
        RebiteAuthSession.validateLogin(email, password, role: 'resto') ||
            (email == _kDefaultEmail &&
                password == _kDefaultPassword);

    if (isAuthValid) {
      setState(() {
        _errorMessage = null;
      });

      _showCustomToast(
        context,
        'Berhasil masuk ke Dashboard Mitra Restoran ($email)',
      );

      // Navigasi ke route dashboard yang sudah didaftarkan di main.dart.
      // Dengan cara ini, callback profil dan form posting tetap berfungsi.
      Future.delayed(const Duration(milliseconds: 600), () {
        if (!mounted) return;

        Navigator.pushNamed(
          context,
          '/restaurant-dashboard',
        );
      });
    } else {
      setState(() {
        _errorMessage =
            'Email atau kata sandi salah!\n'
            'Default: $_kDefaultEmail / $_kDefaultPassword';
      });

      _showCustomToast(
        context,
        'Kredensial tidak cocok. Silakan daftar jika belum memiliki akun.',
      );
    }
  }

  // ==========================================================================
  // GANTI PERAN: CLAIMER ATAU MITRA RESTORAN
  // ==========================================================================
  void _onRoleChanged(String newRole) {
    if (newRole == _selectedRole) return;

    setState(() {
      _selectedRole = newRole;
    });

    if (newRole == 'claimer') {
      _showCustomToast(
        context,
        'Beralih ke Portal Pencari / Claimer...',
      );

      Future.delayed(const Duration(milliseconds: 250), () {
        if (!mounted) return;

        RebiteRouteTracker.push(
          context,
          const RebiteLoginPage(),
          routeName: AppRoutes.login,
        ).then((_) {
          if (mounted) {
            setState(() {
              _selectedRole = 'resto';
            });
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      children: [
        // HERO HEADER DAN LOGO
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            const PartnerHeroBanner(),
            Positioned(
              bottom: -44,
              child: PartnerBrandLogoAvatar(
                onTapLogo: () {
                  RebiteRouteTracker.push(
                    context,
                    const RebiteOnboarding(),
                    routeName: AppRoutes.onboarding,
                  );
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 60),

        // BODY FORM LOGIN
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PartnerWelcomeHeader(),

              const SizedBox(height: 22),

              PartnerRoleSwitcherPill(
                selectedRole: _selectedRole,
                onRoleChanged: _onRoleChanged,
              ),

              const SizedBox(height: 20),

              PartnerFeatureCarousel(
                selectedRole: _selectedRole,
              ),

              const SizedBox(height: 16),

              // PESAN ERROR
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFF5A3A0),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        color: Color(0xFFD32F2F),
                        size: 20,
                      ),
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

              // INPUT EMAIL
              PartnerInputField(
                label: 'Email Restoran / ID Mitra',
                hintText: 'restoran@rebite.id atau ID-MITRA',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
              ),

              const SizedBox(height: 18),

              // INPUT PASSWORD
              PartnerInputField(
                label: 'Kata Sandi',
                hintText: '••••••••',
                controller: _passwordController,
                obscureText: _obscurePassword,
                prefixIcon: Icons.lock_outline_rounded,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: _kTextMuted,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),

              const SizedBox(height: 16),

              // INGAT SAYA DAN LUPA PASSWORD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        PartnerCustomCheckbox(
                          isChecked: _rememberMe,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ingat Saya',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _kTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      _showCustomToast(
                        context,
                        'Instruksi pemulihan telah dikirim ke email mitra Anda.',
                      );
                    },
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.zero,
                      ),
                      minimumSize: const WidgetStatePropertyAll(
                        Size.zero,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor:
                          WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.hovered) ||
                            states.contains(WidgetState.pressed)) {
                          return _kTangerineHover;
                        }
                        return _kTangerine;
                      }),
                    ),
                    child: Text(
                      'Lupa Sandi?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // TOMBOL LOGIN
              ElevatedButton(
                onPressed: _handleLogin,
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
                      _selectedRole == 'resto'
                          ? 'Masuk ke Dashboard Restoran'
                          : 'Masuk sebagai Claimer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // AKUN DEMO
              PartnerAccountQuickBar(
                onAutoFill: _fillDefaultCredentials,
              ),

              const SizedBox(height: 40),

              // LINK PENDAFTARAN MITRA
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
                      const TextSpan(
                        text: 'Ingin bergabung sebagai mitra? ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            RebiteRouteTracker.push(
                              context,
                              const RebitePartnerClaimerSignupPage(
                                initialRole: 'resto',
                              ),
                              routeName: AppRoutes.partnerSignup,
                            );
                          },
                          child: Text(
                            'Daftar Mitra Restoran Baru',
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
// HERO BANNER HEADER
// ============================================================================
class PartnerHeroBanner extends StatelessWidget {
  const PartnerHeroBanner({super.key});

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
          colors: [
            _kBrunswick,
            _kBrunswickDark,
          ],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0x33EB7D00),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0x66EB7D00),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.storefront_rounded,
                    size: 14,
                    color: _kTangerine,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PORTAL MITRA RESTORAN',
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
                const TextSpan(
                  text: 'Kelola Surplus Makanan, Atur Kuota, ',
                ),
                TextSpan(
                  text: '& Berdayakan Komunitas.',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: _kVanilla,
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
// BRAND LOGO AVATAR
// ============================================================================
class PartnerBrandLogoAvatar extends StatelessWidget {
  final VoidCallback onTapLogo;

  const PartnerBrandLogoAvatar({
    super.key,
    required this.onTapLogo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapLogo,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          color: _kVanilla,
          shape: BoxShape.circle,
          border: Border.all(
            color: _kBgLight,
            width: 4,
          ),
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
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(
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

// ============================================================================
// WELCOME HEADER
// ============================================================================
class PartnerWelcomeHeader extends StatelessWidget {
  const PartnerWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'MERCHANT DASHBOARD ACCESS',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _kTangerine,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Selamat Datang, Mitra Rebite',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: _kDarkBrown,
            height: 1.3,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// ROLE SWITCHER PILL
// ============================================================================
class PartnerRoleSwitcherPill extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const PartnerRoleSwitcherPill({
    super.key,
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isResto = selectedRole == 'resto';

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _kVanilla,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _kBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('claimer'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: !isResto ? _kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: !isResto
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
                      color: !isResto ? _kVanilla : _kTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pencari / Claimer',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: !isResto ? _kVanilla : _kTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: GestureDetector(
              onTap: () => onRoleChanged('resto'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: isResto ? _kBrunswick : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isResto
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
                      color: isResto ? _kVanilla : _kTextMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Mitra Restoran',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isResto ? _kVanilla : _kTextMuted,
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
// CAROUSEL FITUR UNGGULAN MITRA RESTORAN
// ============================================================================
class PartnerFeatureCarousel extends StatefulWidget {
  final String selectedRole;

  const PartnerFeatureCarousel({
    super.key,
    required this.selectedRole,
  });

  @override
  State<PartnerFeatureCarousel> createState() =>
      _PartnerFeatureCarouselState();
}

class _PartnerFeatureCarouselState
    extends State<PartnerFeatureCarousel> {
  final PageController _pageController = PageController();
  int _currentCarouselIndex = 0;

  final List<Map<String, dynamic>> _restoFeatures = const [
    {
      'icon': Icons.tune_rounded,
      'title': 'Atur Kuota & Jadwal Claim',
      'desc':
          'Kelola batasan kuota claim surplus dan atur jadwal pembagian makanan secara fleksibel.',
    },
    {
      'icon': Icons.delivery_dining_rounded,
      'title': 'Misi Pickup Sidejob',
      'desc':
          'Post donasi makanan homeless dengan penjemputan oleh relawan sidejob kurir terverifikasi.',
    },
    {
      'icon': Icons.pets_rounded,
      'title': 'Distribusi Pakan Ternak',
      'desc':
          'Salurkan sisa bahan organik ramah lingkungan tanpa terbuang sia-sia ke tempat pembuangan.',
    },
    {
      'icon': Icons.analytics_outlined,
      'title': 'Laporan Dampak Sosial',
      'desc':
          'Pantau analitik pengurangan jejak karbon, tonase sampah terselamatkan, dan nilai CSR resto.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isResto = widget.selectedRole == 'resto';

    if (!isResto) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: _kVanillaSoft,
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            left: BorderSide(
              color: _kTangerine,
              width: 3,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: _kTangerine,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Akses peta food bank, dapatkan makanan gratis atau potongan harga, dan ambil sidejob antar makanan.',
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
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: _kVanillaSoft,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(
            color: _kTangerine,
            width: 3,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 52,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _restoFeatures.length,
              onPageChanged: (index) {
                setState(() {
                  _currentCarouselIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final feature = _restoFeatures[index];

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      size: 18,
                      color: _kTangerine,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature['desc'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kDarkBrown,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              _restoFeatures.length,
              (dotIndex) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _currentCarouselIndex == dotIndex ? 16 : 6,
                height: 4,
                decoration: BoxDecoration(
                  color: _currentCarouselIndex == dotIndex
                      ? _kTangerine
                      : _kBorder,
                  borderRadius: BorderRadius.circular(4),
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
// PARTNER INPUT FIELD
// ============================================================================
class PartnerInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData prefixIcon;
  final Widget? suffixIcon;

  const PartnerInputField({
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
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: _kDarkBrown,
            letterSpacing: 0.6,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          decoration: BoxDecoration(
            color: _kWhite,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _kBorder,
              width: 2,
            ),
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
              prefixIcon: Icon(
                prefixIcon,
                color: _kTextMuted,
                size: 20,
              ),
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: _kBorderFocus,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// CHECKBOX KUSTOM
// ============================================================================
class PartnerCustomCheckbox extends StatelessWidget {
  final bool isChecked;

  const PartnerCustomCheckbox({
    super.key,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: isChecked ? _kBrunswick : _kWhite,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isChecked ? _kBrunswick : _kBorder,
          width: 2,
        ),
      ),
      child: isChecked
          ? const Icon(
              Icons.check,
              size: 12,
              color: _kVanilla,
            )
          : null,
    );
  }
}

// ============================================================================
// BARIS CEPAT AKUN DEFAULT MITRA RESTORAN
// ============================================================================
class PartnerAccountQuickBar extends StatelessWidget {
  final VoidCallback onAutoFill;

  const PartnerAccountQuickBar({
    super.key,
    required this.onAutoFill,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAutoFill,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: const Color(0x66EBE3A7),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.key_rounded,
              size: 14,
              color: _kBrunswick,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Akun Demo: adminResto@rebite.com | 12345678 (Klik Isi)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _kBrunswick,
                ),
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

  const _AmbientDecorBlob({
    required this.size,
    required this.color,
  });

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
// HALAMAN SETELAH LOGIN RESTORAN
// ============================================================================
class PartnerLoginSuccessPage extends StatelessWidget {
  final String? role;
  final String? userEmail;

  const PartnerLoginSuccessPage({
    super.key,
    this.role,
    this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLight,
      appBar: AppBar(
        backgroundColor: _kBgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: _kDarkBrown,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                ),
                label: Text(
                  'Kembali',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBrunswick,
                  foregroundColor: _kVanilla,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// HALAMAN DESTINASI REGISTRASI MITRA BARU
// ============================================================================
class PartnerRegisterPage extends StatelessWidget {
  const PartnerRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBgLight,
      appBar: AppBar(
        backgroundColor: _kBgLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: _kDarkBrown,
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Kembali',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                ),
                label: Text(
                  'Kembali',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kBrunswick,
                  foregroundColor: _kVanilla,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
