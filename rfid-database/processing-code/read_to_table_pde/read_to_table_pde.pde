import processing.serial.*; //<>//

Serial mySerial;
Table table0,table;
int a = 0;
String temp;

void setup() {
  
  mySerial = new Serial(this,"COM10",9600); 
  
  table0 = loadTable("student/sid.csv","header");
  table = new Table();
  
  table.addColumn("data");    
}
void draw(){
  
  if(mySerial.available() > 0){  
    String value = mySerial.readStringUntil(',');
    
    //for authentication
    if(a == 0 && value != null){
      temp = value;
      
      a = userAuth(value);
      if(a == 0)
        println("invalid user");
      if(a != 0)
        println("Please scan you books");
    }
    //scanning the books
    if(value != null && a != 0 && value.equals(temp) != true){
      scanBook(value);
    }
  }
  saveTable(table, "data/new.csv");
}

int userAuth(String id){
  int x=0;
  
  if(id != null){
    
    for(int  i = 0 ;i < table0.getRowCount(); i++ ){
      
      if(id.equals(table0.getString(i,"data")) == true){
        println("Welcome "+table0.getString(i,"sid"));
        x = 1;
        break;
      }
      else{ 
        x = 0;
      }
    }
  }
  return x;
}

void scanBook(String value){
  String book_id = value;
  int flag = 0;
  flag = checkWhetherBook(book_id);
  int i=0;
  int count = 0;
  String t = "nothing";
  while(book_id !=null && book_id.equals(table0.getString(i,"data")) != true && count < 3)
    println(book_id);
    if(book_id.equals(t) != true){
      TableRow newRow = table.addRow();
      newRow.setString("data", book_id);
      t = book_id;
    }
      
}

int checkWhetherBook(book_id){
  for(int  i = 0 ;i < table0.getRowCount(); i++ ){
      
      if(book_id.equals(table0.getString(i,"data")) == true){
        return 1;
      }
  }
  return 0;
}