#include "SPI.h"
#include "MFRC522.h"

#define SS_PIN 10
#define RST_PIN 9
#define SP_PIN 8

MFRC522 rfid(SS_PIN, RST_PIN);

MFRC522::MIFARE_Key key;

unsigned long int milli_time;

float voltage;

void setup() {
  Serial.begin(9600);
  
//  Serial.println("CLEARDATA");
//  Serial.println("LABEL,Computer Time,Time (Milli Sec.),Id");  
  
  SPI.begin();
  rfid.PCD_Init();
}

void loop() {
  if (!rfid.PICC_IsNewCardPresent() || !rfid.PICC_ReadCardSerial())
    return;

  // Serial.print(F("PICC type: "));
  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
  // Serial.println(rfid.PICC_GetTypeName(piccType));

  // Check is the PICC of Classic MIFARE type
  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI &&
    piccType != MFRC522::PICC_TYPE_MIFARE_1K &&
    piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    //Serial.println(F("Your tag is not of type MIFARE Classic."));
    return;
  }

  String strID = "";
  
  for (byte i = 0; i < 4; i++) {
    strID +=
    (rfid.uid.uidByte[i] < 0x10 ? "0" : "") +
    String(rfid.uid.uidByte[i], HEX) +
    (i!=3 ? ":" : "");
  }
  strID.toUpperCase();

  //Serial.print("Tap card key: ");
  milli_time = millis();
  voltage = 5.0 * analogRead(A0) / 1024.0;
//  Serial.print("DATA,TIME,");
//  Serial.print(milli_time);
//  Serial.print(",");
  Serial.print(strID+',');

  rfid.PICC_HaltA();
  rfid.PCD_StopCrypto1();
}
