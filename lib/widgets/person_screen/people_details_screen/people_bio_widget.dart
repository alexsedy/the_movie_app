import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';

class BioPersonWidget extends StatelessWidget {
  const BioPersonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final person =  NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails;
    final name = person?.name;

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProfilePhotoWidget(),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  Text(
                    name ?? "",
                    maxLines: 3,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const _SocialNetworkWidget(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        const _GeneralInfoWidget(),
        const _BioTextWidget(),
      ],
    );
  }
}

class _GeneralInfoWidget extends StatelessWidget {
  const _GeneralInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<PeopleDetailsModel>(context);
    final person = model?.personDetails;
    final birthday = model?.formatDate(person?.birthday);
    final deathDay = model?.formatDate(person?.deathday);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.knownFor(person?.gender ?? 3)),
                  Text(person?.knownForDepartment ?? context.l10n.unknown),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.gender),
                  Text(context.l10n.genderType(person?.gender ?? 3)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.dateOfBirth),
                  Text(birthday != null && birthday.isNotEmpty 
                          ? birthday 
                          : context.l10n.unknown),
                ],
              ),
            ),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.placeOfBirth),
                  Text(person?.placeOfBirth ?? context.l10n.unknown, softWrap: true,),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (person?.deathday != null) ...[
                    Text(context.l10n.dateOfDeath),
                    Text(deathDay ?? context.l10n.unknown),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 150,),
          ],
        ),
      ],
    );
  }
}

class _SocialNetworkWidget extends StatelessWidget {
  const _SocialNetworkWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<PeopleDetailsModel>(context);
    final personDetails = model?.personDetails;
    final imdbId = personDetails?.imdbId;
    final homepage = personDetails?.homepage;
    final facebookId = personDetails?.externalIds.facebookId;
    final instagramId = personDetails?.externalIds.instagramId;
    final tiktokId = personDetails?.externalIds.tiktokId;
    final youtubeId = personDetails?.externalIds.youtubeId;
    final wikidataId = personDetails?.externalIds.wikidataId;
    final twitterId = personDetails?.externalIds.twitterId;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            context.l10n.socialNetwork,
            style: const TextStyle(
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: imdbId != null
                  ? () => model?.launchImdbProfile(imdbId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.imdb, size: 30,),
            ),
            IconButton(
              onPressed: instagramId != null
                  ? () => model?.launchInstagramProfile(instagramId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.instagram, size: 28,),
            ),
            IconButton(
              onPressed: twitterId != null
                  ? () => model?.launchTwitterProfile(twitterId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.xTwitter, size: 28,),
            ),
            IconButton(
              onPressed: wikidataId != null
                  ? () => model?.launchWikidataProfile(wikidataId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.wikipediaW, size: 28,),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: tiktokId != null
                  ? () => model?.launchTiktokProfile(tiktokId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.tiktok, size: 28,),
            ),
            IconButton(
              onPressed: youtubeId != null
                  ? () => model?.launchYoutubeProfile(youtubeId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.youtube, size: 28,),
            ),
            IconButton(
              onPressed: facebookId != null
                  ? () => model?.launchFacebookProfile(facebookId)
                  : null,
              icon: const FaIcon(FontAwesomeIcons.facebookF, size: 28,),
            ),
            Container(height: 20.0, width: 1.0, color: Colors.grey,),
            IconButton(
              onPressed: homepage != null
                ? () => model?.launchPersonHomepage(homepage)
                : null,
              icon: const FaIcon(FontAwesomeIcons.earthEurope, size: 28,),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProfilePhotoWidget extends StatelessWidget {
  const _ProfilePhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final person =  NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails;
    final profilePath = person?.profilePath;

    return Container(
      clipBehavior: Clip.hardEdge,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.transparent),
      ),
      child: AspectRatio(
        aspectRatio: 500 / 750,
        child: profilePath != null
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
          ApiClient.getImageByUrl(profilePath),)
            : Image.asset(AppImages.noProfile,),
      ),
    );
  }
}

class _BioTextWidget extends StatefulWidget {
  const _BioTextWidget({Key? key}) : super(key: key);

  @override
  _BioTextWidgetState createState() => _BioTextWidgetState();
}

class _BioTextWidgetState extends State<_BioTextWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final biography =  NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails?.biography;

    if(biography == null || biography.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8,),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.biography,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10,),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: Text(
                biography,
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
              secondChild: Text(
                biography,
              ),
            ),
            biography.length <= 300
                ? const SizedBox.shrink()
                : Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            ),
          ],
        ),
      ),
    );
  }
}