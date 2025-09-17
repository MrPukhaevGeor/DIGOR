import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../outside_functions.dart';
import '../../../providers/history.dart';
import '../../../providers/textfield_provider.dart';
import 'search_textfield.dart';

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

  void _showOverlay(bool isEmpty, {double minWidth = 200}) {
    ref.read(popupMenuOpenProvider.notifier).state = true;
    final overlayEntry = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _removeOverlay(),
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
                                        _removeOverlay();
                                      }
                                    },
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: minWidth,
                                    maxWidth:
                                        MediaQuery.of(context).size.width+4),
                                child: Container(
                                  height: kToolbarHeight - 8,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 2,
                                  ),
                                  child: Row(mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: TwoDotEllipsis(
                                         text:
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
                                    ],
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
    _overlayEntry = overlayEntry;
    Overlay.of(context).insert(overlayEntry);
    ref.read(popupMenuClearTextOpenProvider.notifier).state = () {
      if (_overlayEntry != null) {
        _removeOverlay();
      }
    };
    _animationController.forward();
  }

  Future<void> _removeOverlay({bool immediately = false}) async {
    if (_overlayEntry == null) return;

    ref.read(popupMenuOpenProvider.notifier).state = false;

    if (immediately) {
      try {
        _overlayEntry?.remove();
      } catch (_) {}
      _overlayEntry = null;
      return;
    }

    try {
      await _animationController.reverse();
    } catch (_) {}
    try {
      _overlayEntry?.remove();
    } catch (_) {}
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
            onPressed: () => _showOverlay(data.isEmpty),
          ),
        );
  }
}
