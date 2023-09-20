import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie/pages/home.dart';
import 'package:movie/pages/landing.dart';
import 'package:movie/pages/login.dart';
import 'package:movie/pages/register.dart';
import 'package:movie/providers/details_provider.dart';
import 'package:movie/providers/fav_movie_provider.dart';
import 'package:movie/providers/loading_provider.dart';
import 'package:movie/providers/search_movie_proivder.dart';
import 'package:movie/providers/theme_mode_provider.dart';
import 'package:movie/providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavProvider()),
        ChangeNotifierProvider(create: (context) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => DetailsProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LoadingProvider()),
      ],
      child: Consumer(builder: (context, ThemeProvider themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movies',
          theme: FlexThemeData.light(
            scheme: FlexScheme.purpleBrown,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 7,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 10,
              blendOnColors: false,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              elevatedButtonSchemeColor: SchemeColor.secondary,
              elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
              segmentedButtonSchemeColor: SchemeColor.primaryContainer,
              segmentedButtonUnselectedSchemeColor: SchemeColor.background,
              segmentedButtonUnselectedForegroundSchemeColor:
                  SchemeColor.onSurface,
              inputDecoratorIsFilled: false,
              inputDecoratorBorderSchemeColor: SchemeColor.primary,
              inputDecoratorBorderType: FlexInputBorderType.underline,
              inputDecoratorPrefixIconSchemeColor: SchemeColor.primaryContainer,
              drawerBackgroundSchemeColor: SchemeColor.surfaceVariant,
              drawerIndicatorSchemeColor: SchemeColor.tertiary,
              drawerSelectedItemSchemeColor: SchemeColor.primaryContainer,
              drawerUnselectedItemSchemeColor: SchemeColor.tertiary,
              bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              bottomNavigationBarUnselectedLabelSchemeColor:
                  SchemeColor.onPrimaryContainer,
              bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
              bottomNavigationBarUnselectedIconSchemeColor:
                  SchemeColor.onPrimaryContainer,
              bottomNavigationBarBackgroundSchemeColor:
                  SchemeColor.surfaceVariant,
              navigationBarSelectedLabelSchemeColor: SchemeColor.onPrimary,
              navigationBarUnselectedLabelSchemeColor: SchemeColor.onSecondary,
              navigationBarSelectedIconSchemeColor: SchemeColor.primary,
              navigationBarUnselectedIconSchemeColor: SchemeColor.onSecondary,
              navigationBarIndicatorSchemeColor: SchemeColor.surfaceVariant,
              navigationBarIndicatorOpacity: 0.40,
              navigationBarOpacity: 0.86,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.purpleBrown,
            surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
            blendLevel: 13,
            subThemesData: const FlexSubThemesData(
              blendOnLevel: 20,
              blendTextTheme: true,
              useTextTheme: true,
              useM2StyleDividerInM3: true,
              elevatedButtonSchemeColor: SchemeColor.secondary,
              elevatedButtonSecondarySchemeColor: SchemeColor.onPrimary,
              segmentedButtonSchemeColor: SchemeColor.primaryContainer,
              segmentedButtonUnselectedSchemeColor: SchemeColor.background,
              segmentedButtonUnselectedForegroundSchemeColor:
                  SchemeColor.onSurface,
              inputDecoratorIsFilled: false,
              inputDecoratorBorderType: FlexInputBorderType.underline,
              drawerBackgroundSchemeColor: SchemeColor.surfaceVariant,
              drawerIndicatorSchemeColor: SchemeColor.tertiary,
              drawerSelectedItemSchemeColor: SchemeColor.primaryContainer,
              drawerUnselectedItemSchemeColor: SchemeColor.tertiary,
              bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
              bottomNavigationBarUnselectedLabelSchemeColor:
                  SchemeColor.onPrimaryContainer,
              bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
              bottomNavigationBarUnselectedIconSchemeColor:
                  SchemeColor.onPrimaryContainer,
              bottomNavigationBarBackgroundSchemeColor:
                  SchemeColor.surfaceVariant,
              navigationBarSelectedLabelSchemeColor: SchemeColor.onPrimary,
              navigationBarUnselectedLabelSchemeColor: SchemeColor.onSecondary,
              navigationBarSelectedIconSchemeColor: SchemeColor.primary,
              navigationBarUnselectedIconSchemeColor: SchemeColor.onSecondary,
              navigationBarIndicatorSchemeColor: SchemeColor.surfaceVariant,
              navigationBarIndicatorOpacity: 0.40,
              navigationBarOpacity: 0.86,
            ),
            visualDensity: FlexColorScheme.comfortablePlatformDensity,
            useMaterial3: true,
            swapLegacyOnMaterial3: true,
            // To use the Playground font, add GoogleFonts package and uncomment
            // fontFamily: GoogleFonts.notoSans().fontFamily,
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => FirebaseAuth.instance.currentUser == null
                ? const LandingPage()
                : const HomePage(),
            'login': (context) => const LoginPage(),
            'register': (context) => const RegisterPage(),
            'home': (context) => const HomePage(),
          },
        );
      }),
    );
  }
}
