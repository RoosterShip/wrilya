// SPDX-License-Identifier: GPL-3.0-or-later
//
// Copyright (C) 2024 Decentralized Consulting
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
pragma solidity >=0.8.26;

// ----------------------------------------------------------------------------
// Imports
// ----------------------------------------------------------------------------
import {System} from "@latticexyz/world/src/System.sol";
import {unwrap, wrap} from "@prb/math/src/UD60x18.sol";
import "../utils.sol";
import "../errors.sol";
import "../ledger.sol";
import "../codegen/index.sol";
import "../codegen/common.sol";

// ----------------------------------------------------------------------------
/**
 * @title MarketSystem
 * @author Chris Jimison
 * @notice MUD.dev based smart contract interaction with
 */
contract MarketSystem is System {
  /**
   * @dev Pause the Market
   *
   * Requirements:
   *
   * - Only the governor can pause
   */
  function marketPause() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(MPConfig.getActive(), SystemActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    MPConfig.setActive(false);
  }

  /**
   * @dev Run the Market
   *
   * Requirements:
   *
   * - Only the governor can run the market
   */
  function marketRun() public {
    //---------------------------------
    // Verification Block
    //---------------------------------
    require(_msgSender() == GameConfig.getGovernor(), Unauthorized());
    require(!MPConfig.getActive(), SystemActiveState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    MPConfig.setActive(true);
  }

  /**
   * @dev Create a new List Price Offering
   *
   * Requirements:
   *
   * -  Game is Active
   *
   * @param entityId_ to be put up for sale on the list price
   * @param price_ to sell the entity at
   */
  function marketCreateListLot(
    bytes32 entityId_,
    uint256 price_
  ) public returns (bytes32 auctionId) {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());

    //---------------------------------
    // Logic Block
    //---------------------------------
    // Verify user has funds to cover bill AND bill them
    Ledger.transfer(
      account, toBytes32(GameConfig.getPayee()), MPTuning.getListFee()
    );

    auctionId = newID();
    EntityInfo.setOwner(entityId_, toBytes32(_world()));
    MPInfo.set(auctionId, entityId_, account, Auction.LIST);
    MPListInfo.setPrice(auctionId, price_);
  }

  /**
   * @dev Create an English Auction
   *
   * Requirements:
   *
   * - Game is Active
   * - Caller owns the entity to sell
   * - Caller has enough funds to cover the fee
   *
   * @param entityId_ to put up for auction
   * @param endsIn_ how long the auction will run
   * @param startingPrice_ to begin bidding at
   */
  function marketCreateEnglishLot(
    bytes32 entityId_,
    uint256 endsIn_,
    uint256 startingPrice_
  ) public returns (bytes32 aid) {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());

    // Verify user has funds to cover bill AND bill them
    Ledger.transfer(
      account, toBytes32(GameConfig.getPayee()), MPTuning.getEnglishFee()
    );

    //---------------------------------
    // Logic Block
    //---------------------------------

    aid = newID();
    EntityInfo.setOwner(entityId_, toBytes32(_world()));
    MPInfo.set(aid, entityId_, account, Auction.ENGLISH);
    MPEnglishInfo.set(
      aid, block.timestamp + endsIn_, startingPrice_, bytes32(0), 0
    );
  }

  /**
   * @dev Sells the system based on an dutch auction style where the high price
   * is initially set and then the price is reduced until a buyer bids on it.
   *
   * Requirements:
   *
   * - Game is Active
   * - Caller owns the entity to sell
   * - Caller has enough funds to cover the fee
   *
   * @param entityId_ to sell on the dutch market
   * @param endsIn_ how long the sell will go on
   * @param startingPrice_ the price to work down from
   * @param lowestPrice_ the lowest price for the item.  Determines rate
   */
  function marketCreateDutchLot(
    bytes32 entityId_,
    uint256 endsIn_,
    uint256 startingPrice_,
    uint256 lowestPrice_
  ) public returns (bytes32 aid) {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());

    // Verify user has funds to cover bill AND bill them
    Ledger.transfer(
      account, toBytes32(GameConfig.getPayee()), MPTuning.getDutchFee()
    );

    //---------------------------------
    // Logic Block
    //---------------------------------
    uint256 discountRate =
      convert(wrap(startingPrice_ - lowestPrice_).div(wrap(endsIn_)));
    aid = newID();
    EntityInfo.setOwner(entityId_, toBytes32(_world()));
    MPInfo.set(aid, entityId_, account, Auction.DUTCH);
    MPDutchInfo.set(
      aid,
      block.timestamp,
      block.timestamp + endsIn_,
      startingPrice_,
      discountRate
    );
  }

  /**
   * @dev Create a new penny auction order.  A penny auction is like an english
   * auction however you never get your bid price back.  Thus bidder keep thier
   * price low to not risk paying a high bid but not getting the item.
   *
   * Requirements:
   *
   * - Game is Active
   * - Caller owns the entity to sell
   * - Caller has enough funds to cover the fee
   *
   * @param entityId_ to sell on the dutch market
   * @param endsIn_ how long the sell will go on
   */
  function marketCreatePennyLot(
    bytes32 entityId_,
    uint256 endsIn_
  ) public returns (bytes32 aid) {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(EntityInfo.getOwner(entityId_) == account, InvalidCaller());

    // Verify user has funds to cover bill AND bill them
    Ledger.transfer(
      account, toBytes32(GameConfig.getPayee()), MPTuning.getPennyFee()
    );

    //---------------------------------
    // Logic Block
    //---------------------------------

    aid = newID();
    EntityInfo.setOwner(entityId_, toBytes32(_world()));
    MPInfo.set(aid, entityId_, account, Auction.PENNY);
    MPPennyInfo.set(aid, block.timestamp + endsIn_, bytes32(0), 0, 0);
  }

  /**
   * @dev Place an offer for a market lot
   * @param auctionId_ to place an offer for
   * @param price_ of the offer
   */
  function marketBidLot(bytes32 auctionId_, uint256 price_) public {
    Auction aType = MPInfo.getAuctionType(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(Auction.UNKNOWN != aType, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    if (Auction.LIST == aType) onListOffer(auctionId_, price_);
    else if (Auction.ENGLISH == aType) onEnglishOffer(auctionId_, price_);
    else if (Auction.DUTCH == aType) onDutchOffer(auctionId_, price_);
    else if (Auction.PENNY == aType) onPennyOffer(auctionId_, price_);
  }

  /**
   * @dev Wilthdraw an order from our market
   *
   * Requirements:
   *
   * - Game is Active
   * - Only the seller can withdraw the asset
   * - We are only supporting List Price withdraws at the moment
   * - Withdraws could be supported from other auctions with limitations
   * @param auctionId_ to withdraw from
   */
  function marketWithdrawLot(bytes32 auctionId_) public {
    Auction aType = MPInfo.getAuctionType(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(Auction.LIST == aType, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------
    onListWithdraw(auctionId_);
  }

  /**
   * @dev Claim a completed auction.  This can be called by anyone
   *
   * Requirements:
   *
   * - Game is Active
   * - Only English and Penny auctions can be claimed.
   * - List and Dutch are claimed on the first offer
   * - The order has gone past it's endAt time
   *
   * @param auctionId_ to claim
   */
  function marketClaimLot(bytes32 auctionId_) public {
    Auction aType = MPInfo.getAuctionType(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(GameConfig.getActive(), GameActiveState());
    require(
      Auction.ENGLISH == aType || Auction.PENNY == aType, InvalidArgument()
    );

    //---------------------------------
    // Logic Block
    //---------------------------------
    if (Auction.ENGLISH == aType) onEnglishClaim(auctionId_);
    else if (Auction.PENNY == aType) onPennyClaim(auctionId_);
  }

  // --------------------------------------------------------------------------
  // Helpers
  // --------------------------------------------------------------------------

  function newID() private returns (bytes32) {
    uint256 val = MPNonce.get() + 1;
    MPNonce.set(val);
    return bytes32(val);
  }

  function onListOffer(bytes32 auctionId_, uint256 price_) private {
    uint256 price = MPListInfo.getPrice(auctionId_);
    bytes32 seller = MPInfo.getSeller(auctionId_);
    bytes32 account = toBytes32(_msgSender());
    bytes32 payee = toBytes32(GameConfig.getPayee());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(price_ >= price, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------

    Ledger.transfer(account, payee, price);
    Ledger.transfer(
      payee, seller, price - percent(price, MPTuning.getListRake())
    );

    EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), account);

    MPInfo.deleteRecord(auctionId_);
    MPListInfo.deleteRecord(auctionId_);
  }

  function onListWithdraw(bytes32 auctionId_) private {
    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(MPInfo.getSeller(auctionId_) == account, InvalidCaller());

    //---------------------------------
    // Logic Block
    //---------------------------------
    EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), account);

    MPInfo.deleteRecord(auctionId_);
    MPListInfo.deleteRecord(auctionId_);
  }

  function onEnglishOffer(bytes32 auctionId_, uint256 price_) private {
    bytes32 account = toBytes32(_msgSender());
    bytes32 world = toBytes32(_world());
    (
      uint256 endsAt,
      uint256 startingPrice,
      bytes32 bidder,
      uint256 currentPrice
    ) = MPEnglishInfo.get(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------

    require(endsAt >= block.timestamp, TimeExpired());
    require(
      (price_ > startingPrice) && (price_ >= currentPrice), InvalidArgument()
    );
    require(bidder != account, InvalidCaller());

    //---------------------------------
    // Logic Block
    //---------------------------------

    if (bytes32(0) != bidder) {
      Ledger.transfer(world, bidder, currentPrice);
    }
    Ledger.transfer(account, world, price_);
    MPEnglishInfo.setBidder(auctionId_, account);
    MPEnglishInfo.setCurrentPrice(auctionId_, price_);
  }

  function onEnglishClaim(bytes32 auctionId_) private {
    uint256 endsAt = MPEnglishInfo.getEndsAt(auctionId_);
    bytes32 bidder = MPEnglishInfo.getBidder(auctionId_);
    uint256 price = MPEnglishInfo.getCurrentPrice(auctionId_);
    bytes32 seller = MPInfo.getSeller(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------

    require(block.timestamp > endsAt, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------

    // No successful bids
    if ((price == 0) && (bidder == bytes32(0))) {
      EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), seller);
    }
    // There was at least one bid
    else {
      EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), bidder);
      Ledger.transfer(
        toBytes32(_world()),
        MPInfo.getSeller(auctionId_),
        price - percent(price, MPTuning.getDutchRake())
      );
    }

    MPInfo.deleteRecord(auctionId_);
    MPEnglishInfo.deleteRecord(auctionId_);
  }

  function onDutchOffer(bytes32 auctionId_, uint256 price_) private {
    (
      uint256 startsAt,
      uint256 endsAt,
      uint256 startingPrice,
      uint256 discountRate
    ) = MPDutchInfo.get(auctionId_);

    bytes32 account = toBytes32(_msgSender());
    uint256 timeElapsed = block.timestamp - startsAt;
    uint256 discount = discountRate * timeElapsed;
    uint256 price = startingPrice - discount;
    bytes32 payee = toBytes32(GameConfig.getPayee());

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(endsAt >= block.timestamp, TimeExpired());
    require(price_ >= price, InsufficientFunds());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(account, payee, price);
    Ledger.transfer(
      payee,
      MPInfo.getSeller(auctionId_),
      price - percent(price, MPTuning.getDutchRake())
    );

    EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), account);

    MPInfo.deleteRecord(auctionId_);
    MPDutchInfo.deleteRecord(auctionId_);
  }

  function onPennyOffer(bytes32 auctionId_, uint256 price_) private {
    (uint256 endsAt, bytes32 bidder, uint256 currentPrice, uint256 total) =
      MPPennyInfo.get(auctionId_);

    bytes32 account = toBytes32(_msgSender());

    //---------------------------------
    // Verification Block
    //---------------------------------

    require(endsAt >= block.timestamp, TimeExpired());
    require(price_ >= currentPrice, InvalidArgument());
    require(bidder != account, InvalidArgument());

    //---------------------------------
    // Logic Block
    //---------------------------------
    Ledger.transfer(account, toBytes32(_world()), price_);
    MPPennyInfo.set(auctionId_, endsAt, account, price_, total + price_);
  }

  function onPennyClaim(bytes32 auctionId_) private {
    uint256 endsAt = MPPennyInfo.getEndsAt(auctionId_);
    bytes32 bidder = MPPennyInfo.getBidder(auctionId_);
    uint256 price = MPPennyInfo.getTotal(auctionId_);
    bytes32 seller = MPInfo.getSeller(auctionId_);

    //---------------------------------
    // Verification Block
    //---------------------------------
    require(block.timestamp > endsAt, InvalidState());

    //---------------------------------
    // Logic Block
    //---------------------------------

    // No successful bids
    if ((price == 0) && (bidder == bytes32(0))) {
      EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), seller);
    }
    // There was at least one bid
    else {
      EntityInfo.setOwner(MPInfo.getEntityId(auctionId_), bidder);
      Ledger.transfer(
        toBytes32(_world()),
        seller,
        price - percent(price, MPTuning.getPennyRake())
      );
    }

    MPInfo.deleteRecord(auctionId_);
    MPPennyInfo.deleteRecord(auctionId_);
  }
}
