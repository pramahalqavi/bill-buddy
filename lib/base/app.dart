import 'package:billbuddy/base/app_theme.dart';
import 'package:billbuddy/database/app_database.dart';
import 'package:billbuddy/repository/bill_repository.dart';
import 'package:billbuddy/screen/home_screen.dart';
import 'package:billbuddy/utils/string_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/constants.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  await getIt.allReady();
  runApp(const BillBuddyApp());
}

Future<void> initDependencies() async {
  getIt.registerSingletonAsync<AppDatabase>(() async =>
      await $FloorAppDatabase
      .databaseBuilder(Constants.appDatabaseName)
      .build()
  );
  getIt.registerSingleton<ImagePicker>(ImagePicker());
  getIt.registerSingleton<TextRecognizer>(TextRecognizer(script: TextRecognitionScript.latin));
}

class BillBuddyApp extends StatelessWidget {
  const BillBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: getRepositoryProviders(context),
      child: MaterialApp(
        title: StringRes.appName,
        theme: AppTheme.light,
        home: const HomeScreen(),
        )
    );
  }

  static List<RepositoryProvider> getRepositoryProviders(BuildContext context) {
    return [
      RepositoryProvider<BillRepository>(
          create: (context) => BillRepository(getIt.get<AppDatabase>())
      )
    ];
  }
}


