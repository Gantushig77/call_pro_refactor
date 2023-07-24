import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import './model/post.dart';
import './screen/home_page.dart';
import 'constant/config.dart';
import 'screen/post_detail.dart';

void main() async {
  // Checking if Widgets binding is complete
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // Preserving splash until render is ready
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Initializing hive with adapters and making ready to use the box
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  await Hive.openBox(hiveBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // removing splash on render:
    FlutterNativeSplash.remove();
    // Checking system dark mode and user preference
    final box = Hive.box(hiveBoxName);
    final brightness = MediaQuery.of(context).platformBrightness;
    bool systemDark = brightness == Brightness.dark;
    bool isDark = box.get('isDark') ?? systemDark;

    return GetMaterialApp(
      title: 'Refactor Task App',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      initialRoute: MyHomePage.routeName,
      // registering named routes, since it's convenient and useful when handling
      // notification navigations
      getPages: [
        GetPage(name: MyHomePage.routeName, page: () => const MyHomePage()),
        GetPage(name: PostDetailPage.routeName, page: () => const PostDetailPage()),
      ],
    );
  }
}
