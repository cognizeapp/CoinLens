import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/error/failure.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/validators.dart';
import '../../../services/analytics/analytics_service.dart';
import '../domain/auth_repository.dart';
import 'auth_providers.dart';
import 'widgets/social_sign_in_buttons.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _showError(Object error) {
    final message = error is Failure ? error.message : 'Something went wrong.';
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(analyticsServiceProvider)
        .logEvent(AnalyticsEvent.signInStarted);
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signIn(_email.text, _password.text);
    if (!mounted) return;
    if (ok) {
      await ref
          .read(analyticsServiceProvider)
          .logEvent(AnalyticsEvent.signInCompleted, params: {'method': 'email'});
    }
  }

  Future<void> _guest() async {
    final ok =
        await ref.read(authControllerProvider.notifier).continueAsGuest();
    if (mounted && ok) {
      await ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.signInCompleted, params: {'method': 'guest'});
    }
  }

  Future<void> _social(SocialProvider provider) async {
    final ok = await ref.read(authControllerProvider.notifier).social(provider);
    if (mounted && ok) {
      await ref.read(analyticsServiceProvider).logEvent(
          AnalyticsEvent.signInCompleted,
          params: {'method': provider.name});
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final busy = state.isLoading;

    ref.listen(authControllerProvider, (_, next) {
      if (next is AsyncError) _showError(next.error);
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  children: [
                    const Icon(Icons.center_focus_strong_rounded,
                        color: AppColors.gold, size: 30),
                    const SizedBox(width: AppSpacing.sm),
                    Text(AppConstants.appName,
                        style: Theme.of(context).textTheme.headlineMedium),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign in to sync your collection across devices.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.xxl),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: Validators.email,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: const InputDecoration(hintText: 'Password'),
                  validator: Validators.password,
                  onFieldSubmitted: (_) => _submit(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: busy
                        ? null
                        : () async {
                            final err = Validators.email(_email.text);
                            if (err != null) {
                              _showError(AuthFailure(err));
                              return;
                            }
                            await ref
                                .read(authControllerProvider.notifier)
                                .resetPassword(_email.text);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'If that email has an account, a reset link is on its way.')),
                              );
                            }
                          },
                    child: const Text('Forgot password?'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FilledButton(
                  onPressed: busy ? null : _submit,
                  child: busy
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Color(0xFF1A1400)),
                        )
                      : const Text('Sign In'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text('or',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                  const Expanded(child: Divider()),
                ]),
                const SizedBox(height: AppSpacing.lg),
                SocialSignInButtons(onSelected: _social, busy: busy),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: busy ? null : _guest,
                  child: const Text('Explore without an account'),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New here?',
                        style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: busy ? null : () => context.push('/sign-up'),
                      child: const Text('Create an account'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
