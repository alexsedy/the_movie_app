// import 'package:flutter/material.dart';
// import 'package:the_movie_app/data/datasources/local/cache_management/account_management.dart';
// import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';
//
// class AiRecommendationByDescriptionModel extends ChangeNotifier {
//
//   Future<void> onGenerateContent(BuildContext context, String description, int count) async {
//     var prompt;
//     Locale? locale = await AccountManager.getUserLocale();
//     if(locale != null) {
//       switch(locale.languageCode){
//         case "en":
//           prompt = '''
//             Analyze the description "$description" and provide exactly $count titles matching it.
//             If the description specifies content type (movies/animated movies/anime movies/TV shows/animated series/anime series) - provide only that type.
//             If no specific type is mentioned - provide mixed content of any type.
//             Format requirements:
//             - Return ONLY titles separated by semicolons (Title1; Title2; Title3)
//             - Include both modern (last 20 years) and classic works
//             - Mix different decades for variety
//             Content types allowed:
//             - Movies (complete, self-contained films)
//             - Animated movies (complete animated films)
//             - Anime movies (complete anime films)
//             - TV series (multi-episode shows)
//             - Animated series (multi-episode animated shows)
//             - Anime series (multi-episode anime)
//             Important: Output ONLY titles in format: Title1; Title2; Title3
//           ''';
//         case "uk":
//           prompt = '''
//             Проаналізуйте опис "$description" та надайте рівно $count відповідних назв.
//             Якщо в описі вказано конкретний тип контенту (фільми/мультфільми/повнометражне аніме/серіали/мультсеріали/аніме-серіали) - видавайте тільки його.
//             Якщо конкретний тип не вказаний - надайте змішаний контент будь-яких типів.
//             Вимоги до формату:
//             - Поверніть ТІЛЬКИ назви, розділені крапкою з комою (Назва1; Назва2; Назва3)
//             - Включіть сучасні (останні 20 років) та класичні роботи
//             - Змішуйте твори з різних десятиліть
//             Допустимі типи контенту:
//             - Фільми (повнометражні кінофільми)
//             - Мультфільми (повнометражні анімаційні фільми)
//             - Аніме (повнометражні аніме-фільми)
//             - Серіали (багатосерійні шоу)
//             - Мультсеріали (багатосерійні анімаційні шоу)
//             - Аніме-серіали (багатосерійні аніме)
//             Важливо: Виводьте ТІЛЬКИ назви у форматі: Назва1; Назва2; Назва3
//           ''';
//         case "ru":
//           prompt = '''
//             Проанализируйте описание "$description" и предоставьте ровно $count подходящих названий.
//             Если в описании указан конкретный тип контента (фильмы/мультфильмы/полнометражное аниме/сериалы/мультсериалы/аниме-сериалы) - выдавайте только его.
//             Если конкретный тип не указан - предоставьте смешанный контент любых типов.
//             Требования к формату:
//             - Верните ТОЛЬКО названия, разделённые точкой с запятой (Название1; Название2; Название3)
//             - Включите современные (последние 20 лет) и классические работы
//             - Смешивайте произведения из разных десятилетий
//             Допустимые типы контента:
//             - Фильмы (полнометражные кинофильмы)
//             - Мультфильмы (полнометражные анимационные фильмы)
//             - Аниме (полнометражные аниме-фильмы)
//             - Сериалы (многосерийные шоу)
//             - Мультсериалы (многосерийные анимационные шоу)
//             - Аниме-сериалы (многосерийные аниме)
//             Важно: Выводите ТОЛЬКО названия в формате: Название1; Название2; Название3
//           ''';
//         default:
//           prompt = '''
//             Analyze the description "$description" and provide exactly $count titles matching it.
//             If the description specifies content type (movies/animated movies/anime movies/TV shows/animated series/anime series) - provide only that type.
//             If no specific type is mentioned - provide mixed content of any type.
//             Format requirements:
//             - Return ONLY titles separated by semicolons (Title1; Title2; Title3)
//             - Include both modern (last 20 years) and classic works
//             - Mix different decades for variety
//             Content types allowed:
//             - Movies (complete, self-contained films)
//             - Animated movies (complete animated films)
//             - Anime movies (complete anime films)
//             - TV series (multi-episode shows)
//             - Animated series (multi-episode animated shows)
//             - Anime series (multi-episode anime)
//             Important: Output ONLY titles in format: Title1; Title2; Title3
//           ''';
//       }
//     }
//
//     // Для фильмов:
//     // Предоставьте ровно $count названий фильмов (включая кинофильмы, мультфильмы или полнометражное аниме), соответствующих описанию: $description.
//     // Формат: Название1; Название2; Название3
//     // Правила:
//     // - Только названия, разделённые точкой с запятой
//     // - Без нумерации и пояснений
//     // - Только полнометражные фильмы (не сериалы)
//     // Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
//
// // Для сериалов:
// //     Предоставьте ровно $count названий сериалов (включая телесериалы, мультсериалы или аниме-сериалы), соответствующих описанию: $description.
// //     Формат: Название1; Название2; Название3
// //     Правила:
// //     - Только названия, разделённые точкой с запятой
// //     - Без нумерации и пояснений
// //     - Только многосерийные произведения (не отдельные фильмы)
// //     Важно: Ответ ТОЛЬКО названиями, ничего дополнительного.
//
//     // Для фільмів:
//     // Надайте рівно $count назв фільмів (включаючи кінофільми, мультфільми або повнометражне аніме), що відповідають опису: $description.
//     // Формат: Назва1; Назва2; Назва3
//     // Правила:
//     // - Тільки назви, розділені крапкою з комою
//     // - Без нумерації та пояснень
//     // - Тільки повнометражні фільми (не серіали)
//     // Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
//
// // Для серіалів:
// //     Надайте рівно $count назв серіалів (включаючи телесеріали, мультсеріали або аніме-серіали), що відповідають опису: $description.
// //     Формат: Назва1; Назва2; Назва3
// //     Правила:
// //     - Тільки назви, розділені крапкою з комою
// //     - Без нумерації та пояснень
// //     - Тільки багатосерійні твори (не окремі фільми)
// //     Важливо: Відповідь ТІЛЬКИ назвами, нічого додаткового.
//
//     // if (true) {
//     //   prompt = '''
//     //     Return exactly $count movie titles (including films, animated movies, or anime movies) that match this description: $description.
//     //     Format: Title1; Title2; Title3
//     //     Rules:
//     //     - Only titles, separated by semicolons
//     //     - No numbering or explanations
//     //     - Only complete, self-contained movies (not TV series)
//     //     Important: Respond ONLY with the titles, nothing else.
//     //   ''';
//     // } else {
//     //   prompt = '''
//     //     Return exactly $count TV series titles (including TV shows, animated series, or anime series) that match this description: $description.
//     //     Format: Title1; Title2; Title3
//     //     Rules:
//     //     - Only titles, separated by semicolons
//     //     - No numbering or explanations
//     //     - Only series with multiple episodes (not single movies)
//     //     Important: Respond ONLY with the titles, nothing else.
//     //   ''';
//
//     Navigator.pushNamed(
//         context,
//         MainNavigationRouteNames.aiRecommendationList,
//         arguments: {"prompt": prompt, "isMovie": true, "isGenre": false});
//   }
// }