import 'dart:io';
import 'package:adalem/core/components/loader_md.dart';
import 'package:adalem/features/auth/data/google_datasource.dart';
import 'package:adalem/features/auth/data/repo_impl.dart';
import 'package:adalem/features/auth/domain/uc_getauthstate.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/auth/domain/uc_googlesignin.dart';
import 'package:adalem/features/auth/domain/uc_signout.dart';
import 'package:adalem/features/auth/presentation/view_login.dart';
import 'package:adalem/config/firebase_options.dart';
import 'package:adalem/features/auth/presentation/vm_login.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/data/repo_impl.dart';
import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:adalem/nav/authgate_nav.dart';
import 'package:adalem/shell.dart';
import 'package:adalem/core/theme_mode.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final authRepo = AuthRepositoryImpl(dataSource: AuthRemoteDataSourceImpl());
  final notebookRepo = NotebookRepositoryImpl(dataSource: FirestoreDataSourceImpl());
  final contentRepo = ContentRepositoryImpl(dataSource: ContentDataSourceImpl());
  final getAuthState = GetAuthState(authRepo);

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: authRepo),
        Provider.value(value: notebookRepo),
        Provider.value(value: contentRepo),
        Provider.value(value: getAuthState),

        ChangeNotifierProvider(
        create: (_) => LoginViewModel(
          signInWithGoogle: SignInWithGoogle(authRepo),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotebookViewModel(
            getNotebooks: GetNotebooks(notebookRepo), 
          )..loadNotebooks(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateViewModel(
            createNotebook: CreateNotebook(
              contentRepo: contentRepo,
            ),
            getCurrentUser: GetCurrentUser(authRepo),
            ),
          ),
        ChangeNotifierProvider(
          create:(_) => ProfileViewModel(
            signOut: SignOut(authRepo), 
            getCurrentUser: GetCurrentUser(authRepo),
          )..init(),
        ),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADALEM',

      theme: lightMode,
      darkTheme: darkMode,
      
      //home: SmallLoader(),
      home: const AuthGate(), //Add view: ADALEM is only available on Android
      //view for new user/tutorial

      routes: {
        '/home': (context) => const Shell(),
      }
    );
  }
}

//Try debug paint

