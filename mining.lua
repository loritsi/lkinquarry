-- lkin quarry v1.0 --

whitelist = {
    "minecraft:diamond",
    "minecraft:raw_iron",
    "minecraft:raw_gold",
    "minecraft:redstone",
    "create:raw_zinc",
    "minecraft:raw_copper",
    "minecraft:lapis_lazuli",
    "minecraft:emerald"
}

print("Welcome to Quarry")

function askYN(question)
    while true do
        print(question .. " Is this okay? (Y/N)")
        local entry = io.read()
        entry = string.upper(entry)
        if entry == "Y" then
            return true
        elseif entry == "N" then
            return false
        else
            print("I didn't understand your input. Please try again! (Y/N only)")
        end
    end
end


while true do
    turtle.refuel(64)
    fuel = turtle.getFuelLevel()
    print("My fuel level is " .. fuel)
    if fuel < 1 then
        print("Please give me some fuel and then press enter")
        io.read()
    elseif fuel < 1000 then
        print("My fuel is somewhat low. Consider giving me some more fuel, then restart.")
        break
    else
        break
    end
end
 
while true do
    print("How far forward should I go?")
    forward = tonumber(io.read())
    print("How far left should I go?")
    left = tonumber(io.read())
    print("How far down should I go?")
    print("(Leave blank for unlimited)")
    down = tonumber(io.read())
    if not down then
        down = math.huge
    end
    yn = askYN("You want me to dig a " .. forward .. " by " .. left .. " hole that is " .. down .. " blocks deep.")
    if yn == true then
        break
    elseif yn == false then
        print("Okay. Enter it again:")
    else
        error("askYN returned weird output: " .. yn)
    end
end

function returndepth(value)
    for i = 1, value do
        turtle.up()
    end
    error("finished")
end

function check()
    local has_block, data = turtle.inspect()
    if has_block then
        if data.name == "minecraft:bedrock" then
            returndepth(depth)
        end
    else
        return false
    end
end

function checkdown()
    local has_block, data = turtle.inspectDown()
    if has_block then
        if data.name == "minecraft:bedrock" then
            returndepth(depth)
        end
    else
        return false
    end
end

function step()
    check()
    turtle.dig() --digs using item in left hand, NOT digs the left block
    turtle.forward()
end

function stepdown()
    checkdown()
    turtle.digDown()
    depth = depth + 1
    turtle.down()
end

function digline(length)
    for i = 1, length do
        step()
    end
end

function turn()
    if turning == "left" then
        turtle.turnLeft()
        step()
        turtle.turnLeft()
        turning = "right"
    elseif turning == "right" then
        turtle.turnRight()
        step()
        turtle.turnRight()
        turning = "left"
    end
end

function digsquare(length, width)
    turning = direction
    for w = 1, width do
        digline(length - 1)
        if w < width then
            turn()
        end
    end
end

function checkwhitelist(item)
    for i = 1, #whitelist do
        if item == whitelist[i] then
            return true
        end
    end
    return false
end
    

function emptyinv()
    for i = 1, 16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil then
            itemname = item.name
        end
        if checkwhitelist(itemname) == false then
            if itemname == "minecraft:coal" then
                turtle.refuel()
            else
                turtle.drop()
            end
        end
    end
end


depth = 0
direction = "left"
print("Okay. Commencing quarry...")
step()
for d = 1, down do
    digsquare(forward, left)
    emptyinv()
    turtle.turnLeft()
    turtle.turnLeft()
    stepdown()
    if d % 2 == 0 then
        direction = "left"
    else
        direction = "right"
    end
end
returndepth(depth)
