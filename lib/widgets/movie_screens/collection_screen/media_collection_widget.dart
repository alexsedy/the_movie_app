import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/collection_screen/media_collection_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/color_list_shimmer_skeleton_widget.dart';

class MediaCollectionWidget extends StatefulWidget {
  const MediaCollectionWidget({super.key});

  @override
  State<MediaCollectionWidget> createState() => _MediaCollectionWidgetState();
}

class _MediaCollectionWidgetState extends State<MediaCollectionWidget> {
  @override
  void initState() {
    NotifierProvider.read<MediaCollectionModel>(context)?.loadCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const _TextHeaderWidget(),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _TextHeaderWidget extends StatelessWidget {
  const _TextHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MediaCollectionModel>(context);
    final name = model?.mediaCollections?.name;

    if(name == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white.withOpacity(0.5),
        child: Container(
          height: 40,
          width: 250,
          color: Colors.white,
        ),
      );
    }

    return Text(name);
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MediaCollectionModel>(context);
    final mediaCollections = model?.mediaCollections;

    if(model == null) {
      return const SizedBox.shrink();
    } else if (mediaCollections == null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 10, right: 10, bottom: 2),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.withOpacity(0.5),
              highlightColor: Colors.white.withOpacity(0.5),
              child: Container(
                height: 25,
                width: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
          const Expanded(child: ColorListShimmerSkeletonWidget()),
        ],
      );
    }

    return Column(
      children: [
        const _BodyOverviewWidget(),
        Expanded(
          child: ParameterizedVerticalListWidget(
            paramModel: ParameterizedWidgetModel(
              action: model.onMediaDetailsScreen,
              altImagePath: AppImages.noPoster,
              list: ConverterHelper.convertMediaCollection(mediaCollections),
            ),
          ),
        )
      ],
    );
  }
}

class _BodyOverviewWidget extends StatefulWidget {
  const _BodyOverviewWidget({super.key});

  @override
  State<_BodyOverviewWidget> createState() => _BodyOverviewWidgetState();
}

class _BodyOverviewWidgetState extends State<_BodyOverviewWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MediaCollectionModel>(context);
    final mediaCollections = model?.mediaCollections;
    final overview = mediaCollections?.overview;

    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 10, right: 10, bottom: 2),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Text(
                overview ?? "",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              secondChild: Text(
                overview ?? "",
              ),
            ),
            overview != null && overview.length <= 60
                ? const SizedBox.shrink()
                : Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}

