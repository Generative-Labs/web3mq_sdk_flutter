import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3mq/src/dapp_connect/model/app_metadata.dart';
import 'package:web3mq/src/dapp_connect/model/namespace.dart';
import 'package:web3mq/src/dapp_connect/model/participant.dart';
import 'package:web3mq/src/dapp_connect/model/session.dart';
import 'package:web3mq/src/dapp_connect/storage/storage.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Web3MQSessionProposalStorage', () {
    late Storage storage;

    late Map<String, ProposalNamespace> requiredNamespaces;

    late SessionProperties sessionProperties;

    late Participant participant;

    setUp(() async {
      final store = FakeSharedPreferencesStore({});
      SharedPreferencesStorePlatform.instance = store;
      storage = Web3MQStorage();
      requiredNamespaces = {
        '456': ProposalNamespace({}, {'personal_sign'}, {})
      };
      sessionProperties = SessionProperties('789');
      participant = Participant('publicKey',
          AppMetadata('name', 'description', 'url', ['icons'], 'redirect'));
    });

    test('setSessionProposal and getSessionProposal', () async {
      final topic = '123';
      final sessionProposal = SessionProposalFactory.create(
          topic, participant, requiredNamespaces, sessionProperties);
      final proposalId = sessionProposal.id;
      await storage.setSessionProposal(sessionProposal);
      final retrievedProposal = await storage.getSessionProposal(proposalId);
      expect(retrievedProposal, equals(sessionProposal));
    });

    test('removeSessionProposal', () async {
      final topic = '123';
      final sessionProposal = SessionProposalFactory.create(
          topic, participant, requiredNamespaces, sessionProperties);
      final proposalId = sessionProposal.id;
      await storage.setSessionProposal(sessionProposal);
      await storage.removeSessionProposal(proposalId);
      final retrievedProposal = await storage.getSessionProposal(proposalId);
      expect(retrievedProposal, isNull);
    });

    test('clear', () async {
      final topic1 = '123';
      final sessionProposal1 = SessionProposalFactory.create(
          topic1, participant, requiredNamespaces, sessionProperties);
      final proposalId1 = sessionProposal1.id;

      final topic2 = '123';
      final sessionProposal2 = SessionProposalFactory.create(
          topic2, participant, requiredNamespaces, sessionProperties);
      final proposalId2 = sessionProposal2.id;

      await storage.setSessionProposal(sessionProposal1);
      await storage.setSessionProposal(sessionProposal2);
      await storage.clear();

      final retrievedProposal1 = await storage.getSessionProposal(proposalId1);
      final retrievedProposal2 = await storage.getSessionProposal(proposalId2);

      expect(retrievedProposal1, isNull);
      expect(retrievedProposal2, isNull);
    });
  });
}

class FakeSharedPreferencesStore extends SharedPreferencesStorePlatform {
  FakeSharedPreferencesStore(Map<String, Object> data)
      : backend = InMemorySharedPreferencesStore.withData(data);

  final InMemorySharedPreferencesStore backend;
  final List<MethodCall> log = <MethodCall>[];

  @override
  Future<bool> clear() {
    log.add(const MethodCall('clear'));
    return backend.clear();
  }

  @override
  Future<Map<String, Object>> getAll() {
    log.add(const MethodCall('getAll'));
    return backend.getAll();
  }

  @override
  Future<Map<String, Object>> getAllWithPrefix(String prefix) {
    log.add(const MethodCall('getAllWithPrefix'));
    return backend.getAllWithPrefix(prefix);
  }

  @override
  Future<bool> remove(String key) {
    log.add(MethodCall('remove', key));
    return backend.remove(key);
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) {
    log.add(MethodCall('setValue', <dynamic>[valueType, key, value]));
    return backend.setValue(valueType, key, value);
  }
}
