import 'package:flutter/material.dart';
import 'package:panduan/app/views/change_password/widgets/changepassword_form.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  static const String routeName = '/changePassword';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.only(right: 16),
      ),
      body: const ChangePasswordForm(),
    );
  }
}
