var web3 = new Web3(Web3.givenProvider);
var contractInstance;


$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x8193c39eFd9Ba40B19e6a5A35139789a2B55f5A1", {from: accounts[0]});
      console.log(contractInstance);
    });



     $("#play_button").click(inputData)
    $("#result_button").click(spin)
    $("#initial_button").click(createPlayer)





});

  function inputData(){
  var bet = parseFloat($("#bet_amount").val())*(10 ** 15);

  var config = {
   value: //web3.utils.toWei('3', 'ether')
        bet
  }

  contractInstance.methods.placeBet().send(config)
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

function createPlayer(){
    contractInstance.methods.createPlayer().send()
    alert("fffff")
}


  function spin(){
  contractInstance.methods.getReward().call().then(function(res){
    var res = parseFloat(res)*(10 ** 18);

    $("#result_output").text("You won " + res);
    console.log(res)


  })

}
