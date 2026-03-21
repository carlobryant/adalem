import 'package:adalem/core/components/model_mastery.dart';
import 'package:flutter/material.dart';

class MasteryAnimation extends StatefulWidget {
  final int? addPts;
  final int? currPts;
  final int? maxPts;
  final int mastery;
  final double? progress;

  const MasteryAnimation({
    super.key,
    this.addPts,
    this.currPts,
    this.maxPts,
    required this.mastery,
    this.progress,
    });

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
    final masteryLabel = MasteryLevel.values.firstWhere(
      (level) => level.id == widget.mastery,
      orElse: () => MasteryLevel.level1,
    ).label;

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
        
              SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Column(
                children: [
                  const SizedBox(height: 120),

                  // MASTERY TITLE
                  Image(
                    image: AssetImage("assets/ic_mastery${widget.mastery}.png"),
                    width: 200,
                  ),
                  const SizedBox(height: 10),
                  Text("Mastery:".toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                  Text(masteryLabel.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontFamily: "LoveYaLikeASister",
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      height: 0.9,
                      fontSize: 28,
                    ),
                  ),

                  // MASTERY PROGRESS
                  const SizedBox(height: 5),
                  if(widget.progress != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: widget.progress,
                        minHeight: 24,
                        backgroundColor: Theme.of(context).colorScheme.onSurface,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  const SizedBox(height: 3),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      widget.addPts != null && widget.addPts! > 0 ?
                        Text(
                          "+${widget.addPts} Points",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ) : Spacer(),
                      if(widget.currPts != null && widget.maxPts != null)
                        Text(
                          "${widget.currPts} / ${widget.maxPts} Points",
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}