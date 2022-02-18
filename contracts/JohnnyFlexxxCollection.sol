pragma solidity ^0.8.2;

import "./ERC721.sol";

contract JohnnyFlexxxCollection is ERC721 {

  string public name; // ERC721Metadata
  string public symbol; // ERC721Metadata
  uint256 public tokenCount;
  mapping (uint256 => string) private _tokenURIs;

  constructor(string memory _name, string memory _symbol) {
    name = _name;
    symbol = _symbol;
  }

  // Returns a URL that points to NFT metadata
  function tokenURI(uint256 tokenId) public view returns (string memory) {

    // Error check to verify if tokenId exists
    require(_owners[tokenId] != address(0), "Token ID does not exist.");

    return _tokenURIs[tokenId];
  }

  // Creates a new NFT inside our collection
  function mint(string memory _tokenURI) public {
    // Update token count. (Also represents tokenId)
    tokenCount += 1;
    _balances[msg.sender] += 1;
    _owners[tokenCount] = msg.sender;
    _tokenURIs[tokenCount] = _tokenURI;

    emit Transfer(address(0), msg.sender, tokenCount);

  }

  function supportsInterface(bytes4 interfaceId) public pure override returns(bool) {
    return interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
  }

}
