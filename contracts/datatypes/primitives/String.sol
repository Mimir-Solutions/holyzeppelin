// // SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity 0.7.5;

import "hardhat/console.sol";

import "../../math/SafeMath.sol";

// /**
//  * @dev String operations.
//  */
library String {

    using SafeMath for uint256;
    
    function toLower(string memory str) pure internal returns (string memory ) {
        bytes memory bStr = bytes(str);
        bytes memory bLower = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            if ((bStr[i] >= 65) && (bStr[i] <= 90)) {
                bLower[i] = byte(int(bStr[i]) + 32);
            } else {
                bLower[i] = bStr[i];
            }
        }
        return string(bLower);
    }

    function toUpper(string memory str) pure internal returns (string memory ) {
        bytes memory bStr = bytes(str);
        bytes memory bUpper = new bytes(bStr.length);
        for (uint i = 0; i < bStr.length; i++) {
            if ((bStr[i] >= 97) && (bStr[i] <= 122)) {
                bUpper[i] = byte(int(bStr[i]) - 32);
            } else {
                bUpper[i] = bStr[i];
            }
        }
        return string(bUpper);
    }

    function toAddress(string memory self) pure internal returns (address){
        bytes memory tmp = bytes(self);

        uint addr = 0;
        uint b;
        uint b2;

        for (uint i=2; i<2+2*20; i+=2){

            addr *= 256;

            b = uint(tmp[i]);
            b2 = uint(tmp[i+1]);

            if ((b >= 97)&&(b <= 102)) b -= 87;
            else if ((b >= 48)&&(b <= 57)) b -= 48;
            else if ((b >= 65)&&(b <= 70)) b -= 55;

            if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
            else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
            else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;

            addr += (b*16+b2);

        }

        return address(addr);
    }

    function toUint(string memory self) pure internal returns (uint result) {
        bytes memory b = bytes(self);
        uint i;
        result = 0;
        for (i = 0; i < b.length; i++) {
            uint c = uint(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }

    //important -> hex string to bytes
    function toBytes(string memory self) pure internal returns (bytes memory )
    {
        bytes memory bArray = new bytes((bytes(self).length-2)/2);

        uint b;
        uint b1;

        for (uint i=2;i<bytes(self).length;i+=2)
        {
            b = uint(bytes(self)[i]);
            b1 = uint(bytes(self)[i+1]);

            //left digit
            if(b>=48 && b<=57)
                b -= 48;
            //A-F
            else if(b>=65 && b<=70)
                b -= 55;
            //a-f
            else if(b>=97 && b<=102)
                b -= 87;


            //right digit
            if (b1>=48 && b1<=57)
                b1 -= 48;
            //A-F
            else if(b1>=65 && b1<=70)
                b1 -= 55;
            //a-f
            else if(b1>=97 && b1<=102)
                b1 -= 87;

            bArray[i/2-1]=bytes(16*b+b1);
        }

        return bArray;
    }

    function strConcat(string memory a, string memory b, string memory c, string memory d, string memory e) internal pure returns (string memory) {
      bytes memory ba = bytes(a);
      bytes memory bb = bytes(b);
      bytes memory bc = bytes(c);
      bytes memory bd = bytes(d);
      bytes memory be = bytes(e);
      string memory abcde = new string(ba.length + bb.length + bc.length + bd.length + be.length);
      bytes memory babcde = bytes(abcde);
      uint k = 0;
      for (uint i = 0; i < ba.length; i++) babcde[k++] = ba[i];
      for (uint i = 0; i < bb.length; i++) babcde[k++] = bb[i];
      for (uint i = 0; i < bc.length; i++) babcde[k++] = bc[i];
      for (uint i = 0; i < bd.length; i++) babcde[k++] = bd[i];
      for (uint i = 0; i < be.length; i++) babcde[k++] = be[i];
      return string(babcde);
    }

    function strConcat(string memory a, string memory b, string memory c, string memory d) internal pure returns (string memory) {
        return strConcat(a, b, c, d, "");
    }

    function strConcat(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return strConcat(a, b, c, "", "");
    }

    function strConcat(string memory a, string memory b) internal pure returns (string memory) {
        return strConcat(a, b, "", "", "");
    }

    function uint2str(uint i) internal pure returns (string memory _uintAsString) {
        if (i == 0) {
            return "0";
        }
        uint j = i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (i != 0) {
            bstr[k--] = byte(uint8(48 + i % 10));
            i /= 10;
        }
        return string(bstr);
    }

    function bool2str(bool b) internal pure returns (string memory _boolAsString) {
        _boolAsString = b ? "1" : "0";
    }
}
