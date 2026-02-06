import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/configs/get_it/service_locator.dart';
import 'package:panduan/app/cubits/region/region_cubit.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/views/health_post/widgets/healthpostfilter_bottomsheet.dart';
import 'package:panduan/app/widgets/base_formfield.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

class HealthPostHeader extends StatelessWidget {
  const HealthPostHeader({
    required this.userPermissions,
    required this.searchHealthPostController,
    required this.onSearchHealthPost,
    required this.selectedDistrictCodeFilter,
    required this.selectedDistrictNameFilter,
    required this.selectedSubDistrictCodeFilter,
    required this.selectedSubDistrictNameFilter,
    required this.onSelectedFilter,
    super.key,
  });

  final List<String> userPermissions;
  final TextEditingController searchHealthPostController;
  final void Function(String? value) onSearchHealthPost;
  final String? selectedDistrictCodeFilter;
  final String? selectedDistrictNameFilter;
  final String? selectedSubDistrictCodeFilter;
  final String? selectedSubDistrictNameFilter;
  final void Function(Map<String, dynamic> resultMap) onSelectedFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        elevation: 1,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: BaseFormField(
                  hint: 'Cari berdasarkan nama posyandu',
                  controller: searchHealthPostController,
                  prefixIcon: const Icon(MingCute.search_3_line, size: 18),
                  onChanged: onSearchHealthPost,
                ),
              ),
              if (AppHelpers.hasPermission(
                    userPermissions,
                    permissionName: 'level-kecamatan',
                  ) ||
                  AppHelpers.hasPermission(
                    userPermissions,
                    permissionName: 'level-walikota',
                  )) ...{
                const SizedBox(width: 10),
                CupertinoButton(
                  alignment: Alignment.center,
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  onPressed: () async {
                    final result = await showDynamicHeightBottomSheet(
                      context,
                      child: BlocProvider(
                        create: (context) => sl<RegionCubit>(),
                        child: HealthPostFilterBottomSheet(
                          selectedDistrictCode: selectedDistrictCodeFilter,
                          selectedDistrictName: selectedDistrictNameFilter,
                          selectedSubDistrictCode:
                              selectedSubDistrictCodeFilter,
                          selectedSubDistrictName:
                              selectedSubDistrictNameFilter,
                        ),
                      ),
                    );

                    if (result != null) {
                      final resultMap = result as Map<String, dynamic>;

                      onSelectedFilter(resultMap);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.softAmberColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      selectedDistrictCodeFilter == null &&
                              selectedSubDistrictCodeFilter == null
                          ? MingCute.filter_line
                          : MingCute.filter_fill,
                      size: 22,
                      color: AppColors.amberColor,
                    ),
                  ),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
