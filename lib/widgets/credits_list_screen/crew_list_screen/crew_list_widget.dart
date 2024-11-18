import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/person/credits_people/credits.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_model.dart';

class CrewListWidget extends StatelessWidget {
  const CrewListWidget({super.key});

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
    final model = NotifierProvider.watch<CrewListModel>(context);
    final crews = model?.crew;

    if (crews == null) {
      return const SizedBox.shrink();
    } else if (crews.isEmpty) {
      return const SizedBox.shrink();
    }

   return GroupedListView<Crew, String>(
     elements: crews,
     sort: false,
     groupBy: (Crew crew) => crew.department,
     useStickyGroupSeparators: true,
     groupHeaderBuilder: (c) {
       return Padding(
         padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
         child: Text(
           c.department,
           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
         ),
       );},
     indexedItemBuilder: (context, crew, index) {
       final profilePath = crews[index].profilePath;
       final job = crews[index].job;
       final name = crews[index].name;

       return SizedBox(
         height: 163,
         child: Padding(
           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                         padding: const EdgeInsets.only(
                             left: 15, right: 10, bottom: 1),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             const SizedBox(height: 15,),
                               Text(
                                 name ?? "",
                                 style: const TextStyle(
                                     fontWeight: FontWeight.bold),
                                 maxLines: 1,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             // if(paramModel.list[index].secondLine != null)
                             //   const SizedBox(height: 5,),
                             // if(paramModel.list[index].secondLine != null)
                             //   Text(
                             //     paramModel.list[index].secondLine ?? "",
                             //     style: const TextStyle(
                             //         color: Colors.grey),
                             //     maxLines: 1,
                             //     overflow: TextOverflow.ellipsis,
                             //   ),
                             // if(paramModel.list[index].thirdLine != null)
                             // // const SizedBox(height: 15,),
                               const SizedBox(height: 15,),
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
                     model?.onPeopleTab(context, index);
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