import 'package:flutter/material.dart';

class RunVilleBrandHeader extends StatelessWidget {
  const RunVilleBrandHeader({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double titleSize = compact ? 34 : 40;
    final double avatarRadius = compact ? 18 : 22;

    return Row(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Run Ville',
              style: TextStyle(
                color: Colors.white,
                fontSize: titleSize,
                height: 0.95,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: -1.2,
                shadows: const <Shadow>[
                  Shadow(
                    color: Color(0x22000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Icon(
                Icons.directions_run_rounded,
                color: Colors.white,
                size: compact ? 22 : 26,
              ),
            ),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          radius: avatarRadius,
          backgroundColor: Colors.white,
          child: const Icon(Icons.person, color: Color(0xFF404040)),
        ),
      ],
    );
  }
}
