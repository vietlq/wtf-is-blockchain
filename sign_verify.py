#!/usr/bin/env python3

from binascii import hexlify
from sha3 import keccak_256
from ecdsa import SigningKey, SECP256k1

priv_key_hex = '4646464646464646464646464646464646464646464646464646464646464646'
secexp = int(priv_key_hex, 16)

sk = SigningKey.from_secret_exponent(secexp, curve=SECP256k1, hashfunc=keccak_256)
vk = sk.get_verifying_key()
msg = b'I love VISC - https://visc.network'
non_deterministic_signature = sk.sign(msg)
deterministic_signature = sk.sign_deterministic(msg)

assert(sk.sign(msg) != sk.sign(msg))
assert(sk.sign_deterministic(msg) == sk.sign_deterministic(msg))

print("Signing the message:\n", msg)
print("Non-deterministic signature:\n", hexlify(non_deterministic_signature))
print("Deterministic signature:\n", hexlify(deterministic_signature))
print("Verify non-deterministic signature:", vk.verify(non_deterministic_signature, msg))
print("Verify deterministic signature:", vk.verify(deterministic_signature, msg))
