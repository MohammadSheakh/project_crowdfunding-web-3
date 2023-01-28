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
        // view function -> its only going to return some data to be able to view it . 
        // and it also going to be public function and its going to return an address.. rather an array of aaddresss in memory
        // so, something that we stored before , in second parameter it is going to return to be an array of numbers also store
        // in memory .. in this case this is the array of addresses of donators and then the array of the numbers of the donations
        return (campaigns[_id].donators, campaigns[_id].donations);
        // amader campaign theke just return korlam .. 
    }

    // list of all campaigns
    function getCampaigns() public view returns (Campaign[] memory) {
        // take no parameter because , we want to return all campaigns .. 
        // we want to return an array of campaigns .. we are gonna get them from memory 
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);
        // we need to get all Campaigns .. in memory .. allCampaigns
        // amra allCampaigns nam e ekta new variable create kortesi , which is of a type, array of multiple campaign structures

        // so, in this case we are not actually getting the campaigns rather we are just creating an empty array with as 
        // many empty elements as they are actual campaigns.. thats why we have this variable .. numberOfCampaigns

        for(uint i = 0; i < numberOfCampaigns; i++) {
            // loop through all of the campaigns and populate that variable .. 
            Campaign storage item = campaigns[i];
            // we want to get a Campaign from storage .. and lets call it item .. and we are going to simply populate that to
            // to the campaigns[i]

            allCampaigns[i] = item;
            // we are fetching that specific campaign from storage .. and we are popupating it straight to our all campaigns
        }

        return allCampaigns; // finally return
    }
}

/**
 * we are now ready to deploy this smart contract so that we can use it on the front-end .. usually deployment is the toughest
 * part .. but third web amader jonno easy kore dise .. from development to deployment .. ekhon amra hardhat.config.js e jabo 
 */