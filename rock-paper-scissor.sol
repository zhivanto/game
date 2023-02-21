// SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

contract MyGame{

    modifier onlyOwner{
        require(msg.sender == owner);
        _;
    }

    address owner; 

    mapping(string => mapping(string => int256)) public gameRules;
    mapping(uint256 => string) public variants;

    constructor() payable {
        owner = msg.sender;
        gameRules["rock"]["rock"] = 0;
        gameRules["rock"]["scissors"] = 1;
        gameRules["rock"]["paper"] = -1;


        gameRules["scissors"]["scissors"] = 0;
        gameRules["scissors"]["paper"] = 1;
        gameRules["scissors"]["rock"] = -1;
        
        
        gameRules["paper"]["paper"] = 0;
        gameRules["paper"]["rock"] = 1;
        gameRules["paper"]["scissors"] = -1;
        
        variants[0] = "rock";
        variants[1] = "scissors";
        variants[2] = "paper";
    }
    
    
    event GameEnded(address player, uint256 amount, string userChoice, int256 result); 


    function playGame(string memory userChoice) public payable { //view, pure = gassless 
        require(msg.value>0, "Please add your bet"); 
        require(msg.value*2 <= address(this).balance, "Contract balance is insufficient ");

        uint256 botChoiceInt = block.timestamp*block.gaslimit%3; 
        string memory botChoice = variants[botChoiceInt];

        int256 result = gameRules[userChoice][botChoice];


        if (result == 0){
            payable(msg.sender).transfer(msg.value);
        }
        //If user wins he doubles his stake
        if (result == 1){
            payable(msg.sender).transfer(msg.value*2);
        }

        emit GameEnded(msg.sender, msg.value, userChoice, result);

    }
    
    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    }