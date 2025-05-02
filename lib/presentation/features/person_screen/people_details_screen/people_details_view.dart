import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/data/models/person/details/person_details.dart';
import 'package:the_movie_app/presentation/features/person_screen/people_details_screen/people_bio_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/people_details_shimmer_skeleton_widget.dart';
import 'package:the_movie_app/presentation/features/person_screen/viewmodel/people_details_viewmodel.dart';

import 'image_gallery_widget.dart';
import 'other_projects_widget.dart';

class PeopleDetailsView extends StatelessWidget {
  const PeopleDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: const _BodyPeopleDetailsWidget(),
    );
  }
}

class _BodyPeopleDetailsWidget extends StatelessWidget {
  const _BodyPeopleDetailsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final person = context.select<PeopleDetailsViewModel, PersonDetails?>(
            (viewModel) => viewModel.personDetails);

    if(person == null) {
      return const PeopleDetailsShimmerSkeletonWidget();
    }

    return const Padding(
      padding: AppSpacing.screenPaddingH10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            BioPersonWidget(),
            ImageGallery(),
            AppSpacing.gapH20,
            OtherProjectsWidget(),
          ],
        ),
      ),
    );
  }
}