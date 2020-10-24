const CoinFlip = artifacts.require("CoinFlip");

module.exports = function(deployer) {
  deployer.deploy(CoinFlip).then(function(instance){
    instance.depositFunds({value: web3.utils.toWei("50", "ether")})

  })


};
