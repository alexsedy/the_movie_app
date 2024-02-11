import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHeaderSkeletonWidget extends StatelessWidget {
  const ShimmerHeaderSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Container(
        color: Colors.greenAccent,
      ),
    );
  }
}

class ShimmerBodySkeletonWidget extends StatelessWidget {
  const ShimmerBodySkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    color: Colors.white,
                    height: 40,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: (){},
                      child: Row(
                        children: [
                          SizedBox(
                              width: 45,
                              height: 45,
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(0.5),
                                highlightColor: Colors.white.withOpacity(0.5),
                                child: const CircleAvatar(
                                  backgroundColor: Colors.white,
                                ),
                              )
                          ),
                          const SizedBox(width: 10),
                          const Text("User Score", style: TextStyle(color: Colors.black),),
                        ],
                      )
                  ),
                  Container(width: 1, height: 15,color: Colors.grey,),
                  TextButton(
                      onPressed: (){},
                      child: const Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.black),
                          Text("Play Trailer", style: TextStyle(color: Colors.black),),
                        ],
                      )
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list),
                          Text("List"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.favorite),
                          Text("Favorite"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bookmark),
                          Text("Watch"),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star),
                          Text("Rate"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 30,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.white.withOpacity(0.5),
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 80,
                  ),
                ),
              ),
              const SizedBox(height: 30,),
              Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.white.withOpacity(0.5),
                        child: Container(
                          color: Colors.white,
                          width: 120,
                          height: 110,
                        ),
                      ),
                      Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.white.withOpacity(0.5),
                        child: Container(
                          color: Colors.white,
                          width: 120,
                          height: 110,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20,),
          Column(
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
                    itemCount: 4,
                    itemExtent: 125,
                    itemBuilder: (BuildContext context, int index){
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.withOpacity(0.5),
                        highlightColor: Colors.white.withOpacity(0.5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}