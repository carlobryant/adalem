import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/repo_impl.dart';
import 'package:adalem/features/notebooks/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/nav/create_nav.dart';
import 'package:adalem/nav/explore_nav.dart';
import 'package:adalem/nav/home_nav.dart';
import 'package:adalem/nav/profile_nav.dart';
import 'package:adalem/nav/share_nav.dart';
import 'package:flutter/material.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Shell> {
  int _selectedIndex = 0;

  final PageStorageBucket _bucket = PageStorageBucket();
  late final NotebookViewModel _notebookViewModel;
  
 @override
void initState() {
  super.initState();
  final notebookRepo = NotebookRepositoryImpl(
    dataSource: FirestoreDataSourceImpl(),
  );

  _notebookViewModel = NotebookViewModel(
    getNotebooks: GetNotebooks(notebookRepo),
    createNotebook: CreateNotebook(notebookRepo),
  );

  _notebookViewModel.loadNotebooks();
}

  @override
  void dispose() {
    _notebookViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home'),
          NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search),
            label: 'Search'),
          NavigationDestination(
            selectedIcon: Icon(Icons.add),
            icon: Icon(Icons.add),
            label: ''),
          NavigationDestination(
            selectedIcon: Icon(Icons.ios_share),
            icon: Icon(Icons.ios_share),
            label: 'Share'),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Me'),       
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
      ),

      body: SafeArea(
        top: false,
        child: PageStorage(
          bucket: _bucket,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              Home(),
              Explore(notebookViewModel: _notebookViewModel),
              Create(notebookViewModel: _notebookViewModel),
              Share(),
              Profile(),
            ],
          )
        ),
      ),
    );
  }
}