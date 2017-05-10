# IOS-nRF-Toolbox

The nRF Toolbox is a container app that stores your Nordic Semiconductor apps for Bluetooth Smart in one location. 

The current version is 2.5. 

New in 2.5 version:
* Refreshed Look & Feel
* Better user experience in DFU and UART profiles
* Bug fixes

It contains applications demonstrating Bluetooth Smart profiles: 
* **Cycling Speed and Cadence**, 
* **Running Speed and Cadence**, 
* **Heart Rate Monitor**, 
* **Blood Pressure Monitor**, 
* **Health Thermometer Monitor**, 
* **Glucose Monitor**,
* **Proximity Monitor**. 

### Device Firmware Update

The **Device Firmware Update (DFU)** profile allows you to update the application, bootloader and/or the Soft Device image over-the-air (OTA). It is compatible with Nordic Semiconductor nRF5x devices that have the S-Series SoftDevice and bootloader enabled. From version 1.5 onward, the nRF Toolbox has allowed to send the required init packet. More information about the init packet may be found here: [init packet handling](https://github.com/NordicSemiconductor/nRF-Master-Control-Panel/tree/master/init%20packet%20handling).

The DFU has the following features:
- Scans for devices that are in DFU mode.
- Connects to devices in DFU mode and uploads the selected firmware (soft device, bootloader and/or application).
- Allows HEX or BIN file upload through your phone or tablet.
- Allows to update a soft device and bootloader from ZIP in one connection.
- Pause, resume, and cancel file uploads.
- Includes pre-installed examples that consist of the Bluetooth Smart heart rate service and running speed and cadence service.

### Note
- iPhone 4S or newer is required.
- iPad 3 or newer is required.
- Compatible with nRF5x devices with S-Series Softdevice and DFU Bootloader flashed.
- nRF51 and nRF52 Development kits can be ordered from http://www.nordicsemi.com/eng/Buy-Online.
- The SDK and SoftDevices are available online at http://developer.nordicsemi.com.
