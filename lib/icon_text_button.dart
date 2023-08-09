import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final IconData icon;
  final bool? image;
  final String text;
  final String? subtext;
  final Function() onPressed;
  const IconTextButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
    this.subtext,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      child: Row(
        children: [
          image != null && image!
              ? Image.asset("assets/astolfo.png", width: 56, height: 56)
              : Icon(icon, size: 56, color: Colors.black),
          const SizedBox(
            width: 8,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: Theme.of(context).textTheme.headlineMedium,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                ),
                if (subtext != null)
                  Text(
                    subtext!,
                    style: Theme.of(context).textTheme.labelLarge,
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
