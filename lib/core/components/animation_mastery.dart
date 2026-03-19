import 'package:adalem/core/components/model_mastery.dart';
import 'package:flutter/material.dart';

class MasteryAnimation extends StatefulWidget {
  final int mastery;

  const MasteryAnimation({super.key, required this.mastery});

  @override
  State<MasteryAnimation> createState() => _MasteryAnimationState();
}

class _MasteryAnimationState extends State<MasteryAnimation> 
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
    String masteryText;
    switch(widget.mastery){
      case 1: masteryText = MasteryLevel.level1.label; break;
      case 2: masteryText = MasteryLevel.level2.label; break;
      case 3: masteryText = MasteryLevel.level3.label; break;
      case 4: masteryText = MasteryLevel.level4.label; break;
      case 5: masteryText = MasteryLevel.level5.label; break;
      default: masteryText = MasteryLevel.level1.label; break;
    }
    return Center(
      child: UnconstrainedBox(
        clipBehavior: Clip.hardEdge,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle:  _controller.value * 2 * 3.1416,
                  origin: Offset(0, 0),
                  child: child,
                  );
              },
              child: Image(
                image: AssetImage("assets/img_shine.png"),
                opacity: const AlwaysStoppedAnimation<double>(0.1),
                color: Theme.of(context).colorScheme.inverseSurface,
                width: 850,
                ),
              ),
        
              Column(
                children: [
                  SizedBox(height: 60),
                  Image(
                    image: AssetImage("assets/ic_mastery${widget.mastery}.png"),
                    width: 250,
                  ),
                  SizedBox(height: 10),
                  Text("Mastery:".toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                      fontSize: 13,
                      ),
                  ),
                  SizedBox(height: 10),
                  Text(masteryText.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontFamily: "LoveYaLikeASister",
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      height: 0.9,
                    fontSize: 32,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}