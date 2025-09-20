/* extension Filter<T> on Stream<List<T>>  
This creates an extension named 'Filter' on Stream<List<T>>.  
- <T> is a generic type, meaning it can be any data type (like DatabaseNote, int, String, etc.)  
- By doing this, we are adding a new function 'filter' to all Stream<List<T>> types.  
*/
extension Filter<T> on Stream<List<T>> {
  /* Stream<List<T>> filter(bool Function(T) where)  
  - This defines a function 'filter' that returns a Stream<List<T>>  
  - It takes a parameter 'where' which is a function that accepts one item of type T  
    and returns a bool (true or false).  
  - So, 'where' tells which items to keep (true) or remove (false).  

  Important:
  ----------
  - The 'where' here is only a placeholder name for the function you will pass when calling 'filter'.  
  - This is NOT the return value; this is the actual condition function itself.  
  - Later, when you use filter(...), the function you pass as an argument will replace this 'where'.  
  */
  Stream<List<T>> filter(bool Function(T) where) =>

      /* map((items) => items.where(where).toList());  

      - 'map' is a built-in Dart function for streams.  
      - Each time the stream emits a list (called 'items'), map runs this code on it.  

      Here’s what happens inside map:  
      -------------------------------------
      1) 'items' → this is the full list of data coming from the stream.  
      2) '.where(where)' →  
         - 'where' is a **built-in Dart list function** that filters the list.  
         - It checks each element of 'items' using the condition function we passed  
           when calling 'filter'.  
         - If the condition returns true → the item stays in the list.  
         - If the condition returns false → the item is removed.  
         - So the parameter 'where' becomes the actual condition function here.  
      3) '.toList()' →  
         - After filtering, 'where' returns an Iterable (like a temporary list).  
         - '.toList()' converts this Iterable back into a normal List so it  
           matches our return type Stream<List<T>>.  

      Finally, the 'map' returns a new stream that sends out only the filtered lists.
      */
      map((items) => items.where(where).toList());
}

/* This is a generic filter function.  
You can use it in any Stream<List<T>> to filter items dynamically.  
The actual condition for filtering is provided when calling 'filter',  
for example in NoteService.  
*/
