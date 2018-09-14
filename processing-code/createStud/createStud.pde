import processing.serial.*;

Serial mySerial;
Table table;

void setup() {
  mySerial = new Serial(this,"COM10",9600);
  table  = new Table();
  table.addColumn("data");
  table.addColumn("sid");
}

void draw() {
  if(mySerial.available() > 0){
    String id = mySerial.readStringUntil(',');
    if(id != null){
      TableRow newRow = table.addRow();
      newRow.setString("data", id);
      newRow.setString("sid", "B34156");
    }
    saveTable(table, "student/sid.csv");
  }
}