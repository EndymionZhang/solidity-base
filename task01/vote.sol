// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8;

contract Vote {
    // 1. 创建一个mapping，保存所有候选人获得的票数
    mapping(address => uint) public candidateVotes;
    // 2. 创建一个数组，报错所有候选人
    address[] candidateList;

    // 3. 投票给候选人
    function vote(address candidate) public {
        candidateVotes[candidate] += 1;
        if (candidateVotes[candidate] == 1) {
            candidateList.push(candidate);
        }
    }

    // 4. 查询某个候选人的票数
    function getVotes(address candidate) public view returns(uint) {
        return candidateVotes[candidate];
    }

    // 5. 清空所有候选人的票数
    function resetVote() public {
        for (uint i = 0; i < candidateList.length; i++) {
            candidateVotes[candidateList[i]] = 0;
        }
        delete candidateList;
    }
}