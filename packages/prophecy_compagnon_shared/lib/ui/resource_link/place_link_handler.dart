import 'package:material_ui/material_ui.dart';
import 'package:prophecy_compagnon_shared/classes/place.dart';
import 'package:prophecy_compagnon_shared/classes/resource_link/resource_link.dart';
import 'package:prophecy_compagnon_shared/ui/place/place_display_widget.dart';

Future<Widget?> handlePlaceLinkClicked(
    ResourceLink link,
    BuildContext context,
    {
      List<Widget>? extraActionButtons,
    }
) async {
  var place = await PlaceSummary.get(link.id);
  if(!context.mounted) return null;

  if(place == null) {
    return AlertDialog(
      title: const Text('Lieu non trouvé'),
      content: Text(
        "Impossible de trouver le lieu avec l'ID ${link.id}"
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }
  else {
    return AlertDialog(
      title: Text(place.name),
      content: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: PlaceDisplayWidget(placeId: place.id),
        ),
      ),
      actions: [
        ...?extraActionButtons,
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          child: const Text('OK')
        ),
      ],
    );
  }
}