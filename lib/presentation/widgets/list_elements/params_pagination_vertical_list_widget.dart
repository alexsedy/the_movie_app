import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/widget_size.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedPaginationVerticalListWidget extends StatefulWidget {
  final ParameterizedWidgetModel paramModel;
  final Function loadMoreItems;
  final bool hasPagination;
  final ScrollController? scrollController;

  const ParameterizedPaginationVerticalListWidget({
    super.key,
    required this.paramModel,
    required this.loadMoreItems,
    this.hasPagination = true,
    this.scrollController,
  });

  @override
  State<ParameterizedPaginationVerticalListWidget> createState() => _ParameterizedPaginationVerticalListWidgetState();
}

class _ParameterizedPaginationVerticalListWidgetState extends State<ParameterizedPaginationVerticalListWidget> {
  late final ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.hasPagination) {
      _scrollController = widget.scrollController ?? ScrollController();
      _scrollController.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.hasPagination && widget.scrollController == null) {
      _scrollController.dispose();
    } else if (widget.hasPagination) {
      _scrollController.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      widget.loadMoreItems().whenComplete(() {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = widget.paramModel.statuses ?? [];

    return ListView.builder(
      itemExtent: WidgetSize.size180,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: widget.hasPagination ? _scrollController : null,
      itemCount: widget.paramModel.list.length + (widget.hasPagination ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (widget.hasPagination && index == widget.paramModel.list.length) {
          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : AppSpacing.emptyGap;
        }

        final item = widget.paramModel.list[index];
        final posterPath = item.imagePath;

        return Padding(
          padding: AppSpacing.screenPaddingH16V10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )
                    ]
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 500 / 750,
                      child: posterPath != null
                          ? Image.network(
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fill,)
                          : Image.asset(widget.paramModel.altImagePath, width: 95, fit: BoxFit.fill,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: AppSpacing.screenPaddingL16R10B2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpacing.gapH16,
                            Text(
                              item.firstLine ?? "",
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH6,
                            Text(
                              item.secondLine ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH16,
                            Expanded(
                              child: Text(
                                item.thirdLine ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  onTap: () => widget.paramModel.action(context, index),
                ),
              ),
              if (statuses.any((e) => e.id == item.id && e.status != 0))
                Positioned(
                  top: 5,
                  right: 5,
                  child: Icon(
                    Icons.bookmark,
                    color: Colors.blueAccent.withAlpha(180),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
