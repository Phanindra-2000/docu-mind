import 'package:flutter/material.dart';
import 'package:docu_mind/core/router/app_router.dart';
import 'package:docu_mind/core/theme/app_theme.dart';
import 'package:docu_mind/features/splash/presentation/widgets/splash_wrapper.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'DocuMind',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return SplashWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: AppRouter.router,
    );
  }
}
