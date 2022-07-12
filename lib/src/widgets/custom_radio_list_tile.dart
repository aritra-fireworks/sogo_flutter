import 'package:flutter/material.dart';

class CustomRadioListTile<T> extends StatelessWidget {

  const CustomRadioListTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.toggleable = false,
    this.activeColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.autofocus = false,
    this.contentPadding,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
  }) : assert(toggleable != null),
        assert(isThreeLine != null),
        assert(!isThreeLine || subtitle != null),
        assert(selected != null),
        assert(controlAffinity != null),
        assert(autofocus != null),
        super(key: key);

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final bool toggleable;
  final Color? activeColor;
  final Widget? title;
  final Widget? subtitle;
  final Widget? secondary;
  final bool isThreeLine;
  final bool? dense;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  bool get checked => value == groupValue;
  final ShapeBorder? shape;
  final Color? tileColor;
  final Color? selectedTileColor;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool? enableFeedback;

  @override
  Widget build(BuildContext context) {
    final Widget control = CustomRadio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      toggleable: toggleable,
      activeColor: activeColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      autofocus: autofocus,
    );
    Widget? leading, trailing;
    switch (controlAffinity) {
      case ListTileControlAffinity.leading:
      case ListTileControlAffinity.platform:
        leading = control;
        trailing = secondary;
        break;
      case ListTileControlAffinity.trailing:
        leading = secondary;
        trailing = control;
        break;
    }
    return MergeSemantics(
      child: ListTileTheme.merge(
        selectedColor: activeColor ?? Theme.of(context).toggleableActiveColor,
        child: ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: onChanged != null,
          shape: shape,
          tileColor: tileColor,
          selectedTileColor: selectedTileColor,
          onTap: onChanged != null ? () {
            if (toggleable && checked) {
              onChanged!(null);
              return;
            }
            if (!checked) {
              onChanged!(value);
            }
          } : null,
          selected: selected,
          autofocus: autofocus,
          contentPadding: contentPadding,
          visualDensity: visualDensity,
          focusNode: focusNode,
          enableFeedback: enableFeedback,
        ),
      ),
    );
  }
}

const double _kOuterRadius = 8.0;
const double _kInnerRadius = 6.0;

class CustomRadio<T> extends StatefulWidget {

  const CustomRadio({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
  }) : assert(autofocus != null),
        assert(toggleable != null),
        super(key: key);

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;

  bool get _selected => value == groupValue;

  @override
  State<CustomRadio<T>> createState() => _CustomRadioState<T>();
}

class _CustomRadioState<T> extends State<CustomRadio<T>> with TickerProviderStateMixin, ToggleableStateMixin {
  final _RadioPainter _painter = _RadioPainter();

  void _handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);
      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  @override
  void didUpdateWidget(CustomRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selected != oldWidget._selected) {
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged != null ? _handleChanged : null;

  @override
  bool get tristate => widget.toggleable;

  @override
  bool? get value => widget._selected;

  MaterialStateProperty<Color?> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final ThemeData themeData = Theme.of(context);
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return themeData.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return themeData.toggleableActiveColor;
      }
      return themeData.unselectedWidgetColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize = widget.materialTapTargetSize
        ?? themeData.radioTheme.materialTapTargetSize
        ?? themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity = widget.visualDensity
        ?? themeData.radioTheme.visualDensity
        ?? themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor = MaterialStateProperty.resolveWith<MouseCursor>((Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states)
          ?? themeData.radioTheme.mouseCursor?.resolve(states)
          ?? MaterialStateProperty.resolveAs<MouseCursor>(MaterialStateMouseCursor.clickable, states);
    });

    // Colors need to be resolved in selected and non selected states separately
    // so that they can be lerped between.
    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states..remove(MaterialState.selected);
    final Color effectiveActiveColor = widget.fillColor?.resolve(activeStates)
        ?? _widgetFillColor.resolve(activeStates)
        ?? themeData.radioTheme.fillColor?.resolve(activeStates)
        ?? _defaultFillColor.resolve(activeStates);
    final Color effectiveInactiveColor = widget.fillColor?.resolve(inactiveStates)
        ?? _widgetFillColor.resolve(inactiveStates)
        ?? themeData.radioTheme.fillColor?.resolve(inactiveStates)
        ?? _defaultFillColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor = widget.overlayColor?.resolve(focusedStates)
        ?? widget.focusColor
        ?? themeData.radioTheme.overlayColor?.resolve(focusedStates)
        ?? themeData.focusColor;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor = widget.overlayColor?.resolve(hoveredStates)
        ?? widget.hoverColor
        ?? themeData.radioTheme.overlayColor?.resolve(hoveredStates)
        ?? themeData.hoverColor;

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor = widget.overlayColor?.resolve(activePressedStates)
        ?? themeData.radioTheme.overlayColor?.resolve(activePressedStates)
        ?? effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor = widget.overlayColor?.resolve(inactivePressedStates)
        ?? themeData.radioTheme.overlayColor?.resolve(inactivePressedStates)
        ?? effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget._selected,
      child: buildToggleable(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: effectiveMouseCursor,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = effectiveInactivePressedOverlayColor
          ..reactionColor = effectiveActivePressedOverlayColor
          ..hoverColor = effectiveHoverOverlayColor
          ..focusColor = effectiveFocusOverlayColor
          ..splashRadius = widget.splashRadius ?? themeData.radioTheme.splashRadius ?? kRadialReactionRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = effectiveActiveColor
          ..inactiveColor = effectiveInactiveColor,
      ),
    );
  }
}

class _RadioPainter extends ToggleablePainter {
  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Offset center = (Offset.zero & size).center;

    // Outer circle
    final Paint paint = Paint()
      ..color = Color.lerp(inactiveColor, activeColor, position.value)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, _kOuterRadius, paint);

    // Inner circle
    if (!position.isDismissed) {
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(center, _kInnerRadius * position.value, paint);
    }
  }
}
