var web3 = new Web3(Web3.givenProvider);
var contractInstance;


$(document).ready(function() {
    window.ethereum.enable().then(function(accounts){
      contractInstance = new web3.eth.Contract(abi,"0x4af83DaBD38B7Bcab436b5B07EE3109365319844", {from: accounts[0]});
      console.log(contractInstance);
    });

alert("ff")

     $("#play_button").click(inputData)
    $("#result_button").click(spin)





});

  function inputData(){
  var bet = $("#bet_amount").val();

  var config = {
   value: web3.utils.toWei('4', 'ether')

  }

  contractInstance.methods.play().send(config)
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
    $("#result_output").text("lol");
    console.log(res)

  })

}
