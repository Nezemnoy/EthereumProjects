# EthereumProjects

Solidity **0.8.24** + [Foundry](https://book.getfoundry.sh/): токен **UniToken** (ERC-20) и **MultiTransfer** — массовая раздача фиксированной суммы с баланса контракта списку адресов.

## Требования

- [Foundry](https://book.getfoundry.sh/getting-started/installation): `curl -L https://foundry.paradigm.xyz | bash` → `foundryup`
- В PATH: `export PATH="$HOME/.foundry/bin:$PATH"`

Зависимость **`forge-std`** лежит в `lib/forge-std` (при необходимости: `git clone --depth 1 https://github.com/foundry-rs/forge-std.git lib/forge-std` или `forge install foundry-rs/forge-std`).

## Команды

```bash
cd EthereumProjects
forge build          # компиляция
forge test           # тесты
forge fmt            # форматирование
```

Локальная сеть и деплой (пример):

```bash
anvil   # в отдельном терминале, http://127.0.0.1:8545

export PRIVATE_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
forge script script/Deploy.s.sol:Deploy --rpc-url http://127.0.0.1:8545 --broadcast
```

Для тестовой сети подставь свой RPC и ключ: `--rpc-url $RPC_URL` и `PRIVATE_KEY` в `.env` (не коммить ключи).

## Контракты

| Файл | Описание |
|------|----------|
| `src/UniToken.sol` | UniCoin / UNI, 8 decimals, 1M токенов минтеру при деплое |
| `src/MultiTransfer.sol` | Владелец: `setToken`, список кошельков, `multiTransfer(amount)` на каждого |
| `src/interfaces/IERC20.sol` | Минимальный интерфейс для привязки токена |

## Безопасность

Код учебный/демо. Перед mainnet — аудит, ограничения на `approve`, паузы и т.д. по необходимости.
