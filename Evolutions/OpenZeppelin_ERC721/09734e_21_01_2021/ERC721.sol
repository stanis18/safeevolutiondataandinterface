// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;

import "./Context.sol";
import "./IERC721.sol";
import "./IERC721Metadata.sol";
import "./IERC721Receiver.sol";
import "./ERC165.sol";
import "./Address.sol";
import "./Strings.sol";
import "./SafeMath.sol";


/// @notice invariant forall (address addr) previous_ownedTokensCount[addr] == _balances[addr]
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;
    using SafeMath for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping (uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping (address => uint256) private _balances;


    // Mapping from token ID to approved address
    mapping (uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping (address => mapping (address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor (string memory name_, string memory symbol_) public {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view  returns (bool) {
        // return interfaceId == type(IERC721).interfaceId
        //     || interfaceId == type(IERC721Metadata).interfaceId
        //     || super.supportsInterface(interfaceId);
    }


    /// @notice postcondition _balances[owner] == balance
    function balanceOf(address owner) public view   returns (uint256 balance) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /// @notice postcondition _owners[tokenId] == own
    /// @notice postcondition  own !=  address(0)
    function ownerOf(uint256 tokenId) public view   returns (address own) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view   returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view   returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view   returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0
            ? string(abi.encodePacked(baseURI, tokenId.toString()))
            : '';
    }


    function _baseURI() internal view  returns (string memory) {
        return "";
    }

    /// @notice postcondition _owners[tokenId] == msg.sender || _operatorApprovals[_tokenApprovals[tokenId]][msg.sender]
    /// @notice postcondition _tokenApprovals[tokenId] == to 
    /// @notice emits Approval
    function approve(address to, uint256 tokenId) public {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

     /// @notice postcondition _owners[tokenId] != address(0)
    /// @notice postcondition _tokenApprovals[tokenId] == approved
    function getApproved(uint256 tokenId) public view   returns (address approved) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /// @notice postcondition _operatorApprovals[msg.sender][operator] == approved
    /// @notice emits ApprovalForAll
    function setApprovalForAll(address operator, bool approved) public   {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

      /// @notice postcondition _operatorApprovals[owner][operator] == approved
    function isApprovedForAll(address owner, address operator) public view   returns (bool approved) {
        return _operatorApprovals[owner][operator];
    }

    /// @notice  postcondition ( ( _ownedTokensCount[from] ==  __verifier_old_uint (_ownedTokensCount[from] ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to] ==  __verifier_old_uint ( _ownedTokensCount[to] ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function transferFrom(address from, address to, uint256 tokenId) public   {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /// @notice  postcondition ( ( _ownedTokensCount[from] ==  __verifier_old_uint (_ownedTokensCount[from] ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to] ==  __verifier_old_uint ( _ownedTokensCount[to] ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId) public   {
        safeTransferFrom(from, to, tokenId, "");
    }

    /// @notice  postcondition ( ( _ownedTokensCount[from] ==  __verifier_old_uint (_ownedTokensCount[from] ) - 1  &&  from  != to ) || ( from == to )  ) 
    /// @notice  postcondition ( ( _ownedTokensCount[to] ==  __verifier_old_uint ( _ownedTokensCount[to] ) + 1  &&  from  != to ) || ( from  == to ) )
    /// @notice  postcondition  _tokenOwner[tokenId] == to
    /// @notice  emits Transfer
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public   {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    /// @notice  emits Transfer
    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal  {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view  returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view  returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     d*
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    /// @notice  emits Transfer
    function _safeMint(address to, uint256 tokenId) internal  {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    /// @notice  emits Transfer
    function _safeMint(address to, uint256 tokenId, bytes memory _data) internal  {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    /// @notice  emits Transfer
    function _mint(address to, uint256 tokenId) internal  {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    /// @notice  emits Transfer
    function _burn(uint256 tokenId) internal  {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    /// @notice  emits Transfer
    function _transfer(address from, address to, uint256 tokenId) internal  {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;

        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    /// @notice  emits Approval
    function _approve(address to, uint256 tokenId) internal  {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param _data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        private returns (bool)
    {
        // if (to.isContract()) {
        //     try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
        //         return retval == IERC721Receiver(to).onERC721Received.selector;
        //     } catch (bytes memory reason) {
        //         if (reason.length == 0) {
        //             revert("ERC721: transfer to non ERC721Receiver implementer");
        //         } else {
        //             // solhint-di sable-next-line no-inline-assembly
        //             assembly {
        //                 revert(add(32, reason), mload(reason))
        //             }
        //         }
        //     }
        // } else {
        //     return true;
        // }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal  { }
}
