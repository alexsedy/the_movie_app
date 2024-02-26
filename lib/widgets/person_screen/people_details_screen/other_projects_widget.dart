import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:the_movie_app/domain/entity/credits/credits_people/credits_people.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';

class OtherProjectsWidget extends StatelessWidget {
  const OtherProjectsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Other projects",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MoviesButtonWidget(),
            _TvShowButtonWidget(),
          ],
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}

class _TvShowButtonWidget extends StatelessWidget {
  const _TvShowButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final personDetails = NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails;
    final tvCredits = personDetails?.tvCredits;

    return InkWell(
      onTap: (){},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              "TV Shows",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MoviesButtonWidget extends StatelessWidget {
  const _MoviesButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model =  NotifierProvider.watch<PeopleDetailsModel>(context);
    final movieCreditList = model?.movieCreditList;

    if(movieCreditList == null) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          backgroundColor: Colors.transparent,
          builder: (context) {
            return DraggableScrollableSheet(
              initialChildSize: 0.45,
              minChildSize: 0.2,
              maxChildSize: 1,
              builder: (context, scrollController) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: GroupedListView<CreditList, String>(
                    sort: false,
                    elements: movieCreditList,
                    groupBy: (CreditList c) => c.department,
                    groupHeaderBuilder: (c) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Text(
                          c.department,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                    indexedItemBuilder: (context, movieCreditList, index) {
                      return Text(movieCreditList.department != "Actor"
                          ? movieCreditList.job ?? ""
                          : movieCreditList.character ?? ""
                      );
                    },
                  ),
                );
              },
            );
          }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              "Movies",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}