# Development

## Basics

This folder contains "extensions." They are individual modules for the gamemode that extend the functionality in some way.

Each extension has a `HOOKS` table made available to it when it is loaded. Declaring a function on the HOOKS table adds a hook for it. For example:
```Lua
function HOOKS:Initialize()
	print("We're initializing!")
end
```

## What goes where

Extension files starting with `cl_` or `sh_` are sent to and run on the client. Extension starting with `sv_` are run on the server. Extension files starting with anything else are not automatically run.

## Run order

All `sh_` files are run first. Then, all `cl_` or `sv_` files are run based on whether we're a server or client.
