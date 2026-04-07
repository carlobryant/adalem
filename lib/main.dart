import 'package:adalem/features/auth/data/google_datasource.dart';
import 'package:adalem/features/auth/data/repo_impl.dart';
import 'package:adalem/features/auth/domain/auth_repo.dart';
import 'package:adalem/features/auth/domain/uc_getauthstate.dart';
import 'package:adalem/features/auth/domain/uc_getuser.dart';
import 'package:adalem/features/auth/domain/uc_googlesignin.dart';
import 'package:adalem/features/auth/domain/uc_signout.dart';
import 'package:adalem/config/firebase_options.dart';
import 'package:adalem/features/create/data/ai_datasource.dart';
import 'package:adalem/features/create/data/repo_impl.dart';
import 'package:adalem/features/create/presentation/vm_create.dart';
import 'package:adalem/features/flashcards/domain/uc_syncflashcards.dart';
import 'package:adalem/features/notebook_content/data/firestore_datasource.dart';
import 'package:adalem/features/notebook_content/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/content_repo.dart';
import 'package:adalem/features/notebooks/data/firestore_datasource.dart';
import 'package:adalem/features/notebooks/data/repo_impl.dart';
import 'package:adalem/features/notebook_content/domain/uc_createnotebook.dart';
import 'package:adalem/features/notebooks/domain/notebook_repo.dart';
import 'package:adalem/features/notebooks/domain/uc_getnotebooks.dart';
import 'package:adalem/features/notebooks/presentation/vm_notebooks.dart';
import 'package:adalem/features/profile/domain/uc_fetchactivity.dart';
import 'package:adalem/features/profile/domain/uc_updateactivity.dart';
import 'package:adalem/features/profile/presentation/vm_profile.dart';
import 'package:adalem/features/quiz/domain/uc_syncquiz.dart';
import 'package:adalem/nav/authgate_nav.dart';
import 'package:adalem/core/app_theme.dart';
import 'package:firebase_ai/firebase_ai.dart';
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
    //cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final modelAI = FirebaseAI.googleAI().generativeModel(model: 'gemini-3-flash-preview');

  final authRepo = AuthRepositoryImpl(dataSource: AuthRemoteDataSourceImpl());
  final notebookRepo = NotebookRepositoryImpl(dataSource: FirestoreDataSourceImpl());
  final aiRepo = AIRepositoryImpl(dataSource: AIDataSourceImpl(modelAI: modelAI));
  final contentRepo = ContentRepositoryImpl(dataSource: ContentDataSourceImpl());

  final signInWithGoogle = SignInWithGoogle(authRepo);
  final getAuthState = GetAuthState(authRepo);
  final getUserProfile = GetUserProfile(authRepo);

  final syncFlashcards = SyncFlashcards(notebookRepo);
  final syncQuizHistory = SyncQuizHistory(notebookRepo);
  

  runApp(
    MultiProvider(
      providers: [
        // INTERFACE PROVIDERS
        Provider<AuthRepo>.value(value: authRepo),
        Provider<NotebookRepo>.value(value: notebookRepo),
        Provider<ContentRepo>.value(value: contentRepo),

        // GLOBAL USE CASES
        Provider.value(value: getAuthState),
        Provider.value(value: getUserProfile),
        Provider.value(value: syncFlashcards),
        Provider.value(value: syncQuizHistory),
        Provider.value(value: signInWithGoogle),

        // GLOBAL VIEWMODELS
        ChangeNotifierProvider(
          create: (_) => NotebookViewModel(
            getNotebooks: GetNotebooks(notebookRepo),
            getCurrentUser: GetCurrentUser(authRepo),
            getUserProfile: getUserProfile,
          )..loadNotebooks(),
        ),
        ChangeNotifierProvider(
          create: (_) => CreateViewModel(
            createNotebook: CreateNotebook(
              contentRepo: contentRepo,
              aiRepo: aiRepo,
            ),
            getCurrentUser: GetCurrentUser(authRepo),
            ),
          ),
        ChangeNotifierProvider(
          create:(_) => ProfileViewModel(
            signOut: SignOut(authRepo), 
            getCurrentUser: GetCurrentUser(authRepo),
            fetchActivity: FetchActivity(authRepo),
            updateActivity: UpdateActivity(authRepo),
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
      
      home: const AuthGate(), 
      //Add view: ADALEM is only available on Android
      //view for new user/tutorial
    );
  }
}

//Try debug paint

