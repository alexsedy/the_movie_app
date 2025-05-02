import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_description/viewmodel/ai_recommendation_by_description_viewmodel.dart';

class AiRecommendationByDescriptionView extends StatelessWidget {
  const AiRecommendationByDescriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aiRecommendation),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget();

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late TextEditingController _textController;
  double _sliderValue = 10.0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _textController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.screenPaddingAll10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppSpacing.gapH20,
            Text(
              context.l10n.writeADescriptionAiMessage,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            AppSpacing.gapH20,
            TextField(
              controller: _textController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              dragStartBehavior: DragStartBehavior.start,
              autocorrect: true,
              minLines: 5,
              maxLines: 10,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "e.g., A space opera with wizards and laser swords...",
                // Возможно, добавить счетчик символов
                // counterText: "${_textController.text.length} / 500",
              ),
            ),
            AppSpacing.gapH20,
            Text(
              context.l10n.selectMaxNumberOfItems,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              label: _sliderValue.toInt().toString(),
              min: 1,
              max: 100,
              divisions: 99,
            ),
            AppSpacing.gapH20,
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: _textController.text.trim().isNotEmpty
                    ? () => context.read<AiRecommendationByDescriptionViewModel>()
                    .onGenerateContent(
                  context,
                  _textController.text,
                  _sliderValue.toInt(),
                )
                    : null,
                child: Text(context.l10n.generate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}