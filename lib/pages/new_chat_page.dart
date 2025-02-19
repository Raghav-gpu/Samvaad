import 'dart:math';
import 'package:bot/services/gemini_service.dart';
import 'package:bot/theme.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class HolographicOrb extends StatefulWidget {
  @override
  _HolographicOrbState createState() => _HolographicOrbState();
}

class _HolographicOrbState extends State<HolographicOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;
  late Animation<Offset> _floatAnim;

  final List<Particle> _particles =
      List.generate(150, (i) => Particle()); // Increased particle count

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          seconds: 2), // Slightly longer duration for smoother animation
    )..repeat(reverse: true); // Smoothly reverse the animation

    _scaleAnim = TweenSequence([
      TweenSequenceItem(
          tween: Tween(begin: 0.95, end: 1.05),
          weight: 1), // Reduced scale variation
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 0.95), weight: 1),
    ]).animate(CurvedAnimation(
        parent: _controller, curve: Curves.easeInOut)); // Use Curves.easeInOut

    _opacityAnim = Tween(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.easeInOut), // Use Curves.easeInOut
    );

    _floatAnim = Tween<Offset>(
      begin: Offset(0, -0.05), // Reduced float amplitude
      end: Offset(0, 0.05),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Use Curves.easeInOut
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background particles
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            painter: ParticlePainter(_particles, _controller.value),
            size: Size(300, 300),
          ),
        ),
        // Main orb
        SlideTransition(
          position: _floatAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.8),
                    Colors.tealAccent.withOpacity(0.25),
                    Colors.transparent,
                  ],
                  stops: [0.1, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 20,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Holographic grid
                  AnimatedRotation(
                    duration: Duration(seconds: 2),
                    turns: _controller.value,
                    child: CustomPaint(
                      painter: HolographicGridPainter(),
                    ),
                  ),

                  // Core glow
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.1 * _opacityAnim.value),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HolographicGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    // Draw concentric circles
    for (double i = 1; i <= 5; i++) {
      canvas.drawCircle(center, radius * (i / 5), paint);
    }

    // Draw radial lines
    for (double angle = 0; angle < 2 * pi; angle += pi / 8) {
      canvas.drawLine(
        center,
        center + Offset(cos(angle), sin(angle)) * radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class Particle {
  double radius = Random().nextDouble() * 1.5 + 0.8; // Smaller particle size
  Offset position = Offset(
    Random().nextDouble() * 300 - 150,
    Random().nextDouble() * 300 - 150,
  );
  Color color = Colors.cyan
      .withOpacity(Random().nextDouble() * 0.2 + 0.1); // More opaque particles
  double speed = Random().nextDouble() * 0.8 + 0.2; // Adjusted speed
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double time;

  ParticlePainter(this.particles, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;
      final offset = Offset(
        particle.position.dx +
            sin(time * particle.speed * 2) * 15, // Adjusted movement
        particle.position.dy + cos(time * particle.speed * 2) * 15,
      );
      canvas.drawCircle(offset, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];
  final GeminiService _geminiService = GeminiService();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add({
        'sender': 'user',
        'message': _controller.text,
        'time': DateTime.now().toString(),
      });
    });

    final query = _controller.text;
    _controller.clear();

    // Add loading indicator
    setState(() => _messages.add({
          'sender': 'bot',
          'message': 'Thinking...',
          'time': DateTime.now().toString(),
        }));

    try {
      final response = await _geminiService.getGeminiResponse(query);
      setState(() {
        _messages.removeLast();
        _messages.add({
          'sender': 'bot',
          'message': response.replaceAll("**", ""),
          'time': DateTime.now().toString(),
        });
      });
    } catch (e) {
      setState(() {
        _messages.removeLast();
        _messages.add({
          'sender': 'bot',
          'message': 'Connection error: ${e.toString()}',
          'time': DateTime.now().toString(),
        });
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutCirc,
      );
    });
  }

  Widget _messageBubble(Map<String, String> message) {
    final isUser = message['sender'] == 'user';
    final msgColor = isUser ? Colors.cyan[700] : AppColors.background;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        alignment: align,
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: msgColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: isUser ? Radius.circular(20) : Radius.circular(4),
                bottomRight: isUser ? Radius.circular(4) : Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.cyan.withOpacity(0.3),
                width: 0.5,
              ),
            ),
            child: Text(
              message['message']!,
              style: TextStyle(
                color: isUser ? Color(0xFFD1D5DB) : Colors.white,
                fontSize: 16,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'SAMVAAD',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontSize: 18,
            letterSpacing: 2,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        shadowColor: Colors.cyan,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? HolographicOrb()
                : ListView.custom(
                    controller: _scrollController,
                    padding: EdgeInsets.all(20),
                    physics: BouncingScrollPhysics(),
                    childrenDelegate: SliverChildBuilderDelegate(
                      (context, i) => _messageBubble(_messages[i]),
                      childCount: _messages.length,
                    ),
                  ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF11171D),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Ask anything...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      suffixIcon: Icon(Icons.mic_none, color: Colors.cyan),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyan.withOpacity(0.4),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
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
