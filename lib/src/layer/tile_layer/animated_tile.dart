import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';

class AnimatedTile extends StatefulWidget {
  final Tile tile;
  final ImageProvider? errorImage;
  final TileBuilder? tileBuilder;

  const AnimatedTile({
    Key? key,
    required this.tile,
    this.errorImage,
    required this.tileBuilder,
  }) : super(key: key);

  @override
  State<AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile> {
  bool listenerAttached = false;

  Widget get _tileWidget {
    if (widget.tile.loadError && widget.errorImage != null) {
      return Image(
          image: widget.errorImage!,
          fit: BoxFit.fill,
          color: Color.fromRGBO(255, 255, 255, widget.tile.opacity),
          colorBlendMode: BlendMode.modulate);
    } else if (widget.tile.animationController == null) {
      return RawImage(
          image: widget.tile.imageInfo?.image,
          fit: BoxFit.fill,
          color: Color.fromRGBO(255, 255, 255, widget.tile.opacity),
          colorBlendMode: BlendMode.modulate);
    }

    return RawImage(
        image: widget.tile.imageInfo?.image,
        fit: BoxFit.fill,
        opacity: widget.tile.animationController);
  }

  @override
  Widget build(BuildContext context) =>
      widget.tileBuilder?.call(context, _tileWidget, widget.tile) ??
      _tileWidget;

  @override
  void initState() {
    super.initState();

    if (null != widget.tile.animationController) {
      widget.tile.animationController!.addListener(_handleChange);
      listenerAttached = true;
    }
  }

  @override
  void dispose() {
    if (listenerAttached) {
      widget.tile.animationController?.removeListener(_handleChange);
    }

    super.dispose();
  }

  @override
  void didUpdateWidget(AnimatedTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!listenerAttached && null != widget.tile.animationController) {
      widget.tile.animationController!.addListener(_handleChange);
      listenerAttached = true;
    }
  }

  void _handleChange() {
    if (mounted) {
      setState(() {});
    }
  }
}
