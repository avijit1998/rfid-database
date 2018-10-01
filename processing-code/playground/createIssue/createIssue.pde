import processing.serial.*;

Serial mySerial;
Table table;

void setup() {
  mySerial = new Serial(this,"COM10",9600);
  table  = new Table();
  table.addColumn("sid");
  table.addColumn("issue1");
  table.addColumn("issue2");
  table.addColumn("issue3");
  table.addColumn("issue4");
}

void draw() {
  if(mySerial.available() > 0){
    String id = mySerial.readStringUntil(',');
    if(id != null){
      TableRow newRow = table.addRow();
      newRow.setString("sid",null);
      newRow.setString("issue1",null);
      newRow.setString("issue2",null);
      newRow.setString("issue3",null);
      newRow.setString("issue4",null);

    }
    saveTable(table, "Issue/issue.csv");
  }
}