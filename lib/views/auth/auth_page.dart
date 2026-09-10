import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/app_state.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool registerMode = false;
  bool busy = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    setState(() => busy = true);
    final state = context.read<AppState>();
    final success = registerMode
        ? await state.register(
            nameController.text.trim(),
            emailController.text.trim(),
            passwordController.text,
          )
        : await state.signIn(
            emailController.text.trim(),
            passwordController.text,
          );
    if (!mounted) return;
    setState(() => busy = false);
    if (state.registrationMessage != null) {
      setState(() => registerMode = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.registrationMessage!)));
    } else if (!success && state.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8fafc),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final form = _LoginForm(
            formKey: formKey,
            nameController: nameController,
            emailController: emailController,
            passwordController: passwordController,
            registerMode: registerMode,
            busy: busy,
            obscurePassword: obscurePassword,
            onTogglePassword: () =>
                setState(() => obscurePassword = !obscurePassword),
            onSubmit: submit,
            onToggleMode: () => setState(() => registerMode = !registerMode),
          );
          if (constraints.maxWidth < 900) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: form,
                ),
              ),
            );
          }
          return Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(64),
                      child: form,
                    ),
                  ),
                ),
              ),
              const Expanded(child: _AuthIllustration()),
            ],
          );
        },
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.registerMode,
    required this.busy,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool registerMode;
  final bool busy;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSubmit;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 430),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Nova',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 58),
            Text(
              registerMode ? 'Create your account' : 'Welcome back!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xff172033),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              registerMode
                  ? 'Start your language journey today.'
                  : 'Log in to continue learning.',
              style: const TextStyle(color: Color(0xff728096), fontSize: 15),
            ),
            const SizedBox(height: 30),
            if (registerMode) ...[
              _field(
                nameController,
                'Full name',
                Icons.person_outline,
                (value) => value == null || value.trim().isEmpty
                    ? 'Nama wajib diisi'
                    : null,
              ),
              const SizedBox(height: 14),
            ],
            _field(
              emailController,
              'Email address',
              Icons.email_outlined,
              (value) => value == null || !value.contains('@')
                  ? 'Email tidak valid'
                  : null,
              keyboard: TextInputType.emailAddress,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              validator: (value) => value == null || value.length < 6
                  ? 'Password minimal 6 karakter'
                  : null,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  onPressed: onTogglePassword,
                  icon: Icon(
                    obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: busy ? null : onSubmit,
                child: busy
                    ? const SizedBox(
                        width: 21,
                        height: 21,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(registerMode ? 'Create account' : 'Log in'),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: onToggleMode,
                child: Text(
                  registerMode
                      ? 'Already have an account? Log in'
                      : 'Don’t have an account? Sign up',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    String? Function(String?) validator, {
    TextInputType? keyboard,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboard,
    validator: validator,
    decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
  );
}

class _AuthIllustration extends StatelessWidget {
  const _AuthIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff3b82d0),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _SkyPainter())),
          Padding(
            padding: const EdgeInsets.all(64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Learn beyond\nborders.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 46,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Build a daily habit.\nOpen a new world.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 19,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 44),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(
                          Icons.menu_book_rounded,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Your next lesson is waiting.',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: .08);
    for (var i = 0; i < 14; i++) {
      final x = (i * 83.0) % size.width;
      final y = 30 + ((i * 137.0) % size.height);
      canvas.drawCircle(Offset(x, y), i.isEven ? 2.5 : 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
