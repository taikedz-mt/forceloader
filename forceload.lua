-- Naive implementation, taken from rspawn

local forceloading_happening = false

local function forceload_operate(pos1, pos2, handler, transient)
    local i,j,k

    for i=pos1.x,pos2.x,16 do
        for j=pos1.y,pos2.y,16 do
            for k=pos1.z,pos2.z,16 do
                handler({x=i,y=j,z=k}, transient)
            end
        end
    end
end

function forceloader:forceload_blocks_in(pos1, pos2)
    if forceloading_happening then
        forceloader:debug("Forceload operation already underway - abort")
        return false
    end

    forceloader:debug("Forceloading blocks -----------¬", {pos1=minetest.pos_to_string(pos1),pos2=minetest.pos_to_string(pos2)})
    forceloading_happening = true
    minetest.emerge_area(pos1, pos2)
    forceload_operate(pos1, pos2, minetest.forceload_block, true)

    return true
end

function forceloader:forceload_free_blocks_in(pos1, pos2)
    forceloader:debug("Freeing forceloaded blocks ____/", {pos1=minetest.pos_to_string(pos1),pos2=minetest.pos_to_string(pos2)})
    forceload_operate(pos1, pos2, minetest.forceload_free_block, true)
    forceloading_happening = false
end

