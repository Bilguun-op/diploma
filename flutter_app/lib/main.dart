import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app.dart';
import 'providers/store_provider.dart';
import 'providers/i18n_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => StoreProvider(prefs)..loadFromStorage(),
        ),
        ChangeNotifierProvider(
          create: (_) => I18nProvider(prefs)..loadFromStorage(),
        ),
      ],
      child: Consumer<I18nProvider>(
        builder: (context, i18n, _) {
          return MaterialApp(
            title: 'Mongol English Spark',
            debugShowCheckedModeBanner: false,
            locale: Locale(i18n.lang),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('mn'),
            ],
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            home: const App(),
          );
        },
      ),
    );
  }
}
