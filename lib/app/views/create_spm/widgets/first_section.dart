import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/resident.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/views/create_spm/components/personaldata_section.dart';
import 'package:panduan/app/views/create_spm/components/service_section.dart';
import 'package:panduan/app/widgets/base_datepickerfield.dart';

class FirstSection extends StatelessWidget {
  const FirstSection({
    required this.spmFieldUuid,
    required this.spmFieldName,
    required this.formKey,
    required this.selectedSubmissionDate,
    required this.submissionDateController,
    required this.onSelectedSubmissionDate,
    required this.nikController,
    required this.onFindResident,
    required this.fullNameController,
    required this.addressController,
    required this.rt,
    required this.selectedRt,
    required this.onSelectedRt,
    required this.rw,
    required this.selectedRw,
    required this.onSelectedRw,
    required this.selectedDistrict,
    required this.districtController,
    required this.onSelectedDistrict,
    required this.selectedSubDistrict,
    required this.subDistrictController,
    required this.onSelectedSubDistrict,
    required this.phoneController,
    required this.selectedServiceCategory,
    required this.onSelectedServiceCategory,
    // required this.serviceTypes,
    // required this.selectedServiceType,
    // required this.onSelectedServiceType,
    required this.reportDescriptionController,
    super.key,
  });

  final String spmFieldUuid;
  final String spmFieldName;
  final GlobalKey<FormState> formKey;
  final DateTime selectedSubmissionDate;
  final TextEditingController submissionDateController;
  final void Function(DateTime)? onSelectedSubmissionDate;
  final TextEditingController nikController;
  final void Function(Resident?) onFindResident;
  final TextEditingController fullNameController;
  final TextEditingController addressController;
  final List<String> rt;
  final String? selectedRt;
  final void Function(Object?)? onSelectedRt;
  final List<String> rw;
  final String? selectedRw;
  final void Function(Object?)? onSelectedRw;
  final District? selectedDistrict;
  final TextEditingController districtController;
  final void Function(District value)? onSelectedDistrict;
  final SubDistrict? selectedSubDistrict;
  final TextEditingController subDistrictController;
  final void Function(SubDistrict value)? onSelectedSubDistrict;
  final TextEditingController phoneController;
  final String? selectedServiceCategory;
  final void Function(Object?)? onSelectedServiceCategory;
  // final List<ServiceType> serviceTypes;
  // final String? selectedServiceType;
  // final void Function(Object?)? onSelectedServiceType;
  final TextEditingController reportDescriptionController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(MingCute.send_line, size: 20),
                          SizedBox(width: 2),
                          Text(
                            'Form Input SPM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Form input SPM bidang ${spmFieldName.toLowerCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      BaseDateTimePickerGroupField(
                        label: 'Tanggal Pengajuan',
                        hint: 'Pilih tanggal pengajuan',
                        controller: submissionDateController,
                        currentDateTime: selectedSubmissionDate,
                        mandatory: true,
                        onConfirmDate: onSelectedSubmissionDate,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Silahkan pilih tanggal pengajuan';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      PersonalDataSection(
                        nikController: nikController,
                        onFindResident: onFindResident,
                        fullNameController: fullNameController,
                        addressController: addressController,
                        rt: rt,
                        selectedRt: selectedRt,
                        onSelectedRt: onSelectedRt,
                        rw: rw,
                        onSelectedRw: onSelectedRw,
                        selectedRw: selectedRw,
                        selectedDistrict: selectedDistrict,
                        districtController: districtController,
                        onSelectedDistrict: onSelectedDistrict,
                        selectedSubDistrict: selectedSubDistrict,
                        subDistrictController: subDistrictController,
                        onSelectedSubDistrict: onSelectedSubDistrict,
                        phoneController: phoneController,
                      ),
                      const SizedBox(height: 10),
                      ServiceSection(
                        selectedServiceCategory: selectedServiceCategory,
                        onSelectedServiceCategory: onSelectedServiceCategory,
                        // serviceTypes: serviceTypes,
                        // selectedServiceType: selectedServiceType,
                        // onSelectedServiceType: onSelectedServiceType,
                        reportDescriptionController:
                            reportDescriptionController,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
