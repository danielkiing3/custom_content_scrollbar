import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import '../../utils/theme/app_text_styles.dart';
import '../control_input_enum.dart';
import 'vertical_stadium_picker.dart';

//TODO: 2. Extract variable to centralize place
//TODO: 3. Perfect the motion of the metaballs and make it more fluid

class LandspaceScrollSelector extends StatefulWidget {
  const LandspaceScrollSelector({
    super.key,
    required this.progressNotifier,
    required this.contentHeader,
    required this.contentKeys,
    required this.currentSectionIndex,
    required this.activeControlNotifier,
    required this.debouncer,
  });

  final ValueNotifier<double> progressNotifier;

  final List<String> contentHeader;
  final List<GlobalKey> contentKeys;
  final ValueNotifier<int> currentSectionIndex;

  final ValueNotifier<ScrollInput> activeControlNotifier;
  final VoidCallback debouncer;

  @override
  State<LandspaceScrollSelector> createState() => _LandspaceScrollSelectorState();
}

class _LandspaceScrollSelectorState extends State<LandspaceScrollSelector> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _offsetAnimation;
  late Animation<double> _thresholdAnimation;

  static Duration duration = const Duration(milliseconds: 800);
  static Curve curve = Curves.fastOutSlowIn;
  static double ballWidth = 60.0;
  static double stadiumOffsetDy = 100.0;

  // Percent that the animation starts
  final double _threshold = 0.15;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: duration);

    _offsetAnimation = Tween<double>(
      begin: 110,
      end: 0,
    ).animate(CurvedAnimation(parent: _animationController, curve: curve, reverseCurve: curve.flipped));

    _thresholdAnimation = Tween<double>(
      begin: 2.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _animationController, curve: curve));

    widget.progressNotifier.addListener(_handleProgressChange);
  }

  void _handleProgressChange() {
    final double progress = widget.progressNotifier.value;

    if (progress > _threshold && !_isOpen) {
      _animationController.forward();
      _isOpen = true;
    } else if (progress <= _threshold && _isOpen) {
      _animationController.reverse();
      _isOpen = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: <Widget>[
          SizedBox(
            width: ballWidth,
            child: Stack(
              children: <Widget>[
                // -- Metaballs
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (_, _) {
                      return ShaderBuilder((_, FragmentShader shader, _) {
                        return AnimatedSampler((_, Size size, Canvas canvas) {
                          final double radiusInPx = size.width / 2;

                          final Offset radius = Offset(radiusInPx / size.width, radiusInPx / size.height);

                          final Offset blobCenter1 = Offset(
                            radiusInPx / size.width, // X-cord: half width
                            (_offsetAnimation.value + radiusInPx) / size.height, // Y-cord: top + half height
                          );

                          final Offset blobCenter2 = Offset(
                            radiusInPx / size.width, // X-cord: half width
                            (stadiumOffsetDy + (ballWidth / 2)) / size.height, // Y-cord: top + half height
                          );

                          shader.setFloatUniforms((UniformsSetter uniforms) {
                            uniforms
                              // uSize
                              ..setSize(size)
                              // uBlobCenter2
                              ..setOffset(blobCenter2)
                              // uBlobRadius
                              ..setOffset(radius)
                              // uBackgroundColor
                              ..setColor(Colors.white)
                              // uBlobColor
                              ..setColor(Colors.black)
                              // Thresold value
                              ..setFloat(_thresholdAnimation.value)
                              // uBlobCenter1
                              ..setOffset(blobCenter1);

                            canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = shader);
                          });
                          // ignore: require_trailing_commas
                        }, child: const SizedBox());
                        // ignore: require_trailing_commas
                      }, assetKey: 'assets/shaders/metaballs.frag');
                    },
                  ),
                ),

                // -- Progress count
                AnimatedBuilder(
                  animation: _offsetAnimation,
                  builder: (BuildContext context, Widget? child) {
                    return Positioned(
                      top: _offsetAnimation.value,
                      child: Container(
                        width: ballWidth,
                        height: ballWidth,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),

                        child: Center(
                          child: RepaintBoundary(
                            child: ValueListenableBuilder<double>(
                              valueListenable: widget.progressNotifier,
                              builder: (_, double value, _) {
                                return Text(
                                  '${(value * 100).truncate()}%',
                                  style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // -- Selector
          Positioned(
            top: stadiumOffsetDy,
            right: 0,
            child: VerticalStadiumPicker(
              currentSectionIndex: widget.currentSectionIndex,
              contentHeader: widget.contentHeader,
              contentKeys: widget.contentKeys,
              activeControlNotifier: widget.activeControlNotifier,
              debouncer: widget.debouncer,
            ),
          ),
        ],
      ),
    );
  }
}
