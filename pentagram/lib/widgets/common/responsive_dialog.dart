import 'package:flutter/material.dart';
import 'package:pentagram/utils/responsive_helper.dart';

/// A responsive dialog wrapper that prevents overflow issues
/// Use this instead of AlertDialog directly for consistent responsive behavior
class ResponsiveDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final EdgeInsetsGeometry? titlePadding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final ShapeBorder? shape;

  const ResponsiveDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actions,
    this.titlePadding,
    this.contentPadding,
    this.actionsPadding,
    this.shape,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: shape,
      child: Builder(
        builder: (BuildContext context) {
          // Use MediaQueryData directly with fallback
          final mediaQuery = MediaQuery.maybeOf(context);
          if (mediaQuery == null) {
            // Fallback: use safe defaults if MediaQuery not available
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 320, // Safe mobile width
                maxHeight: 500,
              ),
              child: Material(
                shape: shape ?? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildDialogContent(context),
              ),
            );
          }
          
          final responsive = context.responsive;
          
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: mediaQuery.size.width * 0.9,
              maxHeight: mediaQuery.size.height * 0.8,
            ),
            child: Material(
              shape: shape ?? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
              ),
              child: _buildDialogContent(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final responsive = context.responsive;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title
        Padding(
          padding: titlePadding ?? EdgeInsets.fromLTRB(
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(20),
            responsive.padding(12),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Content (scrollable)
        Flexible(
          child: SingleChildScrollView(
            padding: contentPadding ?? EdgeInsets.fromLTRB(
              responsive.padding(20),
              0,
              responsive.padding(20),
              responsive.padding(12),
            ),
            child: content,
          ),
        ),
        // Actions
        Padding(
          padding: actionsPadding ?? EdgeInsets.fromLTRB(
            responsive.padding(20),
            0,
            responsive.padding(20),
            responsive.padding(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions,
          ),
        ),
      ],
    );
  }
}

/// A responsive confirmation dialog for common yes/no scenarios
class ResponsiveConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final Color? confirmColor;
  final IconData? icon;
  final Color? iconColor;

  const ResponsiveConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'OK',
    this.cancelText = 'Batal',
    this.onConfirm,
    this.confirmColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Builder(
        builder: (BuildContext context) {
          // Use MediaQueryData directly with fallback
          final mediaQuery = MediaQuery.maybeOf(context);
          if (mediaQuery == null) {
            // Fallback: use safe defaults if MediaQuery not available
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 320, // Safe mobile width
              ),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _buildConfirmDialogContent(context),
              ),
            );
          }
          
          final responsive = context.responsive;
          
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: mediaQuery.size.width * 0.9,
            ),
            child: Material(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(responsive.borderRadius(16)),
              ),
              child: _buildConfirmDialogContent(context),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfirmDialogContent(BuildContext context) {
    final responsive = context.responsive;
    
    return IntrinsicHeight(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title with optional icon
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.padding(20),
              responsive.padding(20),
              responsive.padding(20),
              responsive.padding(12),
            ),
            child: icon != null
                ? Row(
                    children: [
                      Icon(
                        icon,
                        color: iconColor,
                        size: responsive.iconSize(22),
                      ),
                      SizedBox(width: responsive.spacing(8)),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: responsive.fontSize(16),
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontSize: responsive.fontSize(16),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.padding(20),
              0,
              responsive.padding(20),
              responsive.padding(12),
            ),
            child: Text(
              message,
              style: TextStyle(
                fontSize: responsive.fontSize(14),
                height: 1.4,
              ),
            ),
          ),
          // Actions
          Padding(
            padding: EdgeInsets.fromLTRB(
              responsive.padding(20),
              0,
              responsive.padding(20),
              responsive.padding(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelText,
                    style: TextStyle(fontSize: responsive.fontSize(14)),
                  ),
                ),
                SizedBox(width: responsive.spacing(8)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    onConfirm?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.padding(16),
                      vertical: responsive.padding(10),
                    ),
                  ),
                  child: Text(
                    confirmText,
                    style: TextStyle(fontSize: responsive.fontSize(14)),
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
