import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseDropdownField<T> extends StatelessWidget {
  const BaseDropdownField({
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
    this.multiValue,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.selectedItemBuilder,
    super.key,
  });

  final String hint;
  final List<DropdownItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final ValueListenable<T?>? value;
  final ValueListenable<Iterable<T>>? multiValue;
  final String? Function(T? value)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;

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
      buttonStyleData: const FormFieldButtonStyleData(width: double.infinity),
      menuItemStyleData: MenuItemStyleData(padding: menuItemStylePadding),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        elevation: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
      valueListenable: value,
      multiValueListenable: multiValue,
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

class BaseDropdownGroupField<T> extends StatelessWidget {
  const BaseDropdownGroupField({
    required this.label,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.mandatory = false,
    this.value,
    this.multiValue,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.selectedItemBuilder,
    super.key,
  });

  final String label;
  final String hint;
  final List<DropdownItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final bool mandatory;
  final ValueListenable<T?>? value;
  final ValueListenable<Iterable<T>>? multiValue;
  final String? Function(T? value)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? menuItemStylePadding;
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
        DropdownButtonFormField2<T>(
          isExpanded: true,
          isDense: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontFamily: 'Jost',
          ),
          buttonStyleData: const FormFieldButtonStyleData(
            width: double.infinity,
          ),
          menuItemStyleData: MenuItemStyleData(padding: menuItemStylePadding),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            elevation: 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
          valueListenable: value,
          multiValueListenable: multiValue,
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
    required this.searchHint,
    required this.searchController,
    required this.searchMatchFn,
    required this.emptySearchHint,
    this.value,
    this.multiValue,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.selectedItemBuilder,
    this.onMenuStateChange,
    super.key,
  });

  final String hint;
  final List<DropdownItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final String searchHint;
  final TextEditingController searchController;
  final SearchMatchFn<T> searchMatchFn;
  final String emptySearchHint;
  final ValueListenable<T?>? value;
  final ValueListenable<Iterable<T>>? multiValue;
  final String? Function(T? value)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
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
      buttonStyleData: const FormFieldButtonStyleData(width: double.infinity),
      menuItemStyleData: MenuItemStyleData(padding: menuItemStylePadding),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 200,
        elevation: 1,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
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
      valueListenable: value,
      multiValueListenable: multiValue,
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
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchBarWidgetHeight: 100,
        searchBarWidget: Padding(
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
        noResultsWidget: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            emptySearchHint,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
    required this.searchHint,
    required this.searchController,
    required this.searchMatchFn,
    required this.emptySearchHint,
    this.mandatory = false,
    this.value,
    this.multiValue,
    this.validator,
    this.helperText,
    this.helperTextColor,
    this.prefixIcon,
    this.suffixIcon,
    this.menuItemStylePadding = const EdgeInsets.symmetric(horizontal: 16),
    this.selectedItemBuilder,
    this.onMenuStateChange,
    super.key,
  });

  final String label;
  final String hint;
  final List<DropdownItem<T>>? items;
  final ValueChanged<T?>? onChanged;
  final String searchHint;
  final TextEditingController searchController;
  final SearchMatchFn<T> searchMatchFn;
  final String emptySearchHint;
  final bool mandatory;
  final ValueListenable<T?>? value;
  final ValueListenable<Iterable<T>>? multiValue;
  final String? Function(T? value)? validator;
  final String? helperText;
  final Color? helperTextColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? menuItemStylePadding;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
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
          buttonStyleData: const FormFieldButtonStyleData(
            width: double.infinity,
          ),
          menuItemStyleData: MenuItemStyleData(padding: menuItemStylePadding),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            elevation: 1,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
          valueListenable: value,
          multiValueListenable: multiValue,
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
          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchBarWidgetHeight: 100,
            searchBarWidget: Padding(
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
            noResultsWidget: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                emptySearchHint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
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
