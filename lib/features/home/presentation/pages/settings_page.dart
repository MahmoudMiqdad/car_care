import 'package:car_care/core/locale/locale_cubit.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/theme/theme_cubit.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      appBar: CustomAppBar(title: l10n.settingsTitle, showBackButton: true),
      body: ImageBackground(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16.w,
            20.h,
            16.w,
            MediaQuery.paddingOf(context).bottom + 20.h,
          ),
          children: [
            _SectionLabel(label: l10n.languageLabel),
            SizedBox(height: 8.h),
            const _LanguageCard(),
            SizedBox(height: 24.h),
            _SectionLabel(label: l10n.themeLabel),
            SizedBox(height: 8.h),
            const _ThemeCard(),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 4.w),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.textSecondary(context),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ─── Language Section ──────────────────────────────────────────────────────
class _LanguageCard extends StatelessWidget {
  const _LanguageCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return _SettingsCard(
          children: [
            _OptionTile(
              icon: Icons.language_rounded,
              label: l10n.arabicLabel,
              selected: locale.languageCode == 'ar',
              onTap: () =>
                  context.read<LocaleCubit>().setLocale(const Locale('ar')),
            ),
            const _Divider(),
            _OptionTile(
              icon: Icons.language_rounded,
              label: l10n.englishLabel,
              selected: locale.languageCode == 'en',
              onTap: () =>
                  context.read<LocaleCubit>().setLocale(const Locale('en')),
            ),
          ],
        );
      },
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return _SettingsCard(
          children: [
            _OptionTile(
              icon: Icons.light_mode_outlined,
              label: l10n.lightModeLabel,
              selected: mode == ThemeMode.light,
              onTap: () =>
                  context.read<ThemeCubit>().setThemeMode(ThemeMode.light),
            ),
            const _Divider(),
            _OptionTile(
              icon: Icons.dark_mode_outlined,
              label: l10n.darkModeLabel,
              selected: mode == ThemeMode.dark,
              onTap: () =>
                  context.read<ThemeCubit>().setThemeMode(ThemeMode.dark),
            ),
            const _Divider(),
            _OptionTile(
              icon: Icons.settings_suggest_outlined,
              label: l10n.systemModeLabel,
              selected: mode == ThemeMode.system,
              onTap: () =>
                  context.read<ThemeCubit>().setThemeMode(ThemeMode.system),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: AppColors.border(context).withValues(alpha: 0.6),
      height: 1,
      indent: 14.w,
      endIndent: 14.w,
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final unselectedText = AppColors.textSecondary(context);
    final primaryText = AppColors.textPrimary(context);

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? AppColors.primary : unselectedText,
                size: 21.sp,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                
                    color: selected ? AppColors.primary : primaryText,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 20.sp)
              else
                Icon(
                  Icons.radio_button_unchecked,
               
                  color: unselectedText.withValues(alpha: 0.4),
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}