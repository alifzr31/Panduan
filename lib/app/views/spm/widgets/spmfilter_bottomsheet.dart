import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/cubits/auth/auth_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_textbutton.dart';

class SpmFilterBottomsheet extends StatefulWidget {
  const SpmFilterBottomsheet({
    required this.listStatus,
    required this.selectedStatus,
    super.key,
  });

  final List<String> listStatus;
  final Set<String> selectedStatus;

  @override
  State<SpmFilterBottomsheet> createState() => _SpmFilterBottomsheetState();
}

class _SpmFilterBottomsheetState extends State<SpmFilterBottomsheet> {
  final List<String> _listStatus = [];
  final Set<String> _selectedStatus = {};
  bool _isFiltered = false;

  List<String> showFilterStatusByLevel() {
    if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-opd',
    )) {
      return const ['NEED_VERIFICATION_OPD', 'FINISH_BY_OPD', 'DECLINE_BY_OPD'];
    } else if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kecematan',
    )) {
      return const [
        'NEED_APPROVAL_DISTRICT',
        'FORWARD_TO_OPD',
        'DECLINE_BY_DISTRICT',
      ];
    } else if (AppHelpers.hasPermission(
      context.read<AuthCubit>().state.userPermissions,
      permissionName: 'level-kelurahan',
    )) {
      return const [
        'NEED_VERIFICATION_SUB_DISTRICT',
        'FORWARD_TO_DISTRICT',
        'FORWARD_TO_OPD',
        'FINISH_BY_SUB_DISTRICT',
        'DECLINE_BY_SUB_DISTRICT',
      ];
    } else {
      return widget.listStatus;
    }
  }

  @override
  void initState() {
    final filteredStatus = showFilterStatusByLevel();

    setState(() {
      _listStatus.addAll(
        widget.listStatus.where((element) {
          return filteredStatus.contains(element);
        }),
      );
    });

    if (widget.selectedStatus.isNotEmpty) {
      setState(() {
        _selectedStatus.addAll(widget.selectedStatus);
        _isFiltered = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Filter Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Filter bisa dipilih lebih dari satu.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Divider(height: 1, color: Colors.grey.shade300),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listStatus.length,
                    itemBuilder: (context, index) {
                      final status = _listStatus[index];

                      return Card(
                        elevation: _selectedStatus.contains(status) ? 0 : 1,
                        clipBehavior: Clip.antiAlias,
                        color: _selectedStatus.contains(status)
                            ? AppColors.softBlueColor
                            : Colors.white,
                        margin: EdgeInsets.only(
                          bottom: index == _listStatus.length ? 0 : 10,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: _selectedStatus.contains(status)
                                ? AppColors.blueColor
                                : Colors.white,
                          ),
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            bool isSelected = _selectedStatus.contains(status);

                            if (isSelected) {
                              setState(() {
                                _selectedStatus.remove(status);
                              });
                            } else {
                              setState(() {
                                _selectedStatus.add(status);
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    AppHelpers.statusLabel(status),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: _selectedStatus.contains(status)
                                          ? AppColors.blueColor
                                          : null,
                                    ),
                                  ),
                                ),
                                if (_selectedStatus.contains(status)) ...{
                                  const SizedBox(width: 10),
                                  const Icon(
                                    MingCute.check_circle_fill,
                                    size: 20,
                                    color: AppColors.blueColor,
                                  ),
                                },
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
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
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: BaseButton(
                  bgColor: AppColors.amberColor,
                  label: _selectedStatus.isEmpty
                      ? 'Terapkan Filter'
                      : 'Terapkan Filter (${_selectedStatus.length})',
                  onPressed: () {
                    setState(() {
                      _isFiltered = _selectedStatus.isNotEmpty;
                    });

                    Navigator.pop(context, _selectedStatus);
                  },
                ),
              ),
              if (_isFiltered) ...{
                const SizedBox(height: 8),
                BaseTextButton(
                  text: 'Hapus Filter',
                  size: 14,
                  color: AppColors.pinkColor,
                  onPressed: () {
                    setState(() {
                      _selectedStatus.clear();
                      _isFiltered = false;
                    });

                    Navigator.pop(context, _selectedStatus);
                  },
                ),
              },
            ],
          ),
        ),
      ],
    );
  }
}
