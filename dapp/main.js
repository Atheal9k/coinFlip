var web3 = new Web3(Web3.givenProvider);
var contractInstance;


$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x49e3Bb1DdBd463E3A74Fd8FB306179f4fAf8E0d0", {from: accounts[0]});
      console.log(contractInstance);
    });



     $("#play_button").click(inputData)
    $("#result_button").click(spin)





});

  function inputData(){
  var bet = parseFloat($("#bet_amount").val())*(10 ** 18);

  var config = {
   value: //web3.utils.toWei('3', 'ether')
        bet
  }

  contractInstance.methods.random().send(config)
  .on("transactionHash", function(hash){
    console.log(hash);

  })
  .on("confirmation", function(confirmationNR){
    console.log(confirmationNR);
  })
  .on("receipt", function(receipt){
    console.log(receipt);
    console.log("done")
  })

}



  function spin(){
  contractInstance.methods.getReward().call().then(function(res){
    var res = parseFloat(res)*(10 ** 18);

    $("#result_output").text("You won " + res);
    console.log(res)


  })

}
