// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "openzeppelin-contracts/access/AccessControl.sol";
// import "openzeppelin-contracts/security/Pausable.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Pausable.sol";

contract RWA_Car is ERC721URIStorage, AccessControl, Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MARKETPLACE_ROLE = keccak256("MARKETPLACE_ROLE");

    struct Car {
        string vin;
        string make;
        string trim;
        uint256 yearManufacture;
        uint256 mileage;
        string exteriorColor;
        string interiorColor;
        string driveTrain;
        string engine;
        string transmission;
        string saleDoc;
        bool keys;
        uint256 initialPurchaseAmount;
        uint256 purchaseYear;
        bool forSale;
        uint256 price;
    }

    struct CarInput {
        string vin;
        string make;
        string trim;
        uint256 yearManufacture;
        uint256 mileage;
        string exteriorColor;
        string interiorColor;
        string driveTrain;
        string engine;
        string transmission;
        string saleDoc;
        bool keys;
        uint256 initialPurchaseAmount;
        string tokenURI;
    }

    mapping(uint256 => Car) public cars;
    uint256 public nextTokenId;

    uint256 public constant firstYearDepreciationRate = 14;
    uint256 public constant subsequentYearDepreciationRate = 11;

    event CarMinted(uint256 tokenId, string vin, string make, uint256 yearManufacture);
    event CarListed(uint256 tokenId, uint256 price);
    event CarSold(uint256 tokenId, address buyer);
    event CarValueCalculated(uint256 tokenId, uint256 valueAfterDepreciation, uint256 depreciationAmount);

    constructor() ERC721("RWACarNFT", "CAR") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MARKETPLACE_ROLE, msg.sender);
    }

    modifier onlyRoleOrAdmin(bytes32 role) {
        require(hasRole(role, msg.sender) || hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "Unauthorized");
        _;
    }

    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    function mintCarNFT(CarInput calldata input) external onlyRole(MINTER_ROLE) whenNotPaused {
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, input.tokenURI);

        cars[tokenId] = Car(
            input.vin,
            input.make,
            input.trim,
            input.yearManufacture,
            input.mileage,
            input.exteriorColor,
            input.interiorColor,
            input.driveTrain,
            input.engine,
            input.transmission,
            input.saleDoc,
            input.keys,
            input.initialPurchaseAmount,
            block.timestamp / 365 days,
            false,
            0
        );

        emit CarMinted(tokenId, input.vin, input.make, input.yearManufacture);
        nextTokenId++;
    }

    function listCarForSale(uint256 tokenId, uint256 price) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        require(price > 0, "Invalid price");

        cars[tokenId].forSale = true;
        cars[tokenId].price = price;

        emit CarListed(tokenId, price);
    }

    function buyCar(uint256 tokenId) external payable whenNotPaused {
        Car storage car = cars[tokenId];
        require(car.forSale, "Car not for sale");
        require(msg.value == car.price, "Incorrect value");
        require(ownerOf(tokenId) != address(0), "Invalid token");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);

        car.forSale = false;
        car.price = 0;

        payable(seller).transfer(msg.value);
        emit CarSold(tokenId, msg.sender);
    }

    function calculateDepreciation(uint256 tokenId)
        external
        returns (uint256 remainingValue, uint256 depreciationAmount)
    {
        Car memory car = cars[tokenId];
        require(car.purchaseYear > 0, "Car not minted");

        uint256 yearsElapsed = (block.timestamp / 365 days) - car.purchaseYear;
        remainingValue = car.initialPurchaseAmount;

        for (uint256 i = 0; i < yearsElapsed; i++) {
            uint256 rate = (i == 0) ? firstYearDepreciationRate : subsequentYearDepreciationRate;
            remainingValue = (remainingValue * (100 - rate)) / 100;
        }

        depreciationAmount = car.initialPurchaseAmount - remainingValue;
        emit CarValueCalculated(tokenId, remainingValue, depreciationAmount);
        return (remainingValue, depreciationAmount);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControl, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function withdrawEther() external onlyRole(DEFAULT_ADMIN_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
