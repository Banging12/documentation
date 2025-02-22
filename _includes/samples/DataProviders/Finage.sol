// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

contract FinageChainlink is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;
    
    uint256 oraclePayment;
    int256 public data;
    /**
     * Network: Kovan
     * Oracle: 
     *      Name:           LinkPool
     *      Listing URL:    https://market.link/nodes/323602b9-3831-4f8d-a66b-3fb7531649eb?network=42&start=1614864673&end=1615469473
     *      Address:        0x56dd6586DB0D08c6Ce7B2f2805af28616E082455
     * Job: 
     *      Name:           Finage
     *      ID:             955810d193e144abb85ae2edea65344d
     *      Fee:            0.1 LINK (100000000000000000)
     */
    constructor(uint256 _oraclePayment) ConfirmedOwner(msg.sender) {
      setPublicChainlinkToken();
      oraclePayment = _oraclePayment;
    }

    function requestData
    (
      address _oracle,
      bytes32 _jobId,
      string memory _symbol
    ) 
      public 
      onlyOwner 
    {
      Chainlink.Request memory req = buildChainlinkRequest(_jobId, address(this), this.fulfill.selector);
      req.add("symbol", _symbol);
      sendChainlinkRequestTo(_oracle, req, oraclePayment);
    }

    function fulfill(bytes32 _requestId, int256 _data)
      public
      recordChainlinkFulfillment(_requestId)
    {
      data = _data;
    }
}
