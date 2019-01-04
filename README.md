# Minetest Forceloader Library

Library for managing forceloads.

Goal is to get this added to `minetest/builtin` so that all mods can benefit from the management, and encourage mod makers to write with the mod in mind.

## Features still to implement

* Manage forceloads in line with maximum forceload cap
* Optionally pair with map generation
* Automatically free earliest forceloaded block registered
* Pass position coordinates to forceload/free whole areas
* Optionally prevent simultaneous forceload operations
* Optionally queue forceload operations
* Timer-based unloading
