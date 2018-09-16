import processing.serial.*; //<>//

Serial mySerial;
Table tableS,tableB,table;
int a = 0,b;
String temp = null;
String t = "nothing";
int count;
String value;
void setup() {
  
  mySerial = new Serial(this,"COM10",9600); 
  
  tableS = loadTable("student/sid.csv","header");
  tableB = loadTable("books/bid.csv","header");
  table = new Table();
  
  table.addColumn("data");
}

void draw(){
  
  if(mySerial.available() > 0){  
    value = mySerial.readStringUntil(',');
    
    if(temp == null)
      b = 0;
 
    //for authentication
    if(a == 0 && value != null){
      temp = value;
      
      a = userAuth(value);
      if(a == 0)
        println("invalid user");
      if(a != 0){
        count = 0;
        println("Please scan you books");
        b = 0;
      } 
    }
    if(a != 0)
      scanbooks(value);
    
    if(count >= 3){
      int row = updateNumberOfBooks(temp,count);
      println("you issued "+tableS.getInt(row,"number of books")+" books");
      a = 0;
      count = 0;
      println("you can enter 3 at a time atmost");
      println("lets get to next student");
     }
     
     if(temp != null && count == 0){
       b++;
     }
  }
  saveTable(table, "data/new.csv");
}

int userAuth(String id){
  int x=0;
  
  if(id != null){
    
    for(int  i = 0 ;i < tableS.getRowCount(); i++ ){
      
      if(id.equals(tableS.getString(i,"rfid")) == true){
        println("Welcome "+tableS.getString(i,"sid"));
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

void scanbooks(String value){
  if(value != null && a != 0){
    
      if(value.equals(temp) == false){
        
        count = issueBook(value);
        b = 0;
      }
      else if(value.equals(temp) == true && b > 0 ){
        a = 0;
        b = 0;
        println("the student did not issue any book");
        println("lets get to next student");
      }
      else if(value.equals(temp) == true && count > 0){
        a = 0;
        b = 0;
        
        int row = updateNumberOfBooks(temp,count);
        println("you issued "+tableS.getInt(row,"number of books")+" books");
        
        count = 0;
        println("lets get to next student");
      }
    }
}

int issueBook(String value){
  String book_id = value;
  int flag = 0;
  flag = checkWhetherBook(book_id);
  
  if(book_id !=null && flag != 0 && book_id.equals(t) == false){
    println(book_id);
    TableRow newRow = table.addRow();
    newRow.setString("data", book_id);
    t = book_id;
    count++;
  }
  return count;
}

int checkWhetherBook(String book_id){
  for(int  i = 0 ;i < tableB.getRowCount(); i++ ){
      
      if(book_id.equals(tableB.getString(i,"rfid")) == true){
        return 1;
      }
  }
  return 0;
}

int updateNumberOfBooks(String tem,int c){
  for(int  i = 0 ;i < tableS.getRowCount(); i++ ){
    if(tem.equals(tableS.getString(i,"rfid")) == true){
      println("The user is " + tableS.getString(i,"sid"));
      tableS.setInt(i,"number of books",c);
      return i;
    }
  }
  return -1;
}