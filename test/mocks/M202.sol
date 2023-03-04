// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// import "solmate/tokens/ERC20.sol";
import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract M202 is ERC20("Mockv2", "M22") {
    address deployer = address(4896);
    address Agent1 = address(16);
    address Agent2 = address(32);
    address Agent3 = address(48);
    address add1 = 0xb3F204a5F3dabef6bE51015fD57E307080Db6498;
    address add2 = 0x65Cf1e0f55BD97696ce430aAcC97b5E7831E0fC2;
    address add3 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address anvil_1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address anvil_2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    address anvil_3 = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    address anvil_4 = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
    address anvil_5 = 0x323525cB37428d72e33B8a3d9a72F848d08Bf2B7;

    constructor() {
        _mint(address(0xb3F204a5F3dabef6bE51015fD57E307080Db6498), 10_000_000 ether);
        _mint(msg.sender, 1_000_000 ether);
        _mint(deployer, 400_000 ether);
        _mint(Agent1, 100_000 ether);
        _mint(add1, 100_000 ether);
        _mint(add2, 100_000 ether);
        _mint(add3, 100_000 ether);
        _mint(Agent2, 200_000 ether);
        _mint(Agent3, 300_000 ether);
        _mint(anvil_1, 100_000 ether);
        _mint(anvil_2, 100_000 ether);
        _mint(anvil_3, 1000_000 ether);
        _mint(anvil_4, 200_000 ether);
        _mint(anvil_5, 300_000 ether);
        _mint(address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266), 200_000 ether);
    }
}
