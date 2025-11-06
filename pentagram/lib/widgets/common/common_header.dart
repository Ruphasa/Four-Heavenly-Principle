import 'package:flutter/material.dart';
import 'package:pentagram/utils/app_colors.dart';
import 'package:pentagram/utils/responsive_helper.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final List<Widget>? actions;
  final double expandedHeight;

  const CommonHeader({
    required this.title, super.key,
    this.subtitle,
    this.actions,
    this.expandedHeight = 120,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return SliverAppBar(
      expandedHeight: responsive.isCompact ? expandedHeight * 0.85 : expandedHeight,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        title: Padding(
          padding: EdgeInsetsDirectional.only(
            start: responsive.padding(24),
            bottom: responsive.padding(16),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
              fontSize: responsive.fontSize(16),
            ),
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.primaryGradient,
          ),
          child: subtitle != null
              ? Padding(
                  padding: EdgeInsets.fromLTRB(
                    responsive.padding(16),
                    responsive.isCompact ? 60 : 70,
                    responsive.padding(16),
                    responsive.padding(16),
                  ),
                  child: subtitle!,
                )
              : null,
        ),
      ),
    );
  }
}
