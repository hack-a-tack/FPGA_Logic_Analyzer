/*
-- MODULE: bitstream_upload
-- FUNCTION: upload bitstream to SPI flash
-- AUTHOR: Jakob Kieszek Ottesen
-- CREATED: 2026-05-11 (YYYY-MM-DD)
-- MODIFIED: 2026-05-13

 Circuit:
 CS#: pin 10    DEFAULT (but explicitly set below)
 MOSI: pin 16   DEFAULT
 MISO: pin 14   DEFAULT
 SCK: pin 15    DEFAULT
 */


#include <SPI.h>  // arduino and flash communicate via SPI, so include the library:

// SPI flash memory register addresses:

const int SPI_SPEED = 100000;

// pins used for the SPI connection
// the others you need are controlled by the SPI library
const int chipSelectPin = 10;


void setup() {
  Serial.begin(9600);

  // initialize the chip select pins:
  pinMode(chipSelectPin, OUTPUT);
  digitalWrite(chipSelectPin, HIGH);

  // start the SPI library:
  SPI.begin();
  
  // give the SPI flash time to set up:
  delay(1000);


  // -------------------------------------------------------------------------
  // DIAGNOSTICS / confirm flash resopnse ------------------------------------
  // -------------------------------------------------------------------------

  showJEDEC();

  releasePowerDown();

  Serial.print("AB Device ID: ");
  printHexByte(readDeviceIdAB());

  Serial.print("Status before WREN: ");
  uint8_t before_status = readStatus1();
  printHexByte(before_status);

  writeEnable();

  Serial.print("Status after WREN: ");
  uint8_t after_status = readStatus1();
  printHexByte(after_status);



  // -------------------------------------------------------------------------
  // Micro-test: erase + read; program + read --------------------------------
  // -------------------------------------------------------------------------
  uint8_t buffer[16] = {0};

  uint8_t testPattern[16] = {
    0x00, 0x11, 0x22, 0x33,
    0x44, 0x55, 0x66, 0x77,
    0x88, 0x99, 0xAA, 0xBB,
    0xCC, 0xDD, 0xEE, 0xFF
  };

  Serial.println("Erasing sector 0...");
  sectorErase4k(0x000000);

  Serial.println("Reading after erase...");
  readData(0x000000, buffer, 16);

  Serial.print("Erase readback: ");
  for (int i = 0; i < 16; i++) {
    if (buffer[i] < 0x10) Serial.print("0");
    Serial.print(buffer[i], HEX);
    Serial.print(" ");
  }
  Serial.println();


  Serial.println("Programming test pattern...");
  pageProgram(0x000000, testPattern, 16);

  Serial.println("Reading after program...");
  readData(0x000000, buffer, 16);

  Serial.print("Program readback: ");
  for (int i = 0; i < 16; i++) {
    if (buffer[i] < 0x10) Serial.print("0");
    Serial.print(buffer[i], HEX);
    Serial.print(" ");
  }
  Serial.println();

  bool pass = true;
  for (int i = 0; i < 16; i++) {
    if (buffer[i] != testPattern[i]) {
      pass = false;
    }
  }

  if (pass) {
    Serial.println("PASS: readback matches test pattern");
  } else {
    Serial.println("FAIL: readback mismatch");
  }

  

  /*

  // -------------------------------------------------------------------------
  // ERASE + PROGRAM  --------------------------------------------------------
  // -------------------------------------------------------------------------

  // bitmap size on disk: 106,496 bytes --> / 4096 (sector size) --> 26 x (4k) sectors
  for (int i = 0; i < 1, i++) {
    sectorErase4k(i);
    pageProgram(i, <data>, <length>);
  }


  // -------------------------------------------------------------------------
  // VERIFY ------------------------------------------------------------------
  // -------------------------------------------------------------------------

  // read back addresses from SPI flash
  for (int i = 0; i < 26, i++) {
    readData(i, <buf>, <length>);
  }

  */

}

void loop() {
  Serial.println("In loop");
  delay(5000);
}






void showJEDEC() {
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));  // MSBFIRST! SPI_MODE0!
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0x9F);  // JEDEC ID request

  unsigned int flash_response[3] = {};
  Serial.println("Wrote 0x9F (JEDEC ID request) on MOSI line to SPI flash");
  // flash should return bytes: 0xEF (manufacturer ID, Winbond Serial Flash), 0x40 (memory type) and 0x13 (capacity) (device ID, W25Q40CL)
  flash_response[0] = SPI.transfer(0x00);
  flash_response[1] = SPI.transfer(0x00);
  flash_response[2] = SPI.transfer(0x00);
  Serial.print("[JEDEC ID] Received (byte 0): ");
  Serial.println(flash_response[0]);
  Serial.print("[JEDEC ID] Received (byte 1): ");
  Serial.println(flash_response[1]);
  Serial.print("[JEDEC ID] Received (byte 2): ");
  Serial.println(flash_response[2]);

  digitalWrite(chipSelectPin, HIGH);  // must deselect after we have received response on MISO from SPI flash
  delayMicroseconds(1);
  SPI.endTransaction();

  if (flash_response[0] == 239 && flash_response[1] == 64 && flash_response[2] == 19) {Serial.println("CHECK: JEDEC ID as expected.");}
  else {Serial.println("ERROR: JEDEC ID not as expected.");}
}

uint8_t readStatus1() {
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));  // MSBFIRST! SPI_MODE0!
  digitalWrite(chipSelectPin, LOW);

  SPI.transfer(0x05);
  uint8_t status = SPI.transfer(0x00);

  digitalWrite(chipSelectPin, HIGH);  // must deselect after we have received response on MISO from SPI flash
  delayMicroseconds(1);
  SPI.endTransaction();
  return status;
}

void writeEnable() {
  // Required for every page program, sector erase, block erase, chip erase, write status register and erase/program security registers instruction
  // WEL is automatically reset after power-up and upon compltion of the write status registe, erase/program security registers, page program, sector erase, ...
  // ... block erase and chip erase instructions
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));  // MSBFIRST! SPI_MODE0!
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0x06);
  digitalWrite(chipSelectPin, HIGH);  // must deselect after we have received response on MISO from SPI flash
  delayMicroseconds(1);
  SPI.endTransaction();
  Serial.println("Wrote 0x06 (WEL, write enable latch) to SPI flash");
}

void releasePowerDown() {
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));  // MSBFIRST! SPI_MODE0!
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0xAB);  // release power down
  digitalWrite(chipSelectPin, HIGH);  // must deselect after we have received response on MISO from SPI flash
  delayMicroseconds(1);
  SPI.endTransaction();
  delayMicroseconds(5);
}

uint8_t readDeviceIdAB() {
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));  // MSBFIRST! SPI_MODE0!
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0xAB);
  SPI.transfer(0x00);
  SPI.transfer(0x00);
  SPI.transfer(0x00);
  uint8_t id = SPI.transfer(0x00);
  digitalWrite(chipSelectPin, HIGH);  // must deselect after we have received response on MISO from SPI flash
  delayMicroseconds(1);
  SPI.endTransaction();
  return id;
}

void printHexByte(uint8_t value) {
  Serial.print("0x");
  if (value < 0x10) Serial.print("0");
  Serial.println(value, HEX);
}


void waitBusyClear() {
  // wait until status bit 1 (BUSY bit) goes low (high during sector erase cycle / page program cycle; low when the cycle is finished)
  while (readStatus1() & 0x01) {
    delay(1);
  }
}

void sendAddress(uint32_t addr) {
  // using uint32_t because no uint24_t available. Address has width 24 bits
  SPI.transfer((addr >> 16) & 0xFF);
  SPI.transfer((addr >> 8) & 0xFF);
  SPI.transfer(addr & 0xFF);
}

void sectorErase4k(uint32_t addr) {
  writeEnable();

  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0x20);
  sendAddress(addr);
  digitalWrite(chipSelectPin, HIGH);
  delayMicroseconds(1);
  SPI.endTransaction();
  
  waitBusyClear();

  Serial.print("0x20: sector erase of sector with address 0x");
  Serial.print(addr, HEX);
  Serial.print(" (");
  Serial.print(addr);
  Serial.println(").");
}

void pageProgram(uint32_t addr, const uint8_t *data, uint16_t len) {
  // len must be <= 256 and must not cross a 256-byte page boundary
  writeEnable();

  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0x02);
  sendAddress(addr);  // address of sector to which you want to write data

  for (uint16_t i = 0; i < len; i++) {
    SPI.transfer(data[i]);
  }

  digitalWrite(chipSelectPin, HIGH);
  delayMicroseconds(1);
  SPI.endTransaction();

  waitBusyClear();

  Serial.print("0x02: page program of sector with address 0x");
  Serial.print(addr, HEX);
  Serial.print(" (");
  Serial.print(addr);
  Serial.println(").");
}

void readData(uint32_t addr, uint8_t *buf, uint16_t len) {
  SPI.beginTransaction(SPISettings(SPI_SPEED, MSBFIRST, SPI_MODE0));
  digitalWrite(chipSelectPin, LOW);
  SPI.transfer(0x03);
  sendAddress(addr);  // address of sector from which you want to read data

  for (uint16_t i = 0; i < len; i++) {
    buf[i] = SPI.transfer(0x00);
  }

  digitalWrite(chipSelectPin, HIGH);
  delayMicroseconds(1);
  SPI.endTransaction();

  Serial.print("0x03: data buffer read from address 0x");
  Serial.print(addr, HEX);
  Serial.print(" (");
  Serial.print(addr);
  Serial.println(").");
}