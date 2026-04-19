// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC20} from "./interfaces/IERC20.sol";

/// @title MultiTransfer — список получателей и раздача фиксированной суммы каждому из баланса контракта.
/// Раньше: вызов несуществующей «token.Transfer(...)» (event) и отсутствие проверки общей суммы.
contract MultiTransfer {
    IERC20 public token;
    address public owner;
    address[] private _wallets;

    event TokenUpdated(address indexed token);
    event WalletAdded(address indexed wallet, uint256 index);
    event WalletRemoved(address indexed wallet, uint256 index);
    event BatchSent(uint256 amountPerRecipient, uint256 recipients);

    error Unauthorized();
    error ZeroAddress();
    error TokenNotSet();
    error EmptyRecipients();
    error TransferFailed();
    error InsufficientContractBalance(uint256 need, uint256 have);

    modifier onlyOwner() {
        if (msg.sender != owner) revert Unauthorized();
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function setToken(IERC20 newToken) external onlyOwner {
        if (address(newToken) == address(0)) revert ZeroAddress();
        token = newToken;
        emit TokenUpdated(address(newToken));
    }

    function transferOwnership(address newOwner) external onlyOwner {
        if (newOwner == address(0)) revert ZeroAddress();
        owner = newOwner;
    }

    function pushWallet(address wallet) external onlyOwner {
        if (wallet == address(0)) revert ZeroAddress();
        _wallets.push(wallet);
        emit WalletAdded(wallet, _wallets.length - 1);
    }

    /// Удаление по индексу: последний элемент переносится на место удаляемого (O(1)).
    function removeWallet(uint256 index) external onlyOwner {
        uint256 len = _wallets.length;
        if (index >= len) revert EmptyRecipients();
        address removed = _wallets[index];
        _wallets[index] = _wallets[len - 1];
        _wallets.pop();
        emit WalletRemoved(removed, index);
    }

    function walletAt(uint256 index) external view returns (address) {
        return _wallets[index];
    }

    function walletCount() external view returns (uint256) {
        return _wallets.length;
    }

    function contractTokenBalance() external view returns (uint256) {
        if (address(token) == address(0)) return 0;
        return token.balanceOf(address(this));
    }

    /// Переводит `amountPerRecipient` каждому адресу из списка; нужен полный запас: amount * N.
    function multiTransfer(uint256 amountPerRecipient) external onlyOwner {
        IERC20 t = token;
        if (address(t) == address(0)) revert TokenNotSet();

        uint256 n = _wallets.length;
        if (n == 0) revert EmptyRecipients();

        uint256 totalNeeded;
        unchecked {
            totalNeeded = amountPerRecipient * n;
        }

        uint256 bal = t.balanceOf(address(this));
        if (bal < totalNeeded) revert InsufficientContractBalance(totalNeeded, bal);

        for (uint256 i = 0; i < n; ) {
            address to = _wallets[i];
            if (to == address(0)) revert ZeroAddress();
            if (!t.transfer(to, amountPerRecipient)) revert TransferFailed();
            unchecked {
                ++i;
            }
        }
        emit BatchSent(amountPerRecipient, n);
    }
}
