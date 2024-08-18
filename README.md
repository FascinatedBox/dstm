Don't Stop the Music
====================

### Notice

I am no longer maintaining or even using this repository,. I've found that, in
many cases, this does not work. I think it should, but it simply does not. I
have left it up in case anyone finds it useful.

### Intro

I use Linux and I like to stream various games on Twitch. Sometimes I switch
focus away from a game to check another window, interact with chat, take notes,
and so on. Some games stop playing music if they lose focus, which is why I
created DSTM.

DSTM stands for Don't Stop the Music. The windows of an application launched
through `dstm-run` will behave as they usually do, except that focus out events
are blocked. As a result, application windows will **think** they are still
focused in on, even if they are not.

DSTM works by using LD_PRELOAD to preload a patched `libxcb` or `libX11` that
does not deliver focus out events. The patches for both libraries are included
in the repository.

### Requirements

* Linux (OSX / BSD may work as well)
* X11 (`echo $XDG_SESSION_TYPE` == `x11`)
* Libraries for building libX11 and libxcb (there are several)

### Building

Use `build-dstm.sh <x11|xcb> <64|32>` to build the appropriate library. The
patched libraries that DSTM builds are placed in `.config/dstm/`.

I recommend at least **xcb64** for native games and **xlib32** for Wine.

### Usage

After building the patched libraries, you'll need to manually place `dstm-run`
in a `bin` somewhere.

If you are using `dstm-run` with Steam, set the custom launch options of a game
to exactly `dstm-run %command%`. Steam will launch the game through DSTM, and
the music won't stop.
