import 'package:flutter/material.dart';
import 'package:flutter_authenticated_crud/features/auth/providers/auth_provider.dart';
import 'package:flutter_authenticated_crud/features/auth/providers/register_form_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_authenticated_crud/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (!context.canPop()) return;
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 1),
                    Text(
                      'Crear cuenta',
                      style: textStyles.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),

                const SizedBox(height: 25),

                Container(
                  height:
                      size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: const _RegisterForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);

    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;

      showSnackBar(context, next.errorMessage);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.text,
            onChanged: (value) {
              ref.read(registerFormProvider.notifier).onNameChange(value);
            },
            errorMessage:
                registerForm.isFormPosted
                    ? registerForm.name.errorMessage
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            //onChanged: (value) =>
            // ref.read(loginFormProvider.notifier).onEmailChange(value),
            errorMessage:
                registerForm.isFormPosted
                    ? registerForm.email.errorMessage
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerFormProvider.notifier).onPasswordChange,
            errorMessage:
                registerForm.isFormPosted
                    ? registerForm.password.errorMessage
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged:
                ref.read(registerFormProvider.notifier).onSecondPasswordChange,
            errorMessage:
                registerForm.isFormPosted
                    ? registerForm.secondPassword.errorMessage
                    : null,
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            height: 35,
            child: CustomFilledButton(
              text: 'Crear',
              buttonColor: Colors.black,
              onPressed: () {
                ref.watch(registerFormProvider.notifier).onFormSumit();
              },
            ),
          ),

          const Spacer(flex: 2),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: () {
                  if (context.canPop()) {
                    return context.pop();
                  }
                  context.go('/login');
                },
                child: const Text('Ingresa aquí'),
              ),
            ],
          ),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
