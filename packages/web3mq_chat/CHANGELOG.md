# CHANGELOG

## 0.1.0-dev.1

- Initial version.

## 0.1.0-dev.2

- fix bugs about persistence.
- add apis on `Group`.

## 0.1.0-dev.3

- Add `resetPassword` method.
- Integrating with CyberConnect.

## 0.1.1-dev.1

- Add support for pre-registering addresses. Messages can now be sent to unregistered addresses by
  pre-registering them
  using the new `preRegister` method.When the address is registered, it will receive any messages
  that were sent to it
  while it was unregistered.

## 0.1.1

- fix some bugs.

## 0.1.2

- fix the parser issue of `DappConnect`.

## 0.1.3-dev.1

- adopt `web3mq_dapp_connect`.

## 0.1.3-dev.2

- fix the issue of channel list.

## 0.1.3-dev.3

- export `UtilsApi.dart`.

## 0.2.0-dev.1

- rename and deprecate some apis for more readable.

## 0.2.0-dev.2

- update dependencies.
- add new example code.

## 0.2.0-dev.3

- returns `null` when `userInfo` api response code 404.

## 0.3.0-dev.1

- Upgraded drift dependency.
- Removed Flutter SDK dependency
- Refactor `CyberService` to `ExtraService`