import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
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

  // Initialize service locator (dependency injection)
  await setupServiceLocator();
  // Load the .env file to get the variables from it
  await dotenv.load(fileName: ".env");
  runApp(await builder());
}

