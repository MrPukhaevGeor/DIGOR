import 'dart:ui';

import 'package:flutter/material.dart';

class CustomPopupMenuButton<T> extends StatefulWidget {
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
  State<CustomPopupMenuButton<T>> createState() =>
      _CustomPopupMenuButtonState<T>();
}

class _CustomPopupMenuButtonState<T> extends State<CustomPopupMenuButton<T>>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _entry;
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final curved = CurvedAnimation(parent: _ctrl, curve: Curves.fastOutSlowIn);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(curved);
    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
  }

  @override
  void dispose() {
    _removeOverlay(immediately: true);
    _ctrl.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext ctx) {
    if (_entry != null) return;

    final renderBox = ctx.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenSize = MediaQuery.of(context).size;

    // Повторяем логику позиционирования из исходного _PopupMenuRoute:
    // left = position.left (offset.dx) если right==false
    // top = 4 (как в оригинале)
    // right = 4 если right==true
    final double posLeft = offset.dx;
    final double posTop = 4.0;
    final double? posRight = widget.right ? 4.0 : null;

    const double menuWidth = 200.0;
    final entry = OverlayEntry(builder: (overlayCtx) {
      return Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _removeOverlay();
          },
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  left: widget.right ? null : posLeft,
                  top: posTop,
                  right: posRight,
                  child: AnimatedBuilder(
                    animation: _ctrl,
                    builder: (context, child) {
                      final currentScale = _ctrl.status == AnimationStatus.reverse
                          ? 1.0
                          : _scale.value;
                      return Transform.scale(
                        scale: currentScale,
                        alignment: Alignment.topLeft,
                        child: Opacity(
                          opacity: _fade.value,
                          child: child,
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: menuWidth,
                        clipBehavior: Clip.hardEdge,
                        height: widget.items.length == 1
                            ? widget.items.length * (kToolbarHeight - 8)
                            : widget.items.length * (kToolbarHeight - 2),
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
                            mainAxisSize: MainAxisSize.min,
                            children: widget.items.map((e) {
                              return InkWell(
                                onTap: () {
                                  // Получаем значение из PopupMenuItem<T>, если это он
                                  T? val;
                                  try {
                                    val = (e as PopupMenuItem<T>).value;
                                  } catch (_) {
                                    val = null;
                                  }
                                  // Сначала закроем меню (анимация реверса), потом вызовем callback
                                  _removeOverlay().then((_) {
                                    widget.onSelected?.call(val);
                                  });
                                },
                                child: IgnorePointer(
                                  child: Container(
                                    color: Colors.transparent,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 8),
                                      height: widget.items.length == 1
                                          ? (kToolbarHeight - 8)
                                          : (kToolbarHeight - 2),
                                      alignment: Alignment.topCenter,
                                      child: e,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    _entry = entry;
    Overlay.of(context)!.insert(entry);
    _ctrl.forward();
  }

  /// Закрыть оверлей. Если immediately==true — удалить без анимации (используется в dispose).
  Future<void> _removeOverlay({bool immediately = false}) async {
    if (_entry == null) return;
    if (immediately) {
      try {
        _entry?.remove();
      } catch (_) {}
      _entry = null;
      return;
    }

    try {
      await _ctrl.reverse();
    } catch (_) {}
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (ctx) {
      return GestureDetector(
        onTap: () {
          // Toggle: если уже открыт — закроем, иначе откроем
          if (_entry != null) {
            _removeOverlay();
          } else {
            _showOverlay(ctx);
          }
        },
        child: widget.child,
      );
    });
  }
}
