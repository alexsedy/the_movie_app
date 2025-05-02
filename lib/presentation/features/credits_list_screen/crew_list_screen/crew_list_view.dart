import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/crew_list_screen/viewmodel/crew_list_viewmodel.dart';

class CrewListView extends StatelessWidget {
  const CrewListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.crew),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<CrewListViewModel>();
    final crews = model.crew;

    if (crews.isEmpty) {
    return AppSpacing.emptyGap;
  }

   return GroupedListView<Crew, String>(
     elements: crews,
     sort: false,
     groupBy: (Crew crew) => crew.department,
     useStickyGroupSeparators: true,
     groupHeaderBuilder: (c) {
       return Padding(
         padding: AppSpacing.screenPaddingH16V10,
         child: Text(
           c.department,
           style: Theme.of(context).textTheme.titleMedium,
         ),
       );},
     indexedItemBuilder: (context, crew, index) {
       final profilePath = crews[index].profilePath;
       final job = crews[index].job;
       final name = crews[index].name;

       return SizedBox(
         height: 163,
         child: Padding(
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
                   ],
                 ),
                 clipBehavior: Clip.hardEdge,
                 child: Row(
                   children: [
                     AspectRatio(
                       aspectRatio: 500 / 750,
                       child: profilePath != null
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
                         ApiClient.getImageByUrl(profilePath), width: 95, fit: BoxFit.fitHeight,)
                           : Image.asset(AppImages.noProfile, width: 95, fit: BoxFit.fill,),
                     ),
                     Expanded(
                       child: Padding(
                         padding: AppSpacing.screenPaddingL16R10B2,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             AppSpacing.gapH16,
                               Text(
                                 name ?? "",
                                 style: Theme.of(context).textTheme.bodyLarge,
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             AppSpacing.gapH16,
                               Expanded(
                                 child: Text(
                                   job,
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
                   onTap: () {
                     model.onPeopleTab(context, index);
                   },
                 ),
               )
             ],
           ),
         ),
       );
     }
   );
  }
}