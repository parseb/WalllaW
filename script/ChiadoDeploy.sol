// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "../src/Member1155.sol";

import "forge-std/Script.sol";

import "test/mocks/M721.sol";

// import "../test/utils/functionality.t.sol";
import "../src/interfaces/IMember1155.sol";
import "../src/interfaces/iInstanceDAO.sol";
import "../src/interfaces/IDAO20.sol";
import "../src/interfaces/IMembrane.sol";
import "../src/interfaces/ILongCall.sol";
import "../src/interfaces/IAbstract.sol";
import "openzeppelin-contracts/token/ERC721/IERC721.sol";

// == Logs ==
//   Member --- 100 __________####_____ : 0xdb7074fd9a44db7f5342cb2311a64d84fdb78223
//   ODAO --- 100 __________####_____ : 0x448a5c7e801f9d482730faf4f7dd4d51dc5bec70
//   memBRAINE --- 100 __________####_____ : 0x462a61ed225947d0329f3d93996482dc6c388299
//   Abstract A --- 100 __________####_____ : 0x76f41d03b5c2fb0fd712f14bb6ce638ee560a3f5
//   Meeting POAP --- 100 __________####_____ : 0x4099cb63098976afb78686cf40a7ac0138d5863f
//   ----------populate-----------
//   -----------------------------
//   changing membrane 650394143299153546  --- expected ---  650394143299153546
//   Garden DAO --- 100 __________####_____ : 0x4b4fea5dc28bf59dc875882ce1803c3394c0dd99
//   Membrane ID --- 100 __________####_____ : 650394143299153546
//   Garden DAO --- 100 __________####_____ : 0x4b4fea5dc28bf59dc875882ce1803c3394c0dd99
//   Internal Token  --- 100 __________####_____ : 0x8204a52f509b0cd8710c13c11f2a02215ba03ac8


// http://guild.xyz/walllaw
// LinkeGaard.eth
// Linkebeek community garden incorporated project. Come talk to us every Sunday morning from 9:00 to 13:00 at our on-site stall on Groen Straße nr 306. Simple membership gives access to our garden premises as well as our planning and execution resources.// http://explorer.walllaw.xyz/LinkeGaard.eth
/// {"workspace":{"description":"this is where we budget things","link":"http://linktoprojectedneedsandreviews.com"}, "governance":{"description":"this is where we talk about things", "link":"http://www.discord.com"}}

/// 0xea998a093493c1f0a9f0f0e19c2e54d0f422578c --- instance

/// membrane 455943847601312652  QmdEwTWpsMcBsgJGCAM1eULstRYwSz3inepytgpHwqXSAk

contract ChiadoDeploy is Script {
    MemberRegistry M;
    IoDAO O;
    iInstanceDAO instance;
    IMembrane MembraneR;

    IERC721 CommunityMeetingPoap;

    function run() public {
        vm.startBroadcast(vm.envUint("chiado_PVK")); //// start 1

        M = new MemberRegistry();
        // Mock20 = new M20();
        // Mock202 = new M202();
        O = IoDAO(M.ODAOaddress());
        MembraneR = IMembrane(M.MembraneRegistryAddress());
        CommunityMeetingPoap = IERC721(address(new M721222()));

        string memory addrM = Strings.toHexString(uint256(uint160(address(M))), 20);
        string memory addrODAO = Strings.toHexString(uint256(uint160(address(M.ODAOaddress()))), 20);
        string memory addrMembrane = Strings.toHexString(uint256(uint160(address(M.MembraneRegistryAddress()))), 20);
        string memory addrAbstract = Strings.toHexString(uint256(uint160(address(M.AbstractAddr()))), 20);
        string memory MeetingPoap = Strings.toHexString(uint256(uint160(address(CommunityMeetingPoap))), 20);

        string memory chainID = Strings.toString(block.chainid);

        console.log(string.concat("Member --- ", chainID, " __________####_____ : ", addrM));
        console.log(string.concat("ODAO --- ", chainID, " __________####_____ : ", addrODAO));
        console.log(string.concat("memBRAINE --- ", chainID, " __________####_____ : ", addrMembrane));
        console.log(string.concat("Abstract A --- ", chainID, " __________####_____ : ", addrAbstract));
        console.log(string.concat("Meeting POAP --- ", chainID, " __________####_____ : ", MeetingPoap));

        ////// Populate
        console.log("----------populate-----------");
        console.log("-----------------------------");

        address DAO = O.createDAO(0xb106ed7587365a16b6691a3D4B2A734f4E8268a2);

        address[] memory tokens = new address[](2);
        tokens[0] = iInstanceDAO(DAO).internalTokenAddress();
        /// eur
        tokens[1] = address(CommunityMeetingPoap);

        uint256[] memory balances = new uint256[](2);
        balances[0] = 75 ether;
        balances[1] = 1;

        string memory meta = "QmdEwTWpsMcBsgJGCAM1eULstRYwSz3inepytgpHwqXSAk";

        uint256 membraneId = MembraneR.createMembrane(tokens, balances, meta);

        uint256 result = iInstanceDAO(DAO).changeMembrane(membraneId);
        console.log("changing membrane", Strings.toString(membraneId), " --- expected --- ", Strings.toString(result));

        console.log(
            string.concat(
                "Garden DAO --- ", chainID, " __________####_____ : ", Strings.toHexString(uint256(uint160(DAO)), 20)
            )
        );
        console.log(string.concat("Membrane ID --- ", chainID, " __________####_____ : ", Strings.toString(membraneId)));
        console.log(
            string.concat(
                "Garden DAO --- ", chainID, " __________####_____ : ", Strings.toHexString(uint256(uint160(DAO)), 20)
            )
        );
        console.log(
            string.concat(
                "Internal Token  --- ",
                chainID,
                " __________####_____ : ",
                Strings.toHexString(uint256(uint160(iInstanceDAO(DAO).internalTokenAddress())), 20)
            )
        );
    }
}
