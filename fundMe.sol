//SPDX-Liscense-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import"./priceConverter.sol";

error NotOwner();

error SentFailed();

error LessThanMinimumPound(); 

contract FundMe {
    using PriceConverter for uint256;

    //Minimum British Pound $20 
    uint256 MINIMUMGBP = 20;

    address[] public arrayOfFunders;

    mapping (address => uint256) public addressToAmountFunded;

    address public immutable i_owner;

    constructor(){
        i_owner = msg.sender; 

    }

    // for other people to deposit fund into the contract
    function fund() public payable{

        // The minimum amount is 20GBP, if the amount lower then revert with the error - LessThanMinimumPound
        if (msg.value.EthToGBPConversionRate()>MINIMUMGBP){
            revert LessThanMinimumPound();
        }
        // revert = undo any action and send the remianing gas back 

        // add the funder to the list 
        arrayOfFunders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
        
    }

        function CheckEthInGBP(uint256 EthAmount) public view returns (uint256) {
            // Enter the amount in Eth and it will return GBP in terms of Eth 
            // 20 GBP devide the returned conversionrate gives funders the minimum amount they need to donate in Eth. 
            return EthAmount.EthToGBPConversionRate();
        }

        function withdraw () public onlyOwner {
            // allows the owner to withdraw all the money from the contract 

            //Reset the mapping of address to amount funded to 0
            for (uint256 funderIndex =0; funderIndex<arrayOfFunders.length;funderIndex++){
                address funder = arrayOfFunders[funderIndex];
                addressToAmountFunded[funder] = 0;

            //Reset the array 
            arrayOfFunders = new address[](0);
            }

            //Only allow the owner to withdraw the funds

            (bool sentSucess, ) = payable(msg.sender).call{value: address(this).balance}("");
            if (!sentSucess){
                revert SentFailed();
            }

        }

        modifier onlyOwner{
                if(msg.sender == i_owner){
                    revert NotOwner();
                }
            _;
        }

        // If someone sends money to the Eth to the contract without calling the fund function we want 
        // to stillbe able to process the payments and add them to our funder list 

        receive() external payable {
            fund();
        }

        fallback() external payable {
            fund();
        }
}