abstract class IMediaFilter {
  DateTime? get selectedDateStart;
  DateTime? get selectedDateEnd ;
  String? get genres;
  double get scoreStart;
  double get scoreEnd;
  String? get sortingValue;
  Map<String, String> get sortingDropdownItems;
  Map<String, Map<String, bool>> get genreActions;

  set selectedDateStart(value);
  set selectedDateEnd(value);
  set genres(value);
  set scoreStart(value);
  set scoreEnd(value);
  set sortingValue(value);

  Future<void> loadContent();

  bool isFiltered();

  void clearAllFilters();

  void applyFilter();
}