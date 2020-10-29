pragma solidity >=0.5.12 < 0.6.0;
import "./Ownable.sol";
import "./Storagable.sol";
import "./Winnable.sol";
import "./oracle.sol";



contract CoinFlip is Ownable, Storagable, Winnable, oracle{


    modifier costs(uint cost){
        require(msg.value >= cost, "Need at least 0.1 szabo");
        _;


    }


    function depositFunds() public onlyOwner payable returns(uint){
      balance += msg.value;
      return balance;

    }

    function placeBet(uint betAmount) public payable costs (10000 wei){
         betAmount = betAmount * 1e15;
        random(betAmount);

    }











}
