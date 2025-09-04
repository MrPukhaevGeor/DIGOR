
import 'package:flutter/material.dart';

class CustomPopupMenuButton<T> extends StatelessWidget {
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T?>? onSelected;
  final Widget child;
  final bool right;

  const CustomPopupMenuButton({
    super.key,
    required this.items,
    required this.child,
    this.onSelected, required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        return InkWell(
          onTap: () async {
            final renderBox = ctx.findRenderObject() as RenderBox;
            final offset = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            final value =await Navigator.of(context).push(
              _PopupMenuRoute<T>(
                items: items,
                onSelected: (_ ) {
                  onSelected?.call(_);
                },
                position: RelativeRect.fromLTRB(
                  offset.dx,
                  offset.dy + size.height,
                  offset.dx + size.width,
                  offset.dy,
                ), right: right,
              ),
            );
            print(value);
            onSelected?.call(value);
          },
          child: child,
        );
      },
    );
  }
}class _PopupMenuRoute<T> extends PopupRoute<T> {
  final List<PopupMenuEntry<T>> items;
  final ValueChanged<T?>? onSelected;
  final RelativeRect position;
  final bool right;
  _PopupMenuRoute({
    required this.items,
    required this.onSelected,
    required this.position,
    required this.right,
  });

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => Colors.transparent;

  EdgeInsets get menuPadding => EdgeInsets.zero;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {

    // Сначала ширина (0 -> 1), потом высота (0 -> 1)
    final scaleX = TweenSequence([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 50),
    ]).animate(animation);

    final scaleY = TweenSequence([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 50),
    ]).animate(animation);



    final fadeTransition = Tween(begin: 0.4, end: 1.0).animate(animation);
    return Stack(
      children: [
        Positioned(
          left: (right ? -50 : 0) + position.left,
          top: -35 + position.top,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return FadeTransition(
                opacity: fadeTransition,
                child: Container(
                  alignment: Alignment.topLeft, // растёт от кнопки

                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: ((scaleX.value + 0.3) > 1 ? 1 : (scaleX.value + 0.3)) * 220,

                    height: scaleY.value * (items.length * (kToolbarHeight - 8)),
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          spreadRadius: 5,
                          color: Colors.black.withOpacity(fadeTransition.value/ 3),
                        )
                      ],
                    ),

                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      child: Column(

                        children: items.map((e) {
                          return InkWell(
                            onTap: () {
                              try {
                                Navigator.pop(
                                    context, (e as PopupMenuItem<T>).value);
                              } catch (_) {
                                print(_);
                              }
                            },
                            child: IgnorePointer(
                              child: Container(
                                color: Colors.transparent,

                                child: Container(
                                    height: (kToolbarHeight - 8),

                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        margin: EdgeInsets.only(top: fadeTransition.value * 4,
                                            left: (fadeTransition.value * 16)

                                        ),child: e)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
