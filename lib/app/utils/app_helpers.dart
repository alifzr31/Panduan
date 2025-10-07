import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:panduan/app/models/service_type.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:path_provider/path_provider.dart';

class AppHelpers {
  static double getHeightDevice(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthDevice(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getBottomViewPaddingDevice(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static Map<String, dynamic> addOnHeaders() {
    return {'Content-type': 'application/json', 'Accept': 'application/json'};
  }

  static String rangeDateFormat(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  static String formDateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formDateTimeFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  static String dmyDateFormat(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  static String dmyhmDateFormat(DateTime date) {
    return DateFormat('dd MMMM yyyy HH:mm').format(date);
  }

  static double convertFileSizeByteToKb(int size) {
    return size / 1024;
  }

  static double convertFileSizeByteToMb(int size) {
    return size / (1024 * 1024);
  }

  static Future<File?> compressImage({
    required String path,
    int quality = 60,
  }) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String targetPath =
          "${appDir.path}/picked_${DateTime.now().millisecondsSinceEpoch}.jpg";

      final XFile? compressedFile =
          await FlutterImageCompress.compressAndGetFile(
            path,
            targetPath,
            quality: quality,
          );

      return File(compressedFile?.path ?? '');
    } catch (e) {
      if (kDebugMode) print("Error pick/compress: $e");
      return null;
    }
  }

  static bool hasPermission(
    List<String> userPermissions, {
    required String permissionName,
  }) {
    return userPermissions.contains(permissionName);
  }

  static String serviceTypeIndonesian(String serviceType) {
    final serviceTypes = const [
      ServiceType(nameIndonesian: 'Perencanaan', nameEnglish: 'Planning'),
      ServiceType(nameIndonesian: 'Pelaksanaan', nameEnglish: 'Implementation'),
      ServiceType(nameIndonesian: 'Pengawasan', nameEnglish: 'Surveillance'),
      ServiceType(nameIndonesian: 'Layanan', nameEnglish: 'Service'),
    ];

    return serviceTypes
            .firstWhere(
              (element) =>
                  element.nameEnglish?.toLowerCase().contains(
                    serviceType.toLowerCase(),
                  ) ??
                  false,
            )
            .nameIndonesian ??
        'Jenis Pelayanan Tidak Ditemukan';
  }

  static String statusLabel(String status) {
    switch (status) {
      case "FINISH_BY_SUB_DISTRICT":
        return "Selesai oleh Kelurahan";
      case "FINISH_BY_OPD":
        return "Selesai oleh OPD";
      case "VERIFICATION_SUB_DISTRICT":
        return "Verifikasi Kelurahan";
      case "PROCESS_BY_SUB_DISTRICT":
        return "Diproses Kelurahan";
      case "PROCESS_BY_OPD":
        return "Diproses OPD";
      case "DECLINE_BY_SUB_DISTRICT":
        return "Ditolak Kelurahan";
      case "DECLINE_BY_DISTRICT":
        return "Ditolak Kecamatan";
      case "DECLINE_BY_OPD":
        return "Ditolak OPD";
      case "FORWARD_TO_OPD":
        return "Diteruskan ke OPD";
      case "FORWARD_TO_DISTRICT":
        return "Diteruskan ke Kecamatan";
      case "NEED_VERIFICATION_SUB_DISTRICT":
        return "Perlu Verifikasi Kelurahan";
      case "NEED_VERIFICATION_OPD":
        return "Perlu Verifikasi OPD";
      case "NEED_APPROVAL_DISTRICT":
        return "Perlu Verifikasi Kecamatan";
      default:
        return "Status Tidak Diketahui";
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case "FINISH_BY_SUB_DISTRICT":
      case "FINISH_BY_OPD":
        return Colors.green.shade500;
      case "VERIFICATION_SUB_DISTRICT":
      case "NEED_VERIFICATION_SUB_DISTRICT":
        return Colors.amber.shade500;
      case "PROCESS_BY_SUB_DISTRICT":
      case "PROCESS_BY_OPD":
        return Colors.blue.shade500;
      case "DECLINE_BY_SUB_DISTRICT":
      case "DECLINE_BY_DISTRICT":
      case "DECLINE_BY_OPD":
        return Colors.red.shade500;
      case "FORWARD_TO_OPD":
      case "FORWARD_TO_DISTRICT":
        return Colors.purple.shade500;
      default:
        return Colors.grey.shade500;
    }
  }

  static String showSpmAttachmentLabel({required String key}) {
    final spmAttachments = const [
      SpmAttachment(
        key: 'fc_ktp',
        label: 'Foto Copy Kartu Tanda Penduduk (KTP)',
      ),
      SpmAttachment(key: 'fc_kk', label: 'Foto Copy Kartu Keluarga (KK)'),
      SpmAttachment(
        key: 'surat_izin_tidak_mampu',
        label: 'Surat Pernyataan Tidak Mampu dari RT setempat',
      ),
      SpmAttachment(
        key: 'surat_belum_menerima_bantuan_rehabilitasi',
        label:
            'Surat Pernyataan Calon Penerima belum pernah menerima bantuan Rehabilitasi Rumah',
      ),
      SpmAttachment(
        key: 'surat_keterangan_penghasilan',
        label: 'Surat Keterangan Penghasilan dari Kelurahan',
      ),
      SpmAttachment(
        key: 'fc_surat_tanah',
        label: 'Foto Copy Surat Tanah dan sejenisnya',
      ),
      SpmAttachment(
        key: 'foto_kondisi_rumah',
        label: 'Foto kondisi rumah Calon Penerima Bantuan',
      ),
      SpmAttachment(
        key: 'surat_permohonan_rtrw',
        label: 'Surat Permohonan RT/RW',
      ),
      SpmAttachment(
        key: 'kartu_bpjs_kis_jkn',
        label: 'Kartu BPJS/KIS/JKN (jika ada)',
      ),
      SpmAttachment(
        key: 'buku_kesehatan',
        label: 'Buku Kesehatan Ibu dan Anak (KIA) atau Buku Kesehatan Lansia',
      ),
      SpmAttachment(
        key: 'catatan_kesehatan',
        label: 'Catatan Kesehatan Sebelumnya (jika ada)',
      ),
      SpmAttachment(
        key: 'location_coordinates',
        label: 'Titik Koordinat Lokasi',
      ),
    ];

    final spmAttachmentKeys = spmAttachments.map((e) {
      return e.key;
    }).toList();

    if (spmAttachmentKeys.contains(key)) {
      return spmAttachments.firstWhere((element) {
            return element.key == key;
          }).label ??
          'Unknown';
    }

    return key;
  }

  static List<SpmAttachment> filterSpmAttachmentsByField({
    required String spmFieldName,
  }) {
    final spmAttachments = const [
      SpmAttachment(
        key: 'fc_ktp',
        label: 'Foto Copy Kartu Tanda Penduduk (KTP)',
      ),
      SpmAttachment(key: 'fc_kk', label: 'Foto Copy Kartu Keluarga (KK)'),
      SpmAttachment(
        key: 'surat_izin_tidak_mampu',
        label: 'Surat Pernyataan Tidak Mampu dari RT setempat',
      ),
      SpmAttachment(
        key: 'surat_belum_menerima_bantuan_rehabilitasi',
        label:
            'Surat Pernyataan Calon Penerima belum pernah menerima bantuan Rehabilitasi Rumah',
      ),
      SpmAttachment(
        key: 'surat_keterangan_penghasilan',
        label: 'Surat Keterangan Penghasilan dari Kelurahan',
      ),
      SpmAttachment(
        key: 'fc_surat_tanah',
        label: 'Foto Copy Surat Tanah dan sejenisnya',
      ),
      SpmAttachment(
        key: 'foto_kondisi_rumah',
        label: 'Foto kondisi rumah Calon Penerima Bantuan',
      ),
      SpmAttachment(
        key: 'surat_permohonan_rtrw',
        label: 'Surat Permohonan RT/RW',
      ),
      SpmAttachment(
        key: 'kartu_bpjs_kis_jkn',
        label: 'Kartu BPJS/KIS/JKN (jika ada)',
      ),
      SpmAttachment(
        key: 'buku_kesehatan',
        label: 'Buku Kesehatan Ibu dan Anak (KIA) atau Buku Kesehatan Lansia',
      ),
      SpmAttachment(
        key: 'catatan_kesehatan',
        label: 'Catatan Kesehatan Sebelumnya (jika ada)',
      ),
      SpmAttachment(
        key: 'location_coordinates',
        label: 'Titik Koordinat Lokasi',
      ),
    ];

    final includeAttachmentMap = {
      'pendidikan': {'fc_ktp', 'fc_kk', 'surat_izin_tidak_mampu'},
      'kesehatan': {
        'fc_ktp',
        'fc_kk',
        'surat_permohonan_rtrw',
        'kartu_bpjs_kis_jkn',
        'buku_kesehatan',
        'catatan_kesehatan',
      },
      'pekerjaan umum': {
        'location_coordinates',
        'fc_ktp',
        'fc_kk',
        'surat_permohonan_rtrw',
      },
      'perumahan rakyat': {
        'fc_ktp',
        'fc_kk',
        'surat_belum_menerima_bantuan_rehabilitasi',
        'fc_surat_tanah',
        'foto_kondisi_rumah',
      },
      'trantibum linmas': {'fc_ktp'},
      'sosial': {'fc_ktp', 'fc_kk'},
    };

    final fieldKey = spmFieldName.toLowerCase();
    final include = includeAttachmentMap[fieldKey] ?? {};

    return spmAttachments.where((e) => include.contains(e.key)).toList();
  }
}
