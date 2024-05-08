mixin MediaFilterMixin{
  DateTime? get selectedDateStart;
  DateTime? get selectedDateEnd ;
  String? get genres;
  double get scoreStart;
  double get scoreEnd;
  String? get sortingValue;
  Map<String, String> get sortingDropdownItems;

  set selectedDateStart(value);
  set selectedDateEnd(value);
  set genres(value);
  set scoreStart(value);
  set scoreEnd(value);
  set sortingValue(value);

  Future<void> filterMovie();

  bool isFiltered();

  void clearAllFilters();
}