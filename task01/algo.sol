// SPDX-License-Identifier: MIT 
pragma solidity ^0.8;

contract Algo {
    // 2. 反转一个字符串。输入 "abcde"，输出 "edcba"
    function reverseStr(string memory input) public pure returns (string memory) {
        bytes memory inputBytes = bytes(input);
        uint i = 0;
        uint j = inputBytes.length - 1;
        for (;;) {
            bytes1 temp = inputBytes[i];
            inputBytes[i] = inputBytes[j];
            inputBytes[j] = temp;
            i++;
            j--;
            if (j <=i) {
                break;
            }
        }
        return string(inputBytes);
    }

    // 3. 罗马数字转换
    function converRoman(string memory roman) public pure returns (uint256) {
        bytes memory romanBytes = bytes(roman);
        uint256 result = 0;
        for (uint i = 0; i < romanBytes.length; i++) {
            uint256 curr = convertBaseRoman(romanBytes[i]);
            uint256 next = (i + 1 >= romanBytes.length) ? 0 : convertBaseRoman(romanBytes[i + 1]);
            if (next > curr) {
                result = result + next - curr;
                i++;
            } else {
                result = result + curr;
            }
        }
        return result;
    }

    function convertBaseRoman(bytes1 baseRoman) private pure returns (uint256) {
        if (baseRoman == 'I') return 1;
        if (baseRoman == 'V') return 5;
        if (baseRoman == 'X') return 10;
        if (baseRoman == 'L') return 50;
        if (baseRoman == 'C') return 100;
        if (baseRoman == 'D') return 500;
        if (baseRoman == 'M') return 1000;
        return 0;
    }

    // 4. 数字转换罗马数字
    function converToRoman(uint256 num) public pure returns (string memory) {
        bytes memory result;
        uint16[13] memory levels = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
        for (uint i = 0; i < 13; i++) {
            string memory temp = convertToBaseRoman(levels[i]);
            uint256 divide = num / levels[i];
            bytes memory tempBytes = convertToRomanNum(divide, temp);
            result = abi.encodePacked(string(result), tempBytes);
            num -= (divide * levels[i]);
        }
        return string(result);
    }

    function convertToRomanNum(uint256 num, string memory romanCode) private pure returns (bytes memory) {
        bytes memory result;
        for (uint i = 0; i < num; i++) {
            result = abi.encodePacked(result, romanCode);
        }
        return result;
    }

    function convertToBaseRoman(uint16 level) private pure returns (string memory) {
        if (level == 1000) return 'M';
        if (level == 900) return 'CM';
        if (level == 400) return 'CD';
        if (level == 500) return 'D';
        if (level == 90) return 'XC';
        if (level == 50) return 'L';
        if (level == 40) return 'XL';
        if (level == 10) return 'X';
        if (level == 9) return 'IX';
        if (level == 5) return 'V';
        if (level == 4) return 'IV';
        if (level == 1) return 'I';
        return '';
    }

    // 5. 合并两个有序数组
    function mergeArray(uint256[] memory nums1, uint256[] memory nums2) public pure returns (uint256[] memory) {
        uint256 length = nums1.length + nums2.length;
        uint256[] memory result = new uint256[](length); 
        uint i = 0;
        uint j = 0;
        for (uint m = 0; m < length; m++) {
            if (i < nums1.length && j < nums2.length) {
                result[m] = nums1[i] < nums2[j] ? nums1[i++] : nums2[j++];
            } else if (i < nums1.length) {
                result[m] = nums1[i++];
            } else {
                result[m] = nums2[j++];
            }
        }
        return result;
    }

        // 5. 二分查找，在一个有序列表中，查找目标值
    function searchTarget(uint256[] memory nums, uint256 target) public pure returns (int index) { 
        if (nums.length == 0) return -1;
        if (target > nums[nums.length - 1]) return -1;
        if (target < nums[0]) return -1;
        uint start = 0;
        uint end = nums.length - 1;
        while (start + 1 < end) {
            uint middle = (start + end) / 2;
            if (nums[middle] == target) return int(middle);
            if (nums[end] == target) return int(end);
            if (nums[middle] < target) start = middle;
            else end = middle;
        }
    }
}