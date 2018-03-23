#!/usr/bin/env python3

import rlp
from binascii import hexlify, unhexlify
from eth_utils import to_wei, from_wei
from ethereum.transactions import Transaction
from ecdsa import SigningKey, VerifyingKey, SECP256k1
from sha3 import keccak_256
from web3 import Web3, HTTPProvider, IPCProvider

# Feel free to change to any host/port to suit your network
w3rpc = Web3(HTTPProvider('http://localhost:8545'))

# Build transaction
tx = Transaction(
    nonce    = w3rpc.eth.getTransactionCount(w3rpc.eth.coinbase),
    gasprice = to_wei(1, 'gwei'),
    startgas = to_wei(90000, 'wei'),
    to       = '0x846c2071c0a712d35bf59e0cfc961014a962b5ad',
    value    = to_wei(1, 'ether'),
    data     = b'',
)

# Dummy private key
priv_key_hex = '46'*20
secexp = int(priv_key_hex, 16)
network_id = 4 # Rinkeby

# Specify private key and ChainID/Network ID
tx.sign('0x' + priv_key_hex, network_id)

# Get hex of signed transaction for sending
raw_tx = rlp.encode(tx)
raw_tx_hex = b'0x' + hexlify(raw_tx)

# Signed transaction is like a signed cheque, anyone can drop at a bank
tx_hash = w3rpc.eth.sendRawTransaction(raw_tx_hex)
tx_receipt = w3rpc.eth.getTransactionReceipt(tx_hash)
print(tx_receipt)

# https://rinkeby.etherscan.io/tx/0x01e12e91a0f889039b9116cdbf3733b2f8d3fb2ccb2b74074fee7a6c63c49b87

################################################################

# Illustration for transaction signature verification
# First, make a copy of the signed transaction
decoded_raw_tx = rlp.decode(raw_tx)
signature = decoded_raw_tx[7] + decoded_raw_tx[8]

# We need to recover the unsigned transaction
unsigned_tx = list(decoded_raw_tx)
unsigned_tx[6] = b'\x04' # v = ChainID = Rinkeby
unsigned_tx[7] = b''     # r = 0
unsigned_tx[8] = b''     # s = 0

# Signed message is simply RLP encoding of the unsigned transaction
msg = rlp.encode(unsigned_tx)

# Verify unsigned transaction against the signature in the signed transaction
sk = SigningKey(secexp, curve=SECP256k1, hashfunc=keccak_256)
vk = sk.get_verifying_key()
vk.verify(signature, msg)
