//
//  enhance_stepper.dart
//  flutter_templet_project
//
//  Created by shang on 7/2/21 10:57 AM.
//  Copyright © 7/2/21 shang. All rights reserved.
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Defines the [Stepper]'s titles position when the [type] is [StepperType.horizontal].
enum HorizontalTitlePosition {
  /// A horizontal layout of the steps with their titles position.
  inline,

  /// A horizontal layout of the steps with their titles position.
  bottom,
}

/// Defines the [Stepper]'s separator position when the [type] is [StepperType.horizontal].
enum HorizontalLinePosition {
  /// A horizontal layout of the steps with their separator position in-between the titles.
  center,

  /// A horizontal layout of the steps with their separator position in-between the titles.
  top,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;
const double _kTriangleHeight =
    _kStepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0

/// A material step used in [Stepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
///
/// See also:
///
///  * [Stepper]
///  * <https://material.io/archive/guidelines/components/steppers.html>
@immutable
class EnhanceStep {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const EnhanceStep({
    this.icon,
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive = false,
  });

  /// The icon of the step.
  final Widget? icon;

  /// The title of the step that typically describes it.
  final Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  final Widget? subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;
}

/// A material stepper widget that displays progress through a sequence of
/// steps. Steppers are particularly useful in the case of forms where one step
/// requires the completion of another one, or where multiple steps need to be
/// completed in order to submit the whole form.
///
/// The widget is a flexible wrapper. A parent class should pass [currentStep]
/// to this widget based on some logic triggered by the three callbacks that it
/// provides.
///
/// {@tool sample --template=stateful_widget_scaffold_center}
///
/// ```dart
///
/// StepperType _type = StepperType.vertical;
///
/// List<Tuple2> tuples = [
///   Tuple2(Icons.directions_bike, StepState.indexed, ),
///   Tuple2(Icons.directions_bus, StepState.editing, ),
///   Tuple2(Icons.directions_railway, StepState.complete, ),
///   Tuple2(Icons.directions_car, StepState.disabled, ),
///   Tuple2(Icons.directions_boat, StepState.error, ),
/// ];

/// int _index = 0;
///
/// @override
/// Widget build(BuildContext context) {
/// return EnhanceStepper(
///     stepSize: 40,
///     type: _type,
///     horizontalTitlePosition: HorizontalTitlePosition.bottom,
///     horizontalLinePosition: HorizontalLinePosition.top,
///     currentStep: _index,
///     physics: ClampingScrollPhysics(),
///     steps: tuples.map((e) => EnhanceStep(
///       icon: Icon(e.item1, color: Colors.blue, size: 40,),
///       state: StepState.values[tuples.indexOf(e)],
///       isActive: _index == tuples.indexOf(e),
///       horizontalLinePosition = HorizontalLinePosition.top,
///       title: Text("step ${tuples.indexOf(e)}"),
///       subtitle: Text("subtitle_${tuples.indexOf(e)}_${e.item2.toString()}",),
///       content: Text("Content for Step ${tuples.indexOf(e)}"),
///     )).toList(),
///     onStepCancel: () {
///       go(-1);
///     },
///     onStepContinue: () {
///       go(1);
///     },
///     onStepTapped: (index) {
///       ddlog(index);
///       setState(() {
///         _index = index;
///       });
///     },
///     controlsBuilder: (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }){
///       return Row(
///         children: [
///           SizedBox(height: 30,),
///           ElevatedButton(
///             onPressed: onStepContinue,
///             child: Text("Next"),
///           ),
///           SizedBox(width: 8,),
///           TextButton(onPressed: onStepCancel, child: Text("Back"), ),
///         ],
///       );
///     }
/// );
/// }
///
///   void go(int index) {
///      if (index == -1 && _index <= 0 ) {
///        ddlog("it's first Step!");
///        return;
///      }
///
///      if (index == 1 && _index >= titles.length - 1) {
///        ddlog("it's last Step!");
///        return;
///      }
///
///      setState(() {
///        _index += index;
///      });
///    }
/// ```
///
/// {@end-tool}
///
/// See also:
///
///  * [Step]
///  * <https://material.io/archive/guidelines/components/steppers.html>
class EnhanceStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps], [type], and [currentStep] arguments must not be null.
  const EnhanceStepper({
    Key? key,
    required this.steps,
    this.physics,
    this.stepIconSize = _kStepSize,
    this.type = StepperType.vertical,
    this.horizontalTitlePosition = HorizontalTitlePosition.inline,
    this.horizontalLinePosition = HorizontalLinePosition.top,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  })  : assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  /// The steps of the stepper whose titles, subtitles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<EnhanceStep> steps;

  /// The steps of the stepper icons size.
  final double? stepIconSize;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The type of stepper that determines the layout. In the case of
  /// [StepperType.horizontal], the content of the current step is displayed
  /// underneath as opposed to the [StepperType.vertical] case where it is
  /// displayed in-between.
  final StepperType type;

  /// [StepperType.horizontal], Title and subtitle below the StepIcon. The default value is `HorizontalTitlePosition.inline`.
  final HorizontalTitlePosition horizontalTitlePosition;

  /// [StepperType.horizontal], the steps with their in-between the separator position. The default value is `HorizontalLinePosition.center`.
  final HorizontalLinePosition horizontalLinePosition;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepContinue;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepCancel;

  /// The callback for creating custom controls.
  ///
  /// If null, the default controls from the current theme will be used.
  ///
  /// This callback which takes in a context and two functions: [onStepContinue]
  /// and [onStepCancel]. These can be used to control the stepper.
  /// For example, keeping track of the [currentStep] within the callback can
  /// change the text of the continue or cancel button depending on which step users are at.
  ///
  /// {@tool dartpad --template=stateless_widget_scaffold}
  /// Creates a stepper control with custom buttons.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return Stepper(
  ///     controlsBuilder:
  ///       (BuildContext context, { VoidCallback? onStepContinue, VoidCallback? onStepCancel }) {
  ///          return Row(
  ///            children: <Widget>[
  ///              TextButton(
  ///                onPressed: onStepContinue,
  ///                child: const Text('NEXT'),
  ///              ),
  ///              TextButton(
  ///                onPressed: onStepCancel,
  ///                child: const Text('CANCEL'),
  ///              ),
  ///            ],
  ///          );
  ///       },
  ///     steps: const <Step>[
  ///       Step(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       Step(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  final ControlsWidgetBuilder? controlsBuilder;

  @override
  State<EnhanceStepper> createState() => _EnhanceStepperState();
}

class _EnhanceStepperState extends State<EnhanceStepper>
    with TickerProviderStateMixin {
  late List<GlobalKey> _keys;
  final Map<int, StepState> _oldStates = <int, StepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (var i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(EnhanceStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (var i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _isFirst(int index) => index == 0;

  bool _isLast(int index) => widget.steps.length - 1 == index;

  bool _isCurrent(int index) => widget.currentStep == index;

  bool _isDark() => Theme.of(context).brightness == Brightness.dark;

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 16.0,
      color: Colors.grey.shade400,
      // color: Colors.red,
    );
  }

  Widget _buildicon(int index, bool oldState) {
    final state = oldState ? _oldStates[index]! : widget.steps[index].state;
    final isDarkActive = _isDark() && widget.steps[index].isActive;

    if (widget.steps[index].icon != null && state != StepState.error) {
      return widget.steps[index].icon!;
    }

    switch (state) {
      case StepState.indexed:
      case StepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case StepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case StepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Color _circleColor(int index) {
    final colorScheme = Theme.of(context).colorScheme;
    if (!_isDark()) {
      return widget.steps[index].isActive
          ? colorScheme.primary
          : colorScheme.onSurface.withOpacity(0.38);
    } else {
      return widget.steps[index].isActive
          ? colorScheme.secondary
          : colorScheme.background;
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    var step = widget.steps[index];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: widget.stepIconSize,
      height: widget.stepIconSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: step.icon != null ? null : _circleColor(index),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildicon(index, oldState && step.state == StepState.error),
        ),
      ),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: widget.stepIconSize,
      height: widget.stepIconSize,
      child: Center(
        child: SizedBox(
          width: widget.stepIconSize,
          height: _kTriangleHeight,
          // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(0.0, 0.8),
              // 0.8 looks better than the geometrical 0.33.
              child: _buildicon(index,
                  oldState && widget.steps[index].state != StepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == StepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != StepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildTriangle(index, false);
      }
    }
  }

  Widget _buildVerticalControls(int stepIndex) {
    if (widget.controlsBuilder != null) {
      return widget.controlsBuilder!(
        context,
        ControlsDetails(
          currentStep: widget.currentStep,
          onStepContinue: widget.onStepContinue,
          onStepCancel: widget.onStepCancel,
          stepIndex: stepIndex,
        ),
      );
    }

    final Color cancelColor;
    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    final themeData = Theme.of(context);
    final colorScheme = themeData.colorScheme;
    final localizations = MaterialLocalizations.of(context);

    const OutlinedBorder buttonShape = RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)));
    const buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(height: 48.0),
        child: Row(
          // The Material spec no longer includes a Stepper widget. The continue
          // and cancel button styles have been configured to match the original
          // version of this widget.
          children: <Widget>[
            TextButton(
              onPressed: widget.onStepContinue,
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return states.contains(MaterialState.disabled)
                      ? null
                      : (_isDark()
                          ? colorScheme.onSurface
                          : colorScheme.onPrimary);
                }),
                backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return _isDark() || states.contains(MaterialState.disabled)
                      ? null
                      : colorScheme.primary;
                }),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    buttonPadding),
                shape: MaterialStateProperty.all<OutlinedBorder>(buttonShape),
              ),
              child: Text(localizations.continueButtonLabel),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: TextButton(
                onPressed: widget.onStepCancel,
                style: TextButton.styleFrom(
                  foregroundColor: cancelColor,
                  padding: buttonPadding,
                  shape: buttonShape,
                ),
                child: Text(localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        // case StepState.customIcon:
        return textTheme.bodyLarge!;
      case StepState.disabled:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  TextStyle _subtitleStyle(int index) {
    final themeData = Theme.of(context);
    final textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case StepState.indexed:
      case StepState.editing:
      case StepState.complete:
        // case StepState.customIcon:
        return textTheme.bodySmall!;
      case StepState.disabled:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case StepState.error:
        return textTheme.bodySmall!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: widget.type == StepperType.horizontal &&
              widget.horizontalTitlePosition == HorizontalTitlePosition.bottom
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: _subtitleStyle(index),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.steps[index].subtitle!,
            ),
          ),
      ],
    );
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index)),
              _buildIcon(index),
              _buildLine(!_isLast(index)),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 12.0),
              child: _buildHeaderText(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 24.0,
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: widget.stepIconSize,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0,
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(index),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: <Widget>[
        for (int i = 0; i < widget.steps.length; i += 1)
          Column(
            key: _keys[i],
            children: <Widget>[
              InkWell(
                onTap: widget.steps[i].state != StepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext!,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        widget.onStepTapped?.call(i);
                      }
                    : null,
                canRequestFocus: widget.steps[i].state != StepState.disabled,
                child: _buildVerticalHeader(i),
              ),
              _buildVerticalBody(i),
            ],
          ),
      ],
    );
  }

  Widget _buildHorizontalBottom(int i) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 48.0,
          child: Center(
            child: _buildIcon(i),
          ),
        ),
        Container(
          child: _buildHeaderText(i),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != StepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != StepState.disabled,
          child: widget.type == StepperType.horizontal &&
                  widget.horizontalTitlePosition ==
                      HorizontalTitlePosition.bottom
              ? _buildHorizontalBottom(i)
              : Row(
                  children: <Widget>[
                    SizedBox(
                      height: 72.0,
                      child: Center(
                        child: _buildIcon(i),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsetsDirectional.only(start: 12.0),
                      child: _buildHeaderText(i),
                    ),
                  ],
                ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  height: 1.0,
                  color: Colors.grey.shade400,
                ),
                if (widget.type == StepperType.horizontal &&
                    widget.horizontalLinePosition ==
                        HorizontalLinePosition.top &&
                    widget.horizontalTitlePosition ==
                        HorizontalTitlePosition.bottom)
                  const SizedBox(height: 44)
                else
                  const SizedBox(height: 0),
              ],
            ),
          ),
      ],
    ];

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: children,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            physics: widget.physics,
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                child: widget.steps[widget.currentStep].content,
              ),
              _buildVerticalControls(widget.currentStep),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          'Steppers must not be nested.\n'
          'The material specification advises that one should avoid embedding '
          'steppers within steppers. '
          'https://material.io/archive/guidelines/components/steppers.html#steppers-usage',
        );
      }
      return true;
    }());

    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
        return _buildHorizontal();
    }
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({
    required this.color,
  });

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final base = size.width;
    final halfBase = size.width / 2.0;
    final height = size.height;
    final points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}
