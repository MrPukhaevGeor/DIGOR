import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../outside_functions.dart';
import '../../../providers/history.dart';
import '../../../providers/textfield_provider.dart';

class ClearHistoryButton extends ConsumerStatefulWidget {
  const ClearHistoryButton({super.key});

  @override
  ConsumerState<ClearHistoryButton> createState() => _ClearHistoryButtonState();
}

class _ClearHistoryButtonState extends ConsumerState<ClearHistoryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isMenuOpen = false;
  final GlobalKey _iconKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final curved = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );

    // slide: от правого края (1.0) к нулю при открытии
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(curved);

    // fade: 0 -> 1 (и обратно при закрытии)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu(bool isEmpty) {
    if (_isMenuOpen) {
      // закрываем: только fade будет анимироваться (slide зафиксируем в позиции 0)
      _animationController.reverse().whenComplete(_removeOverlay);
    } else {
      _showOverlay(isEmpty);
      // открываем: slide + fade анимируются
      _animationController.forward();
    }
    setState(() => _isMenuOpen = !_isMenuOpen);
  }

  void _showOverlay(bool isEmpty, {double minWidth = 200}) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _toggleMenu(false),
            child: Stack(
              children: [
                Container(color: Colors.black.withOpacity(0.01)),
                Positioned(
                  right: 4,
                  top: 4,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      // Если идёт reverse (закрытие) —фиксируем slide в Offset.zero,
                      // чтобы при закрытии не было обратного слайда, а только fade.
                      final currentSlide =
                          _animationController.status == AnimationStatus.reverse
                              ? Offset.zero
                              : _slideAnimation.value;

                      return SlideTransition(
                        position: AlwaysStoppedAnimation<Offset>(currentSlide),
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(2),
                            child: InkWell(
                              onTap: isEmpty
                                  ? null
                                  : () {
                                      if (ref
                                          .read(textFieldValueProvider)
                                          .isEmpty) {
                                        _clearHistory();
                                        _toggleMenu(false);
                                      }
                                    },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minWidth: minWidth),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: kToolbarHeight - 8,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    'clear_history'.tr(),
                                    maxLines: 1,
                                    style: isEmpty ||
                                            ref
                                                .read(textFieldValueProvider)
                                                .isNotEmpty
                                        ? theme.textTheme.bodyMedium!.copyWith(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          )
                                        : theme.textTheme.bodyMedium!.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _clearHistory() {
    OutsideFunctions.showClearHistoryDialog(
      context,
      ref.read(historyProvider.notifier).clearHistory,
      tr('del_full_history'),
    ).whenComplete(() =>
        ref.read(textFieldValueProvider.notifier).focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(historyProvider).maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (data) => IconButton(
            padding: EdgeInsets.only(right: 8),
            constraints: BoxConstraints(),
            key: _iconKey,
            icon: const Icon(Icons.more_vert),
            onPressed: () => _toggleMenu(data.isEmpty),
          ),
        );
  }
}
