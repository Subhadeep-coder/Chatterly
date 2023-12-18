import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/config/agora_config.dart';
import 'package:whatsapp/constant/widgets/loader.dart';
import 'package:whatsapp/features/call/controller/call_controller.dart';
import 'package:whatsapp/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final Call call;
  final bool isGroupChat;
  const CallScreen({
    super.key,
    required this.call,
    required this.channelId,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = '';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  void initAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client == null
          ? const Loader()
          : SafeArea(
              child: Stack(
              children: [
                AgoraVideoViewer(client: client!),
                AgoraVideoButtons(
                  client: client!,
                  disconnectButtonChild: IconButton(
                    onPressed: () async {
                      await client!.engine.leaveChannel();
                      ref.read(callControllerProvider).endCall(
                            context,
                            widget.call.callerId,
                            widget.call.recieverId,
                          );
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.call_end),
                  ),
                ),
              ],
            )),
    );
  }
}
