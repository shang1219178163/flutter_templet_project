//
//  NAnimatedSlider.dart
//  flutter_templet_project
//
//  Created by shang on 2025/12/14 09:55.
//  Copyright © 2025/12/14 shang. All rights reserved.
//

import 'package:flutter/material.dart';

class AnimatedSlider extends StatefulWidget {
  const AnimatedSlider({
    super.key,
    this.controller,
    this.value = 0,
    this.min = 0.0,
    this.max = 1.0,
    required this.onChanged,
  });

  final AnimatedSliderController? controller;

  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;

  @override
  State<AnimatedSlider> createState() => _AnimatedSliderState();
}

class _AnimatedSliderState extends State<AnimatedSlider> with SingleTickerProviderStateMixin {
  late final AnimationController _annmController;
  late Animation<double> _animation;

  double _value = 0;

  @override
  void dispose() {
    widget.controller?._detach(this);
    _annmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.controller?._attach(this);
    _annmController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void animateTo(double target) {
    _value = widget.value;
    _animation = Tween<double>(
      begin: _value,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _annmController,
        curve: Curves.easeOut,
      ),
    )..addListener(() {
        _value = _animation.value;
        setState(() {});
      });

    _annmController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _value,
      min: widget.min,
      max: widget.max,
      onChanged: (v) {
        _annmController.stop(); // 手势优先
        _value = v;
        setState(() {});
        widget.onChanged?.call(v);
      },
    );
  }
}

class AnimatedSliderController {
  _AnimatedSliderState? _anchor;

  void _attach(_AnimatedSliderState anchor) {
    _anchor = anchor;
  }

  void _detach(_AnimatedSliderState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void animateTo(double target) {
    assert(_anchor != null);
    _anchor?.animateTo(target);
  }
}
