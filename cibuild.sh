#!/bin/sh

echo "BUILD.sh"
env

set -ev

installSdl()
{
    curl -O http://www.libsdl.org/release/SDL2-2.0.3.tar.gz
    tar -xzf SDL2-2.0.0.tar.gz
    cd SDL2-2.0.0
    ./configure
    make
    sudo make install
    cd -
}

installNim()
{
    git clone "https://github.com/nim-lang/Nim" ~/nim
    cd ~/nim
    sh bootstrap.sh
    export PATH=$PWD/bin:$PATH
    cd -
}

installNimble()
{
    git clone https://github.com/nim-lang/nimble.git ~/nimble
    cd ~/nimble
    nim c -r src/nimble install
    cd -
    PATH=$HOME/.nimble/bin:$PATH
}

installDependencies()
{
    nimble install -y
}

buildTest()
{
    cd test
    nake
    cd -
}

#sdl2-config --cflags --libs

echo "SDL CONFIG CFLAGS"
#pkg-config --cflags sdl2
#sdl2-config --cflags

echo "SDL CONFIG LINKER"
#pkg-config --libs sdl2
#sdl2-config --libs

#echo Install Sdl
#installSdl

brew install sdl2

echo Install Nim
installNim

echo Install Nimble
installNimble

echo Install dependencies
installDependencies

echo Build test
buildTest
