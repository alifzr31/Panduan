import 'package:flutter/material.dart';
import 'package:panduan/app/cubits/recapitulation/recapitulation_cubit.dart';
import 'package:panduan/app/views/recapitulation/components/recapitulation_card_loading.dart';
import 'package:panduan/app/widgets/base_handlestate.dart';

class RecapitulationBody<T> extends StatelessWidget {
  const RecapitulationBody({
    required this.status,
    required this.errorMessage,
    required this.emptyMessage,
    required this.onRefetch,
    required this.items,
    required this.itemBuilder,
    super.key,
  });

  final Status status;
  final String errorMessage;
  final String emptyMessage;
  final void Function()? onRefetch;
  final List<T> items;
  final Widget Function(BuildContext context, int index, T item) itemBuilder;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case Status.error:
        return Padding(
          padding: const EdgeInsets.all(16),
          child: BaseHandleState(
            handleType: HandleType.error,
            errorMessage: errorMessage,
            onRefetch: onRefetch,
          ),
        );
      case Status.success:
        return items.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16),
                child: BaseHandleState(
                  handleType: HandleType.empty,
                  errorMessage: emptyMessage,
                  onRefetch: onRefetch,
                ),
              )
            : RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: () async {
                  await Future.delayed(
                    const Duration(milliseconds: 2500),
                    onRefetch,
                  );
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return itemBuilder(context, index, items[index]);
                  },
                ),
              );
      default:
        return const RecapitulationCardLoading();
    }
  }
}
