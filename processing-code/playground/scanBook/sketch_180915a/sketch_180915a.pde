import processing.serial.*;

Serial mySerial;
int a = 0;
String temp;
void setup(){
  
  mySerial  = new Serial(this,"COM10",9600);
  
}
void draw(){
  
  if(mySerial.available() > 0){
    String value = mySerial.readStringUntil(',');
    if(a == 0 && value != null){
      temp = value;
      a = userAuth(value);
      println("Now the value of a = "+a);
      println("scan your books");
      println(temp);
    }
    //for books scanning
    if(value != null && a != 0 && value.equals(temp) != true){
      println(value);
    }
  }
}
int userAuth(String id){
  if(id != null){
      //println(id);
      return 1;
    }
    return 0;
}