pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract IoTDevice is Ownable{
    // Creating an event to log temperature updates
    event TemperatureUpdate(uint256 indexed timestamp, uint256 temperature);

    // Creating a variable to store the temperature reading
    uint256 private temperature;

   

    // Creating a variable to store the maximum temperature threshold
    uint256 private maxTemperatureThreshold;

    // Creating a variable to store the last time the temperature was updated
    uint256 private lastUpdateTime;

    
    // Creating a constructor function to set the initial state of the contract
    constructor(uint256 _maxTemperatureThreshold) {
        maxTemperatureThreshold = _maxTemperatureThreshold;
        lastUpdateTime = block.timestamp;
    }

    // Creating a function to update the temperature reading
    function updateTemperature(uint256 new_Temperature) public onlyOwner {
        
        require(block.timestamp - lastUpdateTime >= 1 minutes, "Temperature can only be updated once per minute.");
        temperature = new_Temperature;
        lastUpdateTime = block.timestamp;
        emit TemperatureUpdate(lastUpdateTime, temperature);
        if (temperature > maxTemperatureThreshold) {
            // Trigger an alert if the temperature exceeds the maximum threshold
            triggerAlert();
        }
    }

    // Creating a function to retrieve the temperature reading
    function getTemperature() public view returns (uint256) {
        return temperature;
    }

    // Creating a function to update the maximum temperature threshold
    function updateMaxTemperatureThreshold(uint256 _newThreshold) public onlyOwner {
        maxTemperatureThreshold = _newThreshold;
    }

    // Creating a function to trigger an alert if the temperature exceeds the maximum threshold
    function triggerAlert() private {
        // TODO: Implement alert mechanism (e.g. sending an email or text message to a specified address)
    }
}

contract TemperatureRequester is Ownable {
    // Creating a variable to store the address of the IoT device contract
    address private deviceAddress;

    // Creating a constructor function to set the initial state of the contract
    constructor(address _deviceAddress) {
        deviceAddress = _deviceAddress;
    }

    // Creating a function to request the temperature reading from the IoT device contract
    function requestTemperature() public view returns (uint256) {
        IoTDevice device = IoTDevice(deviceAddress);
        return device.getTemperature();
    }
}
