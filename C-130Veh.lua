---------------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------------
local SPAWN_DISTANCE = 15
local VEHICLE_SPACING = 12
local MENU_NAME = "C-130 Vehicles"
local ALLOWED_AIRCRAFT_TYPE = "C-130J-30"

local vehicleTypes = {
    "M1043 HMMWV Armament",
    "M1045 HMMWV TOW",
    "CHAP_MATV",
    "LAV-25",
    "M-2 Bradley",
    "M978 HEMTT Tanker",
    "M1097 Avenger"
}

local playerMenus = {}
local unitSpawnCount = {}

---------------------------------------------------------------------
-- Get point behind aircraft
---------------------------------------------------------------------
local function getPointBehindUnit(unit, distance)
    local pos = unit:getPosition()
    if not pos then return nil end

    local x = pos.p.x - pos.x.z * distance
    local z = pos.p.z - pos.z.z * distance

    return { x = x, z = z }
end

---------------------------------------------------------------------
-- SPAWN VEHICLE (CTLD permission, aircraft-relative)
---------------------------------------------------------------------
local function spawnVehicleForUnit(unit, vehicleType)
    if not unit or not unit:isExist() then return end
    if unit:getTypeName() ~= ALLOWED_AIRCRAFT_TYPE then return end
    if ctld.inAir(unit) then
        trigger.action.outTextForGroup(unit:getGroup():getID(), "Must be on the ground", 5)
        return
    end

    -- 🔒 CTLD permission check
    local inLogistics = ctld.isUnitInALogisticZone(unit:getName()) ~= nil
    local pickup = ctld.inPickupZone(unit)
    local inPickup = pickup and pickup.inZone

    if not inLogistics and not inPickup then
        trigger.action.outTextForGroup(
            unit:getGroup():getID(),
            "You must be near a CTLD logistics or pickup zone",
            5
        )
        return
    end

    -- 📦 Spawn behind aircraft with spacing
    local unitName = unit:getName()
    unitSpawnCount[unitName] = (unitSpawnCount[unitName] or 0) + 1

    local offset = SPAWN_DISTANCE + (unitSpawnCount[unitName] - 1) * VEHICLE_SPACING
    local pt = getPointBehindUnit(unit, offset)
    if not pt then return end

    local groupName = string.format(
        "CTLD_%s_%d",
        vehicleType:gsub("%s+", "_"),
        timer.getTime()
    )

    local newGroup = {
        visible = true,
        lateActivation = false,
        task = "Ground Nothing",
        units = {
            {
                type = vehicleType,
                name = groupName .. "_1",
                x = pt.x,
                y = pt.z,
                heading = 0,
                skill = "Excellent"
            }
        },
        name = groupName
    }

    coalition.addGroup(country.id.USA, Group.Category.GROUND, newGroup)

    trigger.action.outTextForGroup(
        unit:getGroup():getID(),
        "Spawned: " .. vehicleType,
        5
    )
end

---------------------------------------------------------------------
-- F10 MENU
---------------------------------------------------------------------
local function addMenuForUnit(unit)
    if not unit or not unit:isExist() then return end
    if unit:getTypeName() ~= ALLOWED_AIRCRAFT_TYPE then return end

    local unitName = unit:getName()
    if playerMenus[unitName] then return end

    local groupID = unit:getGroup():getID()
    local rootMenu = missionCommands.addSubMenuForGroup(groupID, MENU_NAME)
    playerMenus[unitName] = rootMenu

    for _, v in ipairs(vehicleTypes) do
        missionCommands.addCommandForGroup(
            groupID,
            "Spawn " .. v,
            rootMenu,
            function()
                spawnVehicleForUnit(unit, v)
            end
        )
    end
end

---------------------------------------------------------------------
-- EVENT HANDLER
---------------------------------------------------------------------
world.addEventHandler({
    onEvent = function(_, event)
        if event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then
            if event.initiator and event.initiator:getCategory() == Object.Category.UNIT then
                addMenuForUnit(event.initiator)
            end
        end
    end
})
