import 'package:flutter/material.dart';

// показ предупреждений
void myAlert({
  required BuildContext context,
  required String mytext,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      elevation: 1.2,
      backgroundColor: Colors.red.shade900,
      shape: RoundedRectangleBorder(
        side: const BorderSide(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Text(
            mytext,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 18,
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(
            context,
          );
        },
      ),
    ),
  );
}

class TTip extends StatelessWidget {
  const TTip({
    Key? key,
    required this.message,
    required this.child,
  }) : super(key: key);
  final Widget child;
  final String message;
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      waitDuration: const Duration(seconds: 1),
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
