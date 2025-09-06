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
    this.onSelected,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        return GestureDetector(
          onTap: () async {
            final renderBox = ctx.findRenderObject() as RenderBox;
            final offset = renderBox.localToGlobal(Offset.zero);
            final size = renderBox.size;

            final value = await Navigator.of(context).push(
              _PopupMenuRoute<T>(
                items: items,
                onSelected: (_) {
                  onSelected?.call(_);
                },
                position: RelativeRect.fromLTRB(
                  offset.dx,
                  offset.dy + size.height,
                  offset.dx + size.width,
                  offset.dy,
                ),
                right: right,
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
}

class _PopupMenuRoute<T> extends PopupRoute<T> {
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
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.fastOutSlowIn,
    );

    // Масштаб от 0.8 до 1.0 (а не 0 -> 1, чтобы было мягче)
    final scale = Tween<double>(begin: 0.8, end: 1.0).animate(curved);

    // Прозрачность
    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            left: right?null: position.left,
            top: 4 ,
            right: right? 4:null,
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final currentScale = animation.status == AnimationStatus.reverse
                      ? 1.0
                      : scale.value;
                  return ScaleTransition(
                    scale: AlwaysStoppedAnimation(currentScale),
                    alignment: Alignment.topLeft,
                    child: FadeTransition(
                      opacity: fade,
                      child: Container(
                        alignment: Alignment.topLeft, // растёт от кнопки
          
                        child: Container(
                          width: 200,
                          clipBehavior: Clip.hardEdge,
                          height: items.length == 1
                              ? items.length * (kToolbarHeight - 8)
                              : items.length * (kToolbarHeight - 2),
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 8,
                                spreadRadius: 5,
                                color: Colors.black.withOpacity(0.15),
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
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 8),
                                          height: items.length == 1
                                              ? (kToolbarHeight - 8)
                                              : (kToolbarHeight - 2),
                                          alignment: Alignment.topCenter,
                                          child: e),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
