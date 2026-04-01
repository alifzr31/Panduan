import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/resident.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/base_typeaheadfield.dart';

class EditPersonalDataSection extends StatelessWidget {
  const EditPersonalDataSection({
    required this.nikController,
    required this.onFindResident,
    required this.fullNameController,
    required this.addressController,
    required this.rt,
    required this.selectedRt,
    required this.onSelectedRt,
    required this.rw,
    required this.onSelectedRw,
    required this.selectedRw,
    required this.selectedDistrict,
    required this.districtController,
    required this.onSelectedDistrict,
    required this.selectedSubDistrict,
    required this.subDistrictController,
    required this.onSelectedSubDistrict,
    required this.phoneController,
    super.key,
  });

  final TextEditingController nikController;
  final void Function(Resident?) onFindResident;
  final TextEditingController fullNameController;
  final TextEditingController addressController;
  final List<String> rt;
  final ValueNotifier<String?>? selectedRt;
  final void Function(String?)? onSelectedRt;
  final List<String> rw;
  final void Function(String?)? onSelectedRw;
  final ValueNotifier<String?>? selectedRw;
  final District? selectedDistrict;
  final TextEditingController districtController;
  final void Function(Object?)? onSelectedDistrict;
  final SubDistrict? selectedSubDistrict;
  final TextEditingController subDistrictController;
  final void Function(Object?)? onSelectedSubDistrict;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseFormGroupField(
          label: 'NIK',
          hint: 'Masukkan NIK (16 Digit)',
          mandatory: true,
          controller: nikController,
          keyboardType: TextInputType.number,
          maxLength: 16,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Silahkan masukkan NIK';
            } else {
              if (value.length < 16 || value.length > 16) {
                return 'NIK harus berjumlah 16 digit';
              }
            }

            return null;
          },
        ),
        const SizedBox(height: 10),
        BaseFormGroupField(
          label: 'Nama Lengkap',
          hint: 'Masukkan nama lengkap',
          mandatory: true,
          controller: fullNameController,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Silahkan masukkan nama lengkap';
            }

            return null;
          },
        ),
        const SizedBox(height: 10),
        BaseFormGroupField(
          label: 'Alamat',
          hint: 'Masukkan alamat (min. 10 karakter)',
          mandatory: true,
          controller: addressController,
          maxLines: 4,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Silahkan masukkan alamat';
            } else {
              if (value.length < 10) {
                return 'Alamat minimal berisi 10 karakter';
              }
            }

            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: BaseDropdownGroupField(
                label: 'RT',
                hint: 'Pilih RT',
                mandatory: true,
                value: selectedRt,
                items: List.generate(rt.length, (index) {
                  return DropdownItem(value: rt[index], child: Text(rt[index]));
                }),
                onChanged: onSelectedRt,
                validator: (value) {
                  if (selectedRt == null) {
                    return 'Silahkan pilih RT';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: BaseDropdownGroupField(
                label: 'RW',
                hint: 'Pilih RW',
                mandatory: true,
                value: selectedRw,
                items: List.generate(rw.length, (index) {
                  return DropdownItem(value: rw[index], child: Text(rw[index]));
                }),
                onChanged: onSelectedRw,
                validator: (value) {
                  if (selectedRw == null) {
                    return 'Silahkan pilih RW';
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        BlocBuilder<RegionCubit, RegionState>(
          builder: (context, state) {
            return BaseTypeaHeadGroupField<District>(
              label: 'Kecamatan',
              hint: 'Pilih kecamatan',
              mandatory: true,
              controller: districtController,
              emptyLabel: 'Kecamatan Tidak Ditemukan',
              itemBuilder: (context, value) {
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(value.name?.capitalize() ?? ''),
                );
              },
              onSelected: onSelectedDistrict,
              suggestionsCallback: (keyword) {
                return state.districts.where((element) {
                  return element.name?.toLowerCase().contains(
                        keyword.toLowerCase(),
                      ) ??
                      false;
                }).toList();
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Silahkan pilih kecamatan';
                }

                return null;
              },
            );
          },
        ),
        if (selectedDistrict != null) ...{
          const SizedBox(height: 10),
          BlocBuilder<RegionCubit, RegionState>(
            builder: (context, state) {
              return BaseTypeaHeadGroupField<SubDistrict>(
                label: 'Kelurahan',
                hint: 'Pilih kelurahan',
                mandatory: true,
                controller: subDistrictController,
                emptyLabel: 'Kelurahan Tidak Ditemukan',
                itemBuilder: (context, value) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(value.name?.capitalize() ?? ''),
                  );
                },
                onSelected: onSelectedSubDistrict,
                suggestionsCallback: (keyword) {
                  return state.subDistricts.where((element) {
                    return element.name?.toLowerCase().contains(
                          keyword.toLowerCase(),
                        ) ??
                        false;
                  }).toList();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Silahkan pilih kelurahan';
                  }

                  return null;
                },
              );
            },
          ),
        },
        const SizedBox(height: 10),
        BaseFormGroupField(
          label: 'Nomor Telepon',
          hint: 'Masukkan nomor telepon (08xxx atau 62xxx)',
          mandatory: true,
          controller: phoneController,
          keyboardType: TextInputType.phone,
          maxLength: 13,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value!.isEmpty) {
              return 'Silahkan masukkan nomor telepon';
            } else {
              if (!(value.startsWith('08') || value.startsWith('62'))) {
                return 'Nomor telepon harus diawali dengan 08 atau 62';
              } else {
                if (value.length < 10 || value.length > 13) {
                  return 'Nomor telepon harus berjumlah 10 sampai 13 digit';
                }
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
