const MedicalTestContract = artifacts.require("MedicalTestContract");

module.exports = function (deployer) {
  deployer.deploy(MedicalTestContract);
};