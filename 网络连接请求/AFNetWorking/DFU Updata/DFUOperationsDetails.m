/*
 * Copyright (c) 2015, Nordic Semiconductor
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this
 * software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "DFUOperationsDetails.h"
#import "Utility.h"

#define  PACKET_SIZE  20

@implementation DFUOperationsDetails


-(void) enableNotification
{
    HLog(@"DFUOperationsdetails enableNotification");
    [self.bluetoothPeripheral setNotifyValue:YES forCharacteristic:self.dfuControlPointCharacteristic];
}

-(void) startDFU:(DfuFirmwareTypes)firmwareType
{
    HLog(@"DFUOperationsdetails startDFU");
    self.dfuFirmwareType = firmwareType;
    uint8_t value[] = {START_DFU_REQUEST, firmwareType};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)startOldDFU
{
    HLog(@"DFUOperationsdetails startOldDFU");    
    uint8_t value[] = {START_DFU_REQUEST};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) writeFileSize:(uint32_t)firmwareSize
{
    HLog(@"DFUOperationsdetails writeFileSize");
    uint32_t fileSizeCollection[3];
    switch (self.dfuFirmwareType) {
        case SOFTDEVICE:
            fileSizeCollection[0] = firmwareSize;
            fileSizeCollection[1] = 0;
            fileSizeCollection[2] = 0;
            break;
        case BOOTLOADER:
            fileSizeCollection[0] = 0;
            fileSizeCollection[1] = firmwareSize;
            fileSizeCollection[2] = 0;
            break;
        case APPLICATION:
            fileSizeCollection[0] = 0;
            fileSizeCollection[1] = 0;
            fileSizeCollection[2] = firmwareSize;
            break;
            
        default:
            break;
    }    
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&fileSizeCollection length:sizeof(fileSizeCollection)] forCharacteristic:self.dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

-(void) writeFilesSizes:(uint32_t)softdeviceSize bootloaderSize:(uint32_t)bootloaderSize
{
    HLog(@"DFUOperationsdetails writeFilesSizes");
    uint32_t fileSizeCollection[3];
    fileSizeCollection[0] = softdeviceSize;
    fileSizeCollection[1] = bootloaderSize;
    fileSizeCollection[2] = 0;
        
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&fileSizeCollection length:sizeof(fileSizeCollection)] forCharacteristic:self.dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

-(void) writeFileSizeForOldDFU:(uint32_t)firmwareSize
{
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&firmwareSize length:sizeof(firmwareSize)] forCharacteristic:self.dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

//Init Packet is included in new DFU in SDK 7.0
-(void) sendInitPacket:(NSString *)metaDataURL
{
    
    NSData *fileData = [NSData dataWithContentsOfFile:metaDataURL];
    
    int numberOfPackets = ceil((double)fileData.length /(double)PACKET_SIZE);
    int bytesInLastPacket = fileData.length % 20;
    
    HLog(@"metaDataFile length: %lu and number of packets: %d",(unsigned long)[fileData length], numberOfPackets);
    
    //send initPacket with parameter value set to Receive Init Packet [0] to dfu Control Point Characteristic
    uint8_t initPacketStart[] = {INITIALIZE_DFU_PARAMETERS_REQUEST, START_INIT_PACKET};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&initPacketStart length:sizeof(initPacketStart)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
    
    // send init Packet data to dfu Packet Characteristic
    // for longer .dat file the data need to be chopped into 20 bytes
    for (int index = 0; index < numberOfPackets-1; index++) {
        //chopping data into 20 bytes packet
        NSRange dataRange = NSMakeRange(index*PACKET_SIZE, PACKET_SIZE);
        NSData *packetData = [fileData subdataWithRange:dataRange];
        //writing 20 bytes packet to peripheral
        [self.bluetoothPeripheral writeValue:packetData forCharacteristic:self.dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
    }
    //chopping data for last packet that can be less than 20 bytes
    NSRange dataRange = NSMakeRange((numberOfPackets-1)*PACKET_SIZE, bytesInLastPacket);
    NSData *packetData = [fileData subdataWithRange:dataRange];
    //writing last packet
    [self.bluetoothPeripheral writeValue:packetData forCharacteristic:self.dfuPacketCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
    //send initPacket with parameter value set to Init Packet Complete [1] to dfu Control Point Characteristic
    uint8_t initPacketEnd[] = {INITIALIZE_DFU_PARAMETERS_REQUEST, END_INIT_PACKET};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&initPacketEnd length:sizeof(initPacketEnd)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void)resetAppToDFUMode
{
    [self.bluetoothPeripheral setNotifyValue:YES forCharacteristic:self.dfuControlPointCharacteristic];
    uint8_t value[] = {START_DFU_REQUEST, APPLICATION};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

//dfu Version characteristic is introduced in SDK 7.0
-(void)getDfuVersion
{
    HLog(@"getDFUVersion");
    [self.bluetoothPeripheral readValueForCharacteristic:self.dfuVersionCharacteristic];
}

-(void) enablePacketNotification
{
    HLog(@"DFUOperationsdetails enablePacketNotification");
    uint8_t value[] = {PACKET_RECEIPT_NOTIFICATION_REQUEST, PACKETS_NOTIFICATION_INTERVAL,0};
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}


-(void) receiveFirmwareImage
{
    HLog(@"DFUOperationsdetails receiveFirmwareImage");
    uint8_t value = RECEIVE_FIRMWARE_IMAGE_REQUEST;
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) validateFirmware
{
    HLog(@"DFUOperationsdetails validateFirmwareImage");
    uint8_t value = VALIDATE_FIRMWARE_REQUEST;
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) activateAndReset
{
    HLog(@"DFUOperationsdetails activateAndReset");
    uint8_t value = ACTIVATE_AND_RESET_REQUEST;
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) resetSystem
{
    HLog(@"DFUOperationsDetails resetSystem");
    uint8_t value = RESET_SYSTEM;
    [self.bluetoothPeripheral writeValue:[NSData dataWithBytes:&value length:sizeof(value)] forCharacteristic:self.dfuControlPointCharacteristic type:CBCharacteristicWriteWithResponse];
}

-(void) setPeripheralAndOtherParameters:(CBPeripheral *)peripheral
             controlPointCharacteristic:(CBCharacteristic *)controlPointCharacteristic
                   packetCharacteristic:(CBCharacteristic *)packetCharacteristic
{
    HLog(@"setPeripheralAndOtherParameters %@",peripheral.name);
    self.bluetoothPeripheral = peripheral;
    self.dfuControlPointCharacteristic = controlPointCharacteristic;
    self.dfuPacketCharacteristic = packetCharacteristic;
}

-(void) setPeripheralAndOtherParametersWithVersion:(CBPeripheral *)peripheral
             controlPointCharacteristic:(CBCharacteristic *)controlPointCharacteristic
                   packetCharacteristic:(CBCharacteristic *)packetCharacteristic
                    versionCharacteristic:(CBCharacteristic *)versionCharacteristic
{
    HLog(@"setPeripheralAndOtherParameters %@",peripheral.name);
    self.bluetoothPeripheral = peripheral;
    self.dfuControlPointCharacteristic = controlPointCharacteristic;
    self.dfuPacketCharacteristic = packetCharacteristic;
    self.dfuVersionCharacteristic = versionCharacteristic;
}

@end
