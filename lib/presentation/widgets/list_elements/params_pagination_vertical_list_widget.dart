import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedPaginationVerticalListWidget extends StatefulWidget {
  final ParameterizedWidgetModel paramModel;
  final Function loadMoreItems;

  const ParameterizedPaginationVerticalListWidget({
    super.key,
    required this.paramModel, required this.loadMoreItems,
  });

  @override
  State<ParameterizedPaginationVerticalListWidget> createState() => _ParameterizedPaginationVerticalListWidgetState();
}

class _ParameterizedPaginationVerticalListWidgetState extends State<ParameterizedPaginationVerticalListWidget> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    var scrollController = widget.paramModel.scrollController;

    if(scrollController != null) {
      _scrollController = scrollController;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      widget.loadMoreItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = widget.paramModel.statuses ?? [];

    return ListView.builder(
      itemExtent: AppSpacing.p160,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _scrollController,
      itemCount: widget.paramModel.list.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.paramModel.list.length) {
          return _isLoading
              ? Center(child: CircularProgressIndicator())
              : AppSpacing.emptyGap;
        }

        String? posterPath = widget.paramModel.list[index].imagePath;

        return Padding(
          padding: AppSpacing.screenPaddingH16V10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
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
                              widget.paramModel.list[index].firstLine ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH6,
                            Text(
                              widget.paramModel.list[index].secondLine ?? "",
                              style: const TextStyle(
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH16,
                            Expanded(
                              child: Text(
                                widget.paramModel.list[index].thirdLine ?? "",
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
                  borderRadius: const BorderRadius.all(Radius.circular(
                      10)),
                  onTap: () {
                    widget.paramModel.action(context, index);
                  },
                ),
              ),
              if(statuses.any((e) =>
                e.id == widget.paramModel.list[index].id && e.status != 0))
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
