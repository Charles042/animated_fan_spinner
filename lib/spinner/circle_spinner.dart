import 'dart:math';

import 'package:flutter/material.dart';

class CircleSpinner extends StatefulWidget {
  @override
  _CircleSpinnerState createState() => _CircleSpinnerState();
}

getRandomColor(Random random) {
  var a = random.nextInt(255);
  var r = random.nextInt(255);
  var g = random.nextInt(255);
  var b = random.nextInt(255);
  return Color.fromARGB(a, r, g, b);
}

double maxRadius = 6;
double maxSpeed = .2;
double maxTheta = 2.0 * pi;

class _CircleSpinnerState extends State<CircleSpinner>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  AnimationController bubbleController;
  List<Particles> particles;
  Random random = Random(100);

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    controller.forward();
    controller.repeat();
    bubbleController =
        AnimationController(vsync: this, duration: const Duration(seconds: 15));
    animation = Tween<double>(begin: 0.0, end: 300).animate(bubbleController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          bubbleController.repeat();
        } else if (status == AnimationStatus.dismissed) {
          bubbleController.forward();
        }
        bubbleController.forward();
      });

    this.particles = List.generate(300, (index) {
      var p = Particles();
      p.color = getRandomColor(random);
      p.position = Offset(-1, -1);
      p.speed = random.nextDouble() * 0.2;
      p.theta = random.nextDouble() * 0.2 * pi;

      p.radius = random.nextDouble() * maxRadius;
      return p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width - 20.0,
        child: Center(
          child: CustomPaint(
            painter: BubblePainter(
                particles: particles, animationValue: animation.value),
            child: RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(controller),
              child: Container(
                height: 210.0,
                width: 210.0,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      height: 200.0,
                      width: 200.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[800],
                            Colors.grey[700],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(25.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:AssetImage('assets/images/fanblade.jpg'),
                          radius: 50.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    bubbleController.dispose();
    super.dispose();
  }
}

class BubblePainter extends CustomPainter {
  Offset polarToCartesian(double speed, double theta) {
    return Offset(speed * cos(theta), speed = sin(theta));
  }

  double animationValue;
  List<Particles> particles;

  BubblePainter({this.particles, this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    //updates the object
    this.particles.forEach((p) {
      var velocity = polarToCartesian(p.speed, p.theta);
      var dx = p.position.dx + velocity.dx;
      var dy = p.position.dy + velocity.dy;

      //re-initialize if position is outside the canvas
      if (p.position.dx < 0 || p.position.dx > size.width) {
        dx = Random(DateTime.now().microsecondsSinceEpoch).nextDouble() *
            size.width;
      }

      if (p.position.dy < 0 || p.position.dx > size.height) {
        dy = Random(DateTime.now().microsecondsSinceEpoch).nextDouble() *
            size.height;
      }
      p.position = Offset(dx, dy);
    });

    this.particles.forEach((p) {
      var paint = Paint();
      paint.color = Colors.grey;
      canvas.drawCircle(p.position, p.radius, paint);
    });

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Particles {
  Offset position;
  Color color;

  double speed;
  double theta;

  double radius;
}
