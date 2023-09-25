import 'package:flutter/material.dart';
import 'package:web3mq_dapp_connect/web3mq_dapp_connect.dart';

///
class RequestModal extends StatelessWidget {
  ///
  const RequestModal(this.request,
      {super.key,
      required this.onSelectedConfirm,
      required this.onSelectedCancel});

  ///
  final Request request;

  // 增加两个回调函数
  final void Function(Request) onSelectedConfirm;
  final void Function(Request) onSelectedCancel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (request.sender?.appMetadata.icons?.isNotEmpty ?? false)
                  CircleAvatar(
                      backgroundImage: NetworkImage(
                          request.sender?.appMetadata.icons?.first ?? ''),
                      radius: 16)
                else
                  const SizedBox(width: 32, height: 32),
                const SizedBox(width: 32, height: 32),
                const SizedBox(width: 8),
                Text(request.sender?.appMetadata.url ?? ''),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: SizedBox(
                height: 100, // 固定高度
                child: Text(
                  'Namespace: ${request.params}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${request.sender?.appMetadata.description}',
            ),
            const SizedBox(height: 8),
            Text(
              'Message: ${request.sender?.appMetadata.description}',
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () => onSelectedCancel(request),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => onSelectedConfirm(request),
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
