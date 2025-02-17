// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(count) =>
      "${Intl.plural(count, one: '(${count} эпизод)', other: '(${count} эпизодов)')}";

  static String m1(username) => "Создано пользователем ${username}.";

  static String m2(name) => "Удалить список \"${name}\"?";

  static String m3(seriesCount, date) => "Эпизодов: ${seriesCount} • ${date}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'Женский', two: 'Мужской', other: 'Не указан')}";

  static String m5(numberOfItems) => "Элементы: ${numberOfItems}";

  static String m6(itemCount) => "Элементы: ${itemCount}.";

  static String m7(count) =>
      "${Intl.plural(count, one: 'Известена по:', two: 'Известен по:', other: 'Известен(а) по:')}";

  static String m8(message) => "Список \"${message}\" создан.";

  static String m9(status) => "${Intl.select(status, {
            'status_0': 'Нет статуса',
            'status_1': 'Посмотрел',
            'status_2': 'Смотрю',
            'status_3': 'Буду смотреть',
            'status_4': 'Перестал',
            'status_5': 'Не буду смотреть',
          })}";

  static String m10(message) => "Этот фильм добавлен в список \"${message}\"";

  static String m11(name) => "Этот фильм уже есть в списке \"${name}\".";

  static String m12(message) => "Этот сериал добавлен в список \"${message}\"";

  static String m13(name) => "Этот сериал уже есть в списке \"${name}\".";

  static String m14(name) => "Обновить список \"${name}\"";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addToTheList":
            MessageLookupByLibrary.simpleMessage("Добавить в список"),
        "aiRecommendation":
            MessageLookupByLibrary.simpleMessage("AI Рекомендации"),
        "aiRecommendationList":
            MessageLookupByLibrary.simpleMessage("Список AI рекомендаций"),
        "anErrorHasOccurredTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "Произошла ошибка. Пожалуйста, попробуйте позже."),
        "biography": MessageLookupByLibrary.simpleMessage("Биография"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "cast": MessageLookupByLibrary.simpleMessage("Актерский состав"),
        "clear": MessageLookupByLibrary.simpleMessage("Очистить"),
        "clearAll": MessageLookupByLibrary.simpleMessage("Очистить все"),
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "collections": MessageLookupByLibrary.simpleMessage("Коллекции"),
        "confirmLeaveMessage": MessageLookupByLibrary.simpleMessage(
            "Вы действительно хотите выйти?"),
        "countEpisode": m0,
        "create": MessageLookupByLibrary.simpleMessage("Создать"),
        "createANewList":
            MessageLookupByLibrary.simpleMessage("Создать новый список"),
        "createdByUsername": m1,
        "crew": MessageLookupByLibrary.simpleMessage("Съемочная группа"),
        "dateOfBirth": MessageLookupByLibrary.simpleMessage("Дата рождения:"),
        "dateOfDeath": MessageLookupByLibrary.simpleMessage("Дата смерти:"),
        "day": MessageLookupByLibrary.simpleMessage("День"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteSelectedItems":
            MessageLookupByLibrary.simpleMessage("Удалить выбранные элементы?"),
        "deleteTheNameList": m2,
        "description": MessageLookupByLibrary.simpleMessage("Описание"),
        "discoverGeminiAiMessage": MessageLookupByLibrary.simpleMessage(
            "Откройте возможности с Gemini AI"),
        "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
        "episode": MessageLookupByLibrary.simpleMessage("Эпизод"),
        "episodesSeriesCountDate": m3,
        "favorite": MessageLookupByLibrary.simpleMessage("Избранное"),
        "findAnythingWelcome":
            MessageLookupByLibrary.simpleMessage("Находите все"),
        "gender": MessageLookupByLibrary.simpleMessage("Пол:"),
        "genderType": m4,
        "generate": MessageLookupByLibrary.simpleMessage("Сгенерировать"),
        "generateListByDescription": MessageLookupByLibrary.simpleMessage(
            "Сгенерировать список по описанию"),
        "generateListByGenres": MessageLookupByLibrary.simpleMessage(
            "Сгенерировать список по жанрам"),
        "guest": MessageLookupByLibrary.simpleMessage("Гость"),
        "hello": MessageLookupByLibrary.simpleMessage("Привет,"),
        "home": MessageLookupByLibrary.simpleMessage("Главная"),
        "imageGallery":
            MessageLookupByLibrary.simpleMessage("Галерея изображений"),
        "itemNumberOfItems": m5,
        "itemsCount": m6,
        "knownFor": m7,
        "list": MessageLookupByLibrary.simpleMessage("Список"),
        "listCreatedMessage": m8,
        "listViewWithSelection":
            MessageLookupByLibrary.simpleMessage("Список с выбором"),
        "login": MessageLookupByLibrary.simpleMessage("Войти"),
        "logout": MessageLookupByLibrary.simpleMessage("Выйти"),
        "mediaStatus": m9,
        "min": MessageLookupByLibrary.simpleMessage("мин"),
        "movieAddedToListMessage": m10,
        "movieCast":
            MessageLookupByLibrary.simpleMessage("Актерский состав фильма"),
        "movieCrew":
            MessageLookupByLibrary.simpleMessage("Съемочная группа фильма"),
        "movieExistsInListMessage": m11,
        "movies": MessageLookupByLibrary.simpleMessage("Фильмы"),
        "name": MessageLookupByLibrary.simpleMessage("Название"),
        "networks": MessageLookupByLibrary.simpleMessage("Телесети"),
        "newList": MessageLookupByLibrary.simpleMessage("Новый список"),
        "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
        "noLoginAccountMessage": MessageLookupByLibrary.simpleMessage(
            "Списки недоступны. Пожалуйста, войдите в систему."),
        "noOtherMovieProjects":
            MessageLookupByLibrary.simpleMessage("Других фильмов нет"),
        "noOtherTvShowProjects":
            MessageLookupByLibrary.simpleMessage("Других сериалов нет"),
        "noResults": MessageLookupByLibrary.simpleMessage("Нет результатов."),
        "noTrailer": MessageLookupByLibrary.simpleMessage("Нет трейлера"),
        "ok": MessageLookupByLibrary.simpleMessage("Ок"),
        "otherProjects": MessageLookupByLibrary.simpleMessage("Другие проекты"),
        "overview": MessageLookupByLibrary.simpleMessage("Обзор"),
        "persons": MessageLookupByLibrary.simpleMessage("Знаменитости"),
        "placeOfBirth": MessageLookupByLibrary.simpleMessage("Место рождения:"),
        "playTrailer":
            MessageLookupByLibrary.simpleMessage("Воспроизвести трейлер"),
        "pleaseEnterCorrectDate": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите корректную дату"),
        "productionCompanies":
            MessageLookupByLibrary.simpleMessage("Продакшн-компании"),
        "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
        "public": MessageLookupByLibrary.simpleMessage("Публичный"),
        "rate": MessageLookupByLibrary.simpleMessage("Оценить"),
        "rateMovie": MessageLookupByLibrary.simpleMessage("Оценить фильм"),
        "rated": MessageLookupByLibrary.simpleMessage("Оцененные"),
        "recommendation": MessageLookupByLibrary.simpleMessage("Рекомендации"),
        "recommendationMovies":
            MessageLookupByLibrary.simpleMessage("Рекомендованные фильмы"),
        "recommendationTvShows":
            MessageLookupByLibrary.simpleMessage("Рекомендованные сериалы"),
        "releaseDates": MessageLookupByLibrary.simpleMessage("Даты выхода"),
        "search": MessageLookupByLibrary.simpleMessage("Поиск"),
        "searchGlobalSearchHint": MessageLookupByLibrary.simpleMessage(
            "Поиск фильмов, сериалов, знаменитостей"),
        "seasons": MessageLookupByLibrary.simpleMessage("Сезоны"),
        "selectMaxNumberOfItems": MessageLookupByLibrary.simpleMessage(
            "Выберите максимальное количество элементов"),
        "selectMovieOrTv": MessageLookupByLibrary.simpleMessage(
            "Выберите: фильмы или сериалы"),
        "selectOneOrMoreGenres": MessageLookupByLibrary.simpleMessage(
            "Выберите один или несколько жанров"),
        "seriesCast":
            MessageLookupByLibrary.simpleMessage("Актерский состав серии"),
        "seriesCrew":
            MessageLookupByLibrary.simpleMessage("Съемочная группа серии"),
        "seriesGuestStars":
            MessageLookupByLibrary.simpleMessage("Приглашенные звезды"),
        "socialNetwork":
            MessageLookupByLibrary.simpleMessage("Социальные сети"),
        "theListIsEmpty": MessageLookupByLibrary.simpleMessage("Список пуст."),
        "theListRemovedMessage":
            MessageLookupByLibrary.simpleMessage("Список удален"),
        "theRatingWasDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
            "Оценка была успешно удалена."),
        "trailers": MessageLookupByLibrary.simpleMessage("Трейлеры"),
        "trendingMovies":
            MessageLookupByLibrary.simpleMessage("Популярные фильмы"),
        "trendingPersons":
            MessageLookupByLibrary.simpleMessage("Популярные знаменитости"),
        "trendingTvs":
            MessageLookupByLibrary.simpleMessage("Популярные сериалы"),
        "tvAddedToListMessage": m12,
        "tvExistsInListMessage": m13,
        "tvShowCast":
            MessageLookupByLibrary.simpleMessage("Актерский состав сериала"),
        "tvShowCrew":
            MessageLookupByLibrary.simpleMessage("Съемочная группа сериала"),
        "tvShows": MessageLookupByLibrary.simpleMessage("Сериалы"),
        "unknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
        "unknownErrorPleaseTryAgainLater": MessageLookupByLibrary.simpleMessage(
            "Неизвестная ошибка. Пожалуйста, попробуйте позже."),
        "update": MessageLookupByLibrary.simpleMessage("Обновить"),
        "updateTheNameList": m14,
        "userLists":
            MessageLookupByLibrary.simpleMessage("Списки пользователя"),
        "userScore": MessageLookupByLibrary.simpleMessage("Оценка"),
        "watch": MessageLookupByLibrary.simpleMessage("Наблюдать"),
        "watchlist":
            MessageLookupByLibrary.simpleMessage("Список для просмотра"),
        "week": MessageLookupByLibrary.simpleMessage("Неделя"),
        "writeADescriptionAiMessage": MessageLookupByLibrary.simpleMessage(
            "Напишите максимально подробное описание"),
        "yes": MessageLookupByLibrary.simpleMessage("Да"),
        "youAreNotLoggedIn":
            MessageLookupByLibrary.simpleMessage("Вы не авторизованы.")
      };
}
