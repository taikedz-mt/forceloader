# Forceload Library Implementation

## Wrappers

We should override the forceload API. This allows us to intercept forceloads from other mods that didn't register a dependency on this mod

```lua
local real_forceload_blocks = minetest.forceload_blocks

local function our_forceload_blocks(pos, transient)
    ...
    real_forceload_blocks(pos, transient)
    ...
end
```

## Transient/non-transient

We should keep a table of non-transient forceloads that do not get de-registered by the automatic management.

The sum of transient and non-transient blocks must be less than or equal to the max number of blocks

Question: how to retrieve the positions of non-transient blocks that were loaded after server reboot? The `forceloaded.txt` file does not store positions but integers.

## Optional behaviours

By default, the library should behave as close to possible as original API: calling forceload defaults to running parallel operations, and does not queue commands.

An extra setting `forceload.always_queue` can be implemented to overide this behaviour at the user's discretion. This might break mods that don't expect the behaviour, but being able to turn the feature on or off can help in debugging.

## Auto unload

Automatically unloading can happen in two ways:

* a forceload is called and the sum of blocks is maxxed out (pop front)
* a forceload/free has been called on timer (pop middle)

Since we have a concept of a front and back, we need to keep these ordered.

Popping an arbitrary number and re-indexing the queue will pop the wrong one if one times out soon after the other

We might need to implement a queuing data type for this, or a pair of tables:

* table1 is a set of positions that have been forceloaded
* table2 is a map of `index -> pos` which is ordered in order of creation

Manipulating these tables then needs to be done via a queue API so two operations don't try to manage the table simultaneously

* table3 is an ordered list of operations on the table pair, with an API to add operations (which themselves can add or remove forceloads, with a priority of unloading first)
