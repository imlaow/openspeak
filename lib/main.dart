import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const ProviderScope(child: OpenSpeakApp()));
}

class OpenSpeakApp extends StatelessWidget {
  const OpenSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return AnimatedBuilder(
          animation: themeController,
          builder: (context, _) {
            final useDynamic = themeController.useDynamicColor;
            final lightScheme = useDynamic
                ? lightDynamic
                : ColorScheme.fromSeed(
                    seedColor: themeController.seedColor,
                    brightness: Brightness.light,
                  );
            final darkScheme = useDynamic
                ? darkDynamic
                : ColorScheme.fromSeed(
                    seedColor: themeController.seedColor,
                    brightness: Brightness.dark,
                  );

            return MaterialApp.router(
              title: 'OpenSpeak',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(dynamicScheme: lightScheme),
              darkTheme: AppTheme.dark(dynamicScheme: darkScheme),
              themeMode: themeController.themeMode,
              routerConfig: appRouter,
            );
          },
        );
      },
    );
  }
}
