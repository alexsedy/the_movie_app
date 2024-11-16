import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/ai_feature_screen/by_description/ai_recommendation_by_description/ai_recommendation_by_description_model.dart';

class AiRecommendationByDescriptionScreenWidget extends StatelessWidget {
  const AiRecommendationByDescriptionScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Recommendation"),
      ),
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatefulWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  late TextEditingController textController;
  var _sliderValue = 10.0;

  @override
  void initState() {
    textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AiRecommendationByDescriptionModel>(context);

    if(model == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              "Write a description that is as detailed as possible",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20,),
            TextField(
              onChanged: (v) {
                setState(() {
                });
              },
              controller: textController,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              dragStartBehavior: DragStartBehavior.start,
              autocorrect: true,
              minLines: 5,
              maxLines: 50,
              decoration: InputDecoration(
                border: OutlineInputBorder()
              ),
            ),
            SizedBox(height: 20,),
            Text(
              "Select max number of items",
              style: TextStyle(
                fontSize: 20,
              ),
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
            SizedBox(height: 20,),
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: textController.text.trim().isNotEmpty
                    ? () => model.onGenerateContent(
                    context,
                    textController.text,
                    _sliderValue.toInt(),
                )
                    : null,
                child: Text("Generate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
