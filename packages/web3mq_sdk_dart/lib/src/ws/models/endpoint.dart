enum Endpoint {
  devUsWest2(uri: "dev-us-west-2.web3mq.com"),
  devJp1(uri: "dev-ap-jp-1.web3mq.com"),
  devSg1(uri: "dev-ap-singapore-1.web3mq.com"),
  testUsWest1(uri: "testnet-us-west-1-1.web3mq.com"),
  testUsWest2(uri: "testnet-us-west-1-2.web3mq.com"),
  testJp1(uri: "testnet-ap-jp-1.web3mq.com"),
  testJp2(uri: "testnet-ap-jp-2.web3mq.com"),
  testSg1(uri: "testnet-ap-singapore-1.web3mq.com"),
  testSg2(uri: "testnet-ap-singapore-2.web3mq.com");

  const Endpoint({
    required this.uri,
  });

  final String uri;
}
