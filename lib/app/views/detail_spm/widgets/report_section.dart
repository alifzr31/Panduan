import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/models/attachment.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/app_helpers.dart';
import 'package:panduan/app/utils/string_extension.dart';
import 'package:panduan/app/views/detail_spm/components/attachment_card.dart';
import 'package:panduan/app/views/detail_spm/widgets/reportmap_bottomsheet.dart';
import 'package:panduan/app/views/webview/webview_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:panduan/app/widgets/base_iconbutton.dart';
import 'package:panduan/app/widgets/show_custombottomsheet.dart';

class ReportSection extends StatelessWidget {
  const ReportSection({
    required this.receiptNumber,
    required this.healthPostName,
    required this.subDistrictName,
    required this.districtName,
    required this.reportedAt,
    required this.createdAt,
    required this.spmFieldName,
    required this.serviceCategoryName,
    required this.serviceType,
    required this.status,
    required this.reportDescription,
    required this.latitude,
    required this.longitude,
    required this.attachments,
    super.key,
  });

  final String receiptNumber;
  final String healthPostName;
  final String subDistrictName;
  final String districtName;
  final DateTime reportedAt;
  final DateTime createdAt;
  final String spmFieldName;
  final String serviceCategoryName;
  final String serviceType;
  final String status;
  final String reportDescription;
  final String? latitude;
  final String? longitude;
  final List<Attachment> attachments;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    receiptNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                BaseIconButton(
                  icon: MingCute.copy_line,
                  size: 18,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: receiptNumber));

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          padding: EdgeInsets.all(16),
                          content: Text(
                            'Nomor resi berhasil disalin ke papan klip',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              'Posyandu ${healthPostName.capitalize()}, Kelurahan ${subDistrictName.capitalize()}, Kecamatan ${districtName.capitalize()}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 6),
            Text(
              'Dilaporkan pada ${AppHelpers.dmyhmDateFormat(reportedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 2),
            Text(
              'Dibuat pada ${AppHelpers.dmyhmDateFormat(createdAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Material(
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: AppColors.softBlueColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        child: Text(
                          spmFieldName.capitalize(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Material(
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    color: AppColors.softBlueColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 10,
                        ),
                        child: Text(
                          serviceCategoryName.capitalize(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (serviceType.isNotEmpty) ...{
                    const SizedBox(width: 6),
                    Material(
                      shape: const StadiumBorder(),
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.softBlueColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 10,
                          ),
                          child: Text(
                            AppHelpers.serviceTypeIndonesian(serviceType),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blueColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  },
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.grey.shade300),
            ),
            Text(
              'Deskripsi Keluhan/Usulan/Pengaduan',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 4),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.greyFormField,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                reportDescription,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (latitude != null && longitude != null) ...{
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                child: BaseButtonIcon(
                  icon: MingCute.location_2_fill,
                  label: 'Lihat Lokasi',
                  onPressed: () {
                    showDynamicHeightBottomSheet(
                      context,
                      child: ReportMapBottomsheet(
                        latitude: double.parse(
                          latitude ?? '-6.911602389605126',
                        ),
                        longitude: double.parse(
                          longitude ?? '107.6097574966405',
                        ),
                      ),
                    );
                  },
                ),
              ),
            },
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.grey.shade300),
            ),
            if (attachments.isNotEmpty) ...{
              Text(
                'Lampiran (${attachments.length})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: attachments.length,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];

                  return AttachmentCard(
                    title: attachment.title ?? '',
                    fileName: attachment.nameFile ?? '',
                    filePath: attachment.path,
                    checklist: attachment.checklist ?? false,
                    index: index,
                    dataLength: attachments.length,
                    onPressedShowFile: () {
                      Navigator.pushNamed(
                        context,
                        WebviewPage.routeName,
                        arguments: {
                          'fileName': attachment.nameFile,
                          'filePath': attachment.path,
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
            },
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
              decoration: BoxDecoration(
                color: AppHelpers.statusColor(status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  AppHelpers.statusLabel(status),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
