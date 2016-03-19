# Development

This folder contains "extensions." They are individual modules for the gamemode that extend the functionality in some way.

Each extension has a `HOOKS` table made available to it when it is loaded. Declaring a function on the HOOKS table adds a hook for it. For example:
```Lua
function HOOKS:Initialize()
	print("We're initializing!")
end
```
