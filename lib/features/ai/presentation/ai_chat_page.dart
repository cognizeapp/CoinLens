import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/l10n_extensions.dart';
import '../../../core/widgets/state_views.dart';
import '../../coin/domain/coin_models.dart';
import '../../coin/presentation/coin_providers.dart';
import 'ai_chat_controller.dart';

class AiChatPage extends ConsumerWidget {
  const AiChatPage({super.key, required this.scanId});
  final String scanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scan = ref.watch(scanByIdProvider(scanId));
    return Scaffold(
      appBar: AppBar(title: Text(l.aiAssistantTitle)),
      body: scan.when(
        loading: () => const LoadingView(),
        error: (_, __) => ErrorStateView(message: l.aiCouldNotOpen),
        data: (record) => _ChatView(
          coinName: record.identification.coinName,
          identification: record.identification,
        ),
      ),
    );
  }
}

class _ChatView extends ConsumerStatefulWidget {
  const _ChatView({required this.coinName, required this.identification});
  final String coinName;
  final CoinIdentification identification;

  @override
  ConsumerState<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<_ChatView> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(String text) {
    ref
        .read(aiChatControllerProvider(widget.identification).notifier)
        .send(text);
    _input.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiChatControllerProvider(widget.identification));

    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.backgroundSecondary,
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            context.l10n.aiTalkingAbout(widget.coinName),
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        Expanded(
          child: state.messages.isEmpty
              ? _Suggestions(onPick: _send)
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: state.messages.length + (state.sending ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i >= state.messages.length) {
                      return const _Bubble(fromUser: false, text: '…');
                    }
                    final m = state.messages[i];
                    return _Bubble(fromUser: m.fromUser, text: m.text);
                  },
                ),
        ),
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Text(state.error!.localized(context.l10n),
                style: const TextStyle(color: AppColors.danger, fontSize: 12)),
          ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 4,
                    textInputAction: TextInputAction.send,
                    decoration:
                        InputDecoration(hintText: context.l10n.aiAskHint),
                    onSubmitted: _send,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton.filled(
                  style: IconButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.onGold),
                  onPressed: state.sending ? null : () => _send(_input.text),
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onPick});
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const Icon(Icons.auto_awesome_rounded, color: AppColors.gold, size: 30),
        const SizedBox(height: AppSpacing.md),
        Text(context.l10n.aiAssistantIntro,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.lg),
        ...[
          context.l10n.qWhyValuable,
          context.l10n.qIsRare,
          context.l10n.qWhereSell,
          context.l10n.qAuthenticate,
          context.l10n.qHowMuchList,
        ].map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: OutlinedButton(
              onPressed: () => onPick(q),
              style: OutlinedButton.styleFrom(
                alignment: Alignment.centerLeft,
                minimumSize: const Size.fromHeight(48),
              ),
              child: Align(alignment: Alignment.centerLeft, child: Text(q)),
            ),
          ),
        ),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.fromUser, required this.text});
  final bool fromUser;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(AppSpacing.md),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: fromUser ? AppColors.gold : AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: fromUser ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fromUser ? AppColors.onGold : AppColors.textPrimary,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
