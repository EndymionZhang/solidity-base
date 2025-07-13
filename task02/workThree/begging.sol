// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
    任务目标
        使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
        记录每个捐赠者的地址和捐赠金额。
        允许合约所有者提取所有捐赠的资金。

    任务步骤
        编写合约
            创建一个名为 BeggingContract 的合约。
            合约应包含以下功能：
            一个 mapping 来记录每个捐赠者的捐赠金额。
            一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
            一个 withdraw 函数，允许合约所有者提取所有资金。
            一个 getDonation 函数，允许查询某个地址的捐赠金额。
            使用 payable 修饰符和 address.transfer 实现支付和提款。
        部署合约
            在 Remix IDE 中编译合约。
            部署合约到 Goerli 或 Sepolia 测试网。
        测试合约
            使用 MetaMask 向合约发送以太币，测试 donate 功能。
            调用 withdraw 函数，测试合约所有者是否可以提取资金。
            调用 getDonation 函数，查询某个地址的捐赠金额。

    任务要求
        合约代码：
            使用 mapping 记录捐赠者的地址和金额。
            使用 payable 修饰符实现 donate 和 withdraw 函数。
            使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
        测试网部署：
            合约必须部署到 Goerli 或 Sepolia 测试网。
        功能测试：
            确保 donate、withdraw 和 getDonation 函数正常工作。

    提交内容
        合约代码：提交 Solidity 合约文件（如 BeggingContract.sol）。
        合约地址：提交部署到测试网的合约地址。
        测试截图：提交在 Remix 或 Etherscan 上测试合约的截图。

    额外挑战（可选）
        捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
        捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
        时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
*/

contract BeggingContract is Ownable {
    mapping(address => uint256) private _donations;
    address[] private top3Donators;
    // 单位秒
    uint256 private immutable donateOverTime;

    event Donate(address indexed donator, uint256 amount);
    event Withdraw(address indexed withdrawer, uint256 amount);

    // 带过期时间的合约：0xDa4534E8c85bB5B488D4bce41D716FE7638e1AE5
    // 不带过期时间的合约：0x64905A43EB7dC53f893ee2F8e092fC9d8080be4D
    constructor(address initialOwner) Ownable(initialOwner) {
        donateOverTime = block.timestamp + 30;
        top3Donators.push(address(0));
        top3Donators.push(address(0));
        top3Donators.push(address(0));
    } 

    function renounceOwnership() public override view onlyOwner {
       revert("Not allowed to renounce owner");
    }

    function donate() external payable {
        // if (donateOverTime < block.timestamp) {
        //     revert ("over donate time.");
        // }
        address sender = msg.sender;
        uint256 value = msg.value;
        if (value == 0) {
            return;
        }
        _donations[sender] += value;
        emit Donate(sender, value);
        address donator = sender;
        for (uint i = 0; i < 3; i++) {
            if (_donations[top3Donators[i]] < _donations[donator]) {
                address temp = top3Donators[i];
                top3Donators[i] = donator;
                donator = temp;
            }
        }
    }

    function withdraw() external onlyOwner {
        uint256 totalAmount = address(this).balance;
        if (totalAmount == 0) {
            return;
        }
            // 安全转账（推荐方式）
        (bool success, ) = msg.sender.call{value: totalAmount}("");
        require(success, "Transfer failed");
        emit Withdraw(msg.sender, totalAmount);
    }

    function getDonation(address donator) external view returns (uint256){
        uint256 amount = _donations[donator];
        return amount;
    }

    function top3DonatorsView() public view returns (address[3] memory, uint256[3] memory) {
        uint256[3] memory donatorAmount;
        address[3] memory donatorAddresses;
        for (uint i = 0; i < 3; i++) {
            if (top3Donators[i] == address(0)) {
                break;
            }
            if (_donations[top3Donators[i]] == 0) {
                break;
            }
            donatorAmount[i] = _donations[top3Donators[i]];
            donatorAddresses[i] = top3Donators[i];
        }
        return (donatorAddresses, donatorAmount);
    }
}
