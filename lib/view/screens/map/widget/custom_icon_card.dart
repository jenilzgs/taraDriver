import 'package:flutter/material.dart';
import 'package:ride_sharing_user_app/util/dimensions.dart';
import 'package:ride_sharing_user_app/util/styles.dart';

class CustomIconCard extends StatefulWidget {
  final String icon;
  final String title;
  final int index;
  final Function()? onTap;
  const CustomIconCard({super.key, required this.icon, required this.index, this.onTap, required this.title});

  @override
  State<CustomIconCard> createState() => _CustomIconCardState();
}

class _CustomIconCardState extends State<CustomIconCard> with SingleTickerProviderStateMixin{

  double? scale;
  AnimationController? controller;
  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500,),
      lowerBound: 0.0, upperBound: 0.1,)..addListener(() {setState(() {});});
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
  @override
  Widget build(BuildContext context) {
    scale = 1 - controller!.value;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(scale: scale,
        child: Column(children: [

            Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Container(decoration: BoxDecoration(
                  border: Border.all(width: .25, color: Theme.of(context).primaryColor.withOpacity(.75)),
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.3), blurRadius: 1, spreadRadius: 1, offset: const Offset(2,2))],
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
                child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSize),
                  child: SizedBox(width: Dimensions.iconSizeLarge,child: Image.asset(widget.icon, color: Theme.of(context).primaryColor)))),),

          Text(widget.title, style: textRegular.copyWith(),)
          ],
        ),
      ),
    );
  }
  void _tapDown(TapDownDetails details) {
    controller?.forward();
  }
  void _tapUp(TapUpDetails details) {
    controller?.reverse();
  }
}