// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves;
    uint private seed;
    mapping(address => uint) waveCounts;
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; 
        string message; 
        uint256 timestamp; 
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Now that contract becomes really smart!!");
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(lastWavedAt[msg.sender] + 2 minutes < block.timestamp,"Wait 2m");

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        waveCounts[msg.sender]++;
        console.log("%s has waved a total of %d times!", msg.sender, waveCounts[msg.sender]);
        console.log("%s waved with message %s", msg.sender, _message);

        waves.push(Wave(msg.sender, _message, block.timestamp));
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);
        emit NewWave(msg.sender, block.timestamp, _message);

        if (seed <= 5) {
        console.log("%s won!", msg.sender);

        uint256 prizeAmount = 0.0001 ether;
        require(prizeAmount <= address(this).balance,
        "Trying to withdraw more money than the contract has.");
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract.");
        }

    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns(uint) {
        console.log("We have total %d waves", totalWaves);
        return totalWaves;
    }

}