import 'package:flutter/material.dart';
import 'package:panduan/app/models/spm.dart';
import 'package:panduan/app/views/edit_spm/widgets/editspm_form.dart';

class EditSpmPage extends StatelessWidget {
  const EditSpmPage({
    required this.spmFieldUuid,
    required this.spmFieldName,
    required this.detailSpm,
    super.key,
  });

  static const String routeName = '/editSpm';

  final String spmFieldUuid;
  final String spmFieldName;
  final Spm? detailSpm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Edit SPM',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      body: EditSpmForm(
        spmFieldUuid: spmFieldUuid,
        spmFieldName: spmFieldName,
        detailSpm: detailSpm,
      ),
    );
  }
}
