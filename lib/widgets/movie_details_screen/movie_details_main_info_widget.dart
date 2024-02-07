import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/elements/_score_radial_percent_widget.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SummaryMovieWidget(),
        _ScoreAndTrailerWidget(),
        _TaglineWidget(),
        _OverviewWidget(),
        _DiscriptionWidget(),
        SizedBox(height: 30,),
        _PeopleWidget(),
      ],
    );
  }
}

class _ScoreAndTrailerWidget extends StatelessWidget {
  const _ScoreAndTrailerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: (){},
          child: Row(
            children: [
              SizedBox(
                width: 45,
                height: 45,
                child: RadiantPercentWidget(
                  child: Text("73%", style: TextStyle(color: Colors.white),),
                  percent: 0.73,
                  progressFreeColor: Colors.grey,
                  progressLineColor: Colors.green,
                  backgroundCircleColor: Colors.black87,
                  lineWidth: 3,
                ),
              ),
              SizedBox(width: 10),
              Text("User Score", style: TextStyle(color: Colors.black),),
            ],
          )
        ),
        Container(width: 1, height: 15,color: Colors.grey,),
        TextButton(
          onPressed: (){},
          child: Row(
            children: [
              Icon(Icons.play_arrow, color: Colors.black),
              Text("Play Trailer", style: TextStyle(color: Colors.black),),
            ],
          )
        ),
      ],
    );
  }
}

class _DiscriptionWidget extends StatelessWidget {
  const _DiscriptionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("When a group of friends discover how to conjure spirits using an embalmed hand, they become hooked on the new thrill, until one of them goes too far and unleashes terrifying supernatural forces."),
    );
  }
}

class _TaglineWidget extends StatelessWidget {
  const _TaglineWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("You call. They'll answer.", style: TextStyle(fontSize: 21, fontStyle: FontStyle.italic),),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
    );
  }
}

class _SummaryMovieWidget extends StatelessWidget {
  const _SummaryMovieWidget({super.key});

  @override
  final double textSize = 16;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: "15",
                style: TextStyle(
                  fontSize: textSize,
                ),
              ),
              TextSpan(text: " ● ", style: TextStyle(fontSize: textSize,),),
              TextSpan(
                  text: "1h 49m",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
              TextSpan(text: " ● ", style: TextStyle(fontSize: textSize,),),
              TextSpan(
                  text: "07/28/2023 (GB)",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
              TextSpan(text: " ● ", style: TextStyle(fontSize: textSize,),),
              TextSpan(
                  text: "Horror, Thriller",
                  style: TextStyle(
                    fontSize: textSize,
                  )
              ),
            ]
        ),
      ),
    );
  }
}

class _PeopleWidget extends StatelessWidget {
  const _PeopleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final styleOfName = TextStyle(fontSize: 16, );
    final styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],
            ),
          ],
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Danny Philippou", style: styleOfName,),
                Text("Director, Writer", style: styleOfRole,),
              ],
            ),
          ],
        )
      ],
    );
  }
}






