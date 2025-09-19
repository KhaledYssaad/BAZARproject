import 'package:app/widgets/service_not_available_yet.dart';
import 'package:flutter/material.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ServiceNotAvailableYet.show(context, "we'll add it later");
      },
      icon: const Icon(
        Icons.notifications_outlined,
        color: Colors.black,
      ),
    );
  }
}
