import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_care/core/service/fcm_service.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load();
    log('Environment variables loaded successfully');
  } catch (e) {
    log('Error loading .env file: $e');
  }
  await ScreenUtil.ensureScreenSize();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  var firebaseReady = false;
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    firebaseReady = true;
  } catch (e, s) {
    log('Firebase initialization failed: $e', stackTrace: s);
  }

  await setupServiceLocator();

  if (firebaseReady) {
    try {
      await getIt<FcmService>().initializeNotifications();
      getIt<FcmService>().listenToMessages();
    } catch (e, s) {
      log('Notification initialization failed: $e', stackTrace: s);
    }
  }

  runApp(await builder());

  if (firebaseReady) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(getIt<FcmService>().handleInitialMessage());
    });
  }
}

