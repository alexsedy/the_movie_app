// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ua locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ua';

  static String m0(count) =>
      "${Intl.plural(count, one: '(${count} епізод)', other: '(${count} епізодів)')}";

  static String m1(username) => "Створено користувачем ${username}.";

  static String m2(name) => "Видалити список \"${name}\"?";

  static String m3(seriesCount, date) => "Серій: ${seriesCount} • ${date}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'Жіноча', two: 'Чоловіча', other: 'Не вказано')}";

  static String m5(numberOfItems) => "Елементи: ${numberOfItems}";

  static String m6(itemCount) => "Елементи: ${itemCount}.";

  static String m7(count) =>
      "${Intl.plural(count, one: 'Відома за:', two: 'Відомий за:', other: 'Відомий(а) за:')}";

  static String m8(message) => "Список \"${message}\" створено.";

  static String m9(message) => "Цей фільм додано до списку \"${message}\"";

  static String m10(name) => "Цей фільм вже є у списку \"${name}\".";

  static String m11(message) => "Цей серіал додано до списку \"${message}\"";

  static String m12(name) => "Цей серіал вже є у списку \"${name}\".";

  static String m13(name) => "Оновити список \"${name}\"";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addToTheList":
            MessageLookupByLibrary.simpleMessage("Додати до списку"),
        "aiRecommendation":
            MessageLookupByLibrary.simpleMessage("AI Рекомендації"),
        "aiRecommendationList":
            MessageLookupByLibrary.simpleMessage("Список AI рекомендацій"),
        "anErrorHasOccurredTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "Виникла помилка. Будь ласка, спробуйте пізніше."),
        "biography": MessageLookupByLibrary.simpleMessage("Біографія"),
        "cancel": MessageLookupByLibrary.simpleMessage("Скасувати"),
        "cast": MessageLookupByLibrary.simpleMessage("Акторський склад"),
        "clear": MessageLookupByLibrary.simpleMessage("Очистити"),
        "clearAll": MessageLookupByLibrary.simpleMessage("Очистити все"),
        "close": MessageLookupByLibrary.simpleMessage("Закрити"),
        "collections": MessageLookupByLibrary.simpleMessage("Колекції"),
        "confirmLeaveMessage":
            MessageLookupByLibrary.simpleMessage("Ви дійсно бажаєте вийти?"),
        "countEpisode": m0,
        "create": MessageLookupByLibrary.simpleMessage("Створити"),
        "createANewList":
            MessageLookupByLibrary.simpleMessage("Створити новий список"),
        "createdByUsername": m1,
        "crew": MessageLookupByLibrary.simpleMessage("Знімальна група"),
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("Дата народження:"),
        "dateOfDeath": MessageLookupByLibrary.simpleMessage("Дата смерті:"),
        "day": MessageLookupByLibrary.simpleMessage("День"),
        "delete": MessageLookupByLibrary.simpleMessage("Видалити"),
        "deleteSelectedItems":
            MessageLookupByLibrary.simpleMessage("Видалити вибрані елементи?"),
        "deleteTheNameList": m2,
        "description": MessageLookupByLibrary.simpleMessage("Опис"),
        "discoverGeminiAiMessage": MessageLookupByLibrary.simpleMessage(
            "Відкрийте можливості з Gemini AI"),
        "edit": MessageLookupByLibrary.simpleMessage("Редагувати"),
        "episode": MessageLookupByLibrary.simpleMessage("Епізод"),
        "episodesSeriesCountDate": m3,
        "favorite": MessageLookupByLibrary.simpleMessage("Улюблене"),
        "findAnythingWelcome":
            MessageLookupByLibrary.simpleMessage("Знайдіть що завгодно"),
        "gender": MessageLookupByLibrary.simpleMessage("Стать:"),
        "genderType": m4,
        "generate": MessageLookupByLibrary.simpleMessage("Згенерувати"),
        "generateListByDescription": MessageLookupByLibrary.simpleMessage(
            "Згенерувати список за описом"),
        "generateListByGenres": MessageLookupByLibrary.simpleMessage(
            "Згенерувати список за жанрами"),
        "guest": MessageLookupByLibrary.simpleMessage("Гість"),
        "hello": MessageLookupByLibrary.simpleMessage("Привіт,"),
        "home": MessageLookupByLibrary.simpleMessage("Головна"),
        "imageGallery":
            MessageLookupByLibrary.simpleMessage("Галерея зображень"),
        "itemNumberOfItems": m5,
        "itemsCount": m6,
        "knownFor": m7,
        "list": MessageLookupByLibrary.simpleMessage("Список"),
        "listCreatedMessage": m8,
        "listViewWithSelection":
            MessageLookupByLibrary.simpleMessage("Список із вибором"),
        "login": MessageLookupByLibrary.simpleMessage("Увійти"),
        "logout": MessageLookupByLibrary.simpleMessage("Вийти"),
        "min": MessageLookupByLibrary.simpleMessage("хв"),
        "movieAddedToListMessage": m9,
        "movieCast":
            MessageLookupByLibrary.simpleMessage("Акторський склад фільму"),
        "movieCrew":
            MessageLookupByLibrary.simpleMessage("Знімальна група фільму"),
        "movieExistsInListMessage": m10,
        "movies": MessageLookupByLibrary.simpleMessage("Фільми"),
        "name": MessageLookupByLibrary.simpleMessage("Назва"),
        "networks": MessageLookupByLibrary.simpleMessage("Канали"),
        "newList": MessageLookupByLibrary.simpleMessage("Новий список"),
        "noData": MessageLookupByLibrary.simpleMessage("Немає даних"),
        "noLoginAccountMessage": MessageLookupByLibrary.simpleMessage(
            "Списки недоступні. Будь ласка, увійдіть в систему."),
        "noOtherMovieProjects":
            MessageLookupByLibrary.simpleMessage("Інших фільмів немає"),
        "noOtherTvShowProjects":
            MessageLookupByLibrary.simpleMessage("Інших серіалів немає"),
        "noResults": MessageLookupByLibrary.simpleMessage("Немає результатів."),
        "noTrailer": MessageLookupByLibrary.simpleMessage("Трейлера немає"),
        "ok": MessageLookupByLibrary.simpleMessage("Ок"),
        "otherProjects": MessageLookupByLibrary.simpleMessage("Інші проєкти"),
        "overview": MessageLookupByLibrary.simpleMessage("Огляд"),
        "persons": MessageLookupByLibrary.simpleMessage("Знаменитості"),
        "placeOfBirth":
            MessageLookupByLibrary.simpleMessage("Місце народження:"),
        "playTrailer":
            MessageLookupByLibrary.simpleMessage("Переглянути трейлер"),
        "pleaseEnterCorrectDate": MessageLookupByLibrary.simpleMessage(
            "Будь ласка, введіть правильну дату"),
        "productionCompanies":
            MessageLookupByLibrary.simpleMessage("Продюсерські компанії"),
        "profile": MessageLookupByLibrary.simpleMessage("Профіль"),
        "public": MessageLookupByLibrary.simpleMessage("Публічний"),
        "rate": MessageLookupByLibrary.simpleMessage("Оцінити"),
        "rateMovie": MessageLookupByLibrary.simpleMessage("Оцінити фільм"),
        "rated": MessageLookupByLibrary.simpleMessage("Оцінені"),
        "recommendation": MessageLookupByLibrary.simpleMessage("Рекомендації"),
        "recommendationMovies":
            MessageLookupByLibrary.simpleMessage("Рекомендовані фільми"),
        "recommendationTvShows":
            MessageLookupByLibrary.simpleMessage("Рекомендовані серіали"),
        "releaseDates": MessageLookupByLibrary.simpleMessage("Дати виходу"),
        "search": MessageLookupByLibrary.simpleMessage("Пошук"),
        "searchGlobalSearchHint": MessageLookupByLibrary.simpleMessage(
            "Пошук фільмів, серіалів, знаменитостей"),
        "seasons": MessageLookupByLibrary.simpleMessage("Сезони"),
        "selectMaxNumberOfItems": MessageLookupByLibrary.simpleMessage(
            "Виберіть максимальну кількість елементів"),
        "selectMovieOrTv": MessageLookupByLibrary.simpleMessage(
            "Виберіть: Фільми або Феріали"),
        "selectOneOrMoreGenres": MessageLookupByLibrary.simpleMessage(
            "Виберіть один або кілька жанрів"),
        "seriesCast":
            MessageLookupByLibrary.simpleMessage("Акторський склад серії"),
        "seriesCrew":
            MessageLookupByLibrary.simpleMessage("Знімальна група серії"),
        "seriesGuestStars":
            MessageLookupByLibrary.simpleMessage("Запрошені зірки"),
        "socialNetwork":
            MessageLookupByLibrary.simpleMessage("Соціальні мережі"),
        "theListIsEmpty":
            MessageLookupByLibrary.simpleMessage("Список порожній."),
        "theListRemovedMessage":
            MessageLookupByLibrary.simpleMessage("Список видалено"),
        "theRatingWasDeletedSuccessfully":
            MessageLookupByLibrary.simpleMessage("Оцінку успішно видалено."),
        "trailers": MessageLookupByLibrary.simpleMessage("Трейлери"),
        "trendingMovies":
            MessageLookupByLibrary.simpleMessage("Популярні фільми"),
        "trendingPersons":
            MessageLookupByLibrary.simpleMessage("Популярні знаменитості"),
        "trendingTvs":
            MessageLookupByLibrary.simpleMessage("Популярні серіали"),
        "tvAddedToListMessage": m11,
        "tvExistsInListMessage": m12,
        "tvShowCast":
            MessageLookupByLibrary.simpleMessage("Акторський склад серіалу"),
        "tvShowCrew":
            MessageLookupByLibrary.simpleMessage("Знімальна група серіалу"),
        "tvShows": MessageLookupByLibrary.simpleMessage("Серіали"),
        "unknown": MessageLookupByLibrary.simpleMessage("Невідомо"),
        "unknownErrorPleaseTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "Невідома помилка. Будь ласка, спробуйте пізніше."),
        "update": MessageLookupByLibrary.simpleMessage("Оновити"),
        "updateTheNameList": m13,
        "userLists": MessageLookupByLibrary.simpleMessage("Списки користувача"),
        "userScore": MessageLookupByLibrary.simpleMessage("Оцінка"),
        "watch": MessageLookupByLibrary.simpleMessage("Спостерігати"),
        "watchlist":
            MessageLookupByLibrary.simpleMessage("Список для перегляду"),
        "week": MessageLookupByLibrary.simpleMessage("Тиждень"),
        "writeADescriptionAiMessage": MessageLookupByLibrary.simpleMessage(
            "Напишіть максимально детальний опис"),
        "yes": MessageLookupByLibrary.simpleMessage("Так"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Ви не авторизовані.")
      };
}
