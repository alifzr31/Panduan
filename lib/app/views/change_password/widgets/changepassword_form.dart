import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_customtoast.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  State<ChangePasswordForm> createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  final _newPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool hasTenCharacters = false;
  bool hasUppercase = false;
  bool hasDigit = false;
  bool hasSymbol = false;
  final _confirmPasswordController = TextEditingController();
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      elevation: 1,
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              BaseFormGroupField(
                                label: 'Kata Sandi Saat Ini',
                                hint: 'Masukkan kata sandi saat ini',
                                mandatory: true,
                                controller: _currentPasswordController,
                                obscureText: _obscureCurrentPassword,
                                suffixIcon: BaseIconButton(
                                  icon: _obscureCurrentPassword
                                      ? MingCute.eye_fill
                                      : MingCute.eye_close_line,
                                  size: 18,
                                  onPressed: () {
                                    setState(() {
                                      _obscureCurrentPassword =
                                          !_obscureCurrentPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Silahkan masukkan kata sandi saat ini';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              BaseFormGroupField(
                                label: 'Kata Sandi Baru',
                                hint: 'Masukkan kata sandi baru',
                                mandatory: true,
                                controller: _newPasswordController,
                                obscureText: _obscureNewPassword,
                                onChanged: (value) {
                                  setState(() {
                                    hasTenCharacters =
                                        (value?.length ?? 0) >= 10
                                        ? true
                                        : false;
                                    hasUppercase =
                                        AppHelpers.passwordHasUppercase(
                                          value ?? '',
                                        );
                                    hasDigit = AppHelpers.passwordHasDigit(
                                      value ?? '',
                                    );
                                    hasSymbol = AppHelpers.passwordHasSymbol(
                                      value ?? '',
                                    );
                                  });
                                },
                                suffixIcon: BaseIconButton(
                                  icon: _obscureNewPassword
                                      ? MingCute.eye_fill
                                      : MingCute.eye_close_line,
                                  size: 18,
                                  onPressed: () {
                                    setState(() {
                                      _obscureNewPassword =
                                          !_obscureNewPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Silahkan masukkan kata sandi baru';
                                  } else {
                                    if (value.length < 10) {
                                      return 'Kata sandi baru minimal 10 karakter';
                                    } else if (value ==
                                        _currentPasswordController.text) {
                                      return 'Kata sandi baru tidak boleh sama dengan kata sandi saat ini';
                                    } else if (!AppHelpers.passwordHasUppercase(
                                      value,
                                    )) {
                                      return 'Kata sandi baru harus mengandung minimal 1 huruf kapitaljanjanianna';
                                    } else if (!AppHelpers.passwordHasDigit(
                                      value,
                                    )) {
                                      return 'Kata sandi baru harus mengandung minimal 1 angka';
                                    } else if (!AppHelpers.passwordHasSymbol(
                                      value,
                                    )) {
                                      return 'Kata sandi baru harus mengandung minimal 1 simbol';
                                    }
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              BaseFormGroupField(
                                label: 'Konfirmasi Kata Sandi Baru',
                                hint: 'Masukkan ulang kata sandi baru',
                                mandatory: true,
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: BaseIconButton(
                                  icon: _obscureConfirmPassword
                                      ? MingCute.eye_fill
                                      : MingCute.eye_close_line,
                                  size: 18,
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Silahkan masukkan ulang kata sandi baru';
                                  } else {
                                    if (value != _newPasswordController.text) {
                                      return 'Kata sandi yang anda masukkan tidak sesuai';
                                    }
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      elevation: 1,
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Kata sandi baru harus mengandung:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  hasTenCharacters
                                      ? MingCute.check_circle_fill
                                      : MingCute.close_circle_fill,
                                  size: 14,
                                  color: hasTenCharacters
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Minimal 10 karakter',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  hasUppercase
                                      ? MingCute.check_circle_fill
                                      : MingCute.close_circle_fill,
                                  size: 14,
                                  color: hasUppercase
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Minimal 1 huruf kapital',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  hasDigit
                                      ? MingCute.check_circle_fill
                                      : MingCute.close_circle_fill,
                                  size: 14,
                                  color: hasDigit
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Minimal 1 angka',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  hasSymbol
                                      ? MingCute.check_circle_fill
                                      : MingCute.close_circle_fill,
                                  size: 14,
                                  color: hasSymbol
                                      ? Colors.green.shade600
                                      : Colors.red.shade600,
                                ),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    'Minimal 1 simbol (contoh: !@#\$%^&*(),.?":{}|<>)',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SafeArea(
            top: false,
            child: BlocListener<AuthCubit, AuthState>(
              listenWhen: (previous, current) =>
                  previous.changePasswordStatus != current.changePasswordStatus,
              listener: (context, state) {
                if (state.changePasswordStatus ==
                    ChangePasswordStatus.loading) {
                  context.loaderOverlay.show();
                }

                if (state.changePasswordStatus ==
                    ChangePasswordStatus.success) {
                  context.loaderOverlay.hide();
                  context.read<AuthCubit>().logout(
                    logoutReason: 'password-updated',
                  );
                }

                if (state.changePasswordStatus == ChangePasswordStatus.error) {
                  context.loaderOverlay.hide();
                  showCustomToast(
                    context,
                    type: ToastificationType.error,
                    title: 'Ubah Kata Sandi Gagal',
                    description: state.changePasswordError,
                  );
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: BaseButton(
                  label: 'Ubah Kata Sandi',
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<AuthCubit>().changePassword(
                        currentPassword: _currentPasswordController.text,
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
