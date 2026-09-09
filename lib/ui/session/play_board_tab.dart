import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../classes/generic_image.dart';
import '../../classes/session/board/item.dart';
import '../../classes/session/game_session.dart';
import '../utils/generic_image_widget.dart';
import '../utils/session/clients/session_message_bus_client.dart';
import '../utils/session/messages/set_state/board.dart';
import 'board/item_picker.dart';
import 'board/item_widget.dart';

const _sideBarPillWidth = 60.0;
const _sideBarBackgroundColor = Color.fromARGB(255, 30, 31, 34);
const _sideBarForegroundColor = Color.fromARGB(255, 232, 234, 231);

class PlayBoardTab extends StatelessWidget {
  const PlayBoardTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var session = context.watch<GameSession>();

    return Row(
      children: [
        Container(
          width: _sideBarPillWidth + 20,
          decoration: BoxDecoration(
            color: _sideBarBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: ListenableBuilder(
                listenable: session.board,
                builder: (BuildContext context, Widget? child) {
                  return _PlayBoardSideBar(
                    items: session.board,
                    initialSelection: session.board.selected,
                    onItemSelected: (int index) {
                      SessionMessageBusClient.instance
                        ?.publish(
                            SessionSetStateBoardSelect(
                              index: index,
                            )
                          );
                    },
                    onItemCreated: (SessionBoardItem i) {
                      SessionMessageBusClient.instance
                        ?.publish(
                            SessionSetStateBoardPush(
                              item: i,
                            )
                          );
                      SessionMessageBusClient.instance
                        ?.publish(
                            SessionSetStateBoardSelect(
                              index: 0,
                            )
                        );
                    },
                    onItemRemoved: (int index) {
                      SessionMessageBusClient.instance
                        ?.publish(
                            SessionSetStateBoardRemove(
                              index: index,
                            )
                        );
                    },
                  );
                }
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: _sideBarBackgroundColor,
              border: Border(
                left: BorderSide(
                  color: _sideBarForegroundColor.withAlpha(100),
                  width: 1
                ),
              ),
            ),
            child: ListenableBuilder(
              listenable: session.board,
              builder: (BuildContext context, Widget? child) {
                if(session.board.selected == null) {
                  return SizedBox.expand();
                }
                else {
                  return SessionBoardItemWidget(
                    item: session.board.elementAt(session.board.selected!),
                  );
                }
              }
            ),
          ),
        ),
      ],
    );
  }
}

class _PlayBoardSideBar extends StatelessWidget {
  const _PlayBoardSideBar({
    required this.items,
    required this.onItemSelected,
    this.initialSelection,
    required this.onItemCreated,
    required this.onItemRemoved,
  });

  final Iterable<SessionBoardItem> items;
  final void Function(int) onItemSelected;
  final int? initialSelection;
  final void Function(SessionBoardItem) onItemCreated;
  final void Function(int) onItemRemoved;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var session = context.watch<GameSession>();

    return ListView.builder(
      itemCount: items.length + 1,
      itemBuilder: (BuildContext context, int index) {
        if(index == 0) {
          return Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
            child: _PlayBoardSideBarPill(
              onTap: () async {
                var item = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                    SessionBoardItemPickerDialog()
                );
                if(item == null) return;
                if(!context.mounted) return;

                onItemCreated(item);
              },
              child: Tooltip(
                message: 'Ajouter un élément au plateau',
                child: Center(
                  child: Text(
                    // TODO: something fancier
                    '+',
                    style: theme.textTheme.headlineLarge!
                      .copyWith(
                        color: _sideBarForegroundColor,
                      ),
                  ),
                ),
              ),
            ),
          );
        }
        else {
          var item = items.elementAt(index - 1);
          var canRemove = item.removable;

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 12.0, 8.0, 4.0),
                child: _PlayBoardItemPill(
                  item: item,
                  onTap: () => onItemSelected(index - 1),
                  selected: initialSelection == (index - 1),
                ),
              ),
              if(canRemove)
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => onItemRemoved(index - 1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red[800],
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        }
      },
    );
  }
}

class _PlayBoardSideBarPill extends StatelessWidget {
  const _PlayBoardSideBarPill({
    required this.child,
    required this.onTap,
    this.selected = false,
  });

  final Widget child;
  final void Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _sideBarPillWidth,
      height: _sideBarPillWidth,
      decoration: BoxDecoration(
        border: Border.all(
          color: selected ? Colors.white : Colors.white38,
          width: selected ? 3.0 : 1.0,
        ),
        borderRadius: BorderRadius.circular(_sideBarPillWidth / 10),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_sideBarPillWidth / 10),
            child: child,
          ),
        ),
      ),
    );
  }
}

class _PlayBoardItemPill extends StatelessWidget {
  const _PlayBoardItemPill({
    required this.item,
    required this.onTap,
    this.selected = false,
  });

  final SessionBoardItem item;
  final void Function() onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return _PlayBoardSideBarPill(
      onTap: onTap,
      selected: selected,
      child: Tooltip(
        message: item.title,
        child: FutureBuilder(
          future: item.thumbnail(_sideBarPillWidth),
          builder: (BuildContext context, AsyncSnapshot<GenericImage> snapshot) {
            if(snapshot.hasError) {
              return Icon(Icons.error);
            }

            if(!snapshot.hasData || snapshot.data == null) {
              return Icon(Icons.cancel);
            }

            return GenericImageWidget(
              image: snapshot.data!,
              maxDimension: _sideBarPillWidth,
            );
          }
        )
      ),
    );
  }
}