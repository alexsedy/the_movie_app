import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

class RateButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const RateButtonWidget({
    super.key, required this.mediaDetailsElementType, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isRated = model.isRated;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onLongPress: () => model.toggleDeleteRating(context),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _RateDialogWidget(model: model,);
          },
        );
      },
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isRated
                ? const Icon(Icons.star, color: Colors.amber,)
                : const Icon(Icons.star_outline),
            Text(context.l10n.rate,),
          ],
        ),
      ),
    );
  }
}

class _RateDialogWidget extends StatefulWidget {
  final IBaseMediaDetailsModel model;
  const _RateDialogWidget({required this.model});

  @override
  State<_RateDialogWidget> createState() => _RateDialogWidgetState();
}

class _RateDialogWidgetState extends State<_RateDialogWidget> {
  double rate = 0.0;

  @override
  void initState() {
    final currentRate = widget.model.rate;
    rate = currentRate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(context.l10n.rateMovie),
      children: [
        Center(
          child: Text(
            "${context.l10n.rate}: ${rate.round()}",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          // label: "Rate: ${rate.round()}",
          divisions: 10,
          value: rate,
          onChanged: (value) {
            setState(() {
              rate = value;
              widget.model.rate = value;
            },);
          },
          // onChangeEnd: (value) =>  widget.model.toggleAddRating(context, value),
        ),
        TextButton(
          onPressed: () async {
            showDialog (
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
            await widget.model.toggleAddRating(context, rate);
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(context.l10n.ok),),
      ],
    );
  }
}