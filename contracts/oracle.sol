pragma solidity >=0.5.12 < 0.6.0;
import "./provableAPI.sol";
import "./Storagable.sol";
import "./Winnable.sol";


contract oracle is usingProvable, Storagable, Winnable{


  uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
  uint256 public latestNumber;



  event LogNewProvableQuery(string description);
  event generatedRandomNumber(uint256 randomNumber);
  event idCheck(string a, bytes32 q_id);









    function __callback(address punter, bytes32 _queryId, string memory _result/* bytes memory _proof*/) public {
    require(msg.sender == provable_cbAddress());

    uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 2;

    latestNumber = randomNumber;
    emit generatedRandomNumber(randomNumber);
    saveResults(latestNumber,_queryId);
    punters[punter].id;
    winOrLose(punter, _queryId);
    delete waiting[_queryId].id;

  }

  function random(/*address punter*/uint _betAmount) payable public  {
    uint256 QUERY_EXECUTION_DELAY =0;
    uint GAS_FOR_CALLBACK = 200000;


   bytes32 q_id =  provable_newRandomDSQuery(
        QUERY_EXECUTION_DELAY,
        NUM_RANDOM_BYTES_REQUESTED,
        GAS_FOR_CALLBACK
      );
       _betAmount = msg.value;
      createPlayer(msg.sender, _betAmount, q_id);


     emit idCheck("The ID of this call is ", q_id);
    emit LogNewProvableQuery("Provable query was sent, standing by for the answer.");

  }



}
