import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'login_view.dart';
import 'home_view.dart';
import 'character_detail_view.dart';
import 'favorite_spells_view.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Hive
  await Hive.initFlutter();
  await Hive.openBox('favorite_spells');

  // Inisialisasi Notifikasi Lokal
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Harry Potter App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFF5FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          primary: Colors.purple.shade300,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/character_detail', page: () => CharacterDetailView()),
        GetPage(name: '/favorite_spells', page: () => FavoriteSpellsView()),
      ],
    );
  }
}