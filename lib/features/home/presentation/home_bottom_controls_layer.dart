import 'package:flutter/material.dart';

class HomeBottomControlLayer extends StatelessWidget {
  const HomeBottomControlLayer({
    required this.isPaused,
    required this.isMuted,
    required this.mainLabel,
    required this.onMainPressed,
    required this.onMutePressed,
    required this.onStopPressed,
    super.key,
  });

  final bool isPaused;
  final bool isMuted;
  final String mainLabel;
  final VoidCallback onMainPressed;
  final VoidCallback onMutePressed;
  final VoidCallback onStopPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 86),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            _smallCircleButton(
              icon: Icons.stop_rounded,
              semanticLabel: '러닝 종료',
              onTap: onStopPressed,
              iconColor: const Color(0xFFFF6151),
            ),
            const SizedBox(width: 20),
            _mainButton(
              icon: isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
              label: mainLabel,
              onTap: onMainPressed,
            ),
            const SizedBox(width: 20),
            _smallCircleButton(
              icon:
                  isMuted ? Icons.music_off_rounded : Icons.music_note_rounded,
              semanticLabel: isMuted ? '음소거 해제' : '음소거',
              onTap: onMutePressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallCircleButton({
    required IconData icon,
    required String semanticLabel,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFFFF7E66),
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x2C000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor, size: 34),
        ),
      ),
    );
  }

  Widget _mainButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: '러닝 시작 또는 일시정지',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 184,
          height: 184,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6F57),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 9),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 14,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.black, size: 88),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
