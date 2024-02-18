import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterMoviesButtonWidget extends StatelessWidget {
  const FilterMoviesButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Filter Movies'),
              content: const Expanded(
                child: SingleChildScrollView(
                  child: _FilterMoviesWidget(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.filter_list_alt),
    );
  }
}

class _FilterMoviesWidget extends StatefulWidget {
  const _FilterMoviesWidget({
    super.key,
  });

  @override
  State<_FilterMoviesWidget> createState() => _FilterMoviesWidgetState();
}

class _FilterMoviesWidgetState extends State<_FilterMoviesWidget> {
  var _rangeValues = const RangeValues(0, 10);
  String? _sortingValue = "Popularity Descending";
  DateTime? _selectedDateFrom;
  DateTime? _selectedDateTo;
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
      initialDate: _selectedDateFrom,
      firstDate: DateTime(2010),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDateFrom) {
      setState(() {
        _selectedDateFrom = picked;
      });
    }
  }

  Future<void> _selectDateTo(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTo ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2099),
    );
    if (picked != null && picked != _selectedDateTo) {
      if (_selectedDateFrom != null && picked.isBefore(_selectedDateFrom!)) {
        setState(() {
          _isShowError = true;
        });
      } else {
        setState(() {
          _isShowError = false;
          _selectedDateTo = picked;
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


  final dropdownItems = <String> [
    "Popularity Descending",
    "Popularity Ascending",
    "Rating Descending",
    "Rating Ascending",
    "Release Date Descending",
    "Release Date Ascending",
    "Title (A-Z)",
    "Title (Z-A)",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
          title: const Text("Filters"),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("Release Dates"),
                Column(
                  children: [
                    if(_isShowError)
                      Text("Plaease enter correct date", style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () => _selectDateFrom(context),
                      child: Text(_formatDateFrom(_selectedDateFrom)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDateTo(context);
                      },
                      child: Text(_formatDateTo(_selectedDateTo)),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            _GenresMoviesFilterWidget(),
            Column(
              children: [
                const SizedBox(height: 10),
                const Text("User score"),
                RangeSlider(
                  labels: RangeLabels(
                      _rangeValues.start.round().toString(),
                      _rangeValues.end.round().toString()
                  ),
                  divisions: 10,
                  values: _rangeValues,
                  min: 0,
                  max: 10,
                  onChanged: (RangeValues values) {
                    setState(() {
                      _rangeValues = values;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        DropdownButton<String>(
          value: _sortingValue,
          // hint: const Text("Soring"),
          items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _sortingValue = value;
            });
          },
        ),
      ],
    );
  }
}

class _GenresMoviesFilterWidget extends StatefulWidget {
  const _GenresMoviesFilterWidget({
    super.key,
  });

  @override
  State<_GenresMoviesFilterWidget> createState() => _GenresMoviesFilterWidgetState();
}

class _GenresMoviesFilterWidgetState extends State<_GenresMoviesFilterWidget> {
  bool isEnabledAction = false;
  bool isEnabledAdventure = false;
  bool isEnabledAnimation = false;
  bool isEnabledComedy = false;
  bool isEnabledCrime = false;
  bool isEnabledDocumentary = false;
  bool isEnabledDrama = false;
  bool isEnabledFamily = false;
  bool isEnabledFantasy = false;
  bool isEnabledHistory = false;
  bool isEnabledHorror = false;
  bool isEnabledMusic = false;
  bool isEnabledMystery = false;
  bool isEnabledRomance = false;
  bool isEnabledScienceFiction = false;
  bool isEnabledTVMovie = false;
  bool isEnabledThriller = false;
  bool isEnabledWar = false;
  bool isEnabledWestern = false;

  var onPressedItems = <String, bool>{
    "28": false,      //Action = 28
    "12": false,      //Adventure = 12
    "16": false,      //Animation = 16
    "35": false,      //Comedy = 35
    "80": false,      //Crime = 80
    "99": false,      //Documentary = 99
    "18": false,      //Drama = 18
    "10751": false,   //Family = 10751
    "14": false,      //Fantasy = 14
    "36": false,      //History = 36
    "27": false,      //Horror = 27
    "10402": false,   //Music = 10402
    "9648": false,    //Mystery = 9648
    "10749": false,   //Romance = 10749
    "878": false,     //Science Fiction = 878
    "10770": false,   //TV Movie = 10770
    "53": false,      //Thriller = 53
    "10752": false,   //War = 10752
    "37": false       //Western = 37
  };

  // пример как получить лист с ID
  // List<String> listIdsByTrue = onPressedItems.entries
  //     .where((entry) => entry.value == true)
  //     .map((entry) => entry.key)
  //     .toList();

  // final chipItems = [
  //   ActionChip(label: Text("Action")),
  //   ActionChip(label: Text("Adventure")),
  //   ActionChip(label: Text("Animation")),
  //   ActionChip(label: Text("Comedy")),
  //   ActionChip(label: Text("Crime")),
  //   ActionChip(label: Text("Documentary")),
  //   ActionChip(label: Text("Family")),
  //   ActionChip(label: Text("Fantasy")),
  //   ActionChip(label: Text("History")),
  //   ActionChip(label: Text("Horror")),
  //   ActionChip(label: Text("Music")),
  //   ActionChip(label: Text("Mystery")),
  //   ActionChip(label: Text("Romance")),
  //   ActionChip(label: Text("Science Fiction")),
  //   ActionChip(label: Text("TV Movie")),
  //   ActionChip(label: Text("Thriller")),
  //   ActionChip(label: Text("War")),
  //   ActionChip(label: Text("Western")),
  // ];

  // var onPressedItems = const <String, bool>{
  //   "Action": false,
  //   "Adventure": false,
  //   "Animation": false,
  //   "Comedy": false,
  //   "Crime": false,
  //   "Documentary": false,
  //   "Drama": false,
  //   "Family": false,
  //   "Fantasy": false,
  //   "History": false,
  //   "Horror": false,
  //   "Music": false,
  //   "Mystery": false,
  //   "Romance": false,
  //   "Science Fiction": false,
  //   "TV Movie": false,
  //   "Thriller": false,
  //   "War": false,
  //   "Western": false
  // };

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Text("Genres"),
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ActionChip(
                      label: Text("Action"),
                      backgroundColor: onPressedItems["28"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["28"] = !onPressedItems["28"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Adventure"),
                      backgroundColor: onPressedItems["12"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["12"] = !onPressedItems["12"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Animation"),
                      backgroundColor: onPressedItems["16"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["16"] = !onPressedItems["16"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Comedy"),
                      backgroundColor: onPressedItems["35"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["35"] = !onPressedItems["35"]!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    ActionChip(
                      label: Text("Crime"),
                      backgroundColor: onPressedItems["80"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["80"] = !onPressedItems["80"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Documentary"),
                      backgroundColor: onPressedItems["99"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["99"] = !onPressedItems["99"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Drama"),
                      backgroundColor: onPressedItems["18"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["18"] = !onPressedItems["18"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Family"),
                      backgroundColor: onPressedItems["10751"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["10751"] = !onPressedItems["10751"]!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    ActionChip(
                      label: Text("Fantasy"),
                      backgroundColor: onPressedItems["14"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["14"] = !onPressedItems["14"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("History"),
                      backgroundColor: onPressedItems["36"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["36"] = !onPressedItems["36"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Horror"),
                      backgroundColor: onPressedItems["27"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["27"] = !onPressedItems["27"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Music"),
                      backgroundColor: onPressedItems["10402"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["10402"] = !onPressedItems["10402"]!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    ActionChip(
                      label: Text("Mystery"),
                      backgroundColor: onPressedItems["9648"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["9648"] = !onPressedItems["9648"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Romance"),
                      backgroundColor: onPressedItems["10749"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["10749"] = !onPressedItems["10749"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Science Fiction"),
                      backgroundColor: onPressedItems["878"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["878"] = !onPressedItems["878"]!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    ActionChip(
                      label: Text("TV Movie"),
                      backgroundColor: onPressedItems["10770"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["10770"] = !onPressedItems["10770"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Thriller"),
                      backgroundColor: onPressedItems["53"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["53"] = !onPressedItems["53"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("War"),
                      backgroundColor: onPressedItems["10752"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["10752"] = !onPressedItems["10752"]!;
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    ActionChip(
                      label: Text("Western"),
                      backgroundColor: onPressedItems["37"]! ? Colors.blueAccent : Colors.transparent,
                      onPressed: () {
                        setState(() {
                          onPressedItems["37"] = !onPressedItems["37"]!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ]
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ExpansionTile(
  //       title: Text("Genres"),
  //       children: [
  //         SingleChildScrollView(
  //           scrollDirection: Axis.horizontal,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   ActionChip(
  //                     label: Text("Action"),
  //                     backgroundColor: isEnabledAction ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledAction = !isEnabledAction;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Adventure"),
  //                     backgroundColor: isEnabledAdventure ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledAdventure = !isEnabledAdventure;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Animation"),
  //                     backgroundColor: isEnabledAnimation ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledAnimation = !isEnabledAnimation;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Comedy"),
  //                     backgroundColor: isEnabledComedy ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledComedy = !isEnabledComedy;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   ActionChip(
  //                     label: Text("Crime"),
  //                     backgroundColor: isEnabledCrime ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledCrime = !isEnabledCrime;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Documentary"),
  //                     backgroundColor: isEnabledDocumentary ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledDocumentary = !isEnabledDocumentary;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Family"),
  //                     backgroundColor: isEnabledFamily ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledFamily = !isEnabledFamily;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Fantasy"),
  //                     backgroundColor: isEnabledFantasy ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledFantasy = !isEnabledFantasy;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   ActionChip(
  //                     label: Text("History"),
  //                     backgroundColor: isEnabledHistory? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledHistory = !isEnabledHistory;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Horror"),
  //                     backgroundColor: isEnabledHorror ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledHorror = !isEnabledHorror;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Music"),
  //                     backgroundColor: isEnabledMusic ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledMusic = !isEnabledMusic;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Mystery"),
  //                     backgroundColor: isEnabledMystery ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledMystery = !isEnabledMystery;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   ActionChip(
  //                     label: Text("Romance"),
  //                     backgroundColor: isEnabledRomance ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledRomance = !isEnabledRomance;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Science Fiction"),
  //                     backgroundColor: isEnabledScienceFiction ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledScienceFiction = !isEnabledScienceFiction;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("TV Movie"),
  //                     backgroundColor: isEnabledTVMovie ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledTVMovie = !isEnabledTVMovie;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               Row(
  //                 children: [
  //                   ActionChip(
  //                     label: Text("Thriller"),
  //                     backgroundColor: isEnabledThriller ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledThriller = !isEnabledThriller;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("War"),
  //                     backgroundColor: isEnabledWar ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledWar = !isEnabledWar;
  //                       });
  //                     },
  //                   ),
  //                   const SizedBox(width: 10),
  //                   ActionChip(
  //                     label: Text("Western"),
  //                     backgroundColor: isEnabledWestern ? Colors.blueAccent : Colors.transparent,
  //                     onPressed: () {
  //                       setState(() {
  //                         isEnabledWestern = !isEnabledWestern;
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 10),
  //             ],
  //           ),
  //         ),
  //       ]
  //   );
  // }
}