import 'package:adalem/core/components/button_xl.dart';
import 'package:adalem/core/components/card_toast.dart';
import 'package:adalem/features/auth/domain/auth_user.dart';
import 'package:adalem/features/notebooks/presentation/model_notebooks.dart';
import 'package:adalem/features/share/presentation/view_shareselect.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShareCompleteView extends StatefulWidget {
  final VoidCallback onBack;
  final List<AuthUser> users;
  final List<NotebookModel> notebooks;

  const ShareCompleteView({
    super.key,
    required this.onBack,
    required this.users,
    required this.notebooks,
  });

  @override
  State<ShareCompleteView> createState() => _ShareCompleteViewState();
}

class _ShareCompleteViewState extends State<ShareCompleteView>
with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ToastCard.success(context, "Notebooks shared successfully!");
    });

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
    const double avatarRadius = 28.0; 
    const double iconSize = 16.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Text(
          widget.users.length > 1 ?
          "Shared to ${widget.users[0].name} and ${widget.users.length - 1} Others"
          : widget.users.length == 1 ?
          "Shared Successfully to ${widget.users[0].name}"
          : "Shared Notebooks",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: UnconstrainedBox(
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
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                children: [
                  // AVATARS
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12.0, 
                      runSpacing: 12.0, 
                      children: widget.users.map((user) {
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
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
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.surface,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  size: iconSize,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
              
                  Text(
                    "Successfully Shared!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SHARED NOTEBOOKS
                  const SizedBox(height: 30),
                  ShareSelectionView(notebooks: widget.notebooks, isSolid: true),
                  Spacer(),
            
                  // RETURN BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: XLButton(
                      onTap: widget.onBack,
                      child: Text(
                        "Return",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 30),
                ],
              )
              ),
          ],
        ),
      ),
    );
  }
}