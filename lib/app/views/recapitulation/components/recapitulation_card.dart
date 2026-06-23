import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/utils/build_context_extension.dart';
import 'package:panduan/app/utils/string_extension.dart';

class RecapitulationCard extends StatelessWidget {
  const RecapitulationCard({
    required this.label,
    required this.title,
    required this.total,
    required this.pendidikan,
    required this.kesehatan,
    required this.pekerjaanUmum,
    required this.perumahanRakyat,
    required this.sosial,
    required this.trantibumLinmas,
    required this.lainnya,
    this.dataLength = 0,
    this.index = 0,
    super.key,
  });

  final String label;
  final String title;
  final int total;
  final int pendidikan;
  final int kesehatan;
  final int pekerjaanUmum;
  final int perumahanRakyat;
  final int sosial;
  final int trantibumLinmas;
  final int lainnya;
  final int dataLength;
  final int index;

  Widget _buildStatRow(String title, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 8),
          Text(
            '$value SPM',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(
        bottom: index == dataLength - 1 ? context.deviceViewPadding.bottom : 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.softBlueColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      MingCute.building_5_line,
                      size: 24,
                      color: AppColors.blueColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        title.capitalize(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Material(
                  clipBehavior: Clip.antiAlias,
                  shape: const StadiumBorder(),
                  color: AppColors.pinkColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      child: Text(
                        '$total SPM',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(height: 1),
            ),
            _buildStatRow('Pendidikan:', pendidikan),
            _buildStatRow('Kesehatan:', kesehatan),
            _buildStatRow('Pekerjaan Umum:', pekerjaanUmum),
            _buildStatRow('Perumahan Rakyat:', perumahanRakyat),
            _buildStatRow('Sosial:', sosial),
            _buildStatRow('Trantibum Linmas:', trantibumLinmas),
            _buildStatRow('Lainnya:', lainnya),
          ],
        ),
      ),
    );
  }
}
