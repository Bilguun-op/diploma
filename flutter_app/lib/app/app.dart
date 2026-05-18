import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';
import '../pages/grammar_page.dart';
import '../pages/arcade_page.dart';
import '../pages/profile_page.dart';
import '../widgets/app_header.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreProvider>(
      builder: (context, store, _) {
        if (!store.user.loggedIn) {
          return const LoginPage();
        }

        return Scaffold(
          body: Column(
            children: [
              const AppHeader(),
              Expanded(
                child: _buildCurrentPage(context, store),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCurrentPage(BuildContext context, StoreProvider store) {
    switch (store.currentRoute) {
      case '/':
        return const HomePage();
      case '/grammar':
        return const GrammarPage();
      case '/arcade':
        return const ArcadePage();
      case '/profile':
        return const ProfilePage();
      case '/login':
        return const LoginPage();
      default:
        return const HomePage();
    }
  }
}
