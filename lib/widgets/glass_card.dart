import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? borderColor;
  final double borderWidth;
  final Color? backgroundColor;
  final double blur;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final BoxShadow? boxShadow;
  final VoidCallback? onTap;
  final bool addShimmer;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.borderColor,
    this.borderWidth = 1.5,
    this.backgroundColor,
    this.blur = 10.0,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.boxShadow,
    this.onTap,
    this.addShimmer = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.13)
        : Colors.white.withOpacity(0.3);
    
    final defaultBgColor = theme.brightness == Brightness.dark
        ? Colors.black.withOpacity(0.2)
        : Colors.white.withOpacity(0.1);
    
    final defaultShadow = BoxShadow(
      color: theme.brightness == Brightness.dark
          ? Colors.black.withOpacity(0.2)
          : Colors.black.withOpacity(0.1),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: boxShadow != null ? [boxShadow!] : [defaultShadow],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: backgroundColor ?? defaultBgColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: borderColor ?? defaultBorderColor,
                  width: borderWidth,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.5),
                    theme.brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.02)
                        : Colors.white.withOpacity(0.2),
                  ],
                ),
              ),
              child: addShimmer 
                  ? ShimmerEffect(child: child)
                  : child,
            ),
          ),
        ),
      ),
    );
  }
}

class ShimmerEffect extends StatefulWidget {
  final Widget child;

  const ShimmerEffect({
    super.key,
    required this.child,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.2),
              ],
              stops: [
                0.0,
                (_animation.value / 2 + 0.5) * 0.8 + 0.1,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final Color? borderColor;
  final double blur;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final BoxShadow? boxShadow;
  final Alignment? alignment;
  final bool? opaque;
  final bool addGlow;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.borderColor,
    this.blur = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.height,
    this.width,
    this.boxShadow,
    this.alignment,
    this.opaque = false,
    this.addGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderColor = theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.13)
        : Colors.white.withOpacity(0.3);
    
    final defaultShadow = BoxShadow(
      color: theme.brightness == Brightness.dark
          ? Colors.black.withOpacity(0.2)
          : Colors.black.withOpacity(0.1),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    );

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow != null ? [boxShadow!] : [defaultShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              color: opaque == true
                  ? (theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.8)
                      : Colors.white.withOpacity(0.8))
                  : (theme.brightness == Brightness.dark
                      ? Colors.black.withOpacity(0.2)
                      : Colors.white.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: borderColor ?? defaultBorderColor,
                width: 1.0,
              ),
              boxShadow: addGlow ? [
                BoxShadow(
                  color: theme.brightness == Brightness.dark
                      ? Colors.cyanAccent.withOpacity(0.05)
                      : Colors.blueAccent.withOpacity(0.05),
                  blurRadius: 15,
                  spreadRadius: -5,
                  offset: const Offset(0, 0),
                ),
              ] : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlowingContainer extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double glowIntensity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final BoxShadow? boxShadow;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool animate;
  
  const GlowingContainer({
    super.key,
    required this.child,
    required this.glowColor,
    this.glowIntensity = 0.5,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.height,
    this.width,
    this.boxShadow,
    this.backgroundColor,
    this.borderColor,
    this.animate = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBgColor = theme.brightness == Brightness.dark
        ? Colors.black.withOpacity(0.4)
        : Colors.white.withOpacity(0.1);
        
    final defaultBorderColor = theme.brightness == Brightness.dark
        ? glowColor.withOpacity(0.5)
        : glowColor.withOpacity(0.7);

    if (animate) {
      return _AnimatedGlowingContainer(
        glowColor: glowColor,
        glowIntensity: glowIntensity,
        height: height,
        width: width,
        margin: margin,
        borderRadius: borderRadius,
        borderColor: borderColor ?? defaultBorderColor,
        backgroundColor: backgroundColor ?? defaultBgColor,
        padding: padding,
        child: child,
      );
    }

    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow != null ? [boxShadow!] : [
          BoxShadow(
            color: glowColor.withOpacity(glowIntensity * 0.3),
            blurRadius: 10,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: glowColor.withOpacity(glowIntensity * 0.2),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? defaultBgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? defaultBorderColor,
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _AnimatedGlowingContainer extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final double glowIntensity;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  final Color backgroundColor;
  final Color borderColor;

  const _AnimatedGlowingContainer({
    required this.child,
    required this.glowColor,
    required this.glowIntensity,
    required this.borderRadius,
    required this.padding,
    this.margin,
    this.height,
    this.width,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  State<_AnimatedGlowingContainer> createState() => _AnimatedGlowingContainerState();
}

class _AnimatedGlowingContainerState extends State<_AnimatedGlowingContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0.7, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withOpacity(widget.glowIntensity * 0.2 * _animation.value),
                blurRadius: 10 * _animation.value,
                spreadRadius: 1 * _animation.value,
              ),
              BoxShadow(
                color: widget.glowColor.withOpacity(widget.glowIntensity * 0.1 * _animation.value),
                blurRadius: 20 * _animation.value,
                spreadRadius: 1 * _animation.value,
              ),
            ],
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.borderColor,
                width: 1.5,
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
} 