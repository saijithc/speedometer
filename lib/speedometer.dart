import 'package:flutter/material.dart';
import 'package:speedometer/meter_painter.dart';

class Speedometer extends StatefulWidget {
  const Speedometer({super.key});

  @override
  State<Speedometer> createState() => _SpeedometerState();
}

class _SpeedometerState extends State<Speedometer>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  bool isPressing = false;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    animation = Tween<double>(begin: 0, end: 100).animate(controller);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 400,
                width: MediaQuery.sizeOf(context).width,
                child: AnimatedBuilder(
                  builder: (context, child) {
                    return CustomPaint(
                      painter: MeterPainter(percentage: animation.value),
                    );
                  },
                  animation: controller,
                ),
              ),
              GestureDetector(
                onLongPress: () {
                  setState(() {
                    isPressing = true;
                  });
                  controller.forward();
                },
                onLongPressEnd: (details) async {
                  setState(() {
                    isPressing = false;
                  });
                  await Future.delayed(
                    const Duration(milliseconds: 400),
                  );
                  controller.animateBack(0,
                      duration: const Duration(seconds: 12));
                },
                child: Container(
                  height: 45,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isPressing ? Colors.green[200] : Colors.green),
                  child: const Center(
                    child: Text(
                      'accelerator',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
