//login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//register exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class GenericGoogleException implements Exception {}

//google log-in exceptions
class AccountExistsWithDifferentCrendentialsGoogleException implements Exception {}

class InvalidCrendentialGoogleException implements Exception {}

class UserDisabledGoogleException implements Exception {}

class OperationNotAllowedGoogleException implements Exception {}

class UserNotFoundGoogleException implements Exception {}

class WrongPasswordGoogleException implements Exception {}

class InvalidVerificationCodeGoogleException implements Exception {}

class InvalidVerificationIDGoogleException implements Exception {}