pragma solidity >=0.5.12 < 0.6.0;
import "./Ownable.sol";
import "./provableAPI.sol";

contract CoinFlip is Ownable, usingProvable{


  //the minimum cost to play
 modifier costs(uint cost){
     require(msg.value >= cost, "Need at least 1 finney");
     _;


 }

 //bet structure
 struct bet{
     uint betAmount;
     bytes32 id;
     address payable punter;
 }

 struct result{
     uint value;
     bool isWin;
     bool canPlayAgain;
     bytes32 id;
 }

 //bet mapping
 mapping (bytes32 => bet) internal bets;
 mapping (uint => result) internal results;

 //contract balance
 uint public balance;

 //initial function for owner to deposit funds into the contract
 function depositFunds() public onlyOwner payable returns(uint){
   balance += msg.value;
   return balance;

 }

 function placeBet(uint betAmount) public payable costs (1 finney){
      betAmount = betAmount * 1e15;

     random(msg.sender,betAmount);



 }

uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
uint256 public latestNumber;



event LogNewProvableQuery(string description);
event generatedRandomNumber(uint256 randomNumber);
event idCheck(string a, bytes32 q_id);
event youWin (string, uint);
event youLose(string, uint);





 //the oracle function to start the RNG getting process
 function random(address punter, uint _betAmount) payable public  {
 uint256 QUERY_EXECUTION_DELAY =0;
 uint GAS_FOR_CALLBACK = 200000;


bytes32 q_id =  provable_newRandomDSQuery(
     QUERY_EXECUTION_DELAY,
     NUM_RANDOM_BYTES_REQUESTED,
     GAS_FOR_CALLBACK
   );
    _betAmount = msg.value;

   bet memory newBet;
   newBet.betAmount = _betAmount;
   newBet.id = q_id;
   //newBet.canPlayAgain = false;
   newBet.punter = msg.sender;
   bets[q_id] = newBet;


 emit idCheck("The ID of this call is ", q_id);
 emit LogNewProvableQuery("Provable query was sent, standing by for the answer.");

}


 //oracle callback
 function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
 require(msg.sender == provable_cbAddress());

 uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2;

 latestNumber = randomNumber;
 emit generatedRandomNumber(randomNumber);
 saveResults(_queryId, latestNumber);
 winOrLose(_queryId);


}

     //check if player won or not. If they did, transfer winnings to them
  function winOrLose(bytes32 q_id) internal returns (uint){
     bool checkFlag = results[latestNumber].isWin;

      if (checkFlag == true){
         //pay player
         address payable payPlayer = bets[q_id].punter;
         uint toReward = bets[q_id].betAmount * 2;
         payPlayer.transfer(toReward);

         balance -= bets[q_id].betAmount;

         emit youWin("You won ", bets[q_id].betAmount *2);
         toReward  =0;
     }

     else {
         //keep money
         balance += bets[q_id].betAmount;
         emit youLose("You lost ", bets[q_id].betAmount);
     }


     bets[q_id].betAmount = 0;


  }
  //save the result of the rng to the result mapping
  function saveResults(bytes32 q_id, uint value) public{
     result memory newResult;
     newResult.value = latestNumber;
     newResult.id = q_id;
     newResult.canPlayAgain = true;

     if (latestNumber  ==1){
         newResult.isWin = true;
     }

     else {
         newResult.isWin = false;
     }

     results[latestNumber] = newResult;
     winOrLose(q_id);
     delete bets[q_id];

 }



}
