// SPDX-License-Identifier: UNLICENSED
// this is solidity file..
pragma solidity ^0.8.9;

contract CrowdFunding {
    // acts as object in js
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target; // uint256 means number
        uint256 deadline;
        uint256 amountCollected;
        string image; // image er url save korbo 
        address[] donators; // array of addresss
        uint256[] donations; // array of amount of donations 
    }

    mapping(uint256 => Campaign) public campaigns; // bujhi nai 😥

    uint256 public numberOfCampaigns = 0; // koto gula campaign create korlam .. sheta track rakhbo

    function createCampaign(
        address _owner, 
        string memory _title, // string er shathe memory jinish ta lage .. 
        string memory _description, 
        uint256 _target, 
        uint256 _deadline, 
        string memory _image
    ) public returns (uint256) {
        /**
         * in solidity .. you have to specify if this function is only internal or if you can use it from our front-end.. so
         * since this one will be public .. we can add a public keyword right here.. and then we even have to specify what is 
         * going to return .. sheta amra () er modhdhe bole dibo . we return the id of that specific campaign
         */
        Campaign storage campaign = campaigns[numberOfCampaigns]; // create new Campaign
        // first e numberOfCampaign hocche 0 .. pore amra increase korbo 

        // require statement in solidity is like a check .. to see everything is good .. 
        // is everything ok ? 
        // block.timestamp hocche current time ..campaign er deadline,  current time er cheye choto hoile error dekhabe je 
        // campaign er deadline er time current time theke beshi hoite hobe .. 
        require(campaign.deadline < block.timestamp, "The deadline should be a date in the future.");
        // eta satisfy na hoile .. code shamne agabe na .. 

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0; // create houar shomoy 0 .. pore donate korle increase hobe .. 
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1; // index return korlam .. most newly created campaign
    }

    function donateToCampaign(uint256 _id) public payable {
        // we need to get the id of the campaign we want to donate the money to and its going to be public and 
        // its going to be payable .. its a special keyword that signifies that we are going to send some 
        // cryptocurrency through out the function .. 
        uint256 amount = msg.value; // this is what we we are trying to send from our front-end

        // we are then going to get the campaign we want to donate to
        Campaign storage campaign = campaigns[_id]; // campaigns ta hocche maping .. jeta amra shuru te create korsilam .. 

        campaign.donators.push(msg.sender); // donator er address push kortesi jeta front-end theke ashse 
        campaign.donations.push(amount);

        // send hocche variable .. eta amader janabe actually send hoise kina 
        (bool sent, ) = payable(campaign.owner).call{value: amount}("");      
        // amra campaign er owner er kase pathacchi .. 

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount; // ager value er shathe new value add kore dilam 
        }
    }

    // list of all dotator who donate a compaign
    function getDonators(uint256 _id) view public returns (address[] memory, uint256[] memory) {
        // we need to know of which campaign do we want to get the donators form
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    // list of all campaigns
    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }
}