import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/string_extension.dart';

class ReporterSection extends StatelessWidget {
  const ReporterSection({
    required this.nik,
    required this.fullName,
    required this.address,
    required this.rt,
    required this.rw,
    required this.subDistrictName,
    required this.districtName,
    required this.phone,
    super.key,
  });

  final String nik;
  final String fullName;
  final String address;
  final String rt;
  final String rw;
  final String subDistrictName;
  final String districtName;
  final String phone;

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
            const Text(
              'Data Pelapor',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.grey.shade300),
            ),
            Row(
              children: [
                const Icon(MingCute.IDcard_line, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    nik,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(MingCute.user_1_line, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    fullName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(MingCute.home_4_line, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '$address RT $rt RW $rw, Kelurahan ${subDistrictName.capitalize()}, Kecamatan ${districtName.capitalize()}',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(MingCute.phone_line, size: 18),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
