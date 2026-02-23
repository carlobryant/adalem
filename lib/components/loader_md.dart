import 'dart:async';
import 'package:flutter/material.dart';

class MediumLoader extends StatefulWidget {
  final List<String>? loading;

  const MediumLoader({super.key, this.loading});

  @override
  State<MediumLoader> createState() => _MediumLoaderState();
}

class _MediumLoaderState extends State<MediumLoader> 
  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curved;
  Timer? _textTimer;
  int _textIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
     )..repeat();

    _curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.slowMiddle,
    );

    if(widget.loading?.isNotEmpty ?? false) {
      _textTimer = Timer.periodic(
        const Duration(seconds: 3), 
        (timer) => setState(() {
          _textIndex = (_textIndex + 1) % widget.loading!.length;
        }));
    }
  }

  @override
  void dispose() {
    _textTimer?.cancel();
    _curved.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _curved,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _curved.value * 3 * 3.1416,
                    origin: Offset(1.1, -12.8),
                    child: child,
                    );
                },
                child: Image(
                  image: AssetImage("assets/ic_loadergear.png"),
                  width: 80,
                  color: Colors.grey.shade600,
                  ),
                ),
          
                Image(
                  image: AssetImage("assets/ic_loader.png"),
                  width: 80,
                  color: Colors.grey.shade600,
                  ),
            ],
          ),
  
          widget.loading?.isNotEmpty ?? false ?
          SizedBox(height: 30) : SizedBox(),
  
          Text(
            widget.loading?.isNotEmpty ?? false ?
            widget.loading![_textIndex] : "",
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}