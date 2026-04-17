import 'package:adalem/core/app_constraints.dart';
import 'package:adalem/features/home/presentation/view_homelist.dart';
import 'package:adalem/features/home/presentation/view_homeupdates.dart';
import 'package:adalem/features/notebook_content/presentation/view_content.dart';
import 'package:adalem/features/notebooks/presentation/view_hnotebookrank.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final VoidCallback onNavigateToExplore;
  final VoidCallback onNavigateToCreate;

  const HomeView({
    super.key,
    required this.onNavigateToExplore,
    required this.onNavigateToCreate,
    });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;

  @override
   Widget build(BuildContext context) {
    final profilevm = context.watch<ProfileViewModel>();
    final notebookvm = context.watch<NotebookViewModel>();
    final notebooks = notebookvm.rankedNotebooks;
    final updates = profilevm.updates;
    final uid = notebookvm.currentUserId;

    return Scaffold(
      body: NestedScrollView(
        // APP BAR
        headerSliverBuilder:(context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Image(image: AssetImage("assets/img_adalem.png"),
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 35,
                  ),
                ),
                Text("ADALEM",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: "LoveYaLikeASister",
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: widget.onNavigateToExplore, 
                icon: Icon(Icons.search, 
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary
                ),
              ),
            ],
          )
        ],

        body: RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onRefresh: () async {
            notebookvm.setSortOption(notebookvm.currentSort); 
            await Future.delayed(const Duration(milliseconds: 550));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 140, 
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      scrollDirection: Axis.horizontal,
                      
                      itemCount: notebookvm.notebookCount < Constraint.maxCreate ?
                        notebooks.length + 1 : notebooks.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        
                        if (index == notebooks.length 
                        && notebookvm.notebookCount < Constraint.maxCreate) {
                          return Row(
                            children: [
                              if (notebooks.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 70, right: 10),
                                child: SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  child: Text("Create Your First Notebook!",
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 25,
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 70,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 70, left: 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTap: widget.onNavigateToCreate,
                                        child: DottedBorder(
                                          options: CircularDottedBorderOptions(
                                            color: Theme.of(context).colorScheme.primary,
                                            dashPattern: const [8, 4],
                                            strokeWidth: 2,
                                          ),
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: Center(
                                              child: Icon(
                                                Icons.add,
                                                size: 35,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                  
                        final notebook = notebooks[index];
                        return SizedBox(
                          width: 70,
                          height: 70, 
                          child: NotebookWithRank(
                            onTap: () => Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                              builder: (context) => ContentView(
                                notebookId: notebook.id,
                                notebookTitle: notebook.title,
                                notebookCourse: notebook.course,
                                image: notebook.image,
                                ),
                              )),
                            isLoading: notebookvm.isLoading,
                            image: notebook.image, 
                            mastery: notebook.users[uid]?.mastery ?? 0, 
                            course: notebook.course,
                          ),
                        );
                      },
                    ),
                  ),

                  if(updates.isNotEmpty && !notebookvm.isLoading)
                  HomeUpdatesView(
                    updates: updates,
                  ),

                  HomeListView(
                    notebooks: notebookvm.toDoNotebooks,
                    isLoading: notebookvm.isLoading,    
                    uid: uid,                            
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}