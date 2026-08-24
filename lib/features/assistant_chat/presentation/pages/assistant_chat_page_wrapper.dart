// lib/features/assistant_chat/presentation/pages/assistant_chat_page_wrapper.dart
import 'package:car_care/core/service_locator/service_locator.dart';
import 'package:car_care/features/assistant_chat/presentation/cubit/assistant_chat_cubit.dart';
import 'package:car_care/features/assistant_chat/presentation/pages/assistant_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssistantChatPageWrapper extends StatelessWidget {
  const AssistantChatPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AssistantChatCubit>(),
      child: const AssistantChatPage(),
    );
  }
}