pragma solidity >=0.5.12 < 0.6.0;
import "./Ownable.sol";

contract Storagable is Ownable{


     struct result{
        uint number;
        bool isWin;
        bytes32 id;
    }


    struct bet{
        address payable player;
        uint betAmount;
        bytes32 id;
    }

    struct punter{
        address payable punter;
        uint punterBalance;
        bytes32 id;
    }

    uint public balance;


    mapping (bytes32 => bet) internal waiting;
      mapping (bytes32 => result) internal results;
      mapping (address => punter)internal punters;

       event depositedFunds(string whatHappened, uint funds);
      event withDrewFunds (string whatHappened, uint funds);
      event checkBalance(uint, uint);


    function createPlayer(address payable n_player, uint _betAmount, bytes32 q_id )public payable  {

        bet memory newPlayer;
        newPlayer.player = n_player;
        newPlayer.betAmount = _betAmount;
        waiting[q_id] = newPlayer;
        punters[msg.sender].id = q_id;

    }

     function saveResults(uint numberCalled, bytes32 q_id) public{
        result memory newResult;
        newResult.number = numberCalled;
        newResult.id = q_id;


        if (numberCalled  ==1){
            newResult.isWin = true;
        }

        else {
            newResult.isWin = false;
        }

        results[q_id] = newResult;

    }

    function depositPunterFunds()public payable{
        punter memory newPunter;
        newPunter.punter = msg.sender;
        newPunter.punterBalance = punters[msg.sender].punterBalance;
        newPunter.id = punters[msg.sender].id;
        punters[msg.sender] = newPunter;
        punters[msg.sender].punterBalance += msg.value;
        emit depositedFunds("You deposited ", msg.value);
    }

    function getPunterBalance() public  returns(uint){
        emit checkBalance(punters[msg.sender].punterBalance, punters[msg.sender].punterBalance);
        return punters[msg.sender].punterBalance;
    }

    function withdrawPunterBalance () public returns(uint){
        uint toTransfer = punters[msg.sender].punterBalance;
        emit checkBalance(toTransfer, toTransfer);
        punters[msg.sender].punterBalance = 0;
        msg.sender.transfer(toTransfer);
          emit withDrewFunds("You withdrew ", toTransfer);
        return toTransfer;


    }

    function withdrawContractBalance () public onlyOwner returns (uint){
        uint toSend = balance;
        balance = 0;
        msg.sender.transfer(toSend);
        return toSend;

    }





}
