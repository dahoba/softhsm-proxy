# Alpine SoftHSMv2 with PKCS11-proxy 

- Alpine 3.9
- SoftHSM v2.5
- PKCS11-Proxy
- stunnel

Initial token

```
softhsm2-util --init-token --slot 0 --label "My First Token" --pin 1234 --so-pin 0000
```

Test the module

```
pkcs11-tool --module /usr/local/lib/softhsm/libsofthsm2.so -l -t
```

Test proxy module

```
PKCS11_PROXY_SOCKET="tcp://softhsm:5657" pkcs11-tool --module=/usr/local/lib/libpkcs11-proxy.so  -l -t
```
