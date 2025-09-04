import 'dart:math';

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
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isMenuOpen = false;
  final GlobalKey _iconKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleMenu(bool isEmpty) {
    if (_isMenuOpen) {
      _removeOverlay();
      _animationController.reverse();
    } else {
      _showOverlay(isEmpty);
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
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(2),
                        child: InkWell(
                          onTap: isEmpty
                              ? null
                              : () {
                                  _clearHistory();
                                  _toggleMenu(false);
                                },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: minWidth,
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: kToolbarHeight - 8,
                              constraints: BoxConstraints(minWidth: 150),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Text(
                                'clear_history'.tr(),
                                maxLines: 1,
                                style: isEmpty
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
            tr('del_full_history'))
        .whenComplete(() =>
            ref.read(textFieldValueProvider.notifier).focusNode.requestFocus());
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(historyProvider).maybeWhen(
        orElse: () => const SizedBox.shrink(),
        data: (data) => IconButton(
              key: _iconKey,
              icon: const Icon(Icons.more_vert),
              onPressed: () => _toggleMenu(data.isEmpty),
            ));
  }
}
