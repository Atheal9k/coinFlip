pragma solidity >=0.5.12 < 0.6.0;
import "./Ownable.sol";
import "./provableAPI.sol";



contract CoinFlip is Ownable, usingProvable{


    uint internal balance;
    uint internal betAmount;
    //uint internal result;
    uint internal reward;


    bytes32 id;


    event youWin (string, uint);
    event youLose(string, uint);

    struct result{
        uint value;
        bool isWin;
    }


    struct bet{
        address player;
        uint betAmount;
    }

    mapping (bytes32 => bet) private waiting;
      mapping (uint => result) private results;



     modifier costs(uint cost){
        require(msg.value >= cost, "Need at least 0.1 szabo");
        _;


    }

    uint256 constant NUM_RANDOM_BYTES_REQUESTED = 1;
  uint256 public latestNumber;


  event LogNewProvableQuery(string description);
  event generatedRandomNumber(uint256 randomNumber);
  event idCheck(string ss, bytes32 id);


  //constructor() public {
  //update();
  //}

  function __callback(bytes32 _queryId, string memory _result, bytes memory _proof) public {
    require(msg.sender == provable_cbAddress());

    uint256 randomNumber = uint256(keccak256(abi.encodePacked(_result))) % 100;

    latestNumber = randomNumber;
    saveResults(latestNumber);
    winOrLose();

    delete waiting[id];



    emit generatedRandomNumber(randomNumber);
  }

  function random() payable public costs (0.1 szabo) {
    uint256 QUERY_EXECUTION_DELAY =0;
    uint GAS_FOR_CALLBACK = 200000;
     id =
    provable_newRandomDSQuery(
        QUERY_EXECUTION_DELAY,
        NUM_RANDOM_BYTES_REQUESTED,
        GAS_FOR_CALLBACK
      );

     updatePlayer(msg.value);
     emit idCheck("The ID of this call is ",id);
    emit LogNewProvableQuery("Provable query was sent, standing by for the answer.");

  }

    function saveResults(uint value) public{
        result memory newResult;
        newResult.value = latestNumber;

        if (latestNumber % 2 ==1){
            newResult.isWin = true;
        }

        else {
            newResult.isWin = false;
        }

        results[latestNumber] = newResult;
    }



    function updatePlayer(uint _betAmount )public payable  {
        //update();

        bet memory newPlayer;
        newPlayer.player = msg.sender;
        newPlayer.betAmount = _betAmount;
        waiting[id] = newPlayer;


        betAmount += msg.value;




       // winOrLose();



    }




    function getResults(bytes32 id) internal returns (address player, uint bets){
         return (waiting[id].player, waiting[id].betAmount);


    }

    function winOrLose() internal returns (uint){
        if (results[latestNumber].isWin == true){
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
