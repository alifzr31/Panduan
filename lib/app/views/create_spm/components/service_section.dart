import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/create_spm/createspm_cubit.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_formfield.dart';

class ServiceSection extends StatelessWidget {
  const ServiceSection({
    required this.selectedServiceCategory,
    required this.onSelectedServiceCategory,
    required this.reportDescriptionController,
    super.key,
  });

  final ValueNotifier<String?>? selectedServiceCategory;
  final void Function(String?)? onSelectedServiceCategory;
  final TextEditingController reportDescriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<CreateSpmCubit, CreateSpmState>(
          builder: (context, state) {
            return BaseDropdownGroupField<String?>(
              label: 'Kategori Layanan',
              hint: state.serviceCategoryStatus == ServiceCategoryStatus.success
                  ? 'Pilih kategori layanan'
                  : 'Mohon tunggu...',
              mandatory: true,
              value: selectedServiceCategory,
              items:
                  state.serviceCategoryStatus == ServiceCategoryStatus.success
                  ? state.serviceCategories.map((e) {
                      return DropdownItem(
                        value: e.uuid,
                        child: Text(e.name ?? ''),
                      );
                    }).toList()
                  : const [],
              onChanged: onSelectedServiceCategory,
              validator: (value) {
                if (selectedServiceCategory == null) {
                  return 'Silahkan pilih kategori layanan';
                }

                return null;
              },
            );
          },
        ),
        const SizedBox(height: 10),
        BaseFormGroupField(
          label: 'Uraian Pelaporan',
          hint: 'Masukkan uraian pelaporan (min. 20 karakter)',
          mandatory: true,
          controller: reportDescriptionController,
          maxLines: 4,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Silahkan masukkan uraian pelaporan';
            } else {
              if (value.length < 20) {
                return 'Uraian pelaporan minimal berisi 20 karakter';
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
