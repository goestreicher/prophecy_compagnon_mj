import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../classes/storage/storage.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({ super.key });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isWorking = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0.0),
            child: Column(
              spacing: 16.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16.0,
                  children: [
                    ElevatedButton.icon(
                      label: const Text('Exporter les données'),
                      icon: Icon(Icons.download),
                      onPressed: () async {
                        setState(() {
                          isWorking = true;
                        });
                        await FilePicker.platform.saveFile(
                          fileName: 'prophecy-compagnon-mj-export.zip',
                          bytes: await DataStorage.instance.export(),
                        );
                        setState(() {
                          isWorking = false;
                        });
                      },
                    ),
                    ElevatedButton.icon(
                      label: const Text('Importer une sauvegarde'),
                      icon: Icon(Icons.publish),
                      onPressed: () async {
                        var result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['zip'],
                          withData: true,
                        );
                        if(!context.mounted) return;
                        if(result == null) return;

                        setState(() {
                          isWorking = true;
                        });
                        await DataStorage.instance.import(result.files.first.bytes!);
                        setState(() {
                          isWorking = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if(isWorking)
          const Opacity(
            opacity: 0.6,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black,
            ),
          ),
        if(isWorking)
          const Center(
            child: CircularProgressIndicator()
          ),
      ],
    );
  }
}