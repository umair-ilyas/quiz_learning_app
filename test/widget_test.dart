import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quiz_learning_app/features/quiz/widgets/option_tile.dart';

void main() {
  Widget buildTile({
    required String optionLabel,
    required String optionText,
    required bool isSelected,
    required bool isCorrect,
    required bool isRevealed,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: OptionTile(
            optionLabel: optionLabel,
            optionText: optionText,
            isSelected: isSelected,
            isCorrect: isCorrect,
            isRevealed: isRevealed,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  group('OptionTile widget tests', () {
    testWidgets('renders option label and text', (tester) async {
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'A',
          optionText: 'Paris',
          isSelected: false,
          isCorrect: false,
          isRevealed: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('A'), findsOneWidget);
      expect(find.text('Paris'), findsOneWidget);
    });

    testWidgets('shows check icon when correct answer is revealed', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'B',
          optionText: 'London',
          isSelected: true,
          isCorrect: true,
          isRevealed: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('shows cancel icon when wrong answer is selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'C',
          optionText: 'Berlin',
          isSelected: true,
          isCorrect: false,
          isRevealed: true,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.cancel_rounded), findsOneWidget);
    });

    testWidgets('no icon shown when not revealed', (tester) async {
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'D',
          optionText: 'Rome',
          isSelected: false,
          isCorrect: true,
          isRevealed: false,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
      expect(find.byIcon(Icons.cancel_rounded), findsNothing);
    });

    testWidgets('calls onTap when not revealed and tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'A',
          optionText: 'Blue',
          isSelected: false,
          isCorrect: true,
          isRevealed: false,
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onTap when revealed (disabled)', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTile(
          optionLabel: 'A',
          optionText: 'Blue',
          isSelected: true,
          isCorrect: true,
          isRevealed: true,
          onTap: () => tapped = true,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, isFalse);
    });
  });
}
