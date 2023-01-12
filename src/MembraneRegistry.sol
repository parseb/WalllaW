// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IoDAO.sol";
import "./interfaces/iInstanceDAO.sol";
import "./interfaces/IMembrane.sol";
import "./interfaces/IMember1155.sol";

import "openzeppelin-contracts/token/ERC20/IERC20.sol";
import "./errors.sol";

contract MembraneRegistry {
    address MRaddress;
    IoDAO ODAO;
    IMemberRegistry iMR;

    mapping(uint256 => Membrane) getMembraneById;
    mapping(address => uint256) usesMembrane;

    constructor(address ODAO_) {
        iMR = IMemberRegistry(msg.sender);
        ODAO = IoDAO(ODAO_);
    }

    error Membrane__membraneNotFound();
    error Membrane__aDAOnot();
    error Membrane__ExpectedODorD();
    error Membrane__MembraneChangeLimited();
    error Membrane__EmptyFieldOnMembraneCreation();
    error Membrane__onlyODAOToSetEndpoint();
    error Membrane__SomethingWentWrong();

    event CreatedMembrane(uint256 id, string metadata);
    event ChangedMembrane(address they, uint256 membrane);
    event gCheckKick(address indexed who);

    function createMembrane(address[] memory tokens_, uint256[] memory balances_, string memory meta_)
        public
        returns (uint256 id)
    {
        /// @dev consider negative as feature . [] <- isZero. sybil f
        /// @dev @security erc165 check
        if (!((tokens_.length / balances_.length) * bytes(meta_).length >= 1)) {
            revert Membrane__EmptyFieldOnMembraneCreation();
        }
        Membrane memory M;
        M.tokens = tokens_;
        M.balances = balances_;
        M.meta = meta_;
        id = uint256(keccak256(abi.encode(M))) % 1 ether;
        getMembraneById[id] = M;

        emit CreatedMembrane(id, meta_);
    }

    function setMembrane(uint256 membraneID_, address dao_) external returns (bool) {
        if ((msg.sender != dao_) && (msg.sender != address(ODAO))) revert Membrane__MembraneChangeLimited();
        if (getMembraneById[membraneID_].tokens.length == 0) revert Membrane__membraneNotFound();

        usesMembrane[dao_] = membraneID_;
        emit ChangedMembrane(dao_, membraneID_);
        return true;
    }

    function setMembraneEndpoint(uint256 membraneID_, address dao_, address owner_) external returns (bool) {
        if (msg.sender != address(ODAO)) revert Membrane__onlyODAOToSetEndpoint();
        if (address(uint160(membraneID_)) == owner_) {
            if (bytes(getMembraneById[membraneID_].meta).length == 0) {
                Membrane memory M;
                M.meta = "endpoint";
                getMembraneById[membraneID_] = M;
            }
            usesMembrane[dao_] = membraneID_;
            return true;
        } else {
            revert Membrane__SomethingWentWrong();
        }
    }

    function checkG(address who_, address DAO_) public view returns (bool s) {
        Membrane memory M = getInUseMembraneOfDAO(DAO_);
        uint256 i;
        s = true;
        for (i; i < M.tokens.length;) {
            s = s && (IERC20(M.tokens[i]).balanceOf(who_) >= M.balances[i]);
            unchecked {
                ++i;
            }
        }
    }

    //// @notice burns membership token of check entity if ineligible
    /// @param who_ checked address
    function gCheck(address who_, address DAO_) external returns (bool s) {
        if (iMR.balanceOf(who_, uint160(bytes20(DAO_))) == 0) return false;
        s = checkG(who_, DAO_);
        if (s) return true;
        if (!s) iMR.gCheckBurn(who_, DAO_);

        //// removed liquidate on kick . this burns membership token but lets user own internaltoken. @security consider

        emit gCheckKick(who_);
    }

    function entityData(uint256 id_) external view returns (string memory) {
        return getMembraneById[id_].meta;
    }

    function getMembrane(uint256 id_) external view returns (Membrane memory) {
        return getMembraneById[id_];
    }

    function isMembrane(uint256 id_) external view returns (bool) {
        return (getMembraneById[id_].tokens.length > 0);
    }

    function inUseMembraneId(address DAOaddress_) public view returns (uint256 ID) {
        return usesMembrane[DAOaddress_];
    }

    function getInUseMembraneOfDAO(address DAOAddress_) public view returns (Membrane memory) {
        return getMembraneById[usesMembrane[DAOAddress_]];
    }

    function inUseUriOf(address DAOaddress_) external view returns (string memory) {
        return getInUseMembraneOfDAO(DAOaddress_).meta;
    }
}
