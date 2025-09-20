//login exceptions

class UserNotFoundAuthException
    implements
        Exception {} //here exception is already define in flutter implent is a keyword which is saying that UserNotFoundAuthException is now behave as an exception

class WrongPasswordAuthException implements Exception {}

//register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

//generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

//implements mtlb ye ek exception define hai or ko class hum bana rhe hai wo v exception k andar ayengaye bs hum humari class m kuch extra v add krskthe if we want
/*This Animal class is like a contract:

Any class that implements it must have a sound() function.

It doesn’t tell what the sound is, just that it must exist. */