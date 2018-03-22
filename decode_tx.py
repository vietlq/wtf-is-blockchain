#!/usr/bin/env python3

import rlp
from binascii import hexlify, unhexlify
from eth_utils import to_wei, from_wei

# https://etherscan.io/tx/0x4b353f2ac768fb3a4d1be17bf2ced520a60beb3a154ce1b145bcb6391bc84a7b
# https://etherscan.io/getRawTx?tx=0x4b353f2ac768fb3a4d1be17bf2ced520a60beb3a154ce1b145bcb6391bc84a7b
'''
AccountNonce     uint64          `json:"nonce"    gencodec:"required"`
Price            *big.Int        `json:"gasPrice" gencodec:"required"`
GasLimit         uint64          `json:"gas"      gencodec:"required"`
Recipient        *common.Address `json:"to"       rlp:"nil"` // nil means contract creation
Amount           *big.Int        `json:"value"    gencodec:"required"`
Payload          []byte          `json:"input"    gencodec:"required"`
// Signature values
V                *big.Int        `json:"v"        gencodec:"required"`
R                *big.Int        `json:"r"        gencodec:"required"`
S                *big.Int        `json:"s"        gencodec:"required"`
'''

rawtx_hex = 'f86b028511cfc15d00825208940975ca9f986eee35f5cbba2d672ad9bc8d2a08448766c92c5cf830008026a0d2b0d401b543872d2a6a50de92455decbb868440321bf63a13b310c069e2ba5ba03c6d51bcb2e1653be86546b87f8a12ddb45b6d4e568420299b96f64c19701040'
rawtx = unhexlify(rawtx_hex)
tx_vals = rlp.decode(rawtx)

to_wei(0.123, 'ether')
from_wei(123000000000000000, 'ether')
