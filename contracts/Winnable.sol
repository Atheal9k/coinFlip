pragma solidity >=0.5.12 < 0.6.0;
import "./Ownable.sol";
import "./Storagable.sol";



contract Winnable is Ownable, Storagable {



    event youWin (string, uint);
    event youLose(string, uint);
    event checkBalance(uint, uint);


      function winOrLose(address punter, bytes32 q_id) internal returns (uint){
          bool checkFlag = results[q_id].isWin;
        uint betAmount = waiting[q_id].betAmount;

        if (checkFlag == true || checkFlag == false){
            //pay player

            uint toReward = betAmount * 2;
            uint winnings = punters[punter].punterBalance;


           winnings += toReward;
            emit checkBalance(betAmount, winnings);
            Storagable.balance -= betAmount;

            emit youWin("You won ", toReward);
            toReward  =0;
        }

        else {
            //keep money
            balance += betAmount;
            emit youLose("You lost ", betAmount);
        }


        betAmount = 0;

    }












}
