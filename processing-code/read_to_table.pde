//import the required libraries
import processing.serial.*;

Serial mySerial;
Table table;

void setup()
{
  //set mySerial to listen on COM port 10 at 9600 baud
  mySerial = new Serial(this, "COM10", 9600);
  
  table = new Table();
  //add a column header "Data" for the collected data
  table.addColumn("Data");
}
//draw is like loop in arduino it will work forever based on condition
//here we will use keyPressed function to stop the reading from serial
void draw()
{
  if(mySerial.available() > 0)
  {
    //set the value recieved as a String
    String value = mySerial.readStringUntil('\n');
    //printing here to check whether the value is received or not
    println(value);
    //check to make sure there is a value
    if(value != null)
    {
      //add a new row for each value
      TableRow newRow = table.addRow();
      //place the new row and value under the "Data" column
      newRow.setString("Data", value);
    }
  }
}
//
void keyPressed()
{
  //save as a table in csv format(data/table - data folder name table)
  saveTable(table,"table.csv");
  exit();
}