// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {AccessControl} from "openzeppelin-contracts/access/AccessControl.sol";
import {ERC721} from "openzeppelin-contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "openzeppelin-contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {ERC721Pausable} from "openzeppelin-contracts/token/ERC721/extensions/ERC721Pausable.sol";
import {AggregatorV3Interface} from "foundry-chainlink-toolkit/lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/// @title RWA_Car - NFT representation of real-world cars with depreciation and Chainlink price feeds
/// @notice Mint, list, and sell tokenized cars using ERC721 standard with ETH/USD conversion via Chainlink
/// @dev Contract assumes 8-decimal USD prices and uses Fuji testnet price feed
contract RWA_Car is ERC721, ERC721URIStorage, AccessControl, ERC721Pausable {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    bytes32 public constant MARKETPLACE_ROLE = keccak256("MARKETPLACE_ROLE");

    AggregatorV3Interface internal priceFeed;

    /// @notice Car metadata structure
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
        uint256 priceUSD;
    }

    mapping(uint256 => Car) public cars;
    uint256 public nextTokenId;

    uint256 public constant firstYearDepreciationRate = 14;
    uint256 public constant subsequentYearDepreciationRate = 11;

    /// @notice Emitted when a car NFT is minted
    event CarMinted(
        uint256 indexed tokenId,
        string vin,
        string make,
        uint256 yearManufacture
    );

    /// @notice Emitted when a car is listed for sale
    event CarListed(uint256 indexed tokenId, uint256 priceUSD);

    /// @notice Emitted when a car is purchased
    event CarSold(uint256 indexed tokenId, address indexed buyer);

    /// @notice Emitted when a car's depreciation is calculated
    event CarValueCalculated(
        uint256 tokenId,
        uint256 valueAfterDepreciation,
        uint256 depreciationAmount
    );

    /// @notice Initializes roles and sets Chainlink price feed
    /// @dev Uses Fuji ETH/USD Aggregator address
    constructor() ERC721("RWACarNFT", "CAR") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MINTER_ROLE, msg.sender);
        _grantRole(MARKETPLACE_ROLE, msg.sender);
        priceFeed = AggregatorV3Interface(
            0x86d67c3D38D2bCeE722E601025C25a575021c6EA
        );
    }

    /// @notice Modifier that checks if caller has role or admin privileges
    /// @param role The role being checked against caller
    modifier onlyRoleOrAdmin(bytes32 role) {
        require(
            hasRole(role, msg.sender) ||
                hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
            "Unauthorized"
        );
        _;
    }

    /// @notice Pause all sensitive functions
    function pause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _pause();
    }

    /// @notice Resume normal operations
    function unpause() external onlyRole(DEFAULT_ADMIN_ROLE) {
        _unpause();
    }

    /// @notice Mints a new car NFT to the caller
    /// @param vin Vehicle identification number
    /// @param make Manufacturer make
    /// @param trim Trim level
    /// @param yearManufacture Year of manufacture
    /// @param mileage Car mileage
    /// @param exteriorColor Exterior color
    /// @param interiorColor Interior color
    /// @param driveTrain Drivetrain type
    /// @param engine Engine model
    /// @param transmission Transmission type
    /// @param saleDoc Sale documentation status
    /// @param keys True if keys are included
    /// @param purchaseAmount Original USD purchase value (8 decimals)
    /// @param tokenURI_ IPFS metadata URI
    function mintCarNFT(
        string memory vin,
        string memory make,
        string memory trim,
        uint256 yearManufacture,
        uint256 mileage,
        string memory exteriorColor,
        string memory interiorColor,
        string memory driveTrain,
        string memory engine,
        string memory transmission,
        string memory saleDoc,
        bool keys,
        uint256 purchaseAmount,
        string memory tokenURI_
    ) external onlyRole(MINTER_ROLE) whenNotPaused {
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI_);

        cars[tokenId] = Car(
            vin,
            make,
            trim,
            yearManufacture,
            mileage,
            exteriorColor,
            interiorColor,
            driveTrain,
            engine,
            transmission,
            saleDoc,
            keys,
            purchaseAmount,
            block.timestamp / 365 days,
            false,
            0
        );

        emit CarMinted(tokenId, vin, make, yearManufacture);
        nextTokenId++;
    }

    /// @notice Lists a minted car NFT for sale
    /// @param tokenId ID of the token to list
    /// @param priceUSD Price in USD (8 decimals)
    function listCarForSale(uint256 tokenId, uint256 priceUSD) external {
        require(ownerOf(tokenId) == msg.sender, "Not owner");
        require(priceUSD > 0, "Invalid price");

        cars[tokenId].forSale = true;
        cars[tokenId].priceUSD = priceUSD;

        emit CarListed(tokenId, priceUSD);
    }

    /// @notice Purchase a car using ETH converted from USD
    /// @param tokenId Token ID to purchase
    function buyCar(uint256 tokenId) external payable whenNotPaused {
        Car storage car = cars[tokenId];
        require(car.forSale, "Not for sale");

        uint256 priceETH = getConversionRate(car.priceUSD);
        require(msg.value >= priceETH, "Underpaid");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);

        car.forSale = false;
        car.priceUSD = 0;

        payable(seller).transfer(msg.value);
        emit CarSold(tokenId, msg.sender);
    }

    /// @notice Calculates depreciation based on time since purchase
    /// @param tokenId Token to evaluate
    /// @return remainingValue Post-depreciation value
    /// @return depreciationAmount Total value lost
    function calculateDepreciation(
        uint256 tokenId
    ) external returns (uint256 remainingValue, uint256 depreciationAmount) {
        Car memory car = cars[tokenId];
        require(car.purchaseYear > 0, "Not minted");

        uint256 yearsElapsed = (block.timestamp / 365 days) - car.purchaseYear;
        uint256 value = car.initialPurchaseAmount;

        for (uint256 i = 0; i < yearsElapsed; i++) {
            uint256 rate = (i == 0)
                ? firstYearDepreciationRate
                : subsequentYearDepreciationRate;
            value = (value * (100 - rate)) / 100;
        }

        depreciationAmount = car.initialPurchaseAmount - value;
        emit CarValueCalculated(tokenId, value, depreciationAmount);
        return (value, depreciationAmount);
    }

    /// @notice Gets ETH equivalent of a USD price
    /// @param usdAmount Amount in USD with 8 decimals
    /// @return Equivalent ETH amount in wei
    function getConversionRate(
        uint256 usdAmount
    ) public view returns (uint256) {
        (, int256 ethUsdPrice, , , ) = priceFeed.latestRoundData();
        require(ethUsdPrice > 0, "Invalid price");

        uint256 decimals = priceFeed.decimals();
        uint256 ethAmount = (usdAmount * 10 ** 18 * 10 ** decimals) /
            uint256(ethUsdPrice);
        return ethAmount;
    }

    /// @notice Retrieves token URI metadata
    /// @param tokenId NFT ID
    /// @return IPFS or external URI
    function tokenURI(
        uint256 tokenId
    ) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /// @dev Internal function for token transfer/update (includes pause checks)
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Pausable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    /// @notice Checks supported interfaces
    /// @param interfaceId Bytes4 interface identifier
    /// @return True if interface is supported
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(AccessControl, ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// @notice Withdraws ETH from contract to admin wallet
    function withdrawEther() external onlyRole(DEFAULT_ADMIN_ROLE) {
        payable(msg.sender).transfer(address(this).balance);
    }

    receive() external payable {}
}
// import {CCIPReceiver} from "@chainlink/contracts-ccip/src/v0.8/ccip/applications/CCIPReceiver.sol";
// import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
