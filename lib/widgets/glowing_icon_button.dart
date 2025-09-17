import 'package:flutter/material.dart';

class GlowingIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final String? tooltip;

  const GlowingIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24.0,
    required this.color,
    this.tooltip,
  });

  @override
  State<GlowingIconButton> createState() => _GlowingIconButtonState();
}

class _GlowingIconButtonState extends State<GlowingIconButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
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
    Widget buttonWidget = MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            width: widget.size * 1.5,
            height: widget.size * 1.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _isHovering 
                  ? widget.color.withOpacity(0.2) 
                  : Colors.transparent,
              boxShadow: _isHovering
                  ? [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 8 * _glowAnimation.value,
                        spreadRadius: 1 * _glowAnimation.value,
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                customBorder: const CircleBorder(),
                splashColor: widget.color.withOpacity(0.3),
                highlightColor: widget.color.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    widget.icon,
                    color: widget.color,
                    size: widget.size,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    if (widget.tooltip != null) {
      return Tooltip(
        message: widget.tooltip!,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
} 