// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import { MTKErrors } from "./error-my-token.sol";

/**
    任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
    合约包含以下标准 ERC20 功能：
        balanceOf：查询账户余额。
        transfer：转账。
        approve 和 transferFrom：授权和代扣转账。
        使用 event 记录转账和授权操作。
        提供 mint 函数，允许合约所有者增发代币。
    提示：
        使用 mapping 存储账户余额和授权信息。
        使用 event 定义 Transfer 和 Approval 事件。
        部署到sepolia 测试网，导入到自己的钱包
*/

contract MyToken is MTKErrors {
    string private name;
    string private symbol;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 initialSupply) {
        name = "MyToken";
        symbol = "MTK";
        _mint(msg.sender, initialSupply);
    }

    // 提供 mint 函数，允许合约所有者增发代币。
    function _mint(address to, uint256 amount) private {
        require(to != address(0), "Address of zero is not valid");
        _balances[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        if (_balances[from] < amount) {
            revert MTKInsufficientBalance(msg.sender, _balances[msg.sender], amount);
        }
        if (to == address(0)) {
            revert MTKReceiveAddressZero(msg.sender, amount);
        }
        _balances[from] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }

    // transfer：转账。
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    // approve 授权给其他地址token使用权
    function approve(address spender, uint256 amount) public returns (bool) {
        if (spender == address(0)) {
            revert MTKApproveZeroAddress(msg.sender, amount);
        }
        uint256 allowanceLeft = _allowance(msg.sender, spender);
        if (allowanceLeft > 0) {
            revert MTKApprovalNotEmpty(msg.sender, spender, allowanceLeft);
        }
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 查询账户的授权余额
    function _allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    // transferFrom 代扣转账。
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 allowanceLeft = _allowance(from, msg.sender);
        if (allowanceLeft == 0) {
            revert MTKApprovalIsZero(from, msg.sender);
        }
        if (allowanceLeft < amount) {
            revert MTKApprovalIsNotEnough(from, msg.sender, allowanceLeft, amount);
        }
        _allowances[from][msg.sender] -= amount;
        _transfer(from, to, amount);
        return true;
    }

    // balanceOf：查询账户余额。
    function balanceOf() public view returns (uint256) {
        return _balances[msg.sender];
    }    
}