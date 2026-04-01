import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/cubits/health_post/health_post_cubit.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/cubits/spm/spm_cubit.dart';
import 'package:panduan/app/models/district.dart';
import 'package:panduan/app/models/subdistrict.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_dropdownfield.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class SpmFilterBottomsheet extends StatefulWidget {
  const SpmFilterBottomsheet({
    required this.selectedDistrictCode,
    required this.selectedSubDistrictCode,
    required this.selectedHealthPostUuid,
    required this.selectedSpmField,
    required this.selectedStatus,
    super.key,
  });

  final String? selectedDistrictCode;
  final String? selectedSubDistrictCode;
  final String? selectedHealthPostUuid;
  final String? selectedSpmField;
  final Set<String> selectedStatus;

  @override
  State<SpmFilterBottomsheet> createState() => _SpmFilterBottomsheetState();
}

class _SpmFilterBottomsheetState extends State<SpmFilterBottomsheet> {
  final _userPermissions = <String>[];
  bool _canSelectDistrict = false;
  final _selectedDistrict = ValueNotifier<District?>(null);
  bool _canSelectSubDistrict = false;
  final _selectedSubDistrict = ValueNotifier<SubDistrict?>(null);
  bool _canSelectHealthPost = false;
  final _selectedHealthPostUuid = ValueNotifier<String?>(null);
  final _selectedSpmField = ValueNotifier<String?>(null);
  final List<String> _listStatus = AppHelpers.listStatus();
  final _selectedStatus = ValueNotifier<Set<String>>({});
  bool _isFiltered = false;

  Future<void> _initFilter() async {
    final authCubit = context.read<AuthCubit>();
    final regionCubit = context.read<RegionCubit>();
    final healthPostCubit = context.read<HealthPostCubit>();
    final spmCubit = context.read<SpmCubit>();

    _canSelectDistrict =
        AppHelpers.hasPermission(
          _userPermissions,
          permissionName: 'level-walikota',
        ) ||
        AppHelpers.hasPermission(_userPermissions, permissionName: 'level-opd');

    _canSelectSubDistrict =
        _canSelectDistrict ||
        AppHelpers.hasPermission(
          _userPermissions,
          permissionName: 'level-kecamatan',
        );

    _canSelectHealthPost =
        _canSelectSubDistrict ||
        AppHelpers.hasPermission(
          _userPermissions,
          permissionName: 'level-kelurahan',
        );

    if (_canSelectDistrict) {
      await regionCubit.fetchDistricts();
      if (!mounted) return;

      final districts = regionCubit.state.districts;

      _selectedDistrict.value = widget.selectedDistrictCode == null
          ? null
          : districts.firstWhere((e) => e.code == widget.selectedDistrictCode);
    } else {
      _selectedDistrict.value = authCubit.state.profile?.district;
    }

    if (_selectedDistrict.value != null) {
      if (_canSelectSubDistrict) {
        final districtCode = _selectedDistrict.value?.code?.split('.').last;

        await regionCubit.fetchSubDistricts(districtCode: districtCode);
        if (!mounted) return;

        final subDistricts = regionCubit.state.subDistricts;

        _selectedSubDistrict.value = widget.selectedSubDistrictCode == null
            ? null
            : subDistricts.firstWhere(
                (e) => e.code == widget.selectedSubDistrictCode,
              );
      } else {
        _selectedSubDistrict.value = authCubit.state.profile?.subDistrict;
      }

      if (_selectedSubDistrict.value != null) {
        if (_canSelectHealthPost) {
          await healthPostCubit.fetchAllHealthPosts(
            districtCode: _selectedDistrict.value?.code,
            subDistrictCode: _selectedSubDistrict.value?.code,
          );
          if (!mounted) return;

          _selectedHealthPostUuid.value = widget.selectedHealthPostUuid;
        } else {
          _selectedHealthPostUuid.value =
              authCubit.state.profile?.healthPost?.uuid;
        }
      }
    }

    await spmCubit.fetchSpmFields();
    if (!mounted) return;

    _selectedSpmField.value = widget.selectedSpmField;
    _selectedStatus.value
      ..clear()
      ..addAll(widget.selectedStatus);

    final locationFilterActived =
        (_canSelectDistrict && _selectedDistrict.value != null) ||
        (_canSelectSubDistrict && _selectedSubDistrict.value != null) ||
        (_canSelectHealthPost && _selectedHealthPostUuid.value != null);

    setState(() {
      _isFiltered =
          locationFilterActived ||
          _selectedSpmField.value != null ||
          _selectedStatus.value.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _userPermissions.addAll(context.read<AuthCubit>().state.userPermissions);
    });
    _initFilter();
  }

  @override
  void dispose() {
    _selectedDistrict.dispose();
    _selectedSubDistrict.dispose();
    _selectedHealthPostUuid.dispose();
    _selectedSpmField.dispose();
    _selectedStatus.dispose();
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
                    'Filter SPM',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1, color: Colors.grey.shade300),
                ),
                if (_canSelectDistrict) ...{
                  BlocBuilder<RegionCubit, RegionState>(
                    builder: (context, state) {
                      return BaseDropdownGroupField(
                        label: 'Kecamatan',
                        value: _selectedDistrict,
                        hint: state.districtStatus == DistrictStatus.loading
                            ? 'Mohon tunggu...'
                            : 'Pilih kecamatan',
                        items: state.districts.map((e) {
                          return DropdownItem(
                            value: e,
                            child: Text(e.name?.capitalize() ?? ''),
                          );
                        }).toList(),
                        prefixIcon: _selectedDistrict.value == null
                            ? null
                            : BaseIconButton(
                                icon: MingCute.close_circle_fill,
                                size: 18,
                                color: Colors.red.shade600,
                                onPressed: () {
                                  setState(() {
                                    _selectedSubDistrict.value = null;
                                    _selectedHealthPostUuid.value = null;
                                    _selectedDistrict.value = null;
                                  });
                                },
                              ),
                        onChanged: (value) {
                          setState(() {
                            _selectedSubDistrict.value = null;
                            _selectedHealthPostUuid.value = null;
                            _selectedDistrict.value = value;
                          });

                          final districtCode = _selectedDistrict.value?.code
                              ?.split('.')
                              .last;

                          context.read<RegionCubit>().fetchSubDistricts(
                            districtCode: districtCode,
                          );
                        },
                      );
                    },
                  ),
                },
                if (_canSelectSubDistrict &&
                    _selectedDistrict.value != null) ...{
                  const SizedBox(height: 10),
                  BlocBuilder<RegionCubit, RegionState>(
                    builder: (context, state) {
                      return BaseDropdownGroupField(
                        label: 'Kelurahan',
                        value: _selectedSubDistrict,
                        hint:
                            state.subDistrictStatus == SubDistrictStatus.loading
                            ? 'Mohon tunggu...'
                            : 'Pilih kelurahan',
                        items: state.subDistricts.map((e) {
                          return DropdownItem(
                            value: e,
                            child: Text(e.name?.capitalize() ?? ''),
                          );
                        }).toList(),
                        prefixIcon: _selectedSubDistrict.value == null
                            ? null
                            : BaseIconButton(
                                icon: MingCute.close_circle_fill,
                                size: 18,
                                color: Colors.red.shade600,
                                onPressed: () {
                                  setState(() {
                                    _selectedHealthPostUuid.value = null;
                                    _selectedSubDistrict.value = null;
                                  });
                                },
                              ),
                        onChanged: (value) {
                          setState(() {
                            _selectedHealthPostUuid.value = null;
                            _selectedSubDistrict.value = value;
                          });

                          context.read<HealthPostCubit>().fetchAllHealthPosts(
                            districtCode: _selectedDistrict.value?.code,
                            subDistrictCode: _selectedSubDistrict.value?.code,
                          );
                        },
                      );
                    },
                  ),
                },
                if (_canSelectHealthPost &&
                    _selectedSubDistrict.value != null) ...{
                  const SizedBox(height: 10),
                  BlocBuilder<HealthPostCubit, HealthPostState>(
                    builder: (context, state) {
                      return BaseDropdownGroupField(
                        label: 'Posyandu',
                        value: _selectedHealthPostUuid,
                        hint: state.listStatus == ListStatus.loading
                            ? 'Mohon tunggu...'
                            : 'Pilih posyandu',
                        items: state.healthPosts.map((e) {
                          return DropdownItem(
                            value: e.uuid,
                            child: Text(e.name?.capitalize() ?? ''),
                          );
                        }).toList(),
                        prefixIcon: _selectedHealthPostUuid.value == null
                            ? null
                            : BaseIconButton(
                                icon: MingCute.close_circle_fill,
                                size: 18,
                                color: Colors.red.shade600,
                                onPressed: () {
                                  setState(() {
                                    _selectedHealthPostUuid.value = null;
                                  });
                                },
                              ),
                        onChanged: (value) {
                          setState(() {
                            _selectedHealthPostUuid.value = value;
                          });
                        },
                      );
                    },
                  ),
                },
                const SizedBox(height: 10),
                BlocBuilder<SpmCubit, SpmState>(
                  builder: (context, state) {
                    return BaseDropdownGroupField(
                      label: 'Bidang SPM',
                      value: _selectedSpmField,
                      hint: state.spmFieldStatus == SpmFieldStatus.loading
                          ? 'Mohon tunggu...'
                          : 'Pilih bidang SPM',
                      items: state.spmFields.map((e) {
                        return DropdownItem(
                          value: e.name,
                          child: Text(e.name ?? ''),
                        );
                      }).toList(),
                      prefixIcon: _selectedSpmField.value == null
                          ? null
                          : BaseIconButton(
                              icon: MingCute.close_circle_fill,
                              size: 18,
                              color: Colors.red.shade600,
                              onPressed: () {
                                setState(() {
                                  _selectedSpmField.value = null;
                                });
                              },
                            ),
                      onChanged: (value) {
                        setState(() {
                          _selectedSpmField.value = value;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),
                BaseDropdownGroupField(
                  label: 'Status SPM',
                  hint: 'Pilih status SPM',
                  multiValue: _selectedStatus,
                  items: _listStatus.map((e) {
                    return DropdownItem(
                      closeOnTap: false,
                      value: e,
                      child: ValueListenableBuilder(
                        valueListenable: _selectedStatus,
                        builder: (context, value, child) {
                          final isSelected = value.contains(e);

                          return Row(
                            children: [
                              Icon(
                                isSelected
                                    ? MingCute.checkbox_fill
                                    : MingCute.square_line,
                                size: 18,
                                color: isSelected ? AppColors.blueColor : null,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  AppHelpers.statusLabel(e),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (context) {
                    return _listStatus.map((e) {
                      // return ValueListenableBuilder(
                      //   valueListenable: _selectedStatus,
                      //   builder: (context, value, child) {
                      //     return SingleChildScrollView(
                      //       scrollDirection: Axis.horizontal,
                      //       child: Row(
                      //         children: [
                      //           Material(
                      //             shape: const StadiumBorder(),
                      //             clipBehavior: Clip.antiAlias,
                      //             color: AppColors.softBlueColor,
                      //             child: Center(
                      //               child: Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   vertical: 2,
                      //                   horizontal: 10,
                      //                 ),
                      //                 child: Text(
                      //                   AppHelpers.statusLabel(
                      //                     value.toList()[index],
                      //                   ),
                      //                   style: const TextStyle(
                      //                     fontSize: 14,
                      //                     fontWeight: FontWeight.w500,
                      //                     color: AppColors.blueColor,
                      //                   ),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           if (index != (_selectedStatus.length - 1))
                      //             const SizedBox(width: 4),
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // );
                      return ValueListenableBuilder(
                        valueListenable: _selectedStatus,
                        builder: (context, value, child) {
                          return ListView(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            physics: const ClampingScrollPhysics(),
                            children: List.generate(value.length, (index) {
                              return Row(
                                children: [
                                  Material(
                                    shape: const StadiumBorder(),
                                    clipBehavior: Clip.antiAlias,
                                    color: AppColors.softBlueColor,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          AppHelpers.statusLabel(
                                            value.toList()[index],
                                          ),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.blueColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index != (value.length - 1))
                                    const SizedBox(width: 4),
                                ],
                              );
                            }),
                          );
                        },
                      );
                    }).toList();
                  },
                  onChanged: (value) {
                    final isSelected = _selectedStatus.value.contains(value);

                    _selectedStatus.value = isSelected
                        ? ({..._selectedStatus.value}..remove(value))
                        : {..._selectedStatus.value, value!};
                  },
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
                        _isFiltered =
                            _selectedDistrict.value != null ||
                            _selectedSubDistrict.value != null ||
                            _selectedHealthPostUuid.value != null ||
                            _selectedSpmField.value != null ||
                            _selectedStatus.value.isNotEmpty;
                      });

                      final data = {
                        'selectedDistrictCode': _selectedDistrict.value?.code,
                        'selectedSubDistrictCode':
                            _selectedSubDistrict.value?.code,
                        'selectedHealthPostUuid': _selectedHealthPostUuid.value,
                        'selectedSpmField': _selectedSpmField.value,
                        'selectedStatus': _selectedStatus.value,
                      };

                      Navigator.pop(context, data);
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
                          _selectedDistrict.value = null;
                          _selectedSubDistrict.value = null;
                          _selectedHealthPostUuid.value = null;
                          _selectedSpmField.value = null;
                          _selectedStatus.value.clear();
                          _isFiltered = false;
                        });

                        Navigator.pop(context, {
                          'selectedDistrictCode': _selectedDistrict.value?.code,
                          'selectedSubDistrictCode':
                              _selectedSubDistrict.value?.code,
                          'selectedHealthPostUuid':
                              _selectedHealthPostUuid.value,
                          'selectedSpmField': _selectedSpmField.value,
                          'selectedStatus': _selectedStatus.value,
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
