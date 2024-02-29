import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/domain/entity/movie_and_tv_show/credits/credits_details.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/credits_list_screen/crew_list_screen/crew_list_model.dart';

class CrewListWidget extends StatelessWidget {
  const CrewListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crew"),
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
       );
     },
     indexedItemBuilder: (context, crew, index) {
     final profilePath = crews[index].profilePath;
     final job = crews[index].job;
     final name = crews[index].name;

       return SizedBox(
         height: 180,
         child: Padding(
           padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
           child: SizedBox(
             child: Card(
               clipBehavior: Clip.hardEdge,
               child: ListTile(
                 onTap: () => model?.onPeopleTab(context, index),
                 minVerticalPadding: 0,
                 contentPadding: EdgeInsets.zero,
                 title: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
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
                              ApiClient.getImageByUrl(profilePath),)
                           : Image.asset(AppImages.noProfile,),
                     ),
                     const SizedBox(width: 14,),
                     Expanded(
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           const SizedBox(height: 6,),
                           Text(name,
                             softWrap: true,
                             maxLines: 3,
                             style: const TextStyle(
                               fontSize: 22,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           Text(job,
                             softWrap: true,
                             maxLines: 3,
                             style: const TextStyle(
                               fontSize: 20,
                               fontStyle: FontStyle.italic,
                             ),
                           ),
                           const SizedBox(height: 6,),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ),
           ),
         ),
       );
     }
   );
  }
}



// class _WorkBodyWidget extends StatelessWidget {
//   const _WorkBodyWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final model = NotifierProvider.watch<CrewListModel>(context);
//     final crews = model?.crew;
//
//     if (crews == null) {
//       return SizedBox.shrink();
//     }
//
//     // сначала, необходимо сгруппировать список по полю department
//     Map<String, List<Crew>> groupedCrews = {};
//     crews.forEach((crew) {
//       if (!groupedCrews.containsKey(crew.department)) {
//         groupedCrews[crew.department] = [];
//       }
//       groupedCrews[crew.department]?.add(crew);
//     });
//
//     return ListView.builder(
//       itemCount: groupedCrews.length,
//       itemBuilder: (context, groupIndex) {
//         String department = groupedCrews.keys.elementAt(groupIndex);
//         List<Crew> departmentCrews = groupedCrews[department]!;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//               child: Text(
//                 department,
//                 style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//             ),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(),
//               itemCount: departmentCrews.length,
//               itemBuilder: (context, index) {
//                 Crew crew = departmentCrews[index];
//                 return SizedBox(
//                   height: 180,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     child: Card(
//                       clipBehavior: Clip.hardEdge,
//                       child: ListTile(
//                         minVerticalPadding: 0,
//                         contentPadding: EdgeInsets.zero,
//                         title: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             crew.profilePath != null
//                                 ? Image.network(ApiClient.getImageByUrl(crew.profilePath!))
//                                 : Image.asset(AppImages.noProfile),
//                             const SizedBox(width: 14,),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 6,),
//                                   Text(crew.name ?? "",
//                                     softWrap: true,
//                                     maxLines: 3,
//                                     style: const TextStyle(
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(crew.job,
//                                     softWrap: true,
//                                     maxLines: 3,
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6,),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
