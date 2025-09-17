import 'dart:math' as math;
import 'package:flutter/material.dart';

// Add BackgroundEffects class
class BackgroundEffects extends StatelessWidget {
  const BackgroundEffects({super.key});

  @override
  Widget build(BuildContext context) {
    return FuturisticBackground(
      child: Container(),
    );
  }
}

class FuturisticBackground extends StatefulWidget {
  final Widget child;
  final bool enableNeonEdges;

  const FuturisticBackground({
    super.key,
    required this.child,
    this.enableNeonEdges = true,
  });

  @override
  State<FuturisticBackground> createState() => _FuturisticBackgroundState();
}

class _FuturisticBackgroundState extends State<FuturisticBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Solid background with subtle gradient
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF000000),
                const Color(0xFF050505),
                const Color(0xFF080808),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        ),
        
        // Neon Edge Glow (subtle cyan edges)
        if (widget.enableNeonEdges)
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return CustomPaint(
                  painter: NeonEdgePainter(
                    color: const Color(0xFF00E5FF),
                    glowWidth: 2.0,
                  ),
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                );
              },
            ),
          ),
        
        // Content
        widget.child,
      ],
    );
  }
}

class NeonEdgePainter extends CustomPainter {
  final Color color;
  final double glowWidth;
  
  NeonEdgePainter({
    required this.color,
    this.glowWidth = 2.0,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    // Top edge
    final topGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    );
    
    final topPaint = Paint()
      ..shader = topGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, glowWidth * 5),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, glowWidth * 5),
      topPaint,
    );
    
    // Left edge
    final leftGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    );
    
    final leftPaint = Paint()
      ..shader = leftGradient.createShader(
        Rect.fromLTWH(0, 0, glowWidth * 5, size.height),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, glowWidth * 5, size.height),
      leftPaint,
    );
    
    // Right edge
    final rightGradient = LinearGradient(
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    );
    
    final rightPaint = Paint()
      ..shader = rightGradient.createShader(
        Rect.fromLTWH(size.width - glowWidth * 5, 0, glowWidth * 5, size.height),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(size.width - glowWidth * 5, 0, glowWidth * 5, size.height),
      rightPaint,
    );
    
    // Bottom edge
    final bottomGradient = LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        color.withOpacity(0.2),
        color.withOpacity(0.0),
      ],
      stops: const [0.0, 1.0],
    );
    
    final bottomPaint = Paint()
      ..shader = bottomGradient.createShader(
        Rect.fromLTWH(0, size.height - glowWidth * 5, size.width, glowWidth * 5),
      );
    
    canvas.drawRect(
      Rect.fromLTWH(0, size.height - glowWidth * 5, size.width, glowWidth * 5),
      bottomPaint,
    );
  }
  
  @override
  bool shouldRepaint(NeonEdgePainter oldDelegate) {
    return oldDelegate.color != color || 
           oldDelegate.glowWidth != glowWidth;
  }
}

class CloudPainter extends CustomPainter {
  final double animationValue;
  final Color cloudColor;
  final List<Cloud> _clouds = [];

  CloudPainter({
    required this.animationValue,
    required this.cloudColor,
  }) {
    if (_clouds.isEmpty) {
      _initClouds();
    } else {
      _updateClouds();
    }
  }

  void _initClouds() {
    final random = math.Random();
    for (int i = 0; i < 6; i++) {
      _clouds.add(
        Cloud(
          x: random.nextDouble(),
          y: 0.1 + random.nextDouble() * 0.8,
          size: 0.2 + random.nextDouble() * 0.5,
          speed: 0.01 + random.nextDouble() * 0.02,
          offset: random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  void _updateClouds() {
    for (final cloud in _clouds) {
      cloud.update(animationValue);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final cloud in _clouds) {
      final position = Offset(
        cloud.x * size.width,
        cloud.y * size.height,
      );
      
      final cloudWidth = size.width * cloud.size;
      final cloudHeight = cloudWidth * 0.6;
      
      final paint = Paint()
        ..color = cloudColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 50);
      
      // Draw cloud shape as a series of circles
      final centerX = position.dx;
      final centerY = position.dy;
      
      canvas.drawCircle(
        Offset(centerX, centerY),
        cloudWidth * 0.3,
        paint,
      );
      
      canvas.drawCircle(
        Offset(centerX - cloudWidth * 0.25, centerY + cloudHeight * 0.1),
        cloudWidth * 0.25,
        paint,
      );
      
      canvas.drawCircle(
        Offset(centerX + cloudWidth * 0.25, centerY + cloudHeight * 0.05),
        cloudWidth * 0.28,
        paint,
      );
      
      canvas.drawCircle(
        Offset(centerX - cloudWidth * 0.4, centerY - cloudHeight * 0.05),
        cloudWidth * 0.2,
        paint,
      );
      
      canvas.drawCircle(
        Offset(centerX + cloudWidth * 0.4, centerY - cloudHeight * 0.1),
        cloudWidth * 0.22,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CloudPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class Cloud {
  double x;
  double y;
  final double size;
  final double speed;
  final double offset;

  Cloud({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.offset,
  });

  void update(double animationValue) {
    // Move cloud horizontally with slight vertical drift
    x -= speed;
    y += math.sin(animationValue * 2 * math.pi + offset) * 0.001;
    
    // Reset position when cloud goes off-screen
    if (x < -0.5) {
      x = 1.5;
    }
  }
}

class GridPainter extends CustomPainter {
  final double animationValue;
  final Color gridColor;
  final double gridSpacing;
  final int gridDensity;

  GridPainter({
    required this.animationValue,
    required this.gridColor,
    required this.gridSpacing,
    required this.gridDensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    final horizontalLines = (size.height / gridSpacing).ceil();
    final verticalLines = (size.width / gridSpacing).ceil();
    
    // Draw horizontal lines
    for (int i = 0; i <= horizontalLines; i++) {
      final y = i * gridSpacing;
      
      // Add perspective effect
      final offsetFactor = (y / size.height) * 20;
      // Slow down the animation for less flickering
      final xStart = offsetFactor + (5 * math.sin(animationValue * math.pi * 0.5));
      
      final horizontalPaint = Paint()
        ..color = gridColor.withOpacity(1 - (y / size.height) * 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      
      canvas.drawLine(
        Offset(xStart, y),
        Offset(size.width, y),
        horizontalPaint,
      );
    }
    
    // Draw vertical lines
    for (int i = 0; i <= verticalLines; i++) {
      final x = i * gridSpacing;
      
      // Add perspective effect
      final vanishingPointY = size.height * 0.4;
      final perspectiveFactor = 1 - (x / size.width) * 0.5;
      final startY = vanishingPointY - vanishingPointY * perspectiveFactor;
      
      final verticalPaint = Paint()
        ..color = gridColor.withOpacity(1 - (x / size.width) * 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, size.height),
        verticalPaint,
      );
    }
    
    // Draw diagonal lines for 3D effect (fewer lines for less visual noise)
    final diagonalCount = gridDensity ~/ 2;
    for (int i = 0; i < diagonalCount; i++) {
      final t = i / (diagonalCount - 1);
      final x = size.width * t;
      // Slow down the animation for less flickering
      final y = size.height * 0.3 + (size.height * 0.05 * math.sin(animationValue * math.pi * 0.5 + t * 5));
      
      final diagonalPaint = Paint()
        ..color = gridColor.withOpacity(0.2 * (1 - t))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;
      
      canvas.drawLine(
        Offset(x, y),
        Offset(size.width / 2, 0),
        diagonalPaint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final Color particleColor;
  final int particleCount;
  final List<Particle> _particles = [];

  ParticlesPainter({
    required this.animationValue,
    required this.particleColor,
    required this.particleCount,
  }) {
    if (_particles.isEmpty) {
      _initParticles();
    } else {
      _updateParticles();
    }
  }

  void _initParticles() {
    final random = math.Random();
    for (int i = 0; i < particleCount; i++) {
      _particles.add(
        Particle(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: 1 + random.nextDouble() * 3,
          speed: 0.1 + random.nextDouble() * 0.3, // Slower particles
          offset: random.nextDouble() * 2 * math.pi,
        ),
      );
    }
  }

  void _updateParticles() {
    for (final particle in _particles) {
      particle.update(animationValue);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = particleColor
      ..style = PaintingStyle.fill;
    
    for (final particle in _particles) {
      final position = Offset(
        particle.x * size.width,
        particle.y * size.height,
      );
      
      // Glowing effect
      final glowPaint = Paint()
        ..color = particleColor.withOpacity(0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5.0);
      
      canvas.drawCircle(position, particle.size * 2, glowPaint);
      canvas.drawCircle(position, particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final double speed;
  final double offset;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.offset,
  });

  void update(double animationValue) {
    // Move particle in a slight wavy pattern but slower
    x += math.sin(animationValue * math.pi + offset) * 0.005;
    y -= speed * 0.005; // Slower upward movement
    
    // Reset position when particle goes off-screen
    if (y < -0.1) {
      y = 1.1;
      x = math.Random().nextDouble();
    }
    
    // Keep particles within bounds
    if (x < 0) x = 1;
    if (x > 1) x = 0;
  }
}

class CyberPanel extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color borderColor;
  final List<Color> gradientColors;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final double cornerRadius;
  final double cornerSize;
  final bool showTopLeftCorner;
  final bool showTopRightCorner;
  final bool showBottomLeftCorner;
  final bool showBottomRightCorner;
  final EdgeInsetsGeometry padding;
  
  const CyberPanel({
    super.key,
    required this.child,
    this.borderWidth = 2.0,
    this.borderColor = const Color(0xFF00E5FF),
    this.gradientColors = const [Color(0xFF101010), Color(0xFF000000)],
    this.gradientBegin = Alignment.topLeft,
    this.gradientEnd = Alignment.bottomRight,
    this.cornerRadius = 8.0,
    this.cornerSize = 20.0,
    this.showTopLeftCorner = true,
    this.showTopRightCorner = true,
    this.showBottomLeftCorner = true,
    this.showBottomRightCorner = true,
    this.padding = const EdgeInsets.all(16.0),
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: CustomPaint(
        painter: CyberPanelPainter(
          borderWidth: borderWidth,
          borderColor: borderColor,
          cornerRadius: cornerRadius,
          cornerSize: cornerSize,
          showTopLeftCorner: showTopLeftCorner,
          showTopRightCorner: showTopRightCorner,
          showBottomLeftCorner: showBottomLeftCorner,
          showBottomRightCorner: showBottomRightCorner,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: gradientBegin,
              end: gradientEnd,
              colors: gradientColors,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class CyberPanelPainter extends CustomPainter {
  final double borderWidth;
  final Color borderColor;
  final double cornerRadius;
  final double cornerSize;
  final bool showTopLeftCorner;
  final bool showTopRightCorner;
  final bool showBottomLeftCorner;
  final bool showBottomRightCorner;
  
  CyberPanelPainter({
    required this.borderWidth,
    required this.borderColor,
    required this.cornerRadius,
    required this.cornerSize,
    required this.showTopLeftCorner,
    required this.showTopRightCorner,
    required this.showBottomLeftCorner,
    required this.showBottomRightCorner,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    
    final path = Path();
    
    // Top Left Corner
    if (showTopLeftCorner) {
      path.moveTo(0, cornerSize);
      path.lineTo(0, cornerRadius);
      path.quadraticBezierTo(0, 0, cornerRadius, 0);
      path.lineTo(cornerSize, 0);
    } else {
      path.moveTo(0, 0);
      path.lineTo(cornerSize, 0);
    }
    
    // Top Right Corner
    if (showTopRightCorner) {
      path.moveTo(size.width - cornerSize, 0);
      path.lineTo(size.width - cornerRadius, 0);
      path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
      path.lineTo(size.width, cornerSize);
    } else {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, cornerSize);
    }
    
    // Bottom Right Corner
    if (showBottomRightCorner) {
      path.moveTo(size.width, size.height - cornerSize);
      path.lineTo(size.width, size.height - cornerRadius);
      path.quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height);
      path.lineTo(size.width - cornerSize, size.height);
    } else {
      path.moveTo(size.width, size.height);
      path.lineTo(size.width - cornerSize, size.height);
    }
    
    // Bottom Left Corner
    if (showBottomLeftCorner) {
      path.moveTo(cornerSize, size.height);
      path.lineTo(cornerRadius, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - cornerRadius);
      path.lineTo(0, size.height - cornerSize);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(0, size.height - cornerSize);
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(CyberPanelPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor || 
           oldDelegate.borderWidth != borderWidth ||
           oldDelegate.cornerRadius != cornerRadius ||
           oldDelegate.cornerSize != cornerSize;
  }
} 