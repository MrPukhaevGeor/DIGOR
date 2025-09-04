import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../word_page_model.dart';
import 'play_audio_button.dart';

class TitleWidget extends ConsumerWidget {
  final String title;
  final String? audioUrl;
  const TitleWidget(this.title, this.audioUrl, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final zoom = ref.watch(articleZoomProvider);

    return SelectableText.rich(
      TextSpan(
        style: theme.textTheme.headlineSmall!.copyWith(
          fontSize: 28 * zoom,
        ),
        children: [
          TextSpan(text: title.trim()),
          if (audioUrl != null && audioUrl!.isNotEmpty)
            WidgetSpan(
              baseline: TextBaseline.ideographic,
              alignment: PlaceholderAlignment.middle,
              child: PlayAudioButton(audioUrl!),
            ),
        ],
      ),
      showCursor: true,
      cursorColor: Colors.blue,
      toolbarOptions: const ToolbarOptions(
        copy: true,
        selectAll: true,
      ),
      selectionControls: materialTextSelectionControls,
      onSelectionChanged: (selection, cause) {
        if (selection.isValid) {}
      },
    );
  }
}
