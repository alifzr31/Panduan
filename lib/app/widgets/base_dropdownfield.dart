import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseDropdownField extends StatelessWidget {
  const BaseDropdownField({
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.menuItemStyleHeight = kMinInteractiveDimension,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.selectedItemBuilder,
    super.key,
  });

  final String hint;
  final List<DropdownMenuItem<Object>>? items;
  final void Function(Object?)? onChanged;
  final Object? value;
  final String? Function(Object?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double menuItemStyleHeight;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2(
      isExpanded: true,
      isDense: true,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontFamily: 'Jost',
      ),
      buttonStyleData: const ButtonStyleData(width: double.infinity),
      menuItemStyleData: MenuItemStyleData(
        height: menuItemStyleHeight,
        padding: menuItemStylePadding,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        elevation: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      hint: Text(
        hint,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jost',
        ),
      ),
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
      selectedItemBuilder: selectedItemBuilder,
      decoration: InputDecoration(
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jost',
        ),
        helperText: helperText,
        helperMaxLines: 2,
        errorMaxLines: 2,
        helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
        errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 2),
                child: prefixIcon,
              ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 2, right: 10),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blueColor),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade600),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        filled: true,
        fillColor: AppColors.greyFormField,
      ),
    );
  }
}

class BaseDropdownGroupField extends StatelessWidget {
  const BaseDropdownGroupField({
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.mandatory = false,
    this.value,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.menuItemStyleHeight = kMinInteractiveDimension,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.suffixIcon,
    this.selectedItemBuilder,
    super.key,
  });

  final String label;
  final String hint;
  final List<DropdownMenuItem<Object>>? items;
  final void Function(Object?)? onChanged;
  final bool mandatory;
  final Object? value;
  final String? Function(Object?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final double menuItemStyleHeight;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final Widget? suffixIcon;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (mandatory)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2(
          isExpanded: true,
          isDense: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Jost',
          ),
          buttonStyleData: const ButtonStyleData(width: double.infinity),
          menuItemStyleData: MenuItemStyleData(
            height: menuItemStyleHeight,
            padding: menuItemStylePadding,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            elevation: 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              fontFamily: 'Jost',
            ),
          ),
          value: value,
          items: items,
          validator: validator,
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          decoration: InputDecoration(
            helperText: helperText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
            errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 2),
                    child: prefixIcon,
                  ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 2, right: 10),
                    child: suffixIcon,
                  ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueColor),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade600),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            fillColor: AppColors.greyFormField,
          ),
        ),
      ],
    );
  }
}

class BaseDropdownSearchField<T> extends StatelessWidget {
  const BaseDropdownSearchField({
    required this.hint,
    required this.items,
    required this.onChanged,
    this.mandatory = false,
    this.value,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.menuItemStyleHeight = kMinInteractiveDimension,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.suffixIcon,
    this.selectedItemBuilder,
    this.searchHint,
    this.searchController,
    this.searchMatchFn,
    this.onMenuStateChange,
    super.key,
  });

  final String hint;
  final List<DropdownMenuItem<T>>? items;
  final void Function(Object?)? onChanged;
  final bool mandatory;
  final T? value;
  final String? Function(Object?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final double menuItemStyleHeight;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final Widget? suffixIcon;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? searchHint;
  final TextEditingController? searchController;
  final bool Function(DropdownMenuItem<T>, String)? searchMatchFn;
  final void Function(bool)? onMenuStateChange;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<T>(
      isExpanded: true,
      isDense: true,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontFamily: 'Jost',
      ),
      buttonStyleData: const ButtonStyleData(width: double.infinity),
      menuItemStyleData: MenuItemStyleData(
        height: menuItemStyleHeight,
        padding: menuItemStylePadding,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        elevation: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      hint: Text(
        hint,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade500,
          fontWeight: FontWeight.w500,
          fontFamily: 'Jost',
        ),
      ),
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
      selectedItemBuilder: selectedItemBuilder,
      decoration: InputDecoration(
        helperText: helperText,
        helperMaxLines: 2,
        errorMaxLines: 2,
        helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
        errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
        counterText: '',
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: prefixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 10, right: 2),
                child: prefixIcon,
              ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        suffixIcon: suffixIcon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 2, right: 10),
                child: suffixIcon,
              ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 38,
          minWidth: 30,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blueColor),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade600),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        filled: true,
        fillColor: AppColors.greyFormField,
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidgetHeight: 100,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: TextFormField(
            controller: searchController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.all(10),
              hintText: searchHint,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.blueColor),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.blueColor),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.blueColor),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        searchMatchFn: searchMatchFn,
      ),
      onMenuStateChange: onMenuStateChange,
    );
  }
}

class BaseDropdownSearchGroupField<T> extends StatelessWidget {
  const BaseDropdownSearchGroupField({
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.mandatory = false,
    this.value,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.menuItemStyleHeight = kMinInteractiveDimension,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.suffixIcon,
    this.selectedItemBuilder,
    this.searchHint,
    this.searchController,
    this.searchMatchFn,
    this.onMenuStateChange,
    super.key,
  });

  final String label;
  final String hint;
  final List<DropdownMenuItem<T>>? items;
  final void Function(Object?)? onChanged;
  final bool mandatory;
  final T? value;
  final String? Function(Object?)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final double menuItemStyleHeight;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final Widget? suffixIcon;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final String? searchHint;
  final TextEditingController? searchController;
  final bool Function(DropdownMenuItem<T>, String)? searchMatchFn;
  final void Function(bool)? onMenuStateChange;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (mandatory)
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade700,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField2<T>(
          isExpanded: true,
          isDense: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Jost',
          ),
          buttonStyleData: const ButtonStyleData(width: double.infinity),
          menuItemStyleData: MenuItemStyleData(
            height: menuItemStyleHeight,
            padding: menuItemStylePadding,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            elevation: 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
              fontFamily: 'Jost',
            ),
          ),
          value: value,
          items: items,
          validator: validator,
          onChanged: onChanged,
          selectedItemBuilder: selectedItemBuilder,
          decoration: InputDecoration(
            helperText: helperText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            helperStyle: TextStyle(fontSize: 12, color: helperTextColor),
            errorStyle: TextStyle(fontSize: 12, color: Colors.red.shade600),
            counterText: '',
            isDense: true,
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 10, right: 2),
                    child: prefixIcon,
                  ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            suffixIcon: suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 2, right: 10),
                    child: suffixIcon,
                  ),
            suffixIconConstraints: const BoxConstraints(
              minHeight: 38,
              minWidth: 30,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.blueColor),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red.shade600),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            filled: true,
            fillColor: AppColors.greyFormField,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchInnerWidgetHeight: 100,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                controller: searchController,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  hintText: searchHint,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.blueColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.blueColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.blueColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: searchMatchFn,
          ),
          onMenuStateChange: onMenuStateChange,
        ),
      ],
    );
  }
}
