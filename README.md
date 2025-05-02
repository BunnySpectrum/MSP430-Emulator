MSP430 Emulator
===============
# Intro

This is a fork of RudolfGeosits's project: https://github.com/RudolfGeosits/MSP430-Emulator

# Setup
## Linux
```
cd path/to/this/repo
./install_deps.sh
make PREFIX='/usr/local' 
```

TODO [Check Linux install](https://github.com/BunnySpectrum/MSP430-Emulator/issues/3)

## Mac
Steps below assume you are using homebrew to install packages.

Download files from [TI](https://www.ti.com/tool/download/MSP430-GCC-OPENSOURCE)
- "GCC mac toolchain only"
- "Header and support files"

```
brew install libwebsockets
cd path/to/this/repo
make PREFIX='/opt/homebrew'
```


