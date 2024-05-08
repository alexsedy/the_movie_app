import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/models/media_details_model/media_filter_mixin.dart';

class FilterMoviesButtonWidget extends StatelessWidget {
  final MediaFilterMixin model;
  const FilterMoviesButtonWidget({
    super.key, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            elevation: 0.2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.75,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _DateFilterWidget(model: model,),
                      const SizedBox(height: 20),
                      _GenresMoviesFilterWidget(model: model,),
                      const SizedBox(height: 20),
                      _UserScoreFilterWidget(model: model,),
                      const SizedBox(height: 20),
                      _SortByFilterWidget(model: model,),
                      const SizedBox(height: 20),
                      _AcceptedButtonsWidget(model: model,),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }
        );
      },
      icon: Icon(
        Icons.filter_list_alt,
        color: model.isFiltered() ? Colors.blueAccent : Colors.black,
      ),
    );
  }
}

class _DateFilterWidget extends StatefulWidget {
  final MediaFilterMixin model;
  const _DateFilterWidget({
    super.key, required this.model,
  });

  @override
  State<_DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<_DateFilterWidget> {
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;
  final _dateFormat = DateFormat.yMd();
  var _isShowError = false;

  String _formatDateFrom(DateTime? date) {
    if (date != null) {
      return _dateFormat.format(date);
    } else {
      return "From";
    }
  }

  String _formatDateTo(DateTime? date) {
    if (date != null) {
      return _dateFormat.format(date);
    } else {
      return "To";
    }
  }

  Future<void> _selectDateFrom(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateStart,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateStart) {
      if (_selectedDateEnd != null && picked.isAfter(_selectedDateEnd!)) {
        setState(() {
          _isShowError = true;
          _selectedDateStart = null;
          widget.model.selectedDateStart = null;
        });
      } else {
        setState(() {
          _isShowError = false;
          _selectedDateStart = picked;
          widget.model.selectedDateStart = _selectedDateStart;
        });
      }
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateEnd ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != _selectedDateEnd) {
      if (_selectedDateStart != null && picked.isBefore(_selectedDateStart!)) {
        setState(() {
          _isShowError = true;
          _selectedDateEnd = null;
          widget.model.selectedDateEnd = null;
        });
      } else {
        setState(() {
          _isShowError = false;
          _selectedDateEnd = picked;
          widget.model.selectedDateEnd = _selectedDateEnd;
        });
      }
    }
  }

  // Future<void> _selectDateTo(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDateTo ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2099),
  //   );
  //   if (picked != null && picked != _selectedDateTo) {
  //     setState(() {
  //       _selectedDateTo = picked;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    _selectedDateStart = widget.model.selectedDateStart;
    _selectedDateEnd = widget.model.selectedDateEnd;

    return Column(
      children: [
        const Text(
          "Release Dates",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        if(_isShowError)
          const Text("Please enter correct date", style: TextStyle(color: Colors.red)),
        const SizedBox(height: 6,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _selectDateFrom(context),
              child: Text(_formatDateFrom(_selectedDateStart)),
            ),
            ElevatedButton(
              onPressed: () {
                _selectDateTo(context);
              },
              child: Text(_formatDateTo(_selectedDateEnd)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedDateStart = null;
                  _selectedDateEnd = null;
                  widget.model.selectedDateStart = null;
                  widget.model.selectedDateEnd = null;
                  _isShowError = false;
                });
              },
              child: const Text("Clear"),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenresMoviesFilterWidget extends StatefulWidget {
  final MediaFilterMixin model;
  const _GenresMoviesFilterWidget({
    super.key, required this.model,
  });

  @override
  State<_GenresMoviesFilterWidget> createState() => _GenresMoviesFilterWidgetState();
}

class _GenresMoviesFilterWidgetState extends State<_GenresMoviesFilterWidget> {
  // bool isEnabledAction = false;
  // bool isEnabledAdventure = false;
  // bool isEnabledAnimation = false;
  // bool isEnabledComedy = false;
  // bool isEnabledCrime = false;
  // bool isEnabledDocumentary = false;
  // bool isEnabledDrama = false;
  // bool isEnabledFamily = false;
  // bool isEnabledFantasy = false;
  // bool isEnabledHistory = false;
  // bool isEnabledHorror = false;
  // bool isEnabledMusic = false;
  // bool isEnabledMystery = false;
  // bool isEnabledRomance = false;
  // bool isEnabledScienceFiction = false;
  // bool isEnabledTVMovie = false;
  // bool isEnabledThriller = false;
  // bool isEnabledWar = false;
  // bool isEnabledWestern = false;
  //
  // var onPressedItems = <String, bool>{
  //   "28": false,      //Action = 28
  //   "12": false,      //Adventure = 12
  //   "16": false,      //Animation = 16
  //   "35": false,      //Comedy = 35
  //   "80": false,      //Crime = 80
  //   "99": false,      //Documentary = 99
  //   "18": false,      //Drama = 18
  //   "10751": false,   //Family = 10751
  //   "14": false,      //Fantasy = 14
  //   "36": false,      //History = 36
  //   "27": false,      //Horror = 27
  //   "10402": false,   //Music = 10402
  //   "9648": false,    //Mystery = 9648
  //   "10749": false,   //Romance = 10749
  //   "878": false,     //Science Fiction = 878
  //   "10770": false,   //TV Movie = 10770
  //   "53": false,      //Thriller = 53
  //   "10752": false,   //War = 10752
  //   "37": false       //Western = 37
  // };

  final action = <String, Map<String, bool>>{
    "28": {'Action': false},
    "12": {'Adventure': false},
    "16": {'Animation': false},
    "35": {'Comedy': false},
    "80": {'Crime': false},
    "99": {'Documentary': false},
    "18": {'Drama': false},
    "10751": {'Family': false},
    "14": {'Fantasy': false},
    "36": {'History': false},
    "27": {'Horror': false},
    "10402": {'Music': false},
    "9648": {'Mystery': false},
    "10749": {'Romance': false},
    "878": {'Science Fiction': false},
    "10770": {'TV Movie': false},
    "53": {'Thriller': false},
    "10752": {'War': false},
    "37": {'Western': false},
  };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: action.entries.map((entry) {
        return ActionChip(
          label: Text(entry.value.entries.first.key),
          backgroundColor: entry.value.entries.first.value ? Colors.blueAccent : Colors.transparent,
          onPressed: () {
            setState(() {
              final newValue = !entry.value.entries.first.value;
              entry.value.update(entry.value.entries.first.key, (value) => newValue);
            });
          },
        );
      }).toList(),
    );
  }
}

class _UserScoreFilterWidget extends StatefulWidget {
  final MediaFilterMixin model;
  const _UserScoreFilterWidget({super.key, required this.model});

  @override
  State<_UserScoreFilterWidget> createState() => _UserScoreFilterWidgetState();
}

class _UserScoreFilterWidgetState extends State<_UserScoreFilterWidget> {
  @override
  Widget build(BuildContext context) {
    var rangeValues = RangeValues(widget.model.scoreStart, widget.model.scoreEnd);

    return Column(
      children: [
        const Text(
          "User score",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        RangeSlider(
          labels: RangeLabels(
              rangeValues.start.round().toString(),
              rangeValues.end.round().toString()
          ),
          divisions: 10,
          values: rangeValues,
          min: 0,
          max: 10,
          onChanged: (RangeValues values) {
            setState(() {
              widget.model.scoreStart = values.start;
              widget.model.scoreEnd = values.end;
            });
          },
        ),
      ],
    );
  }
}

class _SortByFilterWidget extends StatefulWidget {
  final MediaFilterMixin model;
  const _SortByFilterWidget({super.key, required this.model});

  @override
  State<_SortByFilterWidget> createState() => _SortByFilterWidgetState();
}

class _SortByFilterWidgetState extends State<_SortByFilterWidget> {
   @override
   @override
   Widget build(BuildContext context) {
     final sortingDropdownItems = widget.model.sortingDropdownItems.entries.toList();

     return DropdownButton<String>(
       value: widget.model.sortingValue,
       items: sortingDropdownItems.map((MapEntry<String, String> entry) {
         return DropdownMenuItem<String>(
           value: entry.key,
           child: Text(entry.value),
         );
       }).toList(),
       onChanged: (String? value) {
         setState(() {
           widget.model.sortingValue = value;
         });
       },
     );
   }
}

class _AcceptedButtonsWidget extends StatelessWidget {
  final MediaFilterMixin model;
  const _AcceptedButtonsWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            model.clearAllFilters();
            Navigator.pop(context);
          },
          child: const Text("Clear all"),
        ),
        ElevatedButton(
          onPressed: () {
            model.filterMovie();
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}

