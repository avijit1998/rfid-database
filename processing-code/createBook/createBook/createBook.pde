import processing.serial.*;

Serial mySerial;
Table table;

void setup() {
  mySerial = new Serial(this,"COM10",9600);
  table  = new Table();
  table.addColumn("bookname");
  table.addColumn("rfid");
  table.addColumn("bid");
  table.addColumn("issue(0/1)",Table.INT);
}

void draw() {
  if(mySerial.available() > 0){
    String id = mySerial.readStringUntil(',');
    if(id != null){
      TableRow newRow = table.addRow();
      newRow.setString("bookname", "Book1");
      newRow.setString("rfid", id);
      newRow.setString("bid", "B1");
      newRow.setInt("issue(0/1)",0);
      
    }
    saveTable(table, "books/bid.csv");
  }
}