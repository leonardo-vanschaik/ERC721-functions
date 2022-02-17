pragma solidity ^0.8.2;

contract ERC721 {

  event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
  event ApprovalForAll(address indexed _owner, address  indexed _operator, bool _approved);
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

  // Tracks the balences. The owners address will return the number of NFTs the owner has
  mapping(address => uint256) internal _balances;

  // Tracks the owner of NFT. The NFT id will return the owner address
  mapping(uint256 => address) internal _owners;

  // Tracks if address is approved to handle NFT
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  // TokenId show approved address
  mapping(uint256 => address) private _tokenApprovals;

  // Returns the number of NFTs assigned to an owner
  function balanceOf(address owner) public view returns(uint256) {

    // Error Checking to ensure address is not 0
    require(owner != address(0), "Address is zero.");
    return _balences[owner];
  }

  // Finds the owner of an NFT
  function ownerOf(uint256 tokenId) public view returns(address) {
    address owner = _owners[tokenId];
    // Error checking to ensure NFT is valid
    require(owner != address(0), "Token ID does not exist.");
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

  // Updates an approved address for an NFT
  function approve(address to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);

    // Error Checking to verify that update is called by TokenId Owner or Approved Operator
    require( msg.sender == owner || isApprovedForAll(owner, msg.sender), "Msg.sender is not the owner or an approved operator.");

    _tokenApprovals[tokenId] = to;
    emit Approval(owner, to, tokenId);
  }

  // Gets the approved address for a single NFT
  function getApproved(uint256 tokenId) public view returns(address) {
    // Error check to verify tokenId is valid. By checking if tokenId is linked to an address
    require(_owners[tokenId] != address(0), "Token ID does not exist.");

    return _tokenApprovals[tokenId];
  }

  // Transfer ownership of an NFT
  function transferFrom(address from, address to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);

    // Error check to verify sender is current owner or approved address for the NFT
    require(
      msg.sender == owner ||
      getApproved(tokenId) == msg.sender ||
      isApprovedForAll(owner, msg.sender),
      "Msg.sender is not the owner or approved for transfer."
    );

    // Error check to verify that sender is owner
    require(owner == from, "From address is not the owner.");

    // Error check to verify that receiver address is not zero
    require(to != address(0), "Address is zero.");

    // Error check to check if tokenId is a valid NFT
    require(_owners[tokenId] != address(0), "Toke ID does not exist.");

    // Clear out the old owners approvals for the NFT
    approve(address(0), tokenId);

    _balances[from] -= 1;
    _balances[to] += 1;
    _owners[tokenId] = to;

    emit Transfer(from, to, tokenId);
  }


  // Standard transferFrom but also checks if onERC721Received is implemented WHEN sending to smart contracts
  function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
    transferFrom(from, to, tokenId);
    require(_checkOnERC721Received(), "Receiver not implemented.");
  }

  function safeTransferFrom(address from, address to, uint256 tokenId) public {
    safeTransferFrom(from, to, tokenId, "");
  }

  // Oversimplified
  function _checkOnERC721Received() private pure returns(bool) {
    return true;
  }


  // EIP165 : Query if a contract implements another interace
  function supportsInterface(bytes4 interfaceId) public pure virtual returns(bool) {
    return interfaceId == 0x80ac58cd;
  }

}
