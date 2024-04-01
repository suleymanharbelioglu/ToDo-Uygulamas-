import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:v230/data/local_storage.dart';
import 'package:v230/models/task_model.dart';
import 'package:v230/pages/home_page.dart';

final locator = GetIt.instance;
void setUp() {
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setUpHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  var taskBox = await Hive.openBox<Task>("tasks");
  for (var task in taskBox.values) {
    if (task.createdAt.day != DateTime.now().day) {
      taskBox.delete(task.id);
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await setUpHive();
  setUp();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('tr', 'TR')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.deviceLocale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            elevation: 4,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
      ),
      home: HomePage(),
    );
  }
}
