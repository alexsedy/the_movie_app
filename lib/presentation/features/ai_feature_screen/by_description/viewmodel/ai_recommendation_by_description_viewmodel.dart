import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/navigator_param_const.dart';
import 'package:the_movie_app/data/datasources/local/cache_management/account_management.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class AiRecommendationByDescriptionViewModel extends ChangeNotifier {
  Future<void> onGenerateContent(BuildContext context, String description, int count) async {
    if (description.trim().isEmpty) return;

    String prompt = await _buildPrompt(description, count);

    Navigator.pushNamed(
        context,
        MainNavigationRouteNames.aiRecommendationList,
        arguments: {
          NavParamConst.prompt: prompt,
          NavParamConst.isMovie: true,
          NavParamConst.isGenre: false,
        }
    );
  }

  Future<String> _buildPrompt(String description, int count) async {
    String prompt;
    Locale? locale = await AccountManager.getUserLocale();
    String langCode = locale?.languageCode ?? 'en';

    // TODO: Локализовать шаблоны промптов
    final promptTemplate = {
      'en': '''
            Analyze the description "$description" and provide exactly $count titles matching it.
            If the description specifies content type (movies/animated movies/anime movies/TV shows/animated series/anime series) - provide only that type.
            If no specific type is mentioned - provide mixed content of any type.
            Format requirements: - Return ONLY titles separated by semicolons (Title1; Title2; Title3) - Include both modern (last 20 years) and classic works - Mix different decades for variety
            Content types allowed: - Movies (complete, self-contained films) - Animated movies (complete animated films) - Anime movies (complete anime films) - TV series (multi-episode shows) - Animated series (multi-episode animated shows) - Anime series (multi-episode anime)
            Important: Output ONLY titles in format: Title1; Title2; Title3
         ''',
      'uk': '''
            Проаналізуйте опис "$description" та надайте рівно $count відповідних назв.
            Якщо в описі вказано конкретний тип контенту (фільми/мультфільми/повнометражне аніме/серіали/мультсеріали/аніме-серіали) - видавайте тільки його.
            Якщо конкретний тип не вказаний - надайте змішаний контент будь-яких типів.
            Вимоги до формату: - Поверніть ТІЛЬКИ назви, розділені крапкою з комою (Назва1; Назва2; Назва3) - Включіть сучасні (останні 20 років) та класичні роботи - Змішуйте твори з різних десятиліть
            Допустимі типи контенту: - Фільми (повнометражні кінофільми) - Мультфільми (повнометражні анімаційні фільми) - Аніме (повнометражні аніме-фільми) - Серіали (багатосерійні шоу) - Мультсеріали (багатосерійні анімаційні шоу) - Аніме-серіали (багатосерійні аніме)
            Важливо: Виводьте ТІЛЬКИ назви у форматі: Назва1; Назва2; Назва3
         ''',
      'ru': '''
            Проанализируйте описание "$description" и предоставьте ровно $count подходящих названий.
            Если в описании указан конкретный тип контента (фильмы/мультфильмы/полнометражное аниме/сериалы/мультсериалы/аниме-сериалы) - выдавайте только его.
            Если конкретный тип не указан - предоставьте смешанный контент любых типов.
            Требования к формату: - Верните ТОЛЬКО названия, разделённые точкой с запятой (Название1; Название2; Название3) - Включите современные (последние 20 лет) и классические работы - Смешивайте произведения из разных десятилетий
            Допустимые типы контента: - Фильмы (полнометражные кинофильмы) - Мультфильмы (полнометражные анимационные фильмы) - Аниме (полнометражные аниме-фильмы) - Сериалы (многосерийные шоу) - Мультсериалы (многосерийные анимационные шоу) - Аниме-сериалы (многосерийные аниме)
            Важно: Выводите ТОЛЬКО названия в формате: Название1; Название2; Название3
         '''
    };
    prompt = promptTemplate[langCode] ?? promptTemplate['en']!;
    return prompt;
  }
}