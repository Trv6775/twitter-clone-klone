import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_klone_clone/common/common.dart';
import 'package:twitter_klone_clone/common/loading_page.dart';
import 'package:twitter_klone_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_klone_clone/features/auth/views/sign_up_view.dart';
import 'package:twitter_klone_clone/features/home/views/home_view.dart';
import 'package:twitter_klone_clone/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Klone Clone',
      theme: AppTheme.theme,
      home: ref.watch(currentUserAccountProvider).when(
        data: (user) {
          if (user != null) {
            return const HomeView();
          }
          return const SignUpView();
        },
        error: (error, stackTrace) {
          return ErrorPage(
            error: error.toString(),
          );
        },
        loading: () {
          return const LoadingPage();
        },
      ),
    );
  }
}
