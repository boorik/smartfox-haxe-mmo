# SmartFoxServer 2X and Haxe fullstack sample

A sample project to explain how use haxe (http://haxe.org) with smarfoxserver 2X (http://www.smartfoxserver.com/) on a whole project.

One language from server side to client side enable code sharing and less maintain costs.

You can use this sample as a starting point to create a real time multiplayer game.

It compiles in HTML5, Windows and Android targets, and maybe more.

I will try to explain the best I can some hot spots.

Haxe is a high level modern language that enable cross platform development.
As you maybe know to use SmartFoxserver 2X we need to create jar extensions containing our game logic using Java. Haxe provide a java target (By compiling, it generates .java file and use the java compiler to create a jar ) so we will use it to replace the java language.

We also use Openfl (http://www.openfl.org/) to easily create multiplateform client.

##Code structure :

-server

-common <--- HERE IS THE UNICORN!!!

-client

## Installation guide

- You need haxe installed on your system, check (http://haxe.org) for download and installation notes.

- Then openfl, in the console type :
```sh
haxelib install openfl
haxelib run openfl setup
```
---------------------------------
WARNING CURRENTLY WORKING WITH :

haxe 3.4.0

lime: [2.9.1]

openfl: [3.6.1]

actuate: [1.8.7]

---------------------------------
- Get hxjava to use the java target :
```
haxelib install hxjava
```

- Install the smartfoxserver haxe client (https://github.com/chapatiz/smartfox-haxe-client)

- Get and install SmartFoxServer 2X : (http://www.smartfoxserver.com/download/sfs2x#p=installer)

- Then copy or clone this repo somewhere

- Now you need to copy in server/lib some library from the SFS2X installation SmartFoxServer_2X/SFS2X/lib .
They will provide you server extension API.

 	sfs2x.jar
  
	sfs2x-core.jar
  
	slf4j-api-1.7.5.jar
  
	slf4j-log4j12-1.7.5.jar
	

  
- If you want to create a HTML5 client get the JS client api from (http://www.smartfoxserver.com/download/sfs2x#p=client)
and copy SFS2X_API_JS.js in client/lib/

- finally you have to create the directory : SFS2X/extensions/HaxeExtension and copy server/toDeployInSFS2X/Haxe.zone.xml in SFS2X/zones/

## Compilation

 - server :
 
 To have an autommatic deployment when compiling you can edit server/compileExtension.hxml to set your current SFS2X/extensions directory and working directory in this line:
 ```sh
 -cmd copy "G:\dev\projects\smartfox-haxe-fullstack\server\haxeextension\haxeextension-Debug.jar" "G:\dev\tools\SmartFoxServer_2X\SFS2X\extensions\HaxeExtension\"
  ```
 Then to compile :
 
 ```sh
 haxe compileExtension.hxml
 ```
 - client :
 
  ```sh
 lime test windows
 ```
 
 where the target can be windows, html5 or android.
 
## Highlights

TODO

@:nativeGen

@:meta(com.smartfoxserver.v2.annotations.MultiHandler)
