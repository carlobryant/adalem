import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShareToUsers extends StatelessWidget {
  final Function(String uid) onRemove;
  final VoidCallback onShare;
  final List<AuthUser> users;
  final bool isEmpty;

  const ShareToUsers({
    super.key,
    required this.users,
    required this.onShare,
    required this.onRemove,
    required this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1);
    final borderColor = Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.1);

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
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
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: users.length,
              separatorBuilder: (context, index) => SizedBox(height: 8),
              itemBuilder: (context, index) => _buildUser(context, users[index]),
            ),

            isEmpty ? const SizedBox.shrink()
            : Padding(
              padding: const EdgeInsets.all(8.0),
              child: XLButton(
                  onTap: onShare,
                  child: Text("Share",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUser(BuildContext context, AuthUser user) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          foregroundImage: user.photoURL.isNotEmpty
              ? CachedNetworkImageProvider(user.photoURL)
              : null,
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          child: Image(
            image: const AssetImage("assets/ic_error.png"),
            color: Theme.of(context).colorScheme.surface,
            width: 18,
          ),
        ),
        title: Text(user.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Theme.of(context).colorScheme.inverseSurface,
          ),
        ),
        subtitle: Text(user.email,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.inverseSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: IconButton(
          onPressed: () => onRemove(user.uid),
          icon: Icon(
            Icons.remove_circle_outline_rounded,
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}