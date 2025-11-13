import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:string_validator/string_validator.dart';
import 'package:toastification/toastification.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePass = true;

  @override
  void initState() {
    if (kDebugMode) {
      _passwordController.text = 'bandung123';
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BaseFormGroupField(
            label: 'Username/Email',
            hint: 'Masukkan username atau email anda',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              MingCute.user_1_fill,
              size: 18,
              color: Colors.black,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Silakan masukkan username atau email anda';
              } else {
                if (value.matches('@')) {
                  if (!isEmail(value)) {
                    return 'Email yang anda masukkan tidak benar';
                  }
                }
              }

              return null;
            },
          ),
          const SizedBox(height: 10),
          BaseFormGroupField(
            label: 'Kata Sandi',
            hint: 'Masukkan kata sandi anda',
            obscureText: _obscurePass,
            controller: _passwordController,
            prefixIcon: const Icon(
              MingCute.lock_fill,
              size: 18,
              color: Colors.black,
            ),
            suffixIcon: BaseIconButton(
              icon: _obscurePass ? MingCute.eye_fill : MingCute.eye_close_line,
              size: 18,
              onPressed: () {
                setState(() {
                  _obscurePass = !_obscurePass;
                });
              },
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Silakan masukkan kata sandi anda';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.loginStatus != current.loginStatus,
            listener: (context, state) {
              if (state.loginStatus == LoginStatus.loading) {
                context.loaderOverlay.show();
              }

              if (state.loginStatus == LoginStatus.success) {
                context.loaderOverlay.hide();
                Navigator.pushReplacementNamed(
                  context,
                  DashboardPage.routeName,
                );
                showCustomToast(
                  context,
                  type: ToastificationType.success,
                  title: 'Masuk Berhasil',
                  description: 'Selamat datang!',
                );
              }

              if (state.loginStatus == LoginStatus.error) {
                context.loaderOverlay.hide();
                showCustomToast(
                  context,
                  type: ToastificationType.error,
                  title: 'Masuk Gagal',
                  description: state.loginError,
                );
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: BaseButtonIcon(
                fgColor: Colors.white,
                label: 'Masuk',
                icon: MingCute.entrance_line,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthCubit>().login(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
