// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';

// Extracted from https://developer.apple.com/design/resources/.

// Minimum padding from edges of the segmented control to edges of
// encompassing widget.
const EdgeInsetsGeometry _kHorizontalItemPadding =
    EdgeInsets.symmetric(vertical: 2, horizontal: 3);

// The corner radius of the thumb.
// const Radius _kThumbRadius = Radius.circular(6.93);
// The amount of space by which to expand the thumb from the size of the currently
// selected child.
const EdgeInsets _kThumbInsets = EdgeInsets.symmetric(horizontal: 1);

// Minimum height of the segmented control.
const double _kMinSegmentedControlHeight = 28.0;

const Color _kSeparatorColor = Color(0x4D8E8E93);

const CupertinoDynamicColor _kThumbColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFFFFFFFF),
  darkColor: Color(0xFF636366),
);

// The amount of space by which to inset each separator.
const EdgeInsets _kSeparatorInset = EdgeInsets.symmetric(vertical: 6);
const double _kSeparatorWidth = 1;
const Radius _kSeparatorRadius = Radius.circular(_kSeparatorWidth / 2);

// The minimum scale factor of the thumb, when being pressed on for a sufficient
// amount of time.
const double _kMinThumbScale = 0.95;

// The minimum horizontal distance between the edges of the separator and the
// closest child.
const double _kSegmentMinPadding = 9.25;

// The threshold value used in hasDraggedTooFar, for checking against the square
// L2 distance from the location of the current drag pointer, to the closest
// vertex of the CupertinoSlidingSegmentedControl's Rect.
//
// Both the mechanism and the value are speculated.
const double _kTouchYDistanceThreshold = 50.0 * 50.0;

// The corner radius of the segmented control.
//
// Inspected from iOS 13.2 simulator.
// const double _kCornerRadius = 8.0;

// The minimum opacity of an unselected segment, when the user presses on the
// segment and it starts to fadeout.
//
// Inspected from iOS 13.2 simulator.
const double _kContentPressedMinOpacity = 0.2;

// The spring animation used when the thumb changes its rect.
final SpringSimulation _kThumbSpringAnimationSimulation = SpringSimulation(
  const SpringDescription(mass: 1, stiffness: 503.551, damping: 44.8799),
  0,
  1,
  0, // Every time a new spring animation starts the previous animation stops.
);

const Duration _kSpringAnimationDuration = Duration(milliseconds: 412);

const Duration _kOpacityAnimationDuration = Duration(milliseconds: 470);

const Duration _kHighlightAnimationDuration = Duration(milliseconds: 200);

class _ENSegment<T> extends StatefulWidget {
  const _ENSegment({
    required ValueKey<T> key,
    required this.child,
    required this.pressed,
    required this.highlighted,
    required this.isDragging,
  }) : super(key: key);

  final Widget child;

  final bool pressed;
  final bool highlighted;

  // Whether the thumb of the parent widget (CupertinoSlidingSegmentedControl)
  // is currently being dragged.
  final bool isDragging;

  bool get shouldFadeoutContent => pressed && !highlighted;
  bool get shouldScaleContent => pressed && highlighted && isDragging;

  @override
  _ENSegmentState<T> createState() => _ENSegmentState<T>();
}

class _ENSegmentState<T> extends State<_ENSegment<T>>
    with TickerProviderStateMixin<_ENSegment<T>> {
  late final AnimationController highlightPressScaleController;
  late Animation<double> highlightPressScaleAnimation;

  @override
  void initState() {
    super.initState();
    highlightPressScaleController = AnimationController(
      duration: _kOpacityAnimationDuration,
      value: widget.shouldScaleContent ? 1 : 0,
      vsync: this,
    );

    highlightPressScaleAnimation = highlightPressScaleController.drive(
      Tween<double>(begin: 1.0, end: _kMinThumbScale),
    );
  }

  @override
  void didUpdateWidget(_ENSegment<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(oldWidget.key == widget.key);

    if (oldWidget.shouldScaleContent != widget.shouldScaleContent) {
      highlightPressScaleAnimation = highlightPressScaleController.drive(
        Tween<double>(
          begin: highlightPressScaleAnimation.value,
          end: widget.shouldScaleContent ? _kMinThumbScale : 1.0,
        ),
      );
      highlightPressScaleController
          .animateWith(_kThumbSpringAnimationSimulation);
    }
  }

  @override
  void dispose() {
    highlightPressScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MetaData(
      // Expand the hitTest area of this widget.
      behavior: HitTestBehavior.opaque,
      child: IndexedStack(
        alignment: Alignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity:
                widget.shouldFadeoutContent ? _kContentPressedMinOpacity : 1,
            duration: _kOpacityAnimationDuration,
            curve: Curves.ease,
            child: AnimatedDefaultTextStyle(
              style: DefaultTextStyle.of(context).style.merge(TextStyle(
                  fontWeight: widget.highlighted
                      ? FontWeight.w500
                      : FontWeight.normal)),
              duration: _kHighlightAnimationDuration,
              curve: Curves.ease,
              child: ScaleTransition(
                scale: highlightPressScaleAnimation,
                child: widget.child,
              ),
            ),
          ),
          // The entire widget will assume the size of this widget, so when a
          // segment's "highlight" animation plays the size of the parent stays
          // the same and will always be greater than equal to that of the
          // visible child (at index 0), to keep the size of the entire
          // SegmentedControl widget consistent throughout the animation.
          Offstage(
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontWeight: FontWeight.w500),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

// Fadeout the separator when either adjacent segment is highlighted.
class _ENSegmentSeparator extends StatefulWidget {
  const _ENSegmentSeparator({
    required ValueKey<int> key,
    required this.highlighted,
  }) : super(key: key);

  final bool highlighted;

  @override
  _ENSegmentSeparatorState createState() => _ENSegmentSeparatorState();
}

class _ENSegmentSeparatorState extends State<_ENSegmentSeparator>
    with TickerProviderStateMixin<_ENSegmentSeparator> {
  late final AnimationController separatorOpacityController;

  @override
  void initState() {
    super.initState();

    separatorOpacityController = AnimationController(
      duration: _kSpringAnimationDuration,
      value: widget.highlighted ? 0 : 1,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_ENSegmentSeparator oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(oldWidget.key == widget.key);

    if (oldWidget.highlighted != widget.highlighted) {
      separatorOpacityController.animateTo(
        widget.highlighted ? 0 : 1,
        duration: _kSpringAnimationDuration,
        curve: Curves.ease,
      );
    }
  }

  @override
  void dispose() {
    separatorOpacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: separatorOpacityController,
      child: const SizedBox(width: _kSeparatorWidth),
      builder: (BuildContext context, Widget? child) {
        return Padding(
          padding: _kSeparatorInset,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: _kSeparatorColor.withOpacity(
                  _kSeparatorColor.opacity * separatorOpacityController.value),
              borderRadius: const BorderRadius.all(_kSeparatorRadius),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

/// An iOS 13 style segmented control.
///
/// Displays the widgets provided in the [Map] of [children] in a horizontal list.
/// It allows the user to select between a number of mutually exclusive options,
/// by tapping or dragging within the segmented control.
///
/// A segmented control can feature any [Widget] as one of the values in its
/// [Map] of [children]. The type T is the type of the [Map] keys used to identify
/// each widget and determine which widget is selected. As required by the [Map]
/// class, keys must be of consistent types and must be comparable. The [children]
/// argument must be an ordered [Map] such as a [LinkedHashMap], the ordering of
/// the keys will determine the order of the widgets in the segmented control.
///
/// The widget calls the [onValueChanged] callback *when a valid user gesture
/// completes on an unselected segment*. The map key associated with the newly
/// selected widget is returned in the [onValueChanged] callback. Typically,
/// widgets that use a segmented control will listen for the [onValueChanged]
/// callback and rebuild the segmented control with a new [groupValue] to update
/// which option is currently selected.
///
/// The [children] will be displayed in the order of the keys in the [Map],
/// along the current [TextDirection]. Each child widget will have the same size.
/// The height of the segmented control is determined by the height of the
/// tallest child widget. The width of each child will be the intrinsic width of
/// the widest child, or the available horizontal space divided by the number of
/// [children], which ever is smaller.
///
/// A segmented control may optionally be created with custom colors. The
/// [thumbColor], [backgroundColor] arguments can be used to override the
/// segmented control's colors from its defaults.
///
/// {@tool dartpad}
/// This example shows a [CupertinoSlidingSegmentedControl] with an enum type.
///
/// The callback provided to [onValueChanged] should update the state of
/// the parent [StatefulWidget] using the [State.setState] method, so that
/// the parent gets rebuilt; for example:
///
/// ** See code in examples/api/lib/cupertino/segmented_control/cupertino_sliding_segmented_control.0.dart **
/// {@end-tool}
/// See also:
///
///  * <https://developer.apple.com/design/human-interface-guidelines/ios/controls/segmented-controls/>
class ENCupertinoSlidingSegmentedControl<T> extends StatefulWidget {
  /// Creates an iOS-style segmented control bar.
  ///
  /// The [children] argument must be an ordered [Map] such as a
  /// [LinkedHashMap]. Further, the length of the [children] list must be
  /// greater than one.
  ///
  /// Each widget value in the map of [children] must have an associated key
  /// that uniquely identifies this widget. This key is what will be returned
  /// in the [onValueChanged] callback when a new value from the [children] map
  /// is selected.
  ///
  /// The [groupValue] is the currently selected value for the segmented control.
  /// If no [groupValue] is provided, or the [groupValue] is null, no widget will
  /// appear as selected. The [groupValue] must be either null or one of the keys
  /// in the [children] map.
  ENCupertinoSlidingSegmentedControl({
    super.key,
    required this.children,
    required this.onValueChanged,
    this.groupValue,
    this.thumbColor = _kThumbColor,
    this.radius = const Radius.circular(6.93),
    this.padding = _kHorizontalItemPadding,
    this.height = 32,
    this.backgroundColor = CupertinoColors.tertiarySystemFill,
  })  : assert(children.length >= 2),
        assert(
          groupValue == null || children.keys.contains(groupValue),
          'The groupValue must be either null or one of the keys in the children map.',
        );

  /// The identifying keys and corresponding widget values in the
  /// segmented control.
  ///
  /// This attribute must be an ordered [Map] such as a [LinkedHashMap]. Each
  /// widget is typically a single-line [Text] widget or an [Icon] widget.
  ///
  /// The map must have more than one entry.
  final Map<T, Widget> children;

  /// The identifier of the widget that is currently selected.
  ///
  /// This must be one of the keys in the [Map] of [children].
  /// If this attribute is null, no widget will be initially selected.
  final T? groupValue;

  /// The callback that is called when a new option is tapped.
  ///
  /// The segmented control passes the newly selected widget's associated key
  /// to the callback but does not actually change state until the parent
  /// widget rebuilds the segmented control with the new [groupValue].
  ///
  /// The callback provided to [onValueChanged] should update the state of
  /// the parent [StatefulWidget] using the [State.setState] method, so that
  /// the parent gets rebuilt; for example:
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// class SegmentedControlExample extends StatefulWidget {
  ///   const SegmentedControlExample({super.key});
  ///
  ///   @override
  ///   State createState() => SegmentedControlExampleState();
  /// }
  ///
  /// class SegmentedControlExampleState extends State<SegmentedControlExample> {
  ///   final Map<int, Widget> children = const <int, Widget>{
  ///     0: Text('Child 1'),
  ///     1: Text('Child 2'),
  ///   };
  ///
  ///   int? currentValue;
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return ENCupertinoSlidingSegmentedControl<int>(
  ///       children: children,
  ///       onValueChanged: (int? newValue) {
  ///         setState(() {
  ///           currentValue = newValue;
  ///         });
  ///       },
  ///       groupValue: currentValue,
  ///     );
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  final ValueChanged<T?> onValueChanged;

  /// The color used to paint the rounded rect behind the [children] and the separators.
  ///
  /// The default value is [CupertinoColors.tertiarySystemFill]. The background
  /// will not be painted if null is specified.
  final Color backgroundColor;

  /// The color used to paint the interior of the thumb that appears behind the
  /// currently selected item.
  ///
  /// The default value is a [CupertinoDynamicColor] that appears white in light
  /// mode and becomes a gray color in dark mode.
  final Color thumbColor;

  final Radius radius;

  /// The amount of space by which to inset the [children].
  ///
  /// Defaults to `EdgeInsets.symmetric(vertical: 2, horizontal: 3)`.
  final EdgeInsetsGeometry padding;

  final double height;

  @override
  State<ENCupertinoSlidingSegmentedControl<T>> createState() =>
      _ENSegmentedControlState<T>();
}

class _ENSegmentedControlState<T>
    extends State<ENCupertinoSlidingSegmentedControl<T>>
    with TickerProviderStateMixin<ENCupertinoSlidingSegmentedControl<T>> {
  late final AnimationController thumbController = AnimationController(
      duration: _kSpringAnimationDuration, value: 0, vsync: this);
  Animatable<Rect?>? thumbAnimatable;

  late final AnimationController thumbScaleController = AnimationController(
      duration: _kSpringAnimationDuration, value: 0, vsync: this);
  late Animation<double> thumbScaleAnimation =
      thumbScaleController.drive(Tween<double>(begin: 1, end: _kMinThumbScale));

  final TapGestureRecognizer tap = TapGestureRecognizer();
  final HorizontalDragGestureRecognizer drag =
      HorizontalDragGestureRecognizer();
  final LongPressGestureRecognizer longPress = LongPressGestureRecognizer();

  @override
  void initState() {
    super.initState();
    // If the long press or horizontal drag recognizer gets accepted, we know for
    // sure the gesture is meant for the segmented control. Hand everything to
    // the drag gesture recognizer.
    final team = GestureArenaTeam();
    longPress.team = team;
    drag.team = team;
    team.captain = drag;

    drag
      ..onDown = onDown
      ..onUpdate = onUpdate
      ..onEnd = onEnd
      ..onCancel = onCancel;

    tap.onTapUp = onTapUp;

    // Empty callback to enable the long press recognizer.
    longPress.onLongPress = () {};

    highlighted = widget.groupValue;
  }

  @override
  void didUpdateWidget(ENCupertinoSlidingSegmentedControl<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Temporarily ignore highlight changes from the widget when the thumb is
    // being dragged. When the drag gesture finishes the widget will be forced
    // to build (see the onEnd method), and didUpdateWidget will be called again.
    if (!isThumbDragging && highlighted != widget.groupValue) {
      thumbController.animateWith(_kThumbSpringAnimationSimulation);
      thumbAnimatable = null;
      highlighted = widget.groupValue;
    }
  }

  @override
  void dispose() {
    thumbScaleController.dispose();
    thumbController.dispose();

    drag.dispose();
    tap.dispose();
    longPress.dispose();

    super.dispose();
  }

  // Whether the current drag gesture started on a selected segment. When this
  // flag is false, the `onUpdate` method does not update `highlighted`.
  // Otherwise the thumb can be dragged around in an ongoing drag gesture.
  bool? _startedOnSelectedSegment;

  // Whether an ongoing horizontal drag gesture that started on the thumb is
  // present. When true, defer/ignore changes to the `highlighted` variable
  // from other sources (except for semantics) until the gesture ends, preventing
  // them from interfering with the active drag gesture.
  bool get isThumbDragging => _startedOnSelectedSegment ?? false;

  // Converts local coordinate to segments. This method assumes each segment has
  // the same width.
  T segmentForXPosition(double dx) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final numOfChildren = widget.children.length;
    assert(renderBox.hasSize);
    assert(numOfChildren >= 2);
    var index = (dx ~/ (renderBox.size.width / numOfChildren))
        .clamp(0, numOfChildren - 1); // ignore_clamp_double_lint

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        index = numOfChildren - 1 - index;
    }

    return widget.children.keys.elementAt(index);
  }

  bool _hasDraggedTooFar(DragUpdateDetails details) {
    final renderBox = context.findRenderObject()! as RenderBox;
    assert(renderBox.hasSize);
    final size = renderBox.size;
    final offCenter =
        details.localPosition - Offset(size.width / 2, size.height / 2);
    final l2 =
        math.pow(math.max(0.0, offCenter.dx.abs() - size.width / 2), 2) +
                math.pow(math.max(0.0, offCenter.dy.abs() - size.height / 2), 2)
            as double;
    return l2 > _kTouchYDistanceThreshold;
  }

  // The thumb shrinks when the user presses on it, and starts expanding when
  // the user lets go.
  // This animation must be synced with the segment scale animation (see the
  // _Segment widget) to make the overall animation look natural when the thumb
  // is not sliding.
  void _playThumbScaleAnimation({required bool isExpanding}) {
    thumbScaleAnimation = thumbScaleController.drive(
      Tween<double>(
        begin: thumbScaleAnimation.value,
        end: isExpanding ? 1 : _kMinThumbScale,
      ),
    );
    thumbScaleController.animateWith(_kThumbSpringAnimationSimulation);
  }

  void onHighlightChangedByGesture(T newValue) {
    if (highlighted == newValue) {
      return;
    }
    setState(() {
      highlighted = newValue;
    });
    // Additionally, start the thumb animation if the highlighted segment
    // changes. If the thumbController is already running, the render object's
    // paint method will create a new tween to drive the animation with.
    // TODO(LongCatIsLooong): https://github.com/flutter/flutter/issues/74356:
    // the current thumb will be painted at the same location twice (before and
    // after the new animation starts).
    thumbController.animateWith(_kThumbSpringAnimationSimulation);
    thumbAnimatable = null;
  }

  void onPressedChangedByGesture(T? newValue) {
    if (pressed != newValue) {
      setState(() {
        pressed = newValue;
      });
    }
  }

  void onTapUp(TapUpDetails details) {
    // No gesture should interfere with an ongoing thumb drag.
    if (isThumbDragging) {
      return;
    }
    final segment = segmentForXPosition(details.localPosition.dx);
    onPressedChangedByGesture(null);
    if (segment != widget.groupValue) {
      widget.onValueChanged(segment);
    }
  }

  void onDown(DragDownDetails details) {
    final touchDownSegment = segmentForXPosition(details.localPosition.dx);
    _startedOnSelectedSegment = touchDownSegment == highlighted;
    onPressedChangedByGesture(touchDownSegment);

    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: false);
    }
  }

  void onUpdate(DragUpdateDetails details) {
    if (isThumbDragging) {
      final segment = segmentForXPosition(details.localPosition.dx);
      onPressedChangedByGesture(segment);
      onHighlightChangedByGesture(segment);
    } else {
      final segment = _hasDraggedTooFar(details)
          ? null
          : segmentForXPosition(details.localPosition.dx);
      onPressedChangedByGesture(segment);
    }
  }

  void onEnd(DragEndDetails details) {
    final pressed = this.pressed;
    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);
      if (highlighted != widget.groupValue) {
        widget.onValueChanged(highlighted);
      }
    } else if (pressed != null) {
      onHighlightChangedByGesture(pressed);
      assert(pressed == highlighted);
      if (highlighted != widget.groupValue) {
        widget.onValueChanged(highlighted);
      }
    }

    onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;
  }

  void onCancel() {
    if (isThumbDragging) {
      _playThumbScaleAnimation(isExpanding: true);
    }

    onPressedChangedByGesture(null);
    _startedOnSelectedSegment = null;
  }

  // The segment the sliding thumb is currently located at, or animating to. It
  // may have a different value from widget.groupValue, since this widget does
  // not report a selection change via `onValueChanged` until the user stops
  // interacting with the widget (onTapUp). For example, the user can drag the
  // thumb around, and the `onValueChanged` callback will not be invoked until
  // the thumb is let go.
  T? highlighted;

  // The segment the user is currently pressing.
  T? pressed;

  @override
  Widget build(BuildContext context) {
    assert(widget.children.length >= 2);
    var children = <Widget>[];
    var isPreviousSegmentHighlighted = false;

    var index = 0;
    int? highlightedIndex;
    for (final entry in widget.children.entries) {
      final isHighlighted = highlighted == entry.key;
      if (isHighlighted) {
        highlightedIndex = index;
      }

      if (index != 0) {
        children.add(
          _ENSegmentSeparator(
            // Let separators be TextDirection-invariant. If the TextDirection
            // changes, the separators should mostly stay where they were.
            key: ValueKey<int>(index),
            highlighted: isPreviousSegmentHighlighted || isHighlighted,
          ),
        );
      }

      children.add(
        Semantics(
          button: true,
          onTap: () {
            widget.onValueChanged(entry.key);
          },
          inMutuallyExclusiveGroup: true,
          selected: widget.groupValue == entry.key,
          child: MouseRegion(
            cursor: kIsWeb ? SystemMouseCursors.click : MouseCursor.defer,
            child: _ENSegment<T>(
              key: ValueKey<T>(entry.key),
              highlighted: isHighlighted,
              pressed: pressed == entry.key,
              isDragging: isThumbDragging,
              child: entry.value,
            ),
          ),
        ),
      );

      index += 1;
      isPreviousSegmentHighlighted = isHighlighted;
    }

    assert((highlightedIndex == null) == (highlighted == null));

    switch (Directionality.of(context)) {
      case TextDirection.ltr:
        break;
      case TextDirection.rtl:
        children = children.reversed.toList(growable: false);
        if (highlightedIndex != null) {
          highlightedIndex = index - 1 - highlightedIndex;
        }
    }

    return UnconstrainedBox(
      constrainedAxis: Axis.horizontal,
      child: Container(
        padding: widget.padding.resolve(Directionality.of(context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(widget.radius),
          color: CupertinoDynamicColor.resolve(widget.backgroundColor, context),
        ),
        child: AnimatedBuilder(
          animation: thumbScaleAnimation,
          builder: (BuildContext context, Widget? child) {
            return _ENSegmentedControlRenderWidget<T>(
              highlightedIndex: highlightedIndex,
              thumbColor:
                  CupertinoDynamicColor.resolve(widget.thumbColor, context),
              thumbScale: thumbScaleAnimation.value,
              radius: widget.radius,
              state: this,
              children: children,
            );
          },
        ),
      ),
    );
  }
}

class _ENSegmentedControlRenderWidget<T> extends MultiChildRenderObjectWidget {
  const _ENSegmentedControlRenderWidget({
    super.key,
    super.children,
    required this.highlightedIndex,
    required this.thumbColor,
    required this.thumbScale,
    required this.radius,
    required this.state,
  });

  final int? highlightedIndex;
  final Color thumbColor;
  final double thumbScale;
  final Radius radius;
  final _ENSegmentedControlState<T> state;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ENRenderSegmentedControl<T>(
      highlightedIndex: highlightedIndex,
      thumbColor: thumbColor,
      thumbScale: thumbScale,
      radius: radius,
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _ENRenderSegmentedControl<T> renderObject) {
    assert(renderObject.state == state);
    renderObject
      ..thumbColor = thumbColor
      ..thumbScale = thumbScale
      ..highlightedIndex = highlightedIndex;
  }
}

class _ENSegmentedControlContainerBoxParentData
    extends ContainerBoxParentData<RenderBox> {}

// The behavior of a UISegmentedControl as observed on iOS 13.1:
//
// 1. Tap up inside events will set the current selected index to the index of the
//    segment at the tap up location instantaneously (there might be animation but
//    the index change seems to happen before animation finishes), unless the tap
//    down event from the same touch event didn't happen within the segmented
//    control, in which case the touch event will be ignored entirely (will be
//    referring to these touch events as invalid touch events below).
//
// 2. A valid tap up event will also trigger the sliding CASpringAnimation (even
//    when it lands on the current segment), starting from the current `frame`
//    of the thumb. The previous sliding animation, if still playing, will be
//    removed and its velocity reset to 0. The sliding animation has a fixed
//    duration, regardless of the distance or transform.
//
// 3. When the sliding animation plays two other animations take place. In one animation
//    the content of the current segment gradually becomes "highlighted", turning the
//    font weight to semibold (CABasicAnimation, timingFunction = default, duration = 0.2).
//    The other is the separator fadein/fadeout animation (duration = 0.41).
//
// 4. A tap down event on the segment pointed to by the current selected
//    index will trigger a CABasicAnimation that shrinks the thumb to 95% of its
//    original size, even if the sliding animation is still playing. The
///   corresponding tap up event inverts the process (eyeballed).
//
// 5. A tap down event on other segments will trigger a CABasicAnimation
//    (timingFunction = default, duration = 0.47.) that fades out the content
//    from its current alpha, eventually reducing the alpha of that segment to
//    20% unless interrupted by a tap up event or the pointer moves out of the
//    region (either outside of the segmented control's vicinity or to a
//    different segment). The reverse animation has the same duration and timing
//    function.
class _ENRenderSegmentedControl<T> extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            ContainerBoxParentData<RenderBox>>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            ContainerBoxParentData<RenderBox>> {
  _ENRenderSegmentedControl({
    required int? highlightedIndex,
    required Color thumbColor,
    required double thumbScale,
    required Radius radius,
    required this.state,
  })  : _highlightedIndex = highlightedIndex,
        _thumbColor = thumbColor,
        _thumbScale = thumbScale,
        _radius = radius;

  final _ENSegmentedControlState<T> state;

  // The current **Unscaled** Thumb Rect in this RenderBox's coordinate space.
  Rect? currentThumbRect;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    state.thumbController.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    state.thumbController.removeListener(markNeedsPaint);
    super.detach();
  }

  double get thumbScale => _thumbScale;
  double _thumbScale;
  set thumbScale(double value) {
    if (_thumbScale == value) {
      return;
    }

    _thumbScale = value;
    if (state.highlighted != null) {
      markNeedsPaint();
    }
  }

  int? get highlightedIndex => _highlightedIndex;
  int? _highlightedIndex;
  set highlightedIndex(int? value) {
    if (_highlightedIndex == value) {
      return;
    }

    _highlightedIndex = value;
    markNeedsPaint();
  }

  Color get thumbColor => _thumbColor;
  Color _thumbColor;
  set thumbColor(Color value) {
    if (_thumbColor == value) {
      return;
    }
    _thumbColor = value;
    markNeedsPaint();
  }

  Radius get radius => _radius;
  Radius _radius;
  set radius(Radius value) {
    if (_radius == value) {
      return;
    }
    _radius = value;
    markNeedsPaint();
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    // No gesture should interfere with an ongoing thumb drag.
    if (event is PointerDownEvent && !state.isThumbDragging) {
      state.tap.addPointer(event);
      state.longPress.addPointer(event);
      state.drag.addPointer(event);
    }
  }

  // Intrinsic Dimensions

  double get totalSeparatorWidth =>
      (_kSeparatorInset.horizontal + _kSeparatorWidth) * (childCount ~/ 2);

  RenderBox? nonSeparatorChildAfter(RenderBox child) {
    final nextChild = childAfter(child);
    return nextChild == null ? null : childAfter(nextChild);
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final childCount = this.childCount ~/ 2 + 1;
    var child = firstChild;
    var maxMinChildWidth = 0.0;
    while (child != null) {
      final childWidth = child.getMinIntrinsicWidth(height);
      maxMinChildWidth = math.max(maxMinChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }
    return (maxMinChildWidth + 2 * _kSegmentMinPadding) * childCount +
        totalSeparatorWidth;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final childCount = this.childCount ~/ 2 + 1;
    var child = firstChild;
    var maxMaxChildWidth = 0.0;
    while (child != null) {
      final childWidth = child.getMaxIntrinsicWidth(height);
      maxMaxChildWidth = math.max(maxMaxChildWidth, childWidth);
      child = nonSeparatorChildAfter(child);
    }
    return (maxMaxChildWidth + 2 * _kSegmentMinPadding) * childCount +
        totalSeparatorWidth;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    var child = firstChild;
    var maxMinChildHeight = _kMinSegmentedControlHeight;
    while (child != null) {
      final childHeight = child.getMinIntrinsicHeight(width);
      maxMinChildHeight = math.max(maxMinChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }
    return maxMinChildHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    var child = firstChild;
    var maxMaxChildHeight = _kMinSegmentedControlHeight;
    while (child != null) {
      final childHeight = child.getMaxIntrinsicHeight(width);
      maxMaxChildHeight = math.max(maxMaxChildHeight, childHeight);
      child = nonSeparatorChildAfter(child);
    }
    return maxMaxChildHeight;
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ENSegmentedControlContainerBoxParentData) {
      child.parentData = _ENSegmentedControlContainerBoxParentData();
    }
  }

  Size _calculateChildSize(BoxConstraints constraints) {
    final childCount = this.childCount ~/ 2 + 1;
    var childWidth =
        (constraints.minWidth - totalSeparatorWidth) / childCount;
    var maxHeight = _kMinSegmentedControlHeight;
    var child = firstChild;
    while (child != null) {
      childWidth = math.max(
          childWidth,
          child.getMaxIntrinsicWidth(double.infinity) +
              2 * _kSegmentMinPadding);
      child = nonSeparatorChildAfter(child);
    }
    childWidth = math.min(
      childWidth,
      (constraints.maxWidth - totalSeparatorWidth) / childCount,
    );
    child = firstChild;
    while (child != null) {
      final boxHeight = child.getMaxIntrinsicHeight(childWidth);
      maxHeight = math.max(maxHeight, boxHeight);
      child = nonSeparatorChildAfter(child);
    }
    return Size(childWidth, maxHeight);
  }

  Size _computeOverallSizeFromChildSize(
      Size childSize, BoxConstraints constraints) {
    final childCount = this.childCount ~/ 2 + 1;
    return constraints.constrain(Size(
        childSize.width * childCount + totalSeparatorWidth, childSize.height));
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final childSize = _calculateChildSize(constraints);
    return _computeOverallSizeFromChildSize(childSize, constraints);
  }

  @override
  void performLayout() {
    final constraints = this.constraints;
    final childSize = _calculateChildSize(constraints);
    final childConstraints = BoxConstraints.tight(childSize);
    final separatorConstraints =
        childConstraints.heightConstraints();

    var child = firstChild;
    var index = 0;
    var start = 0.0;
    while (child != null) {
      child.layout(index.isEven ? childConstraints : separatorConstraints,
          parentUsesSize: true);
      final childParentData =
          child.parentData! as _ENSegmentedControlContainerBoxParentData;
      final childOffset = Offset(start, 0);
      childParentData.offset = childOffset;
      start += child.size.width;
      assert(
        index.isEven ||
            child.size.width == _kSeparatorWidth + _kSeparatorInset.horizontal,
        '${child.size.width} != ${_kSeparatorWidth + _kSeparatorInset.horizontal}',
      );
      child = childAfter(child);
      index += 1;
    }

    size = _computeOverallSizeFromChildSize(childSize, constraints);
  }

  // This method is used to convert the original unscaled thumb rect painted in
  // the previous frame, to a Rect that is within the valid boundary defined by
  // the child segments.
  //
  // The overall size does not include that of the thumb. That is, if the thumb
  // is located at the first or the last segment, the thumb can get cut off if
  // one of the values in _kThumbInsets is positive.
  Rect? moveThumbRectInBound(Rect? thumbRect, List<RenderBox> children) {
    assert(hasSize);
    assert(children.length >= 2);
    if (thumbRect == null) {
      return null;
    }

    final firstChildOffset = (children.first.parentData!
            as _ENSegmentedControlContainerBoxParentData)
        .offset;
    final leftMost = firstChildOffset.dx;
    final rightMost =
        (children.last.parentData! as _ENSegmentedControlContainerBoxParentData)
                .offset
                .dx +
            children.last.size.width;
    assert(rightMost > leftMost);

    // Ignore the horizontal position and the height of `thumbRect`, and
    // calculates them from `children`.
    return Rect.fromLTRB(
      math.max(thumbRect.left, leftMost - _kThumbInsets.left),
      firstChildOffset.dy - _kThumbInsets.top,
      math.min(thumbRect.right, rightMost + _kThumbInsets.right),
      firstChildOffset.dy + children.first.size.height + _kThumbInsets.bottom,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final children = getChildrenAsList();

    for (var index = 1; index < childCount; index += 2) {
      _paintSeparator(context, offset, children[index]);
    }

    final highlightedChildIndex = highlightedIndex;
    // Paint thumb if there's a highlighted segment.
    if (highlightedChildIndex != null) {
      final selectedChild = children[highlightedChildIndex * 2];

      final childParentData =
          selectedChild.parentData!
              as _ENSegmentedControlContainerBoxParentData;
      final newThumbRect = _kThumbInsets
          .inflateRect(childParentData.offset & selectedChild.size);

      // Update thumb animation's tween, in case the end rect changed (e.g., a
      // new segment is added during the animation).
      if (state.thumbController.isAnimating) {
        final thumbTween = state.thumbAnimatable;
        if (thumbTween == null) {
          // This is the first frame of the animation.
          final startingRect =
              moveThumbRectInBound(currentThumbRect, children) ?? newThumbRect;
          state.thumbAnimatable =
              RectTween(begin: startingRect, end: newThumbRect);
        } else if (newThumbRect != thumbTween.transform(1)) {
          // The thumbTween of the running sliding animation needs updating,
          // without restarting the animation.
          final startingRect =
              moveThumbRectInBound(currentThumbRect, children) ?? newThumbRect;
          state.thumbAnimatable =
              RectTween(begin: startingRect, end: newThumbRect).chain(
                  CurveTween(curve: Interval(state.thumbController.value, 1)));
        }
      } else {
        state.thumbAnimatable = null;
      }

      final unscaledThumbRect =
          state.thumbAnimatable?.evaluate(state.thumbController) ??
              newThumbRect;
      currentThumbRect = unscaledThumbRect;
      final thumbRect = Rect.fromCenter(
        center: unscaledThumbRect.center,
        width: unscaledThumbRect.width * thumbScale,
        height: unscaledThumbRect.height * thumbScale,
      );

      _paintThumb(context, offset, thumbRect);
    } else {
      currentThumbRect = null;
    }

    for (var index = 0; index < children.length; index += 2) {
      _paintChild(context, offset, children[index]);
    }
  }

  // Paint the separator to the right of the given child.
  final Paint separatorPaint = Paint();
  void _paintSeparator(
      PaintingContext context, Offset offset, RenderBox child) {
    final childParentData =
        child.parentData! as _ENSegmentedControlContainerBoxParentData;
    context.paintChild(child, offset + childParentData.offset);
  }

  void _paintChild(PaintingContext context, Offset offset, RenderBox child) {
    final childParentData =
        child.parentData! as _ENSegmentedControlContainerBoxParentData;
    context.paintChild(child, childParentData.offset + offset);
  }

  void _paintThumb(PaintingContext context, Offset offset, Rect thumbRect) {
    // Colors extracted from https://developer.apple.com/design/resources/.
    const thumbShadow = <BoxShadow>[
      BoxShadow(
        color: Color(0x1F000000),
        offset: Offset(0, 3),
        blurRadius: 8,
      ),
      BoxShadow(
        color: Color(0x0A000000),
        offset: Offset(0, 3),
        blurRadius: 1,
      ),
    ];

    final thumbRRect =
        RRect.fromRectAndRadius(thumbRect.shift(offset), radius);

    for (final shadow in thumbShadow) {
      context.canvas
          .drawRRect(thumbRRect.shift(shadow.offset), shadow.toPaint());
    }

    context.canvas.drawRRect(
      thumbRRect.inflate(0.5),
      Paint()..color = const Color(0x0A000000),
    );

    context.canvas.drawRRect(
      thumbRRect,
      Paint()..color = thumbColor,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    var child = lastChild;
    while (child != null) {
      final childParentData =
          child.parentData! as _ENSegmentedControlContainerBoxParentData;
      if ((childParentData.offset & child.size).contains(position)) {
        return result.addWithPaintOffset(
          offset: childParentData.offset,
          position: position,
          hitTest: (BoxHitTestResult result, Offset localOffset) {
            assert(localOffset == position - childParentData.offset);
            return child!.hitTest(result, position: localOffset);
          },
        );
      }
      child = childParentData.previousSibling;
    }
    return false;
  }
}
