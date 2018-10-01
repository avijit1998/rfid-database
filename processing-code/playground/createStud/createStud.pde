import processing.serial.*;

Serial mySerial;
Table table;

void setup() {
  mySerial = new Serial(this,"COM10",9600);
  table  = new Table();
  table.addColumn("rfid");
  table.addColumn("sid");
  table.addColumn("number of books",Table.INT);
}

void draw() {
  if(mySerial.available() > 0){
    String id = mySerial.readStringUntil(',');
    if(id != null){
      TableRow newRow = table.addRow();
      newRow.setString("rfid", id);
      newRow.setString("sid", "B34156");
      newRow.setInt("number of books",0);
      
    }
    saveTable(table, "student/sid.csv");
  }
}