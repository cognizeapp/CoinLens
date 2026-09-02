import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/auth_repository.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key, required this.onSelected, this.busy = false});

  final ValueChanged<SocialProvider> onSelected;
  final bool busy;

  bool get _showApple =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SocialButton(
          label: 'Continue with Google',
          icon: Icons.g_mobiledata_rounded,
          onPressed: busy ? null : () => onSelected(SocialProvider.google),
        ),
        if (_showApple) ...[
          const SizedBox(height: AppSpacing.md),
          _SocialButton(
            label: 'Continue with Apple',
            icon: Icons.apple_rounded,
            onPressed: busy ? null : () => onSelected(SocialProvider.apple),
          ),
        ],
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.textPrimary),
      label: Text(label),
    );
  }
}
