import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/models/interfaces/i_media_filter_model.dart';

class FilterMoviesButtonWidget extends StatefulWidget {
  final IMediaFilter model;
  const FilterMoviesButtonWidget({
    super.key, required this.model,
  });

  @override
  State<FilterMoviesButtonWidget> createState() => _FilterMoviesButtonWidgetState();
}

class _FilterMoviesButtonWidgetState extends State<FilterMoviesButtonWidget> {
  final GlobalKey<_GenresMoviesFilterWidgetState> _genreKey = GlobalKey<_GenresMoviesFilterWidgetState>();
  final GlobalKey<_UserScoreFilterWidgetState> _userScoreKey = GlobalKey<_UserScoreFilterWidgetState>();
  final GlobalKey<_SortByFilterWidgetState> _sortByKey = GlobalKey<_SortByFilterWidgetState>();
  final GlobalKey<_DateFilterWidgetState> _dateKey = GlobalKey<_DateFilterWidgetState>();
  
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        _DateFilterWidget(model: widget.model, key: _dateKey,),
                        const SizedBox(height: 20),
                        _GenresMoviesFilterWidget(model: widget.model, key: _genreKey,),
                        const SizedBox(height: 20),
                        _UserScoreFilterWidget(model: widget.model, key: _userScoreKey,),
                        const SizedBox(height: 20),
                        _SortByFilterWidget(model: widget.model, key: _sortByKey,),
                        const SizedBox(height: 20),
                        _AcceptedButtonsWidget(
                          model: widget.model,
                          genreKey: _genreKey,
                          sortByKey: _sortByKey,
                          userScoreKey: _userScoreKey,
                          dateKey: _dateKey,
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            }
        );
      },
      icon: Icon(
        Icons.filter_list_alt,
        color: widget.model.isFiltered() ? Colors.blueAccent : Colors.black,
      ),
    );
  }
}

class _DateFilterWidget extends StatefulWidget {
  final IMediaFilter model;
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

  void _refresh() {
    setState(() {
    });
  }

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
  final IMediaFilter model;
  const _GenresMoviesFilterWidget({
    super.key, required this.model,
  });

  @override
  State<_GenresMoviesFilterWidget> createState() => _GenresMoviesFilterWidgetState();
}

class _GenresMoviesFilterWidgetState extends State<_GenresMoviesFilterWidget> {
  void _refresh() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final genreActions = widget.model.genreActions;

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: genreActions.entries.map((entry) {
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
  final IMediaFilter model;
  const _UserScoreFilterWidget({super.key, required this.model});

  @override
  State<_UserScoreFilterWidget> createState() => _UserScoreFilterWidgetState();
}

class _UserScoreFilterWidgetState extends State<_UserScoreFilterWidget> {
  void _refresh() {
    setState(() {
    });
  }

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
  final IMediaFilter model;
  const _SortByFilterWidget({super.key, required this.model});

  @override
  State<_SortByFilterWidget> createState() => _SortByFilterWidgetState();
}

class _SortByFilterWidgetState extends State<_SortByFilterWidget> {
  void _refresh() {
    setState(() {
    });
  }

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
  final IMediaFilter model;
  final GlobalKey<_GenresMoviesFilterWidgetState> genreKey;
  final GlobalKey<_UserScoreFilterWidgetState> userScoreKey;
  final GlobalKey<_SortByFilterWidgetState> sortByKey;
  final GlobalKey<_DateFilterWidgetState> dateKey;

  const _AcceptedButtonsWidget({super.key, required this.model,
    required this.genreKey, required this.userScoreKey,
    required this.sortByKey, required this.dateKey,});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: const Text("Cancel"),
        // ),
        ElevatedButton(
          onPressed: () {
            model.loadFiltered();
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
        ElevatedButton(
          onPressed: () {
            model.clearAllFilters();
            genreKey.currentState?._refresh();
            userScoreKey.currentState?._refresh();
            sortByKey.currentState?._refresh();
            dateKey.currentState?._refresh();
          },
          child: const Text("Clear all"),
        ),
      ],
    );
  }
}