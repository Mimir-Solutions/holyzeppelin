/**
 *Submitted for verification at Etherscan.io on 2019-11-14
 */

// hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/dai.sol
// SPDX-License-Identifier: Unlicensed
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "./interfaces/IDAI.sol";
import "./libraries/LibNote.sol";

////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/dai.sol
// Copyright (C) 2017, 2018, 2019 dbrock, rain, mrchico

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

contract DAI is LibNote {
    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);

    // --- Auth ---
    mapping(address => uint256) public wards;

    function rely(address guy) external note auth {
        wards[guy] = 1;
    }

    function deny(address guy) external note auth {
        wards[guy] = 0;
    }

    modifier auth {
        require(wards[msg.sender] == 1, "Dai/not-authorized");
        _;
    }

    // --- ERC20 Data ---
    string public constant name = "Dai Stablecoin";
    string public constant symbol = "DAI";
    string public constant version = "1";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) private allowances;
    mapping(address => uint256) public nonces;

    // event Approval(address indexed src, address indexed guy, uint wad);
    // event Transfer(address indexed src, address indexed dst, uint wad);

    // --- Math ---
    function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        require((z = x - y) <= x);
    }

    // --- EIP712 niceties ---
    bytes32 public DOMAIN_SEPARATOR;
    // bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address holder,address spender,uint256 nonce,uint256 expiry,bool allowed)");
    bytes32 public constant PERMIT_TYPEHASH =
        0xea2aa0a1be11a07ed86d755c93467f4f82362b452371d1ba94d1715123511acb;

    constructor(uint256 chainId_) {
        wards[msg.sender] = 1;
        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId_,
                address(this)
            )
        );
    }

    function allowance(address account_, address sender_)
        external
        view
        returns (uint256)
    {
        return _allowance(account_, sender_);
    }

    function _allowance(address account_, address sender_)
        internal
        view
        returns (uint256)
    {
        console.log(
            "Cotract::DAI::_allowance:1 Getting allowance of %s from %s for %s.",
            allowances[account_][sender_],
            account_,
            sender_
        );
        return allowances[account_][sender_];
    }

    // --- Token ---
    function transfer(address dst, uint256 wad) external returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }

    function transferFrom(
        address src,
        address dst,
        uint256 wad
    ) public returns (bool) {
        console.log(
            "Contract::DAI::transferFrom:1 Confirming that %s is approved to tansfer %s from %s.",
            msg.sender,
            wad,
            src
        );
        console.log(
            "Contract::DAI::transferFrom:1 Currently %s is approved to transfer %s from %s.",
            msg.sender,
            allowances[src][msg.sender],
            src
        );
        require(balanceOf[src] >= wad, "Dai/insufficient-balance");
        if (src != msg.sender && _allowance(src, msg.sender) != uint256(-1)) {
            require(
                _allowance(src, msg.sender) >= wad,
                "Dai/insufficient-allowance"
            );
            allowances[src][msg.sender] = sub(_allowance(src, msg.sender), wad);
        }
        balanceOf[src] = sub(balanceOf[src], wad);
        balanceOf[dst] = add(balanceOf[dst], wad);
        emit Transfer(src, dst, wad);
        return true;
    }

    function mint(address usr, uint256 wad) external auth {
        console.log(
            "Contract::DAI::mint:1 Minting %s to %s on call from $s.",
            wad,
            usr,
            msg.sender
        );
        balanceOf[usr] = add(balanceOf[usr], wad);
        console.log(
            "Contract::DAI::mint:2 Minted %s to %s on call from $s.",
            wad,
            usr,
            msg.sender
        );
        console.log(
            "Contract::DAI::mint:3 Ballance of $s is now $s.",
            usr,
            balanceOf[usr]
        );
        console.log(
            "Contract::DAI::mint:4 Increasing total supply from %s.",
            totalSupply
        );
        totalSupply = add(totalSupply, wad);
        console.log(
            "Contract::DAI::mint:5 Increased total supply to %s.",
            totalSupply
        );
        console.log("Contract::DAI::mint:6 Emitting Trasfer event.");
        emit Transfer(address(0), usr, wad);
        console.log("Contract::DAI::mint:7 Emited Trasfer event.");
    }

    function burn(address usr, uint256 wad) external {
        require(balanceOf[usr] >= wad, "Dai/insufficient-balance");
        if (usr != msg.sender && _allowance(usr, msg.sender) != uint256(-1)) {
            require(
                _allowance(usr, msg.sender) >= wad,
                "Dai/insufficient-allowance"
            );
            allowances[usr][msg.sender] = sub(_allowance(usr, msg.sender), wad);
        }
        balanceOf[usr] = sub(balanceOf[usr], wad);
        totalSupply = sub(totalSupply, wad);
        emit Transfer(usr, address(0), wad);
    }

    function _approve(address usr, uint256 wad) internal returns (bool) {
        console.log(
            "Contract::DAI::_approve:1 Approving %s to transfer %s from %s.",
            usr,
            wad,
            msg.sender
        );
        allowances[msg.sender][usr] = wad;
        console.log(
            "Contract::DAI::_approve:2 Approved %s to transfer %s from %s.",
            usr,
            _allowance(msg.sender, usr),
            msg.sender
        );
        emit Approval(msg.sender, usr, wad);
        return true;
    }

    function approve(address usr_, uint256 wad_) external returns (bool) {
        console.log(
            "Contract::DAI::_approve:1 Approving %s to transfer %s from %s from external call.",
            usr_,
            wad_,
            msg.sender
        );
        return _approve(usr_, wad_);
    }

    // --- Alias ---
    function push(address usr, uint256 wad) external {
        transferFrom(msg.sender, usr, wad);
    }

    function pull(address usr, uint256 wad) external {
        transferFrom(usr, msg.sender, wad);
    }

    function move(
        address src,
        address dst,
        uint256 wad
    ) external {
        transferFrom(src, dst, wad);
    }

    // --- Approve by signature ---
    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        bytes32 digest =
            keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR,
                    keccak256(
                        abi.encode(
                            PERMIT_TYPEHASH,
                            holder,
                            spender,
                            nonce,
                            expiry,
                            allowed
                        )
                    )
                )
            );

        require(holder != address(0), "Dai/invalid-address-0");
        require(holder == ecrecover(digest, v, r, s), "Dai/invalid-permit");
        require(expiry == 0 || block.timestamp <= expiry, "Dai/permit-expired");
        require(nonce == nonces[holder]++, "Dai/invalid-nonce");
        uint256 wad = allowed ? uint256(-1) : 0;
        allowances[holder][spender] = wad;
        emit Approval(holder, spender, wad);
    }
}
