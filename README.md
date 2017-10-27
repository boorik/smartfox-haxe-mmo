# SmartFoxServer 2X and Haxe MMO sample

A sample project to explain how use haxe (http://haxe.org) with smarfoxserver 2X (http://www.smartfoxserver.com/) 

This is an adaptation of the http://docs2x.smartfoxserver.com/ExamplesJS/simple-mmo example. More precisely the simple MMO world 2 example.

It covers :

- MMORoom
- MMOAOI
- MMOItem
- Buddys
- Chat
- Private chat

You can use this sample as a starting point to create a multiplayer game.

It compiles in HTML5, Windows and Linux targets, and maybe more ( need to test )

## Installation guide

- You need haxe installed on your system, check (http://haxe.org) for download and installation notes.

- Then openfl, in the console type :
```sh
haxelib install openfl
haxelib run openfl setup
```

- Install the smartfoxserver haxe client (https://github.com/boorik/smartfox-haxe-client)

- Get and install SmartFoxServer 2X : (http://www.smartfoxserver.com/download/sfs2x#p=installer)

- Download : JS examples from smartfox site : http://www.smartfoxserver.com/download/get/225
deploy MMOworld2 example on server

- Then copy or clone this repo somewhere

- If you want to create a HTML5 client get the JS client api from (http://www.smartfoxserver.com/download/sfs2x#p=client)
and copy sfs2x-api-1.7.6.js in client/lib/

## Compilation
 
  ```sh
 lime test windows
 ``` 
 where the target can be windows, html5 or android.
 

