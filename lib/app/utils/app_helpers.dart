import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:panduan/app/models/service_type.dart';
import 'package:panduan/app/models/spm_attachment.dart';
import 'package:panduan/app/utils/app_strings.dart';

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

  static CancelToken createCancelToken(
    Map<String, CancelToken> cancelTokens, {
    required String key,
  }) {
    if (cancelTokens.containsKey(key)) {
      cancelTokens[key]?.cancel();
    }

    final cancelToken = CancelToken();
    cancelTokens[key] = cancelToken;

    return cancelToken;
  }

  static void removeCancelToken(
    Map<String, CancelToken> cancelTokens, {
    required String key,
  }) {
    cancelTokens[key]?.cancel();
    cancelTokens.remove(key);
  }

  static void removeAllCancelToken(Map<String, CancelToken> cancelTokens) {
    for (final cancelToken in cancelTokens.values) {
      cancelToken.cancel();
    }

    cancelTokens.clear();
  }

  static String errorHandlingApiMessage(DioException e) {
    final type = e.type;
    final statusCode = e.response?.statusCode;

    if (type == DioExceptionType.connectionError) {
      return AppStrings.noConnectionErrorApiMessage;
    }

    if (statusCode == null) {
      return AppStrings.unknownErrorApiMessage;
    }

    if (statusCode >= 500) {
      return AppStrings.serverErrorApiMessage;
    }

    final rawMessage = e.response?.data['message'];
    final apiMessage = e.response?.data['message'] is String
        ? rawMessage
        : null;

    return apiMessage == null || apiMessage.isEmpty
        ? AppStrings.unknownErrorApiMessage
        : apiMessage;
  }

  static Map<String, dynamic> addOnHeaders() {
    return {'Content-type': 'application/json', 'Accept': 'application/json'};
  }

  static String rangeDateFormat(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
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

  static bool passwordHasUppercase(String password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool passwordHasDigit(String password) {
    return password.contains(RegExp(r'\d'));
  }

  static bool passwordHasSymbol(String password) {
    return password.contains(
      RegExp(r'[!@#\$%^&*(),.?":{}|<>=+\-_~`\[\]\\\/;]'),
    );
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

  static List<String> listStatus() {
    return const [
      'NEED_VERIFICATION_SUB_DISTRICT',
      'NEED_VERIFICATION_OPD',
      'NEED_APPROVAL_DISTRICT',
      'VERIFICATION_SUB_DISTRICT',
      'PROCESS_BY_DISTRICT',
      'PROCESS_BY_SUB_DISTRICT',
      'PROCESS_BY_OPD',
      'FORWARD_TO_DISTRICT',
      'FORWARD_TO_TP_POSYANDU_KOTA',
      'FORWARD_TO_OPD',
      'FINISH_BY_DISTRICT',
      'FINISH_BY_SUB_DISTRICT',
      'FINISH_BY_OPD',
      'DECLINE_BY_SUB_DISTRICT',
      'DECLINE_BY_DISTRICT',
      'DECLINE_BY_OPD',
      'RETURN_TO_TP_POSYANDU_KOTA',
      'RETURN_TO_SUB_DISTRICT',
      'RETURN_TO_KADER',
    ];
  }

  static String statusLabel(String status) {
    switch (status) {
      case "FINISH_BY_DISTRICT":
        return "Selesai oleh Kecamatan";
      case "FINISH_BY_SUB_DISTRICT":
        return "Selesai oleh Kelurahan";
      case "FINISH_BY_OPD":
        return "Selesai oleh OPD";
      case "VERIFICATION_SUB_DISTRICT":
        return "Verifikasi Kelurahan";
      case "PROCESS_BY_DISTRICT":
        return "Diproses Kecamatan";
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
      case "FORWARD_TO_DISTRICT":
        return "Diteruskan ke Kecamatan";
      case "FORWARD_TO_TP_POSYANDU_KOTA":
        return "Perlu Tindak Lanjut TP Posyandu Kota";
      case "FORWARD_TO_OPD":
        return "Diteruskan ke OPD";
      case "NEED_VERIFICATION_SUB_DISTRICT":
        return "Perlu Verifikasi Kelurahan";
      case "NEED_VERIFICATION_OPD":
        return "Perlu Verifikasi OPD";
      case "NEED_APPROVAL_DISTRICT":
        return "Perlu Verifikasi Kecamatan";
      case "RETURN_TO_TP_POSYANDU_KOTA":
        return "Dikembalikan ke TP Posyandu Kota";
      case "RETURN_TO_SUB_DISTRICT":
        return "Dikembalikan ke Kelurahan";
      case "RETURN_TO_KADER":
        return "Dikembalikan ke Posyandu";
      default:
        return "Status Tidak Diketahui";
    }
  }

  static Color statusColor(String status) {
    switch (status) {
      case "FINISH_BY_DISTRICT":
      case "FINISH_BY_SUB_DISTRICT":
      case "FINISH_BY_OPD":
        return Colors.green.shade500;
      case "VERIFICATION_SUB_DISTRICT":
      case "NEED_VERIFICATION_SUB_DISTRICT":
        return Colors.amber.shade500;
      case "PROCESS_BY_DISTRICT":
      case "PROCESS_BY_SUB_DISTRICT":
      case "PROCESS_BY_OPD":
        return Colors.blue.shade500;
      case "DECLINE_BY_SUB_DISTRICT":
      case "DECLINE_BY_DISTRICT":
      case "DECLINE_BY_OPD":
        return Colors.red.shade500;
      case "FORWARD_TO_DISTRICT":
      case "FORWARD_TO_OPD":
        return Colors.purple.shade500;
      case "RETURN_TO_TP_POSYANDU_KOTA":
      case "RETURN_TO_SUB_DISTRICT":
      case "RETURN_TO_KADER":
        return Colors.orange.shade500;
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
      // SpmAttachment(
      //   key: 'location_coordinates',
      //   label: 'Titik Koordinat Lokasi',
      // ),
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
        // 'location_coordinates',
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
