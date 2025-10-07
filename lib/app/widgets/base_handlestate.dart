import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:panduan/app/utils/app_strings.dart';

enum HandleType { empty, error }

class BaseHandleState extends StatelessWidget {
  const BaseHandleState({
    required this.handleType,
    required this.errorMessage,
    this.iconWidth = 100,
    this.errorMessageSize = 14,
    this.iconButtonSize = 18,
    this.labelButtonSize = 14,
    this.onRefetch,
    super.key,
  });

  final HandleType handleType;
  final String errorMessage;
  final double iconWidth;
  final double errorMessageSize;
  final double iconButtonSize;
  final double labelButtonSize;
  final void Function()? onRefetch;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppStrings.assetsIcons +
                (handleType == HandleType.empty ? '/empty.svg' : '/error.svg'),
            width: iconWidth,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: errorMessageSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            onPressed: onRefetch,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(MingCute.refresh_2_line, size: iconButtonSize),
                const SizedBox(width: 4),
                Text(
                  'Muat Ulang',
                  style: TextStyle(
                    fontSize: labelButtonSize,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Jost',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
