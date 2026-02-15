import 'package:flutter/material.dart';
import '../../../core/themes/app_colors.dart';

/// Application logo widget
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 80,
    this.showText = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size * 0.25),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(
            Icons.fitness_center_rounded,
            size: size * 0.5,
            color: color ?? Colors.white,
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.2),
          Text(
            'Progressive Overload',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? AppColors.primary,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Track Your Gains',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color?.withValues(alpha: 0.7) ??
                      AppColors.lightTextSecondary,
                ),
          ),
        ],
      ],
    );
  }
}
