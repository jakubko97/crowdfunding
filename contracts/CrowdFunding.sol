// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

contract fundingCreator {
    CrowdFunding[] public fundings;

    function createFunding(uint256 inputGoal, uint256 inputDeadline) public {
        CrowdFunding newFunding = new CrowdFunding(inputDeadline,inputGoal);
        fundings.push(newFunding);
    }
}

contract CrowdFunding {
    address owner;
    uint256 public deadline;
    uint256 public goal;
    uint256 public raisedAmout;
    mapping(address => uint256) public pledgeOf;
    address bank;


    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    constructor(uint256 secs, uint256 _goal) public {
        owner = msg.sender;
        deadline = now + (secs);
        goal = _goal * 1 ether;
    }

    function contribute(address receiver, uint amount) public payable returns(bool sufficient) {
        require(now < deadline);                // in the fundraising period

        pledgeOf[msg.sender] += msg.value;
        raisedAmout += msg.value;
        emit Transfer(msg.sender, receiver, amount);
        return true;
    }

    // function claimFunds() public {
    //     require(address(this).balance >= goal); // funding goal is met
    //     require(now >= deadline);               // in the withdrawal period
    //     require(msg.sender == owner);

    //     msg.sender.transfer(address(this).balance);
    // }

    function getRefund() public {
        require(address(this).balance < goal);  // funding goal not met
        require(now >= deadline);               // in the withdrawal period

        uint256 amount = pledgeOf[msg.sender];
        pledgeOf[msg.sender] = 0;
        msg.sender.transfer(amount);
    }

    function getBalance(address addr) public view returns(uint) {
		return pledgeOf[addr];
	}
}