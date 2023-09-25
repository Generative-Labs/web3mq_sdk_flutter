import 'package:flutter/material.dart';
import 'package:web3mq_dapp_connect/web3mq_dapp_connect.dart';

///
class SessionProposalModal extends StatelessWidget {
  ///
  const SessionProposalModal(this.sessionProposal,
      {super.key,
      required this.onSelectedConfirm,
      required this.onSelectedCancel});

  ///
  final SessionProposal sessionProposal;

  // 增加两个回调函数
  final void Function(SessionProposal) onSelectedConfirm;
  final void Function(SessionProposal) onSelectedCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (sessionProposal.proposer.appMetadata.icons?.isNotEmpty ??
                  false)
                CircleAvatar(
                    backgroundImage: NetworkImage(
                        sessionProposal.proposer.appMetadata.icons?.first ??
                            ''),
                    radius: 16)
              else
                const SizedBox(width: 32, height: 32),
              const SizedBox(width: 32, height: 32),
              const SizedBox(width: 8),
              Text(sessionProposal.proposer.appMetadata.url ?? ''),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Namespace: ${sessionProposal.requiredNamespaces}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Description: ${sessionProposal.proposer.appMetadata.description}',
          ),
          const SizedBox(height: 8),
          Text(
            'Message: ${sessionProposal.proposer.appMetadata.description}',
          ),
          ButtonBar(
            children: [
              ElevatedButton(
                onPressed: () => onSelectedCancel(sessionProposal),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => onSelectedConfirm(sessionProposal),
                child: const Text('Confirm'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
