import 'package:flutter/material.dart';
import 'package:app/constants/colors.dart';

class NumericKeypad extends StatelessWidget {
  final void Function(String) onKeyPressed;
  const NumericKeypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '.',
      '0',
      'back',
    ];

    return Container(
      color: AppColors.primaryPurple,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyWidth = constraints.maxWidth / 3;
          final keyHeight = constraints.maxHeight / 4;

          return Column(
            children: List.generate(4, (row) {
              return Row(
                children: List.generate(3, (col) {
                  final index = row * 3 + col;
                  if (index >= keys.length) {
                    return SizedBox(width: keyWidth, height: keyHeight);
                  }
                  final value = keys[index];
                  final isBack = value == 'back';

                  return SizedBox(
                    width: keyWidth,
                    height: keyHeight,
                    child: InkWell(
                      onTap: () => onKeyPressed(value),
                      child: Center(
                        child: isBack
                            ? const Icon(Icons.backspace_outlined,
                                color: Colors.white, size: 28)
                            : Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  );
                }),
              );
            }),
          );
        },
      ),
    );
  }
}
