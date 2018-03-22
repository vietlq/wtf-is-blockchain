#!/usr/bin/env python3

from ecdsa import SigningKey, SECP256k1
from sha3 import keccak_256

print(keccak_256('😺'.encode('utf-8')).digest())
print(keccak_256('😺'.encode('utf-8')).hexdigest())

# Priv_key: 0x4646464646464646464646464646464646464646464646464646464646464646
# Expected Address: 0x9d8a62f656a8d1615c1294fd71e9cfb3e4855a4f
