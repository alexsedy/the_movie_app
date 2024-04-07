// import 'package:the_movie_app/models/media_details_model/common_media_details_model.dart';
//
// abstract class BaseTvDetailsModel implements CommonMediaDetailsModel {
//   MediaDetails? get tvShowDetails;
//   ItemState? get tvShowState;
//   List<Lists> get lists;
//   bool get isFavorite;
//   bool get isWatched;
//   bool get isRated;
//   double get rate;
//
//   set rate(value);
//
//   Future<void> loadTvShowDetails();
//
//   Future<void> toggleFavorite(BuildContext context);
//
//   Future<void> toggleWatchlist(BuildContext context);
//
//   Future<void> toggleAddRating(BuildContext context, double rate);
//
//   Future<void> toggleDeleteRating(BuildContext context);
//
//   // Future<void> getAllUserLists(BuildContext context);
//
//   Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public});
//
//   Future<void> addItemListToList({required BuildContext context, required int listId, required String name});
//
//   void onCastListTab(BuildContext context, List<Cast> cast);
//
//   void onCrewListTab(BuildContext context, List<Crew> crew);
//
//   void onPeopleDetailsTab(BuildContext context, int index);
//
//   Future<void> launchYouTubeVideo(String videoKey);
//
//   String formatDate(String? date);
//
//   String formatDateTwo(String? date);
// }