import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dart:ui';
import 'dart:math' as math;

class AnimatedGlowButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isActive;
  final double height;
  final double? width;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final bool pulsate;
  final bool addRipple;
  final bool addCloudyHover;

  const AnimatedGlowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isActive = false,
    this.height = 50,
    this.width,
    required this.color,
    this.textColor = Colors.white,
    this.icon,
    this.pulsate = true,
    this.addRipple = true,
    this.addCloudyHover = true,
  });

  @override
  State<AnimatedGlowButton> createState() => _AnimatedGlowButtonState();
}

class _AnimatedGlowButtonState extends State<AnimatedGlowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.pulsate && widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedGlowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && widget.pulsate) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        if (widget.addCloudyHover) {
          setState(() {
            _isHovering = true;
          });
        }
      },
      onExit: (event) {
        if (widget.addCloudyHover) {
          setState(() {
            _isHovering = false;
          });
        }
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Cloudy hover effect
              if (_isHovering && widget.addCloudyHover)
                Positioned.fill(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return CustomPaint(
                        painter: CloudyHoverPainter(
                          color: widget.color,
                          animationValue: _controller.value,
                        ),
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                      );
                    },
                  ),
                ),
              
              // Main button
              InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(widget.height / 2),
                splashColor: widget.color.withOpacity(0.3),
                child: Container(
                  height: widget.height,
                  width: widget.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    color: widget.color.withOpacity(0.1),
                    boxShadow: widget.isActive
                        ? [
                            BoxShadow(
                              color: widget.color.withOpacity(
                                  0.3 + (_glowAnimation.value * 0.2)),
                              blurRadius: 15 * _glowAnimation.value,
                              spreadRadius: 2 * _glowAnimation.value,
                            ),
                          ]
                        : null,
                    border: Border.all(
                      color: widget.color.withOpacity(0.8),
                      width: 1.5,
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.color.withOpacity(0.8),
                        widget.color.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.height / 2),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Stack(
                        children: [
                          if (widget.addRipple && widget.isActive) RippleEffect(color: widget.color),
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(
                                    widget.icon,
                                    color: widget.textColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.text,
                                  style: TextStyle(
                                    color: widget.textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class RippleEffect extends StatefulWidget {
  final Color color;

  const RippleEffect({
    super.key,
    required this.color,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: RipplePainter(
            color: widget.color,
            animationValue: _controller.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class RipplePainter extends CustomPainter {
  final Color color;
  final double animationValue;

  RipplePainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Add clip to contain effects within the button's boundary
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    canvas.clipRRect(rRect);
    
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final maxRadius = math.min(size.width, size.height) * 0.5; // Limit radius to half of the smallest dimension
    
    final paint = Paint()
      ..color = color.withOpacity(0.15 * (1 - animationValue))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5);
    
    final radius = animationValue * maxRadius;
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    
    if (animationValue > 0.2) {
      final secondPaint = Paint()
        ..color = color.withOpacity(0.15 * (1 - (animationValue - 0.2) / 0.8))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.5);
      
      final secondRadius = ((animationValue - 0.2) / 0.8) * maxRadius * 0.8;
      canvas.drawCircle(Offset(centerX, centerY), secondRadius, secondPaint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class CloudyHoverPainter extends CustomPainter {
  final Color color;
  final double animationValue;
  
  CloudyHoverPainter({
    required this.color,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Add clip to contain effects within the button's boundary
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rRect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    canvas.clipRRect(rRect);
    
    final random = math.Random(42); // Fixed seed for consistent effect
    final numClouds = 8;
    final minRadius = size.width * 0.05;
    final maxRadius = size.width * 0.12;
    
    for (int i = 0; i < numClouds; i++) {
      // Ensure clouds are more likely to be centered inside the button
      final offsetX = size.width * 0.2 + random.nextDouble() * size.width * 0.6;
      final offsetY = size.height * 0.2 + random.nextDouble() * size.height * 0.6;
      final radius = minRadius + random.nextDouble() * (maxRadius - minRadius);
      final opacity = 0.05 + (0.1 * (animationValue + random.nextDouble() * 0.3));
      
      final paint = Paint()
        ..color = color.withOpacity(opacity.clamp(0.05, 0.2))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      
      // Create slightly offset cloud puffs with reduced spread
      final numPuffs = 2 + random.nextInt(2);
      for (int j = 0; j < numPuffs; j++) {
        final puffX = offsetX + (random.nextDouble() * 10 - 5);
        final puffY = offsetY + (random.nextDouble() * 10 - 5);
        final puffRadius = radius * (0.7 + random.nextDouble() * 0.3);
        
        canvas.drawCircle(
          Offset(puffX, puffY), 
          puffRadius, 
          paint
        );
      }
    }
    
    // Add inner glow around the button edges (contained within the button)
    final innerGlowPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 4);
    
    canvas.drawRRect(rRect.deflate(2), innerGlowPaint);
  }
  
  @override
  bool shouldRepaint(CloudyHoverPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.color != color;
  }
}

class NeuButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double? width;
  final IconData? icon;
  final bool isActive;
  final Color? activeColor;

  const NeuButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.width,
    this.icon,
    this.isActive = false,
    this.activeColor,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final activeColor = widget.activeColor ?? theme.colorScheme.primary;
    
    final bgColor = isDark ? Colors.black : Colors.white;
    final shadowColor = isDark ? Colors.black : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.8);
    
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.symmetric(
          horizontal: widget.width != null ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: widget.isActive ? activeColor.withOpacity(0.2) : bgColor,
          borderRadius: BorderRadius.circular(widget.height / 2),
          border: Border.all(
            color: widget.isActive 
                ? activeColor.withOpacity(0.8) 
                : isDark 
                    ? Colors.white.withOpacity(0.1) 
                    : Colors.black.withOpacity(0.05),
            width: 1,
          ),
          boxShadow: _isPressed || widget.isActive
              ? []
              : [
                  // Outer shadow
                  BoxShadow(
                    color: shadowColor.withOpacity(0.5),
                    offset: const Offset(3, 3),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                  // Inner highlight
                  BoxShadow(
                    color: highlightColor,
                    offset: const Offset(-3, -3),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
          gradient: widget.isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    activeColor.withOpacity(0.8),
                    activeColor.withOpacity(0.2),
                  ],
                )
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color: widget.isActive
                      ? isDark
                          ? Colors.white
                          : Colors.black
                      : isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.8),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: widget.isActive
                      ? isDark
                          ? Colors.white
                          : Colors.black
                      : isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 