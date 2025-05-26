import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/institution.dart';
import '../../delegates/search_institution_delegate.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/auth/register_user_form_provider.dart';
import '../../providers/institutions/institutions_search_provider.dart';
import '../../widgets/widgets.dart';

class RegisterTeacherUserScreen extends StatelessWidget {
  static final name = 'register-teacher-user';

  const RegisterTeacherUserScreen({super.key});

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
                SizedBox(height: size.height * 0.05),
                // Icon Banner
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Crear cuenta',
                      style: textStyles.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.01),

                Container(
                  height: size.height, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                    ),
                  ),
                  child: _RegisterFormTeacher(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterFormTeacher extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  _RegisterFormTeacher();

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerUserFormProvider);

    final textStyles = Theme.of(context).textTheme;

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;

      showSnackBar(context, next.errorMessage);
    });

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text('Datos Personales', style: textStyles.titleMedium),
              const SizedBox(height: 20),

              CustomTextFormField(
                label: 'Nombres',
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  ref
                      .read(registerUserFormProvider.notifier)
                      .onFirstnameChange(value);
                },
                errorMessage:
                    registerForm.isFormPosted
                        ? errorMessageToCheckUserApi(
                          errorMessage: registerForm.firstName.errorMessage,
                          errors: registerForm.errors?['firstName'],
                        )
                        : null,
              ),

              const SizedBox(height: 30),

              CustomTextFormField(
                label: 'Apellido Paterno',
                keyboardType: TextInputType.text,
                disableSpace: true,
                onChanged:
                    ref
                        .read(registerUserFormProvider.notifier)
                        .onPaternalLastnameChange,
                errorMessage:
                    registerForm.isFormPosted
                        // ? registerForm.email.errorMessage
                        ? errorMessageToCheckUserApi(
                          errorMessage:
                              registerForm.paternalLastName.errorMessage,
                          errors: registerForm.errors?['paternalLastName'],
                        )
                        : null,
              ),

              const SizedBox(height: 30),

              CustomTextFormField(
                label: 'Apellido Materno',
                keyboardType: TextInputType.text,
                disableSpace: true,
                onChanged:
                    ref
                        .read(registerUserFormProvider.notifier)
                        .onMaternalLastnameChange,
                errorMessage:
                    registerForm.isFormPosted
                        // ? registerForm.email.errorMessage
                        ? errorMessageToCheckUserApi(
                          errorMessage:
                              registerForm.maternalLastName.errorMessage,
                          errors: registerForm.errors?['maternalLastName'],
                        )
                        : null,
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: DropdownButtonFormField<String>(
                  value:
                      [
                            'male',
                            'female',
                            'other',
                          ].contains(registerForm.gender.value)
                          ? registerForm.gender.value
                          : null,
                  decoration: const InputDecoration(labelText: 'Género'),
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Masculino')),
                    DropdownMenuItem(value: 'female', child: Text('Femenino')),
                    DropdownMenuItem(value: 'other', child: Text('Otro')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref
                          .read(registerUserFormProvider.notifier)
                          .onGenderChanged(value);
                    }
                  },
                  validator: (value) {
                    return registerForm.gender.errorMessage;
                  },
                ),
              ),
              const SizedBox(height: 30),

              CustomTextFormField(
                label: 'Clave de elector',
                keyboardType: TextInputType.text,
                disableSpace: true,
                onChanged:
                    ref
                        .read(registerUserFormProvider.notifier)
                        .onElectoralCodeChange,
                errorMessage:
                    registerForm.isFormPosted
                        // ? registerForm.email.errorMessage
                        ? errorMessageToCheckUserApi(
                          errorMessage: registerForm.electoralCode.errorMessage,
                          errors: registerForm.errors?['electoralCode'],
                        )
                        : null,
              ),

              const SizedBox(height: 30),

              CustomTextFormField(
                label: 'CURP',
                keyboardType: TextInputType.text,
                disableSpace: true,
                onChanged:
                    ref.read(registerUserFormProvider.notifier).onCurpChange,
                errorMessage:
                    registerForm.isFormPosted
                        // ? registerForm.email.errorMessage
                        ? errorMessageToCheckUserApi(
                          errorMessage: registerForm.curp.errorMessage,
                          errors: registerForm.errors?['curp'],
                        )
                        : null,
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      label:
                          registerForm.institution.value != null
                              ? registerForm.institution.value!.name
                              : 'Institution',
                      keyboardType: TextInputType.text,
                      disableSpace: true,
                      readOnly: true,
                      errorMessage:
                          registerForm.isFormPosted
                              // ? registerForm.email.errorMessage
                              ? errorMessageToCheckUserApi(
                                errorMessage:
                                    registerForm.institution.errorMessage,
                                errors: registerForm.errors?['institution_id'],
                              )
                              : null,
                    ),
                  ),
                  const SizedBox(width: 10), // espacio entre campo y botón
                  TextButton(
                    onPressed: () {
                      final searchInstitutions = ref.read(
                        searchInstitutionsProvider,
                      );
                      final searchQuery = ref.read(searchQueryProvider);

                      showSearch<Institution?>(
                        query: searchQuery,
                        context: context,
                        delegate: SearchInstitutionsDelegate(
                          searchCallback:
                              ref
                                  .read(searchInstitutionsProvider.notifier)
                                  .searchInstitutionByQuery,
                          inicialInstitutions: searchInstitutions,
                        ),
                      ).then((institution) {
                        if (institution == null) return;

                        if (context.mounted) {
                          ref
                              .read(registerUserFormProvider.notifier)
                              .changeInstitution(institution);
                        }
                      });
                    },
                    child: const Text('Seleccionar Institucion'),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              registerForm.isCheckingUser
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
                      text: 'Crear',
                      buttonColor: Colors.black,
                      onPressed: () {
                        ref
                            .watch(registerUserFormProvider.notifier)
                            .onFormSumit();
                        _formKey.currentState!.validate();
                      },
                    ),
                  ),

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
            ],
          ),
        ),
      ],
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
