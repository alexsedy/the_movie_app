import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/images_const/app_images.dart';

class MovieScreenCastWidget extends StatelessWidget {
  const MovieScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Text(
            "Movie Cast",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: Scrollbar(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 20,
              itemExtent: 125,
              itemBuilder: (BuildContext context, int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                    child: Column(
                      children: [
                        Image(image: AssetImage(AppImages.actor)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text(
                              "Sophie Wilde",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("Mia",
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          child: TextButton(
            onPressed: (){},
            child: const Text(
              "Full Cast & Crew",
              style:  TextStyle(
                fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            )
          ),
        ),
      ],
    );
  }
}
