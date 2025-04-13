import 'package:flutter/material.dart';

class RunningColorBorder extends StatefulWidget {
  final double radius;
  final Widget child;

  const RunningColorBorder({
    Key? key, required this.radius, required this.child,
  }) : super(key: key);

  @override
  _RunningColorBorderState createState() => _RunningColorBorderState();
}

class _RunningColorBorderState extends State<RunningColorBorder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.radius),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0.01,
                  ),
                  gradient: SweepGradient(
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.purple,
                      Colors.red,
                    ],
                    stops: [0.0, 0.16, 0.32, 0.48, 0.64, 0.8, 1.0],
                    transform: GradientRotation(_controller.value * 6.28),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.radius),
                    child: widget.child,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}