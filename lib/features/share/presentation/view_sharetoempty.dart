import 'package:flutter/material.dart';

class ShareToEmpty extends StatelessWidget {
  const ShareToEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).colorScheme.onSurface;
    final surfaceColor = backgroundColor.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);
    
    final surfaceHeight = MediaQuery.of(context).size.height * 0.25;
    final surfaceWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: surfaceWidth,
      height: surfaceHeight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(15),
          border: BoxBorder.fromLTRB(
              bottom: BorderSide(width: 5, color: borderColor),
              right: BorderSide(width: 3, color: borderColor),
              top: BorderSide.none,
              left: BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfo(surfaceColor, surfaceWidth, backgroundColor,
                "Add a Notebook",
                Icon(
                  Icons.add_box_rounded,
                  color: backgroundColor,
                  size: surfaceWidth * 0.12,
                ),
              ),
              _buildInfo(surfaceColor, surfaceWidth, backgroundColor,
                "Add Email of Receiver",
                Icon(
                  Icons.person_add_alt_1_rounded,
                  color: backgroundColor,
                  size: surfaceWidth * 0.12,
                ),
              ),
              _buildInfo(surfaceColor, surfaceWidth, backgroundColor,
                "Share Your Noteboook!",
                Image(
                  image: const AssetImage("assets/ic_nb_shared.png"),
                  color: backgroundColor,
                  width: surfaceWidth * 0.12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(
    Color surfaceColor, 
    double surfaceWidth,
    Color backgroundColor,
    String description,
    Widget icon,
  ){
    return SizedBox(
      width: surfaceWidth * 0.3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: surfaceWidth * 0.15),
            icon,
            SizedBox(height: 10),
            Expanded(
              child: Text(description,
              style: TextStyle(
                color: backgroundColor,
                fontSize: 14,
                height: 0.9,
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}