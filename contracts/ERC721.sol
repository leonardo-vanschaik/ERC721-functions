pragma solidity ^0.8.2;

contract ERC721 {


  event ApprovalForAll(address indexed _owner, address  indexed _operator, bool _approved);

  // Tracks the balences. The owners address will return the number of NFTs the owner has
  mapping(address => uint256);

  // Tracks the owner of NFT. The NFT id will return the owner address
  mapping(uint256 => address) internal _owners;

  // Tracks if address is approved to handle NFT
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  // Returns the number of NFTs assigned to an owner
  function balanceOf(address owner) public view returns(uint256) {

    // Error Checking to ensure address is not 0
    require(owner != address(0), "Address is zero");
    return _balences[owner];
  }

  // Finds the owner of an NFT
  function ownerOf(uint256 tokenId) public view returns(address) {
      address owner = _owners[tokenId];
      // Error checking to ensure NFT is valid
      require(owner != address(0), "TokenID does not exist")
      return owner;
  }

  // Enables or disables an operator to manage all of msg.senders assets.
  function setApprovalForAll(address operator, bool approved) public {
      _operatorApprovals[msg.sender][operator] = approved;
      emit ApprovalForAll(msg.sender, operator, approved);
  }

  // Checks if an address is an operator for another address
  function isApprovedForAll(address owner, address operator) public view returns(bool) {
      return _operatorApprovals[owner][operator];
  }


}
