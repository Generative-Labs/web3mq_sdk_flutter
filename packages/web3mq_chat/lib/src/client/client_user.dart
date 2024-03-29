part of 'client.dart';

///
extension UserExtension on Web3MQClient {
  ///
  Future<UserInfo?> userInfo(String didType, String didValue) async {
    final userInfoFuture = _service.user.userInfo(didType, didValue);
    final List<Future> tasks = [userInfoFuture];
    if (null != _cyberService) {
      await _authCyberIfNeeded();
      final cyberUserInfoFuture =
          _cyberService!.profile.getProfileByAddress(didValue);
      tasks.add(cyberUserInfoFuture);
    }
    final results = await Future.wait(tasks);
    if (results.isEmpty) {
      return null;
    }
    final user = results.first as UserInfo?;
    final cyberUserInfo =
        results.length > 1 ? results[1] as CyberProfile? : null;
    user?.cyberProfile = cyberUserInfo;
    return user;
  }

  /// Updates user profile.
  Future<void> updateProfile(String avatarUrl) async =>
      _service.user.updateProfile(avatarUrl);

  /// Registers a user.
  @Deprecated("Use [createCredentials] instead")
  Future<Credentials> register(DID did, String password,
          {String? domain, String? userId}) async =>
      _doCreateCredentials(did, password,
          domain: domain, type: PasswordSettingType.register, userId: userId);

  /// Create credentials.
  Future<Credentials> createCredentials(DID did, String password,
          {String? domain, String? userId}) async =>
      _doCreateCredentials(did, password,
          domain: domain, type: PasswordSettingType.register, userId: userId);

  /// Resets password for a user.
  Future<Credentials> resetPassword(DID did, String password,
          {String? domain, String? userId}) async =>
      _doCreateCredentials(did, password,
          domain: domain, type: PasswordSettingType.reset, userId: userId);

  /// Registers a user by proxy.
  ///
  /// The [userId] parameter can be generated using the [generateUserIdByDid] function.
  ///
  /// Note that this functionality can also be implemented on the Dapp backend.
  Future<UserRegisterResponse> preRegister(DID did, String userId,
          String dappId, String dappSignature, DateTime dateTime) =>
      _service.user.preRegister(dappId, dappSignature, did.type, did.value,
          userId, dateTime, _apiKey);

  /// Private key in Hex.
  Future<String> retrievePrivateKey(DID did, String password) async {
    if (null == walletConnector) {
      throw Web3MQError('WalletConnector did not setup');
    }
    final message = SignTextFactory.forMainPrivateKey(did, password);
    final signature = await walletConnector!.personalSign(message, did.value);
    return _getPrivateKeyBySignature(signature);
  }

  /// Generates a SessionKey with its `DID` and password, also with an duration for expired.
  /// You can connect that user by `client.connectUser(user)`
  Future<User> generateSessionKeyWithPassword(
      DID did, String password, Duration expiredDuration,
      {String? userId}) async {
    final privateKey = await retrievePrivateKey(did, password);
    return await generateSessionKey(did, privateKey, expiredDuration,
        userId: userId);
  }

  /// Gets a user with its `DID` and password, also with an duration for expired.
  /// You can connect that user by `client.connectUser(user)`
  @Deprecated("Use [generateSessionKeyWithPassword] instead")
  Future<User> userWithDIDAndPassword(
      DID did, String password, Duration expiredDuration,
      {String? userId}) async {
    final privateKey = await retrievePrivateKey(did, password);
    return await userWithDIDAndPrivateKey(did, privateKey, expiredDuration,
        userId: userId);
  }

  Future<User> generateSessionKey(
      DID did, String privateKey, Duration expiredDuration,
      {String? userId}) async {
    final theUserId = userId ?? await _getOrGenerateUserId(did.type, did.value);
    final mainPrivateKeyBytes = hex.decode(privateKey);
    final keyPair = await cry.Ed25519().newKeyPairFromSeed(mainPrivateKeyBytes);
    final mainPublicKey = await keyPair.extractPublicKey();
    final mainPublicKeyHex = hex.encode(mainPublicKey.bytes);

    final tempKeyPair = await cry.Ed25519().newKeyPair();
    final tempPublicKey = await tempKeyPair.extractPublicKey();
    final tempPublicKeyHex = hex.encode(tempPublicKey.bytes);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final publicKeyExpiredTimestamp =
        timestamp + expiredDuration.inMilliseconds;
    final signatureRaw =
        "$theUserId$tempPublicKeyHex$publicKeyExpiredTimestamp$timestamp";
    final signatureRawBytes = utf8.encode(signatureRaw);
    //

    final sha224 = pointycastle.Digest("SHA3-224");
    final signatureContentHash =
        sha224.process(Uint8List.fromList(signatureRawBytes));
    final signatureContent = hex.encode(signatureContentHash);

    final signatureObject = await cry.Ed25519()
        .sign(utf8.encode(signatureContent), keyPair: keyPair);
    final signature = base64Encode(signatureObject.bytes);

    final response = await _service.user.login(
        theUserId,
        did.type,
        did.value,
        signature,
        signatureContent,
        mainPublicKeyHex,
        tempPublicKeyHex,
        "ed25519",
        timestamp,
        publicKeyExpiredTimestamp);

    return User(response.userId, DID(response.didType, response.didValue),
        hex.encode(await tempKeyPair.extractPrivateKeyBytes()));
  }

  /// Gets a user with its `DID` and privateKey, also with an duration for expired.
  /// You can connect that user by `client.connectUser(user)`
  @Deprecated("Use [generateSessionKey] instead")
  Future<User> userWithDIDAndPrivateKey(
          DID did, String privateKey, Duration expiredDuration,
          {String? userId}) =>
      generateSessionKey(did, privateKey, expiredDuration);

  /// Register cyber signing key
  Future<String> registerCyberSigningKey() async {
    if (null == _cyberService) throw Web3MQError('Cyber service did not setup');

    if (null == state.currentUser) {
      throw Web3MQError('User did not setup');
    }

    await _authCyberIfNeeded();
    final address = state.currentUser!.did.value;

    final storage = CyberSigningKeyStorage();
    final hasKey = await storage.hasSigningKeyByAddress(address);
    if (hasKey) {
      return await storage.getSigningKeyByAddress(address);
    }

    final privateKey = await storage.getSigningKeyByAddress(address);
    final keyPair =
        await cry.Ed25519().newKeyPairFromSeed(hex.decode(privateKey));
    final publicKey = await keyPair.extractPublicKey();
    final publicKeyHex = hex.encode(publicKey.bytes);

    final acknowledgement = '''
I authorize CyberConnect from this device using signing key:
''';

    final message = '$acknowledgement$publicKeyHex';
    final signature =
        await cry.Ed25519().sign(utf8.encode(message), keyPair: keyPair);
    final signatureHex = hex.encode(signature.bytes);

    final status = await _cyberService!.connection
        .registerSigningKey(address, message, signatureHex, _apiKey);
    if ('SUCCESS' == status) {
      // persistence key
      storage.setSigningKeyByAddress(address, privateKey);
    } else {
      throw Web3MQError('Register cyber signing key failed: $status');
    }
    return privateKey;
  }

  Future<String> generateUserIdByDid(DID did) async {
    final bytes = utf8.encode('${did.type}:${did.value}');
    final sha224Bytes =
        await cry.Sha224().hash(bytes).then((value) => value.bytes);
    return "user:${hex.encode(sha224Bytes)}";
  }

  /// Gets your main private key.
  Future<Credentials> _doCreateCredentials(DID did, String password,
      {String? domain,
      String? userId,
      PasswordSettingType type = PasswordSettingType.register}) async {
    if (null == walletConnector) {
      throw Web3MQError('WalletConnector did not setup');
    }

    final didType = did.type;
    final didValue = did.value;
    final privateKeyHex = await retrievePrivateKey(did, password);

    final keyPair =
        await cry.Ed25519().newKeyPairFromSeed(hex.decode(privateKeyHex));
    final publicKey = await keyPair.extractPublicKey();
    final publicKeyHex = hex.encode(publicKey.bytes);
    final theUserId = userId ?? await _getOrGenerateUserId(didType, didValue);

    final walletTypeName = "Ethereum";
    final pubKeyType = "ed25519";

    final currentDate = DateTime.now();
    final timestamp = currentDate.millisecondsSinceEpoch;

    final domainUrl = domain ?? "www.web3mq.com";

    final nonceContentRaw =
        "$theUserId$pubKeyType$publicKeyHex$didType$didValue$timestamp";

    final sha224 = pointycastle.Digest("SHA3-224");
    final hashed =
        sha224.process(Uint8List.fromList(utf8.encode(nonceContentRaw)));
    final nonceContent = hex.encode(hashed);

    final dateFormatter = DateFormat('dd/MM/yyyy HH:mm');
    final formattedDateString = dateFormatter.format(currentDate);

    String signatureRaw = SignTextFactory.forSetPassword(walletTypeName,
        didValue, domainUrl, nonceContent, formattedDateString, type);
    final signature =
        await walletConnector!.personalSign(signatureRaw, didValue);

    final response = await _service.user.register(didType, didValue, theUserId,
        publicKeyHex, pubKeyType, signatureRaw, signature, currentDate, _apiKey,
        type: type);

    return Credentials(response.userId,
        DID(response.didType, response.didValue), privateKeyHex);
  }

  Future<String> _getOrGenerateUserId(String didType, String didValue) async {
    try {
      final user = await _service.user.userInfo(didType, didValue);
      final userId = user?.userId;
      if (null != userId) {
        return userId;
      }
    } catch (_) {}
    // Generate and return a new user ID if the user ID is null or an exception occurs
    return await generateUserIdByDid(DID(didType, didValue));
  }

  ///
  Future<String?> _authCyberIfNeeded() async {
    if (null == state.currentUser) {
      return null;
    }

    if (null == walletConnector) {
      return null;
    }

    if (null == _cyberService) {
      return null;
    }

    final currentAccessToken = await _cyberService!.fetchAccessToken();
    if (null != currentAccessToken) {
      return currentAccessToken;
    }

    final domain = 'web3mq.com';
    final address = state.currentUser!.did.value;

    final message = await _cyberService!.auth.loginGetMessage(domain, address);
    final signature = await walletConnector!.personalSign(message, address);
    final token =
        await _cyberService!.auth.loginVerify(domain, address, signature);

    // persistence token
    _cyberService?.saveAccessToken(token);

    return token;
  }

  Future<String> _getPrivateKeyBySignature(String signature) async {
    final hashed = await cry.Sha256().hash(utf8.encode(signature));
    return hex.encode(hashed.bytes);
  }

  /// Registers a user by proxy.
  ///
  /// The [userId] parameter can be generated using the [client.generateUserIdByDid] function.
  @Deprecated("Use [preRegister] instead")
  Future<UserRegisterResponse> registerByProxy(DID did, String userId,
          String dappId, String dappSignature, DateTime dateTime) =>
      preRegister(did, userId, dappId, dappSignature, dateTime);
}
