// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RealEstate{
    using SafeMath for uint256;


    //struct to initiate the properties/details of a property
    struct Property{
        uint256 price;
        address owner;
        bool forSale;
        string name;
        string description;
        string location;
    }


    //mapping from property Id to property structs;
    mapping (uint256 => Property) public properties;

    //arrays of to keep the list of properties ids
    uint256[] public propertyIds;

    //Event to be emitted if property is sold
    event PropertySold(uint256 propertyId);


    //function to list new property for sale
    function listPropertyForSale(uint256 _propertyId, uint256 _price, string memory _name, string memory _description, string memory _location) public{

        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,
            forSale: true,
            name: _name,
            description:_description,
            location: _location

        });
    
    properties[_propertyId] = newProperty;
    propertyIds.push(_propertyId);
    }

    //function to buy properties
    function buyProperty(uint256 _propertyId) public payable {
        Property storage property = properties[_propertyId];

        require(property.forSale,"Property is not for sale");
        require(property.price <= msg.value,"insufficient fund");
    

        property.owner = msg.sender;
        property.forSale = false;
        payable (property.owner).transfer(property.price);

        emit PropertySold(_propertyId);
    }

}