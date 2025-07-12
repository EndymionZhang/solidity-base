// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

interface MTKErrors {
    /**
     * @dev 当发送地址token不足时，抛出异常
     * @param sender 需发送token的地址
     * @param balance 发送token地址的当前所持token数
     * @param needed 需要发送的token数
     */
    error MTKInsufficientBalance(address sender, uint256 balance, uint256 needed);   

    /**
     * @dev 当token收取地址为0时，抛出异常
     * @param sender token的发送地址
     * @param amount 发送到收取地址的token数
     */
    error MTKReceiveAddressZero(address sender, uint256 amount); 

    /**
     * @dev 授权的地址，当前token授权数还没有清空
     * @param owner token持有者
     * @param spender 需要授权的地址
     * @param amount 授权金额
     */
    error MTKApprovalNotEmpty(address owner, address spender, uint256 amount);

    /**
     * @dev token授权数被锁定
     * @param ownder token持有者
     * @param spender 需要授权的地址
     * @param allowanceLeft 可授权金额
     */
    error MTKApproveIsBlocked(address ownder, address spender, uint256 allowanceLeft);

    /**
     * @dev 授权金额小于0，抛出异常
     * @param owner token持有者
     * @param amount 授权金额
     */
    error MTKApproveZeroAddress(address owner, uint256 amount);

    /**
     * @dev token授权数为0，抛出异常
     * @param from token 持有地址
     * @param spender token持有者
     */
    error MTKApprovalIsZero(address from, address spender);

    /**
     * @dev 授权金额不足，无法交易
     * @param from token 持有地址
     * @param spender token 授权者地址
     * @param allowanceLeft 授权金额
     * @param amount 交易金额
     */
    error MTKApprovalIsNotEnough(address from, address spender, uint256 allowanceLeft, uint256 amount);

}