pragma solidity >= 0.4.9;

import "./ExchangeCore.sol";

contract Exchange is ExchangeCore {

    /* Public ABI-encodable method wrappers. */

    function hashOrder_(address exchange, address maker, address staticTarget, bytes memory staticExtradata, uint listingTime, uint expirationTime, uint salt)
        public
        pure
        returns (bytes32 hash)
    {
        return hashOrder(Order(exchange, maker, staticTarget, staticExtradata, listingTime, expirationTime, salt));
    }

    function hashToSign_(bytes32 orderHash)
        public
        pure
        returns (bytes32 hash)
    {
        return hashToSign(orderHash);
    }

    function validateOrderParameters_(address exchange, address maker, address staticTarget, bytes memory staticExtradata, uint listingTime, uint expirationTime, uint salt)
        public
        view
        returns (bool)
    {
        return validateOrderParameters(Order(exchange, maker, staticTarget, staticExtradata, listingTime, expirationTime, salt));
    }

    function validateOrderAuthorization_(bytes32 hash, address maker, uint8 v, bytes32 r, bytes32 s)
        public
        view
        returns (bool)
    {
        return validateOrderAuthorization(hash, maker, Sig(v, r, s));
    }

    function approveOrder_(address exchange, address maker, address staticTarget, bytes memory staticExtradata, uint listingTime, uint expirationTime, uint salt, bool orderbookInclusionDesired)
        public
    {
        return approveOrder(Order(exchange, maker, staticTarget, staticExtradata, listingTime, expirationTime, salt), orderbookInclusionDesired);
    }

    function cancelOrder_(address exchange, address maker, address staticTarget, bytes memory staticExtradata, uint listingTime, uint expirationTime, uint salt)
        public
    {
        return cancelOrder(Order(exchange, maker, staticTarget, staticExtradata, listingTime, expirationTime, salt));
    }

    function atomicMatch_(address[8] memory addrs, uint[6] memory uints, bytes memory firstExtradata, bytes memory firstCalldata, bytes memory secondExtradata,
        bytes memory secondCalldata, uint8[4] memory howToCallsVs, bytes32[5] memory rssMetadata)
        public
        payable
    {
        return atomicMatch(
            Order(addrs[0], addrs[1], addrs[2], firstExtradata, uints[0], uints[1], uints[2]),
            Sig(howToCallsVs[0], rssMetadata[0], rssMetadata[1]),
            Call(addrs[3], AuthenticatedProxy.HowToCall(howToCallsVs[1]), firstCalldata),
            Order(addrs[4], addrs[5], addrs[6], secondExtradata, uints[3], uints[4], uints[5]),
            Sig(howToCallsVs[2], rssMetadata[2], rssMetadata[3]),
            Call(addrs[7], AuthenticatedProxy.HowToCall(howToCallsVs[3]), secondCalldata),
            rssMetadata[4]
        );
    }

}
