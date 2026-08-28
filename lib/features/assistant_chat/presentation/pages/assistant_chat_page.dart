import 'package:car_care/core/constants/app_constants.dart';
import 'package:car_care/core/routing/navigation_x.dart';
import 'package:car_care/core/utils/failure_localizer.dart';
import 'package:car_care/core/routing/routes.dart';
import 'package:car_care/core/theme/app_colors.dart';
import 'package:car_care/core/utils/app_snackbar.dart';
import 'package:car_care/core/widgets/custom_appbar.dart';
import 'package:car_care/core/widgets/image_background.dart';
import 'package:car_care/core/widgets/loding.dart';
import 'package:car_care/features/assistant_chat/presentation/cubit/assistant_chat_cubit.dart';
import 'package:car_care/features/assistant_chat/presentation/cubit/assistant_chat_state.dart';
import 'package:car_care/features/assistant_chat/presentation/widgets/Chat%20Bubble%20Widget.dart';
import 'package:car_care/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssistantChatPage extends StatefulWidget {
  const AssistantChatPage({super.key});

  @override
  State<AssistantChatPage> createState() => _AssistantChatPageState();
}

class _AssistantChatPageState extends State<AssistantChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AssistantChatCubit>().getHistory();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    context.read<AssistantChatCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  Future<void> _confirmDeleteHistory() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.assistantChatDeleteHistoryTitle),
        content: Text(l10n.assistantChatDeleteHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<AssistantChatCubit>().deleteHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground(context),
      appBar: CustomAppBar(
        title: l10n.assistantChatTitle,
        showBackButton: true,
        backgroundColor: AppColors.carWashTeal,
        onBackTapped: () => context.safePopOrGo(Routes.home),
        actionWidget: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.white, size: 22.sp),
          onPressed: _confirmDeleteHistory,
        ),
      ),
      body: ImageBackground(
        child: BlocConsumer<AssistantChatCubit, AssistantChatState>(
          listener: (context, state) {
            if (state is AssistantChatLoaded && state.errorMessage != null) {
              AppSnackBar.error(context, localizeErrorMessage(context, state.errorMessage));
            }
          },
          builder: (context, state) {
            if (state is AssistantChatLoading) {
              return const Center(child: AppLoadingWidget());
            }

            if (state is AssistantChatError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(localizeErrorMessage(context, state.message)),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () =>
                          context.read<AssistantChatCubit>().getHistory(),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              );
            }

            if (state is AssistantChatLoaded) {
              _scrollToBottom();
              return SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: state.messages.isEmpty
                          ? Center(child: Text(l10n.assistantChatEmpty))
                          : ListView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.fromLTRB(
                                AppConstants.pageHorizontal,
                                16.h,
                                AppConstants.pageHorizontal,
                                16.h,
                              ),
                              itemCount: state.messages.length,
                              itemBuilder: (_, index) {
                                final msg = state.messages[index];
                                return ChatBubble(
                                  isUser: msg.role == 'user',
                                  content: msg.content ?? '',
                                );
                              },
                            ),
                    ),

                    if (state.isSending)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Text(
                          l10n.assistantChatTyping,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),

                    Padding(
                      padding: EdgeInsets.all(AppConstants.pageHorizontal),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              minLines: 1,
                              maxLines: 4,
                              textInputAction: TextInputAction.send,
                              textDirection: Directionality.of(context),
                              textAlign: TextAlign.start,
                              onSubmitted: (_) => _send(),
                              decoration: InputDecoration(
                                hintText: l10n.assistantChatHint,
                                hintTextDirection: Directionality.of(context),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                  borderSide: BorderSide(
                                    color: AppColors.accent,
                                    width: 1.2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                  borderSide: BorderSide(
                                    color: AppColors.accent,
                                    width: 1.8,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.r),
                                  borderSide: BorderSide(
                                    color: AppColors.accent,
                                    width: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButton(
                            icon: Icon(Icons.send, color: AppColors.accent),
                            onPressed: state.isSending ? null : _send,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}