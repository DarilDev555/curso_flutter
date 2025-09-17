import '../../providers/auth/auth_provider.dart';
import '../../providers/auth/register_user_form_provider.dart';
import '../../widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({super.key});

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
    final registerFormProvider = ref.watch(registerUserFormProvider);

    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;

      showSnackBar(context, next.errorMessage);
    });

    ref.listen(registerUserFormProvider, (previous, next) {
      if (previous == null) return;
      if (!previous.isValidUser && next.isValidUser) {
        if (context.mounted) {
          context.go('/register-teacher-user');
        }
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const SizedBox(height: 20),

          CustomTextFormField(
            label: 'Nombre de usuario',
            keyboardType: TextInputType.text,
            inicialValue: registerFormProvider.userName.value,
            onChanged: (value) {
              ref.read(registerUserFormProvider.notifier).onNameChange(value);
            },
            disableSpace: true,
            errorMessage:
                registerFormProvider.isFormPosted
                    // ? registerForm.userName.errorMessage
                    ? errorMessageToCheckUserApi(
                      errorMessage: registerFormProvider.userName.errorMessage,
                      errors: registerFormProvider.errors?['userName'],
                    )
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            inicialValue: registerFormProvider.email.value,
            onChanged:
                ref.read(registerUserFormProvider.notifier).onEmailChange,
            disableSpace: true,
            errorMessage:
                registerFormProvider.isFormPosted
                    // ? registerForm.email.errorMessage
                    ? errorMessageToCheckUserApi(
                      errorMessage: registerFormProvider.email.errorMessage,
                      errors: registerFormProvider.errors?['email'],
                    )
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Contraseña',
            inicialValue: registerFormProvider.password.value,
            obscureText: true,
            onChanged:
                ref.read(registerUserFormProvider.notifier).onPasswordChange,
            errorMessage:
                registerFormProvider.isFormPosted
                    ? errorMessageToCheckUserApi(
                      errorMessage: registerFormProvider.password.errorMessage,
                      errors: registerFormProvider.errors?['password'],
                    )
                    : null,
          ),

          const SizedBox(height: 30),

          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            inicialValue: registerFormProvider.password.value,
            onChanged:
                ref
                    .read(registerUserFormProvider.notifier)
                    .onSecondPasswordChange,
            errorMessage:
                registerFormProvider.isFormPosted
                    ? registerFormProvider.secondPassword.errorMessage
                    : null,
          ),

          const SizedBox(height: 30),

          registerFormProvider.isCheckingUser
              ? Container(
                width: double.infinity,
                height: 35,
                decoration: const BoxDecoration(
                  color: Colors.black, // o el color que uses
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeAlign: -5,
                    strokeWidth: 3,
                    color: Colors.white, // opcional
                  ),
                ),
              )
              : SizedBox(
                width: double.infinity,
                height: 35,
                child: CustomFilledButton(
                  text: 'Siguiente',
                  buttonColor: Colors.black,
                  onPressed: () {
                    ref.read(registerUserFormProvider.notifier).checkUserForm();
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

  String? errorMessageToCheckUserApi({
    List<String>? errors,
    String? errorMessage,
  }) {
    return errorMessage ??
        (errors != null && errors.isNotEmpty ? errors.first : null);
  }
}
