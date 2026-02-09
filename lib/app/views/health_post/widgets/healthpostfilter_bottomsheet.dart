import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';
import 'package:panduan/app/widgets/base_typeaheadfield.dart';

class HealthPostFilterBottomSheet extends StatefulWidget {
  const HealthPostFilterBottomSheet({
    required this.selectedDistrictCode,
    required this.selectedDistrictName,
    required this.selectedSubDistrictCode,
    required this.selectedSubDistrictName,
    super.key,
  });

  final String? selectedDistrictCode;
  final String? selectedDistrictName;
  final String? selectedSubDistrictCode;
  final String? selectedSubDistrictName;

  @override
  State<HealthPostFilterBottomSheet> createState() =>
      _HealthPostFilterBottomSheetState();
}

class _HealthPostFilterBottomSheetState
    extends State<HealthPostFilterBottomSheet> {
  String? _selectedDistrict;
  final _districtController = TextEditingController();
  String? _selectedSubDistrict;
  final _subDistrictController = TextEditingController();
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedDistrict = widget.selectedDistrictCode;
      _districtController.text = widget.selectedDistrictName ?? '';
      _selectedSubDistrict = widget.selectedSubDistrictCode;
      _subDistrictController.text = widget.selectedSubDistrictName ?? '';
      _isFiltered = _selectedDistrict != null || _selectedSubDistrict != null;
    });

    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-walikota',
    )) {
      context.read<RegionCubit>().fetchDistricts().then((_) {
        if (_selectedDistrict != null) {
          final districtCode = _selectedDistrict?.split('.').last;

          if (mounted) {
            context.read<RegionCubit>().fetchSubDistricts(
              districtCode: districtCode,
            );
          }
        }
      });
    } else if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kecamatan',
    )) {
      final districtCode = context
          .read<AuthCubit>()
          .state
          .profile
          ?.district
          ?.code
          ?.split('.')
          .last;

      context.read<RegionCubit>().fetchSubDistricts(districtCode: districtCode);
    }
  }

  @override
  void dispose() {
    _districtController.dispose();
    _subDistrictController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Filter Posyandu Binaan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                if (AppHelpers.hasPermission(
                  context.read<AuthCubit>().state.userPermissions,
                  permissionName: 'level-walikota',
                )) ...{
                  BlocBuilder<RegionCubit, RegionState>(
                    builder: (context, state) {
                      return BaseTypeaHeadGroupField(
                        label: 'Kecamatan',
                        hint: 'Pilih kecamatan',
                        controller: _districtController,
                        emptyLabel: 'Kecamatan tidak ditemukan',
                        itemBuilder: (context, value) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(value.name?.capitalize() ?? ''),
                          );
                        },
                        onSelected: (value) {
                          setState(() {
                            _selectedSubDistrict = null;
                            _selectedDistrict = value.code;
                          });
                          _subDistrictController.clear();
                          _districtController.text =
                              value.name?.capitalize() ?? '';

                          context.read<RegionCubit>().fetchSubDistricts(
                            districtCode: value.districtCode,
                          );
                        },
                        suggestionsCallback: (keyword) {
                          return state.districts.where((element) {
                            return element.name?.toLowerCase().contains(
                                  keyword.toLowerCase(),
                                ) ??
                                false;
                          }).toList();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                },
                Visibility(
                  visible:
                      AppHelpers.hasPermission(
                            context.read<AuthCubit>().state.userPermissions,
                            permissionName: 'level-walikota',
                          ) &&
                          _selectedDistrict == null
                      ? false
                      : true,
                  child: BlocBuilder<RegionCubit, RegionState>(
                    builder: (context, state) {
                      return BaseTypeaHeadGroupField(
                        label: 'Kelurahan',
                        hint: 'Pilih kelurahan',
                        controller: _subDistrictController,
                        emptyLabel: 'Kelurahan tidak ditemukan',
                        itemBuilder: (context, value) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(value.name?.capitalize() ?? ''),
                          );
                        },
                        onSelected: (value) {
                          setState(() {
                            _selectedSubDistrict = value.code;
                          });
                          _subDistrictController.text =
                              value.name?.capitalize() ?? '';
                        },
                        suggestionsCallback: (keyword) {
                          return state.subDistricts.where((element) {
                            return element.name?.toLowerCase().contains(
                                  keyword.toLowerCase(),
                                ) ??
                                false;
                          }).toList();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  BaseButton(
                    width: double.infinity,
                    bgColor: AppColors.amberColor,
                    label: 'Terapkan Filter',
                    onPressed: () {
                      setState(() {
                        _isFiltered = true;
                      });

                      Navigator.pop(context, {
                        'selectedDistrictCode': _selectedDistrict,
                        'selectedDistrictName': _districtController.text,
                        'selectedSubDistrictCode': _selectedSubDistrict,
                        'selectedSubDistrictName': _subDistrictController.text,
                      });
                    },
                  ),
                  if (_isFiltered) ...{
                    const SizedBox(height: 8),
                    BaseTextButton(
                      text: 'Hapus Filter',
                      size: 14,
                      color: AppColors.pinkColor,
                      onPressed: () {
                        setState(() {
                          _selectedDistrict = null;
                          _selectedSubDistrict = null;
                          _isFiltered = false;
                        });
                        _districtController.clear();
                        _subDistrictController.clear();

                        Navigator.pop(context, {
                          'selectedDistrictCode': null,
                          'selectedDistrictName': null,
                          'selectedSubDistrictCode': null,
                          'selectedSubDistrictName': null,
                        });
                      },
                    ),
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
