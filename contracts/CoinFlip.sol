pragma solidity 0.5.12;
import "./Owner.sol";


contract CoinFlip is Ownable{


    uint internal balance;
    uint internal betAmount;
    uint internal result;
    uint internal reward;
    event youWin (string, uint);
    event youLose(string, uint);
  //  address player;


     modifier costs(uint cost){
        require(msg.value >= cost, "Need at least 100 Wei");
        _;


    }


    function play()public payable costs(1 ether){
        betAmount += msg.value;
       // reward += msg.value;


        random();
        winOrLose();



    }

    function valueInput()public view returns(uint){

        return betAmount;

    }

  /*  function initialBalance() public payable{
      balance = msg.value;
     */

    //random function()
    function random() internal returns(uint){

            result = now % 2;
        return result;

    }

    function winOrLose() internal returns (uint){
        if (result == 1){
            //pay player
            uint toReward = betAmount*2;

            msg.sender.transfer(toReward);
            balance -= betAmount;

            emit youWin("You won ", toReward);
            toReward  =0;
        }

        else {
            //keep money
            balance += betAmount;
            emit youLose("You lost ", betAmount);
        }

        reward = betAmount;
        betAmount =0;
    }

    function getBalance() public view returns(uint){
        return balance;

    }

    function getReward() public view returns(uint){
        return reward;
    }

    function depositFunds() public onlyOwner payable returns(uint){
      balance += msg.value;
      return balance;

    }




}
