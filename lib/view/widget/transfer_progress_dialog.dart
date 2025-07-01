import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class TransferProgressDialog extends StatefulWidget {
  final img.Image finalImg;
  final Future<void> Function(
    img.Image image,
    Function(double, String) onProgress,
    Function() onTagDetected,
  ) transferFunction;
  final Color colorAccent;

  const TransferProgressDialog({
    Key? key,
    required this.finalImg,
    required this.transferFunction,
    required this.colorAccent,
  }) : super(key: key);

  @override
  State<TransferProgressDialog> createState() => _TransferProgressDialogState();

  static Future<void> show({
    required BuildContext context,
    required img.Image finalImg,
    required Future<void> Function(
      img.Image image,
      Function(double, String) onProgress,
      Function() onTagDetected,
    ) transferFunction,
    required Color colorAccent,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TransferProgressDialog(
          finalImg: finalImg,
          transferFunction: transferFunction,
          colorAccent: colorAccent,
        );
      },
    );
  }
}

class _TransferProgressDialogState extends State<TransferProgressDialog>
    with TickerProviderStateMixin {
  double progress = 0.0;
  String status = "Initializing...";
  bool tagDetected = false;
  bool transferComplete = false;
  bool showHoldStillMessage = false;
  bool displayRefreshComplete = false;
  String? errorMessage;

  late AnimationController _pulseController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _holdStillController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _holdStillPulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startTransfer();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _holdStillController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    _holdStillPulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _holdStillController,
      curve: Curves.easeInOut,
    ));
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _holdStillController.dispose();
    super.dispose();
  }

  String _getErrorMessage(dynamic error) {
    String errorString = error.toString().toLowerCase();
    if (errorString.contains('platformexception(408') &&
        errorString.contains('polling tag timeout')) {
      return "Device connection timed out. Please try bringing your phone closer to the device and try again.";
    }
    if (errorString.contains('platformexception(500') &&
        errorString.contains('communication error') &&
        errorString.contains('tag was lost')) {
      return "Connection was lost during transfer. Please keep your phone close to the device and try again.";
    }
    return error.toString();
  }

  Future<void> _startTransfer() async {
    try {
      await widget.transferFunction(
        widget.finalImg,
        _onProgress,
        _onTagDetected,
      );
    } catch (e) {
      setState(() {
        errorMessage = _getErrorMessage(e);
      });
    }
  }

  void _onProgress(double newProgress, String newStatus) {
    setState(() {
      progress = newProgress;
      status = newStatus;
      if (newProgress >= 1.0) {
        transferComplete = true;
        _showHoldStillMessage();
      }
    });
  }

  void _onTagDetected() {
    setState(() {
      tagDetected = true;
    });
    _pulseController.stop();
  }

  void _showHoldStillMessage() {
    setState(() {
      showHoldStillMessage = true;
    });

    Future.delayed(const Duration(seconds: 15), () {
      if (mounted) {
        setState(() {
          displayRefreshComplete = true;
          showHoldStillMessage = false;
        });
        _holdStillController.stop();
      }
    });
  }

  Widget _buildNFCSearchingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.colorAccent.withOpacity(0.1),
                  border: Border.all(
                    color: widget.colorAccent.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.nfc_outlined,
                  size: 48,
                  color: widget.colorAccent,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          "Please bring your phone close to the Magic E-Paper device",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                final delay = index * 0.3;
                final animationValue = (_pulseController.value + delay) % 1.0;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Opacity(
                    opacity: animationValue > 0.5 ? 1.0 : 0.3,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.colorAccent,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTransferProgressState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(widget.colorAccent),
              ),
            ),
            Text(
              "${(progress * 100).toInt()}%",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.colorAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          status,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildHoldStillState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _holdStillPulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _holdStillPulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange.shade50,
                  border: Border.all(
                    color: Colors.orange.shade300,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.pan_tool_outlined,
                  size: 48,
                  color: Colors.orange.shade600,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text(
          "Keep your phone close!",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "The display is refreshing. Please keep your phone near the device until the image appears completely.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.orange.shade600),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Display refreshing...",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.shade600,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            "Transfer Failed",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red.shade700,
              fontSize: 14,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.shade50,
              border: Border.all(color: Colors.green.shade200, width: 2),
            ),
            child: Icon(
              Icons.check_circle,
              size: 48,
              color: Colors.green.shade600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Transfer Complete!",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Your image has been successfully transferred to the E-Paper device.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.3,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      !tagDetected
                          ? Icons.nfc
                          : showHoldStillMessage
                              ? Icons.pan_tool_outlined
                              : displayRefreshComplete
                                  ? Icons.check_circle
                                  : Icons.upload,
                      key: ValueKey(!tagDetected
                          ? 'nfc'
                          : showHoldStillMessage
                              ? 'hold'
                              : displayRefreshComplete
                                  ? 'complete'
                                  : 'upload'),
                      color: !tagDetected
                          ? widget.colorAccent
                          : showHoldStillMessage
                              ? Colors.orange.shade600
                              : displayRefreshComplete
                                  ? Colors.green.shade600
                                  : widget.colorAccent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        !tagDetected
                            ? "Searching for Device"
                            : showHoldStillMessage
                                ? "Display Refreshing"
                                : displayRefreshComplete
                                    ? "Transfer Complete"
                                    : "Writing to E-Paper",
                        key: ValueKey(!tagDetected
                            ? 'search'
                            : showHoldStillMessage
                                ? 'refresh'
                                : displayRefreshComplete
                                    ? 'complete'
                                    : 'write'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: errorMessage != null
                    ? _buildErrorState()
                    : showHoldStillMessage
                        ? _buildHoldStillState()
                        : displayRefreshComplete
                            ? _buildSuccessState()
                            : !tagDetected
                                ? _buildNFCSearchingState()
                                : _buildTransferProgressState(),
              ),
              if (displayRefreshComplete || errorMessage != null) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: displayRefreshComplete
                          ? Colors.green.shade600
                          : Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      displayRefreshComplete ? "Done" : "Close",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
