import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/image_gallery_widget.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/other_projects_widget.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_bio_widget.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_shimmer_skeleton_widget.dart';

class PeopleDetailsWidget extends StatefulWidget {
  const PeopleDetailsWidget({super.key});

  @override
  State<PeopleDetailsWidget> createState() => _PeopleDetailsWidgetState();
}

class _PeopleDetailsWidgetState extends State<PeopleDetailsWidget> {

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<PeopleDetailsModel>(context)?.loadPersonDetails();
  }

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
    final person =  NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails;

    if(person == null) {
      return const PeopleDetailsShimmerSkeletonWidget();
    }

    return const Padding(
      padding: EdgeInsets.only(right: 8, left: 8, bottom: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BioPersonWidget(),
            SizedBox(height: 10,),
            ImageGallery(),
            SizedBox(height: 20,),
            OtherProjectsWidget(),
          ],
        ),
      ),
    );
  }
}