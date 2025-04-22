import 'package:flutter/material.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedPaginationVerticalListWidget extends StatefulWidget {
  final ParameterizedWidgetModel paramModel;
  final Function loadMoreItems;

  const ParameterizedPaginationVerticalListWidget({
    super.key,
    required this.paramModel, required this.loadMoreItems,
  });

  @override
  State<ParameterizedPaginationVerticalListWidget> createState() => _ParameterizedPaginationVerticalListWidgetState();
}

class _ParameterizedPaginationVerticalListWidgetState extends State<ParameterizedPaginationVerticalListWidget> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    var scrollController = widget.paramModel.scrollController;

    if(scrollController != null) {
      _scrollController = scrollController;
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      widget.loadMoreItems().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final statuses = widget.paramModel.statuses ?? [];

    return ListView.builder(
      itemExtent: 163,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      controller: _scrollController,
      itemCount: widget.paramModel.list.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if (index == widget.paramModel.list.length) {
          return _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
              )
              : const SizedBox.shrink();
        }

        String? posterPath = widget.paramModel.list[index].imagePath;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )
                    ]
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 500 / 750,
                      child: posterPath != null
                          ? Image.network(
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fill,)
                          : Image.asset(widget.paramModel.altImagePath, width: 95, fit: BoxFit.fill,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 10, bottom: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15,),
                            Text(
                              widget.paramModel.list[index].firstLine ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5,),
                            Text(
                              widget.paramModel.list[index].secondLine ?? "",
                              style: const TextStyle(
                                  color: Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 15,),
                            Expanded(
                              child: Text(
                                widget.paramModel.list[index].thirdLine ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(
                      10)),
                  onTap: () {
                    widget.paramModel.action(context, index);
                  },
                ),
              ),
              if(statuses.any((e) =>
                e.id == widget.paramModel.list[index].id && e.status != 0))
                Positioned(
                    top: 5,
                    right: 5,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.blueAccent.withAlpha(180),
                    ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// class ParameterizedPaginationVerticalListWidget extends StatefulWidget {
//   final ParameterizedWidgetModel paramModel;
//   final Function loadMoreItems;
//
//   const ParameterizedPaginationVerticalListWidget({
//     super.key,
//     required this.paramModel, required this.loadMoreItems,
//   });
//
//   @override
//   _ParameterizedPaginationVerticalListWidgetState createState() => _ParameterizedPaginationVerticalListWidgetState();
// }

// class _ParameterizedPaginationVerticalListWidgetState extends State<ParameterizedPaginationVerticalListWidget> {
//   late ScrollController _scrollController;
//   bool _isLoading = false;
//   bool _hasMoreItems = true; // Переменная для отслеживания наличия дополнительных элементов
//
//   @override
//   void initState() {
//     super.initState();
//     var scrollController = widget.paramModel.scrollController;
//     if(scrollController != null) {
//       _scrollController = scrollController;
//     }
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     super.dispose();
//   }
//
//   void _onScroll() {
//     // Проверка, достигаем ли конца списка и если ещё есть элементы для загрузки
//     if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoading && _hasMoreItems) {
//       setState(() {
//         _isLoading = true; // Установка флага загрузки
//       });
//
//       // Инициация подгрузки данных
//       widget.loadMoreItems().then((itemsLoaded) {
//         if (itemsLoaded.isEmpty) {
//           setState(() {
//             _hasMoreItems = false; // Больше нет элементов для загрузки
//           });
//         }
//         setState(() {
//           _isLoading = false; // Установка флага загрузки обратно
//         });
//       }).catchError((error) {
//         print('Ошибка загрузки данных: $error');
//         setState(() {
//           _isLoading = false; // Установка флага загрузки обратно при ошибке
//         });
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemExtent: 163,
//       controller: _scrollController,
//       itemCount: widget.paramModel.list.length + (_isLoading ? 1 : 0), // Добавляем 1, если загружается
//       itemBuilder: (BuildContext context, int index) {
//         if (index >= widget.paramModel.list.length) {
//           // Если загружается и мы достигли конца списка
//           return const Padding(
//             padding: EdgeInsets.symmetric(vertical: 16),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         String? posterPath = widget.paramModel.list[index].imagePath;
//
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           child: Stack(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black.withOpacity(0.2)),
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(1, 2),
//                     ),
//                   ],
//                 ),
//                 clipBehavior: Clip.hardEdge,
//                 child: Row(
//                   children: [
//                     AspectRatio(
//                       aspectRatio: 500 / 750,
//                       child: posterPath != null
//                           ? Image.network(
//                         loadingBuilder: (context, child, loadingProgress) {
//                           if (loadingProgress == null) return child;
//                           return const Center(
//                             child: SizedBox(
//                               width: 60,
//                               height: 60,
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         },
//                         ApiClient.getImageByUrl(posterPath),
//                         width: 95,
//                         fit: BoxFit.fill,
//                       )
//                           : Image.asset(widget.paramModel.altImagePath, width: 95, fit: BoxFit.fill),
//                     ),
//                     Expanded(
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 15, right: 10, bottom: 1),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 15),
//                             Text(
//                               widget.paramModel.list[index].firstLine ?? "",
//                               style: const TextStyle(fontWeight: FontWeight.bold),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               widget.paramModel.list[index].secondLine ?? "",
//                               style: const TextStyle(color: Colors.grey),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             const SizedBox(height: 15),
//                             Flexible(
//                               child: Text(
//                                 widget.paramModel.list[index].thirdLine ?? "",
//                                 maxLines: 3,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: const BorderRadius.all(Radius.circular(10)),
//                   onTap: () {
//                     widget.paramModel.action(context, index);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }