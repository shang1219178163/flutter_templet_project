//
//  SlidableDemoPage.dart
//  fluttertemplet
//
//  Created by shang on 5/20/21 10:26 AM.
//  Copyright © 5/20/21 shang. All rights reserved.
//

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class SlidableDemo extends StatefulWidget {
  SlidableDemo({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SlidableDemoState createState() => _SlidableDemoState();
}

class _SlidableDemoState extends State<SlidableDemo> {
  late final SlidableController slidableController;
  final List<_HomeItem> items = List.generate(20, (i) => _HomeItem(
      i,
      'Tile n°$i',
      _getSubtitle(i),
      _getAvatarColor(i),
    ),
  );

  @protected
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "无标题"),
      ),
      body: Center(
        child: OrientationBuilder(
          builder: (context, orientation) => _buildList(
              context,
              orientation == Orientation.portrait
                  ? Axis.vertical
                  : Axis.horizontal),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _fabColor,
        onPressed: null,
        child: _rotationAnimation == null
            ? Icon(Icons.add)
            : RotationTransition(
              turns: _rotationAnimation!,
              child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, Axis direction) {
    return ListView.builder(
      scrollDirection: direction,
      itemBuilder: (context, index) {
        final Axis slidableDirection =
        direction == Axis.horizontal ? Axis.vertical : Axis.horizontal;
        var item = items[index];
        if (item.index < 8) {
          return _getSlidableWithLists(context, index, slidableDirection);
        } else {
          return _getSlidableWithDelegates(context, index, slidableDirection);
        }
      },
      itemCount: items.length,
    );
  }

  Widget _getSlidableWithLists(
      BuildContext context, int index, Axis direction) {
    final _HomeItem item = items[index];
    //final int t = index;
    return Slidable(
      key: Key(item.title),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            items.removeAt(index);
          });
        },
      ),
      actionPane: _getActionPane(item.index)!,
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? VerticalListItem(items[index])
          : HorizontalListItem(items[index]),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Theme.of(context).primaryColor,
          icon: Icons.archive,
          onTap: () => _showSnackBar(context, 'Archive'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => _showSnackBar(context, 'Share'),
        ),
      ],
      secondaryActions: <Widget>[
        Container(
          height: 800,
          color: Colors.green,
          child: Text('a').center(),
        ),
        IconSlideAction(
          caption: 'More',
          color: Colors.grey.shade200,
          icon: Icons.more_horiz,
          onTap: () => _showSnackBar(context, 'More'),
          closeOnTap: false,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _showSnackBar(context, 'Delete'),
        ),
      ],
    );
  }

  Widget _getSlidableWithDelegates(
      BuildContext context, int index, Axis direction) {
    final _HomeItem item = items[index];

    return Slidable.builder(
      key: Key(item.title),
      controller: slidableController,
      direction: direction,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        closeOnCanceled: true,
        onWillDismiss: (item.index != 10)
            ? null
            : (actionType) {
          return showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Delete'),
                content: Text('Item will be deleted'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  TextButton(
                    child: Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            },
          ) as FutureOr<bool>;
        } as FutureOr<bool> Function(SlideActionType?)?,
        onDismissed: (actionType) {
          _showSnackBar(
              context,
              actionType == SlideActionType.primary
                  ? 'Dismiss Archive'
                  : 'Dimiss Delete');
          setState(() {
            items.removeAt(index);
          });
        },
      ),
      actionPane: _getActionPane(item.index)!,
      actionExtentRatio: 0.25,
      child: direction == Axis.horizontal
          ? VerticalListItem(items[index])
          : HorizontalListItem(items[index]),
      actionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return IconSlideAction(
                caption: 'Archive',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.blue.withOpacity(animation!.value)
                    : (renderingMode == SlidableRenderingMode.dismiss
                    ? Colors.blue
                    : Colors.green),
                icon: Icons.archive,
                onTap: () async {
                  var state = Slidable.of(context);
                  var dismiss = await (showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('archive'),
                        content: Text('Item will be archive'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Ok'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      );
                    },
                  ) as FutureOr<bool>);

                  if (dismiss) {
                    state!.dismiss();
                  }
                },
              );
            } else {
              return IconSlideAction(
                caption: 'Share',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.indigo.withOpacity(animation!.value)
                    : Colors.indigo,
                icon: Icons.share,
                onTap: () => _showSnackBar(context, 'Share'),
              );
            }
          }),
      secondaryActionDelegate: SlideActionBuilderDelegate(
          actionCount: 2,
          builder: (context, index, animation, renderingMode) {
            if (index == 0) {
              return IconSlideAction(
                caption: 'More',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.grey.shade200.withOpacity(animation!.value)
                    : Colors.grey.shade200,
                icon: Icons.more_horiz,
                onTap: () => _showSnackBar(context, 'More'),
                closeOnTap: false,
              );
            } else {
              return IconSlideAction(
                caption: 'Delete',
                color: renderingMode == SlidableRenderingMode.slide
                    ? Colors.red.withOpacity(animation!.value)
                    : Colors.red,
                icon: Icons.delete,
                onTap: () => _showSnackBar(context, 'Delete'),
              );
            }
          }),
    );
  }

  static Widget? _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }

  static Color? _getAvatarColor(int index) {
    switch (index % 4) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.indigoAccent;
      default:
        return null;
    }
  }

  static String? _getSubtitle(int index) {
    switch (index % 4) {
      case 0:
        return 'SlidableBehindActionPane';
      case 1:
        return 'SlidableStrechActionPane';
      case 2:
        return 'SlidableScrollActionPane';
      case 3:
        return 'SlidableDrawerActionPane';
      default:
        return null;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

class HorizontalListItem extends StatelessWidget {
  HorizontalListItem(this.item);
  final _HomeItem item;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 160.0,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: CircleAvatar(
              backgroundColor: item.color,
              child: Text('${item.index}'),
              foregroundColor: Colors.white,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                item.subtitle!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerticalListItem extends StatelessWidget {
  VerticalListItem(this.item);
  final _HomeItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
      Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
          ? Slidable.of(context)?.open()
          : Slidable.of(context)?.close(),
      child: Container(
        color: Colors.white,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: item.color,
            child: Text('${item.index}'),
            foregroundColor: Colors.white,
          ),
          title: Text(item.title),
          subtitle: Text(item.subtitle!),
        ),
      ),
    );
  }
}

class _HomeItem {
  const _HomeItem(
      this.index,
      this.title,
      this.subtitle,
      this.color,
      );

  final int index;
  final String title;
  final String? subtitle;
  final Color? color;
}



extension on ListTile{

  Slidable toNewSlidable({
    Key? key,
    required Widget actionPane,
    List<Widget>? actions,
    List<Widget>? secondaryActions,
    double showAllActionsThreshold = 0.5,
    double actionExtentRatio = 0.25,
    Duration movementDuration = const Duration(milliseconds: 200),
    Axis direction = Axis.horizontal,
    bool closeOnScroll = true,
    bool enabled = true,
    SlidableDismissal? dismissal,
    SlidableController? controller,
    double? fastThreshold,
  }) => Slidable.builder(
    key: key,
    child: this,
    actionPane: actionPane,
    actionDelegate: SlideActionListDelegate(actions: actions),
    secondaryActionDelegate:
    SlideActionListDelegate(actions: secondaryActions),
    showAllActionsThreshold: showAllActionsThreshold,
    actionExtentRatio: actionExtentRatio,
    movementDuration: movementDuration,
    direction: direction,
    closeOnScroll: closeOnScroll,
    enabled: enabled,
    dismissal: dismissal,
    controller: controller,
    fastThreshold: fastThreshold,
  );

  Slidable toSlidable({
    Key? key,
    required Widget actionPane,
    List<Widget>? actions,
    List<Widget>? secondaryActions,
    double showAllActionsThreshold = 0.5,
    double actionExtentRatio = 0.25,
    Duration movementDuration = const Duration(milliseconds: 200),
    Axis direction = Axis.horizontal,
    bool closeOnScroll = true,
    bool enabled = true,
    SlidableDismissal? dismissal,
    SlidableController? controller,
    double? fastThreshold,
  }) => Slidable.builder(
    key: key,
    child: this,
    actionPane: actionPane,
    actionDelegate: SlideActionListDelegate(actions: actions),
    secondaryActionDelegate:
    SlideActionListDelegate(actions: secondaryActions),
    showAllActionsThreshold: showAllActionsThreshold,
    actionExtentRatio: actionExtentRatio,
    movementDuration: movementDuration,
    direction: direction,
    closeOnScroll: closeOnScroll,
    enabled: enabled,
    dismissal: dismissal,
    controller: controller,
    fastThreshold: fastThreshold,
  );
}