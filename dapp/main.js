var web3 = new Web3(Web3.givenProvider);
var contractInstance;


$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x1B87a44e0Bad77e8E36bd7C1e6dcd9D95F3D8351", {from: accounts[0]});
      console.log(contractInstance);
    //  document.body.style.backgroundImage = "https://cdn1.dotesports.com/wp-content/uploads/2020/04/23084744/Legends-of-Runeterra-Bilgewater.jpg"
    });



     $("#play_button").click(inputData)
  //  $("#result_button").click(spin)

    $("#bet_amount").on("input", function() {

      var potentialWinnings = parseFloat(document.getElementById("bet_amount").value)*2;
      //  $("#potential_winnings").text($(this).val(potentialWinnings));
      $("#potential_winnings").text("You can win " + potentialWinnings + " Finney!");
    })




});



  function inputData(){
  var bet = parseFloat($("#bet_amount").val())*(10 ** 15);

  var config = {
   value: //web3.utils.toWei('3', 'ether')
        bet
  }

  contractInstance.methods.placeBet(bet).send(config)
  .on("transactionHash", function(hash){
    $("#loader").show();
    $("#result_output").hide();
    console.log(hash);

  })
  .on("confirmation", function(confirmationNR){
    console.log(confirmationNR);
  })
  .on("receipt", function(receipt){
    console.log(receipt);
    console.log("done")
  })
  contractInstance.once("youWin", {fromBlock: 'latest', toBlock: 'latest' }, function (error, result){
    //let valueConversion = result.returnValues.theBetAmount
    console.log(result)
    $("#loader").hide();
    $("#result_output").show();
    $("#result_output").text("You won " + result.returnValues.theBetAmount)
  //  result.returnValues.theBetAmount
  })

  contractInstance.once("youLose", {fromBlock: 'latest', toBlock: 'latest' }, function (error, result){
    console.log(result)
    $("#loader").hide();
    $("#result_output").show();
    $("#result_output").text("You lost :(" );
  })

}




/*  function spin(){
  contractInstance.methods.getReward().call().then(function(res){
    var res = parseFloat(res)*(10 ** 18);

    $("#result_button").text("You won " + res);
    console.log(res)


  }) */

  function bl(){
  contractInstance.methods.balance().call().then(function(res){
    var res = parseFloat(res)*(10 ** 15);

    //$("#result_button").text("You won " + res);
    console.log(res)

})


  //var eventWatcher = contractInstance.at("0x81ACA5B48c48101aD94C32a6676d8c18C6E9422a");
  //var youWinEvent = contractInstance.youWin();




/*  contractInstance.events.youWin(function(error,result){
    if(!error){
      console.log(result)
    }
    else{
      console.log(error)
    }
  })

  //var youLoseEvent = contractInstance.youLose();
  contractInstance.events.youLose(function(error,result){
    if(!error){
      console.log(result)
    }
    else{
      console.log(error)
    }
  }) */








}
