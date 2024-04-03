#### LINUX
## Shamir's Secret Sharing Scheme
### Allows a secret to be split in to shares and combine to show it
[Learn more](http://point-at-infinity.org/ssss/)

These shares can then be distributed to different people. When the time comes
to retrieve the secret then a preset number of the shares need to be combined.
The number of shares created, and the number needed to retrieve the secret
are set at splitting time. The number of shares required to re-create the
secret can be chosen to be less that the number of shares created, so any
large enough subset of the shares can retrieve the secret.

This scheme allows a secret to be shared, either to reduce the chances that
the secret is lost, or to increase the number of parties that must cooperate
to reveal the secret.


### Installation

linux/debian\
```sudo apt install -y ssss```

macos [HELP](https://formulae.brew.sh/formula/)\
```brew install ssss```

### Dependencies

If wish to work with GUI then install **zenity** or **whiptail/dialog** to go with terminal.
Dialog its only choice for MacOS.