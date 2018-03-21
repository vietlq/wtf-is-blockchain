#!/usr/bin/env python

from ecdsa import SigningKey, SECP256k1

sk = SigningKey.generate(curve=SECP256k1)
vk = sk.get_verifying_key()

print("Private Key:\n%s" % sk.to_pem().decode('utf-8'))
print("Public Key:\n%s" % vk.to_pem().decode('utf-8'))
print("Public Key:\n%s" % vk.to_string())
