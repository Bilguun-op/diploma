import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../providers/i18n_provider.dart';
import '../app/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController(text: '10');
  bool _isSignup = true;

  @override
  void dispose() {
    _nameController.dispose();
    _gradeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<StoreProvider>().login(_nameController.text.trim(), _gradeController.text);
      context.read<StoreProvider>().setRoute('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = context.watch<I18nProvider>();

    return Scaffold(
      body: Stack(
        children: [
          // Background decorations
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Stack(
                children: [
                  Positioned(
                    top: -80,
                    left: MediaQuery.of(context).size.width * 0.25,
                    child: Container(
                      width: 288,
                      height: 288,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme._primary.withOpacity(0.3),
                        blurRadius: 96,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: MediaQuery.of(context).size.width * 0.25,
                    child: Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme._accent.withOpacity(0.2),
                        blurRadius: 96,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Card(
                color: AppTheme._card.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: AppTheme._border.withOpacity(0.6)),
                ),
                shadowColor: AppTheme._primary,
                elevation: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.glowShadow,
                  ),
                  padding: const EdgeInsets.all(32),
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Logo
                        Container(
                          width: 56,
                          height: 56,
                          decoration: AppTheme.heroGradient.copyWith(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppTheme.glowShadow,
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: AppTheme._primaryForeground,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isSignup ? i18n.t('startJourney') : i18n.t('welcome'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          i18n.t('appName'),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppTheme._mutedForeground,
                              ),
                        ),
                        const SizedBox(height: 24),
                        // Form fields
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: i18n.t('name'),
                            hintText: 'Bat-Erdene',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _gradeController,
                          decoration: InputDecoration(
                            labelText: i18n.t('grade'),
                            hintText: '10',
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme._primary,
                              foregroundColor: AppTheme._primaryForeground,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(i18n.t('continue')),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Toggle login/signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isSignup ? i18n.t('noAccount') : i18n.t('haveAccount'),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme._mutedForeground,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignup = !_isSignup;
                                });
                              },
                              child: Text(
                                _isSignup ? i18n.t('login') : i18n.t('signup'),
                                style: const TextStyle(
                                  color: AppTheme._accent,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
