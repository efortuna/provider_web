import 'provider.dart';
import 'package:flutter/widgets.dart';

class AnimatedProvider<T> extends ImplicitlyAnimatedWidget {
  const AnimatedProvider({
    Key key,
    @required this.duration,
    @required this.value,
    this.curve,
    this.updateShouldNotify,
    this.tweenBuilder,
    this.child,
  }) : super(key: key, duration: duration, curve: curve);

  static AnimatedProvider<int> integer({
    Key key,
    @required Duration duration,
    @required int value,
    Curve curve,
    UpdateShouldNotify<int> updateShouldNotify,
    Widget child,
  }) =>
      AnimatedProvider<int>(
        key: key,
        duration: duration,
        value: value,
        curve: curve,
        updateShouldNotify: updateShouldNotify,
        tweenBuilder: (value) => IntTween(begin: value),
        child: child,
      );

  final Duration duration;
  final Curve curve;
  final T value;
  final UpdateShouldNotify<T> updateShouldNotify;
  final Widget child;
  final TweenBuilder<T> tweenBuilder;

  @override
  _AnimatedProviderState<T> createState() => _AnimatedProviderState<T>();
}

class _AnimatedProviderState<T>
    extends _AnimatedWidgetBaseState<AnimatedProvider<T>> {
  Tween<T> _data;

  @override
  Widget build(BuildContext context) {
    return Provider<T>(
      value: _data.evaluate(animation),
      child: widget.child,
      updateShouldNotify: widget.updateShouldNotify,
    );
  }

  @override
  void visitTween(_TweenVisitor visitor) {
    _data = visitor(_data, widget.value,
        widget.tweenBuilder ?? (value) => Tween<T>(begin: value));
  }
}

typedef TweenBuilder<T> = Tween<T> Function(T value);
typedef _TweenVisitor = Tween<T> Function<T>(
    Tween<T> previousTween, T value, TweenBuilder<T> tweenBuilder);

// a more type-safe TweenVisitor implementation
abstract class _AnimatedWidgetBaseState<T extends ImplicitlyAnimatedWidget>
    extends AnimatedWidgetBaseState<T> {
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    var tweenVisitor =
        <T>(Tween<T> previousTween, T value, TweenBuilder<T> tweenBuilder) {
      return visitor(
              previousTween, value, (dynamic value) => tweenBuilder(value as T))
          as Tween<T>;
    };
    visitTween(tweenVisitor);
  }

  void visitTween(_TweenVisitor visitor);
}
