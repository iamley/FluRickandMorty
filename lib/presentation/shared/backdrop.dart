import 'dart:math' as math;

import 'package:FluRickandMorty/domain/entities/character.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class _BackdropPanel extends StatelessWidget {
  final VoidCallback onTap;
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget title;
  final Widget child;

  const _BackdropPanel(
      {Key key,
      this.onTap,
      this.onVerticalDragEnd,
      this.onVerticalDragUpdate,
      this.title,
      this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragEnd: onVerticalDragEnd,
            onVerticalDragUpdate: onVerticalDragUpdate,
            onTap: onTap,
            child: Container(
              height: 48.0,
              padding: EdgeInsetsDirectional.only(start: 16.0),
              alignment: AlignmentDirectional.centerStart,
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subhead,
                child: title,
              ),
            ),
          ),
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: child,
          )
        ],
      ),
    );
  }
}

class _BackdropTitle extends AnimatedWidget {
  final Widget frontTitle;
  final Widget backTitle;

  const _BackdropTitle(
      {Key key, Listenable listenable, this.frontTitle, this.backTitle})
      : super(key: key, listenable: listenable);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = this.listenable;
    return DefaultTextStyle(
      style: Theme.of(context).primaryTextTheme.title,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: Interval(0.5, 1.0),
            ).value,
            child: backTitle,
          ),
          Opacity(
            opacity:
                CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0))
                    .value,
            child: frontTitle,
          )
        ],
      ),
    );
  }
}

class Backdrop extends StatefulWidget {
  final Character currentCharacter;
  final Widget frontPanel;
  final Widget backPanel;
  final Widget frontTitle;
  final Widget backTitle;

  const Backdrop({
    @required this.currentCharacter,
    @required this.frontPanel,
    @required this.backPanel,
    @required this.frontTitle,
    @required this.backTitle,
  })  : assert(frontPanel != null),
        assert(backPanel != null),
        assert(frontTitle != null),
        assert(backTitle != null);

  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, value: 0.0, duration: Duration(milliseconds: 300));
  }

  @override
  void didUpdateWidget(Backdrop oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentCharacter != oldWidget.currentCharacter) {
      setState(() {
        _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
      });
    } else if (!_backdropPanelVisible && widget.currentCharacter != null) {
      setState(() {
        _controller.fling(velocity: 2.0);
      });
    }
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.value -= details.primaryDelta / _backdropHeight;
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    final double flingVelocity =
        details.velocity.pixelsPerSecond.dy / _backdropHeight;

    if (flingVelocity < 0.0) {
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    } else if (flingVelocity > 0.0) {
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    } else {
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    Animation<RelativeRect> panelAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
          0.0, panelTop, 0.0, panelTop - panelSize.height),
      end: RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
    ).animate(_controller.view);

    return Container(
      key: _backdropKey,
      child: Stack(
        children: <Widget>[
          widget.backPanel,
          PositionedTransition(
            rect: panelAnimation,
            child: _BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Text(widget.currentCharacter == null
                  ? 'Personajes'
                  : widget.currentCharacter.name),
              child: widget.frontPanel,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu, progress: _controller.view),
          onPressed: _toggleBackdropPanelVisibility,
        ),
        title: _BackdropTitle(
          listenable: _controller.view,
          frontTitle: widget.frontTitle,
          backTitle: widget.backTitle,
        ),
      ),
      body: LayoutBuilder(builder: _buildStack),
    );
  }
}
