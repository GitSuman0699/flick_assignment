import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../painters/background_painter.dart';
import '../theme/app_colors.dart';
import '../widgets/feature_card.dart';
import '../widgets/circle_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late final AnimationController _mainCtrl;
  late final AnimationController _confettiCtrl;

  late final Animation<double> _bgAnim;
  late final Animation<double> _iconDropAnim;
  late final Animation<double> _logoNudgeAnim;
  late final Animation<double> _text1Anim;
  late final Animation<double> _text2Anim;
  late final Animation<double> _layoutAnim;
  late final Animation<double> _card1Anim;
  late final Animation<double> _card2Anim;
  late final Animation<double> _card3Anim;
  late final Animation<double> _ctaAnim;
  late final Animation<double> _optionAnim;

  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();

    _mainCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 9000),
    );

    _confettiCtrl = AnimationController(vsync: this);

    _bgAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.000, 0.067, curve: Curves.easeIn),
    );

    _iconDropAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.033, 0.111, curve: Curves.easeOut),
    );

    _logoNudgeAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.233, 0.278, curve: Curves.easeInOut),
    );

    _text1Anim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.311, 0.378, curve: Curves.easeOut),
    );

    _text2Anim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.378, 0.444, curve: Curves.easeOut),
    );

    _layoutAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.444, 0.533, curve: Curves.easeInOut),
    );

    _card1Anim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.533, 0.611, curve: Curves.easeOutCubic),
    );

    _card2Anim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.589, 0.667, curve: Curves.easeOutCubic),
    );

    _card3Anim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.644, 0.722, curve: Curves.easeOutCubic),
    );

    _ctaAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.74, 0.75, curve: Curves.easeOutBack),
    );

    _optionAnim = CurvedAnimation(
      parent: _mainCtrl,
      curve: const Interval(0.74, 0.75, curve: Curves.easeOut),
    );

    _mainCtrl.forward();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() => _showConfetti = true);
    });
  }

  @override
  void dispose() {
    _mainCtrl.dispose();
    _confettiCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedBuilder(
        animation: _mainCtrl,
        builder: (context, _) {
          const appBarH = kToolbarHeight;
          final availH = size.height - safeTop - appBarH;
          final nudgedLogoH = lerpDouble(
            availH * 1.00,
            availH * 0.72,
            _logoNudgeAnim.value,
          )!;
          final logoH = lerpDouble(
            nudgedLogoH,
            availH * 0.35,
            _layoutAnim.value,
          )!;
          final featH = availH - logoH;

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: BackgroundPainter(_bgAnim.value)),
              ),
              if (_showConfetti)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Lottie.asset(
                      'assets/lottie/confetti.json',
                      controller: _confettiCtrl,
                      fit: BoxFit.cover,
                      repeat: false,
                      onLoaded: (composition) {
                        _confettiCtrl.duration = composition.duration;
                        _confettiCtrl.forward();
                      },
                    ),
                  ),
                ),
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    SizedBox(height: logoH, child: _buildLogoSection()),
                    SizedBox(height: featH, child: _buildFeaturesSection()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(icon: Icons.chevron_left, onTap: () {}),
          Opacity(
            opacity: _ctaAnim.value.clamp(0.0, 1.0),
            child: CircleButton(icon: Icons.settings_outlined, onTap: () {}),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    final dropOffset = (1.0 - _iconDropAnim.value) * (-120.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.translate(
          offset: Offset(0, dropOffset),
          child: Image.asset(
            'assets/images/flick_tv_logo.png',
            width: 110,
            height: 110,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 20),
        Transform.translate(
          offset: Offset(0, 28 * (1 - _text1Anim.value)),
          child: Opacity(
            opacity: _text1Anim.value.clamp(0.0, 1.0),
            child: Text(
              'FlickTv',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Transform.translate(
          offset: Offset(0, 28 * (1 - _text2Anim.value)),
          child: Opacity(
            opacity: _text2Anim.value.clamp(0.0, 1.0),
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.white, Colors.grey.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds),
              child: const Text(
                'SUMAN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4.0,
                  height: 1.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FeatureCard(
            icon: Icons.devices_rounded,
            title: 'Watch anywhere',
            subtitle: 'Stream on any device, anytime you want',
            animation: _card1Anim,
          ),
          FeatureCard(
            icon: Icons.hd_rounded,
            title: 'Crystal clear 4K',
            subtitle: 'Zero buffering with HD & Dolby sound',
            animation: _card2Anim,
          ),
          FeatureCard(
            icon: Icons.download_for_offline_rounded,
            title: 'Download & watch',
            subtitle: 'Save episodes for offline viewing',
            animation: _card3Anim,
          ),
          const SizedBox(height: 10),
          Transform.scale(
            scale: _ctaAnim.value.clamp(0.0, 1.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonGreen,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Start Watching',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: _optionAnim.value.clamp(0.0, 1.0),
            child: _buildRedeemRow(),
          ),
          const SizedBox(height: 24),
          Opacity(
            opacity: (_optionAnim.value * 0.5).clamp(0.0, 1.0),
            child: const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'Enjoy unlimited streaming with one tap',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedeemRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.redeemIconBg,
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              color: AppColors.accentRed,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Redeem Voucher',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Enter code to unlock free access',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
