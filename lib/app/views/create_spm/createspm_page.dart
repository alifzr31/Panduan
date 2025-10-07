import 'package:flutter/material.dart';
import 'package:panduan/app/views/create_spm/widgets/createspm_form.dart';

class CreateSpmPage extends StatelessWidget {
  const CreateSpmPage({
    required this.spmFieldUuid,
    required this.spmFieldName,
    super.key,
  });

  static const String routeName = '/createSpm';

  final String spmFieldUuid;
  final String spmFieldName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Input SPM $spmFieldName',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: CreateSpmForm(
        spmFieldUuid: spmFieldUuid,
        spmFieldName: spmFieldName,
      ),
    );
  }
}
