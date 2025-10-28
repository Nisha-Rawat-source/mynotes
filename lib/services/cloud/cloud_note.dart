//every document generated in firebase have its unique id

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/foundation.dart';

@immutable
class CloudNote {
  final String documentId; //note id
  final String ownerUserId; //user id
  final String text; //content inside note

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  /*QueryDocumentSnapshot
This is a Firestore class.
It represents one document that comes back from a query or collection fetch.
Example:
If your notes collection has 3 documents,
you will get 3 QueryDocumentSnapshot objects → one for each document.
A single Firestore document (snapshot) whose data is in the form of a Map with String keys and values of any type. */
//named constructor
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        //snapshot here is document and every document have unique id generateed by firebase

        /*snapshot.data()
data() is a built-in method in Firestore’s QueryDocumentSnapshot class.
It gives us the actual data of the document as a Map (key-value pairs). */

        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}

/*firebase also return its data in form of map<string,dynamic> but
it is wraped inside a wraper as QueryDocumentSnapshot*/
