import processing.serial.*; //<>//

Serial mySerial;
Table table0,table;

void setup() {
  
  mySerial = new Serial(this,"COM10",9600); 
  
  table0 = loadTable("student/sid.csv","header");
  table = new Table();
  
  table.addColumn("data");    
}
void draw(){
  
  if(mySerial.available() > 0){  
    String id = mySerial.readStringUntil(',');
    int a = userAuth(id);
    if(a > 0){
      int book_count;
      println("Please scan you books");
      book_count = scanBook();
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
        println("Invalid User");
        break;
      }
    }
  }
  return x;
}

int scanBook(){
  String book_id = mySerial.readStringUntil(',');
  if(book_id != null)
    println(book_id);
  while(book_id != null){   
    TableRow newRow = table.addRow();
    newRow.setString("data", book_id);
    book_id = mySerial.readStringUntil(',');
  }
  return 0;
}