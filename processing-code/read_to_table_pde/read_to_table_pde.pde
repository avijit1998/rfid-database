import processing.serial.*;

Serial mySerial;
Table table;

void setup() {
  
  mySerial = new Serial(this,"COM10",9600);

  table = new Table();
  
  table.addColumn("data");
  
}
void draw(){
  if(mySerial.available() > 0){
    String value = mySerial.readStringUntil('\n');
    if(value != null){
      TableRow newRow = table.addRow();
      newRow.setString("data", value);
    }
    saveTable(table, "data/new.csv");
  }
}