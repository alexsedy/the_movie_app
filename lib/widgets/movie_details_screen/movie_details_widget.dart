import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/movie_details_screen/movie_screen_cast_widget.dart';

import '../images_const/app_images.dart';
import 'movie_details_main_info_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  final int movieId;
  const MovieDetailsWidget({super.key, required this.movieId});

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            onStretchTrigger: () async {},
            stretchTriggerOffset: 200.0,
            expandedHeight: 183.0,
            flexibleSpace: FlexibleSpaceBar(
              title: _MovieNameWidget(), // Замените на название вашего фильма
              background: _TopPosterWidget(), // Замените на ваш фоновый виджет
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              MovieDetailsMainInfoWidget(),
              SizedBox(height: 20,),
              MovieScreenCastWidget(),
            ]),
          ),
        ],
      ),
    );
  }
}



//       ListView(
//         children: [
//           MovieDetailsMainInfoWidget(),
//         ],
//       ),
//     );
//   }
// }

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(image: AssetImage(AppImages.topHeaderPoster)),
        Positioned(
          top: 20,
          left: 15,
          bottom: 20,
          child: Container(
            height: 140, width: 90,
            child: Image(image: AssetImage(AppImages.subHeaderPoster))
          ),
        ),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: "Talk to Me ",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
          TextSpan(
            text: " (2023)",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              )
          ),
        ]
      ),
    );
  }
}
