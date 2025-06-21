class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

//c in crud
class CouldNotCreateNoteException extends CloudStorageExceptions {}

//r in crud
class CouldNotGetAllNotesException extends CloudStorageExceptions {}

//u in crud
class CouldNotUpdateNoteException extends CloudStorageExceptions {}

//d in crud
class CouldNotDeleteNoteException extends CloudStorageExceptions {}
