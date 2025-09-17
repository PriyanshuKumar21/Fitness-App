import 'package:flutter/material.dart';

class CyberCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final Color borderColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CyberCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderColor = const Color(0xFF00E5FF),
    this.backgroundColor,
    this.padding,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.black.withOpacity(0.7);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Corner accents
            Positioned(
              top: 0,
              left: 0,
              child: _buildCornerAccent(isTopLeft: true),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _buildCornerAccent(isTopLeft: false),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _buildCornerAccent(isTopLeft: false, isRotated: true),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _buildCornerAccent(isTopLeft: true, isRotated: true),
            ),
            
            // Main content
            Padding(
              padding: padding ?? const EdgeInsets.all(16.0),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerAccent({
    required bool isTopLeft,
    bool isRotated = false,
  }) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CustomPaint(
        painter: CornerAccentPainter(
          color: borderColor,
          isTopLeft: isTopLeft,
          isRotated: isRotated,
        ),
      ),
    );
  }
}

class CornerAccentPainter extends CustomPainter {
  final Color color;
  final bool isTopLeft;
  final bool isRotated;

  CornerAccentPainter({
    required this.color,
    required this.isTopLeft,
    required this.isRotated,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    
    if (isTopLeft) {
      if (!isRotated) {
        // Top-left corner
        path.moveTo(0, size.height * 0.6);
        path.lineTo(0, 0);
        path.lineTo(size.width * 0.6, 0);
      } else {
        // Bottom-right corner (rotated top-left)
        path.moveTo(size.width, size.height * 0.4);
        path.lineTo(size.width, size.height);
        path.lineTo(size.width * 0.4, size.height);
      }
    } else {
      if (!isRotated) {
        // Top-right corner
        path.moveTo(size.width, size.height * 0.6);
        path.lineTo(size.width, 0);
        path.lineTo(size.width * 0.4, 0);
      } else {
        // Bottom-left corner (rotated top-right)
        path.moveTo(0, size.height * 0.4);
        path.lineTo(0, size.height);
        path.lineTo(size.width * 0.6, size.height);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerAccentPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.isTopLeft != isTopLeft ||
           oldDelegate.isRotated != isRotated;
  }
} 