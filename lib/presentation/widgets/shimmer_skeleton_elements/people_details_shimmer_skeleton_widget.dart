import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';


class PeopleDetailsShimmerSkeletonWidget extends StatelessWidget {
  const PeopleDetailsShimmerSkeletonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPaddingH10,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white.withOpacity(0.5),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.transparent),
                      ),
                      child: AspectRatio(
                        aspectRatio: 500 / 750,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    AppSpacing.gapW10,
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: 34,
                            width: 184,
                            color: Colors.white,
                          ),
                          Column(
                            children: [
                              AppSpacing.gapH32,
                              Text(
                                context.l10n.socialNetwork,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.imdb, size: 30,),
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.instagram, size: 28,),
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.xTwitter, size: 28,),
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.wikipediaW, size: 28,),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.tiktok, size: 28,),
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.youtube, size: 28,),
                                  ),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.facebookF, size: 28,),
                                  ),
                                  Container(height: 20.0, width: 1.0, color: Colors.grey,),
                                  IconButton(
                                    onPressed: (){},
                                    icon: const FaIcon(FontAwesomeIcons.earthEurope, size: 28,),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH10,
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          height: 40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapH20,
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: AppSpacing.screenPaddingH16V10,
                      child: Text(
                        context.l10n.biography,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Padding(
                      padding: AppSpacing.screenPaddingH10,
                      child: Container(
                        height: 100,
                        color: Colors.white,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,),
                  ],
                ),
              ],
            ),
            AppSpacing.gapH10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.screenPaddingH16V10,
                  child: Text(
                    context.l10n.imageGallery,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: AppSpacing.screenPaddingAll10,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                          child: AspectRatio(
                            aspectRatio: 500 / 750,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}