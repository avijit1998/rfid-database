import processing.serial.*; //<>//

Serial mySerial;
Table tableS,tableB,tableI,table;
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
      
      //println("you issued "+tableS.getInt(row,"number of books")+" books");
      println("you issued" + numberOfBooksUnderID(temp) + " books");
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
        
        count = issueBook(value,temp);
        b = 0;
      }
      else if(value.equals(temp) == true && b > 0 ){
        a = 0;
        b = 0;
        println("the student did not issue any book");
        int row = updateNumberOfBooks(temp);
        //println("you issued "+tableS.getInt(row,"number of books")+" books");
        println("you issued" + numberOfBooksUnderID(temp) + " books");
        println("lets get to next student");
      }
      else if(value.equals(temp) == true && count > 0){
        a = 0;
        b = 0;
        String[] s = booksUnderID(temp);
        
        
        //println("you issued "+tableS.getInt(row,"number of books")+" books");
        println("you issued" + numberOfBooksUnderID(temp) + " books");
        println("books issued by you");
        for(int k = 0;k < s.length ; k++){
          if(s[k] != null)
            println(s[k]);
        }
        count = 0;
        println("lets get to next student");
      }
    }
}

int issueBook(String book_id,String stud_id){
  
  int flag = 0;
  
  flag = checkWhetherBook(book_id,stud_id);
  
  if(book_id !=null && flag != 0 && book_id.equals(t) == false){
    
    TableRow newRow = table.addRow();
    newRow.setString("data", book_id);
    t = book_id;
    count++;
  }
  return count;
}

int checkWhetherBook(String book_id,String stud_id){
  
  for(int  i = 0 ;i < tableB.getRowCount(); i++ ){
          
      if(book_id.equals(tableB.getString(i,"rfid")) == true && tableB.getInt(i,"issue(0/1)") == 0){
        println(tableB.getString(i,"bookname"));
        
        tableB.setInt(i,"issue(0/1)",1);
        tableB.setString(i,"issued under",stud_id);
        
        return 1;
      }
      else if(book_id.equals(tableB.getString(i,"rfid")) == true && tableB.getInt(i,"issue(0/1)") == 1 ){
        
        if(getSID(tableB.getString(i,"issued under")) == getSID(stud_id)){
          
          tableB.setInt(i,"issue(0/1)",0);
          tableB.setString(i,"issued under",null);
          println("book returned");
        }
      else{
          println("the book is issued under " + getSID(tableB.getString(i,"issued under")));
        }
      }
  }
  return 0;
}

int updateNumberOfBooks(String tem){
  println(tem);
  for(int  i = 0 ;i < tableS.getRowCount(); i++ ){
    if(tem.equals(tableS.getString(i,"rfid")) == true){
      
      tableS.setInt(i,"number of books",numberOfBooksUnderID(tem));
      return i;
    }
  }
  return -1;
}

String getSID(String rfid){
  for(int  i = 0 ;i < tableS.getRowCount(); i++ ){
    if(rfid.equals(tableS.getString(i,"rfid")) == true)
      return tableS.getString(i,"sid");
  }
  return null;
}

String getBID(String rfid){
  for(int  i = 0 ;i < tableB.getRowCount(); i++ ){
    if(rfid.equals(tableB.getString(i,"rfid")) == true)
      return tableB.getString(i,"bid");
  }
  return null;
}

String[] booksUnderID(String stud_id){
  int j = 0;
  String[] str  = new String[tableB.getRowCount()];
  for(int i = 0;i < tableB.getRowCount();i++){
    if(tableB.getString(i,"issued under") != null){
      if(tableB.getString(i,"issued under").equals(stud_id) == true){
      
      str[j++] = tableB.getString(i,"bid");
    }
    }
  }
  return str;
}

int numberOfBooksUnderID(String stud_id){
  int j = 0;
  for(int i = 0;i < tableB.getRowCount();i++){
    if(tableB.getString(i,"issued under") != null){
      
      if(tableB.getString(i,"issued under").equals(stud_id) == true){
        j++;
      }
    }
  }
  return j;
}