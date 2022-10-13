import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Debug "mo:base/Debug";
import Array "mo:base/Array";
import Trie "mo:base/Trie";

// we can't duplicate name we import from base lib
import Maps "mo:base/RBTree";


actor Worker {


// record
type ToDo = {
  task : Text;
  finished : Bool;
};

// provate func will generate hash of numbers
func natHash(n : Nat) : Hash.Hash {
  Text.hash(Nat.toText(n))
};

//  we made two variable  , goona use in many functions
//  todos_array like a array

var todos_array = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
var taskID : Nat = 0;
 
 
  // Returns the ID that was given to your task
  public func addTodo(task : Text) : async Nat {
    // we assign variable taskID to id
    let id = taskID;
    todos_array.put(id, { task = task; finished = false });
    // it willl push id ,task and status (like task is finished or not)
    taskID += 1;
    //  everytime when  you add task taskID increases with one
    id;
  };



// it will show no of task
public query func show_no_of_task() : async Nat {
   return todos_array.size()
  };


  
  public func finish_task_by_calling_this_function(id : Nat) : async () {
    ignore do ? {
      let task = todos_array.get(id)!.task;
      // it will change the status of function by changing its boolean value
      todos_array.put(id, { task; finished = true });
    }
  };

public query func show_all_task_in_text() : async Text {
    var output : Text = "\n___Tasks___";
    for (todo : ToDo in todos_array.vals()) {
      output #= "\n" # todo.task;
      if (todo.finished) { output #= " ✔"; };
    };
    output # "\n"
  };


// ex - 
// var my_text : [Text] = ["ballu" , "kallu", "sallu", "allu"];

// // now i can iterate array between \ 
//   public query func show_text() : async Text {
//     var display : Text = "\n_lets_begin";
//     for ( t : Text in my_text.vals()){
//       display #= "\n" # t ;

//     };
//     display # "\n"
//   };
//  it return - "\n_lets_begin\nballu\nkallu\nsallu\nallu\n


  public func delete_finished_task() : async () {
    // it will check task is finished or not by checking its boolean value
    todos_array := Map.mapFilter<Nat, ToDo, ToDo>(todos_array, Nat.equal, natHash, 
              func(_, todo) { if (todo.finished) null else ?todo });
  };


};

