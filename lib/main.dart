import 'package:collab_tasker/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/firebase_options.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/core/theme/app_theme.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          scaffoldMessengerKey: snackbarKey,
          routerConfig: router,
          title: 'Collab Tasker',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
        );
      },
    );
  }
}
