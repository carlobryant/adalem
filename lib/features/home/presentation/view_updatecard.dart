import 'package:adalem/core/components/card_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateCardView extends StatelessWidget {
  final String title;
  final String description;
  final DateTime createdAt;
  final String? photoURL;
  final String? path;
  final VoidCallback onTap;

  const UpdateCardView({
    super.key,
    required this.title,
    required this.description,
    required this.createdAt,
    this.photoURL,
    this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: path!=null && path!="" ? 
      () => CheckNetwork.execute(
        signedIn: true, 
        context: context, 
        onTap: () async {onTap();
          final uri = Uri.parse(path!);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
      ) : () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat('MMMM dd yyyy').format(createdAt),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 1600 / 400,
                child: Container(
                  width: double.infinity,
                  decoration: photoURL != null ?
                  BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(photoURL!),
                      fit: BoxFit.cover,
                    ),
                  )
                  : BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.justify,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}