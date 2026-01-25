import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/routing/app_router.dart';
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/core/theme/app_theme.dart';
import 'package:car_care/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleCubit>.value(
      value: getIt<LocaleCubit>(),
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppConstants.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, widget) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.noScaling,
              ),
              child: MaterialApp.router(
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                locale: locale,
                theme: AppTheme.createTheme(
                  isDark: false,
                  languageCode: locale.languageCode,
                ),
                darkTheme: AppTheme.createTheme(
                  isDark: true,
                  languageCode: locale.languageCode,
                ),
                themeMode: ThemeMode.light,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                routerConfig: AppRouter.router,
              ),
            );
          },
        );
      },
    );
  }
}
