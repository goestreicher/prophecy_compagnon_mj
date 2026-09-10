import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:prophecy_compagnon_shared/classes/exportable_binary_data.dart';
import 'package:prophecy_compagnon_shared/classes/generic_image.dart';

class GenericImageWidget extends StatelessWidget {
  const GenericImageWidget({
    super.key,
    required this.image,
    this.maxDimension,
    this.onError,
    this.fit,
  });

  final GenericImage image;
  final double? maxDimension;
  final Widget Function(BuildContext, Object, StackTrace?)? onError;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    Widget imageWidget;

    switch(image.sourceType) {
      case GenericImageSourceType.memory:
        imageWidget = Image.memory(
          image.binary!.data,
          errorBuilder: onError,
          fit: fit,
        );
      case GenericImageSourceType.asset:
        imageWidget = Image.asset(
          image.source,
          bundle: rootBundle,
          errorBuilder: onError,
          fit: fit,
        );
      case GenericImageSourceType.local:
        imageWidget = FutureBuilder(
          future: BinaryDataStore().get(image.source),
          builder: (BuildContext context, AsyncSnapshot<ExportableBinaryData?> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if(snapshot.hasError) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.shadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    spacing: 12.0,
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          "Image invalide: ${snapshot.error.toString()}",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ),
              );
            }

            if(!snapshot.hasData || snapshot.data == null) {
              return Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.shadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    spacing: 12.0,
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.white,
                      ),
                      Expanded(
                        child: Text(
                          "Impossible de charger l'image",
                          style: theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  )
                ),
              );
            }

            return Image.memory(
              snapshot.data!.data,
              errorBuilder: onError,
              fit: fit,
            );
          },
        );
      case GenericImageSourceType.url:
        return Image.network(
          image.source,
          webHtmlElementStrategy: kIsWeb ? WebHtmlElementStrategy.prefer : WebHtmlElementStrategy.never,
          errorBuilder: onError,
          fit: fit,
        );
    }

    if(maxDimension != null) {
      imageWidget = SizedBox(
        height: maxDimension,
        width: maxDimension,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}