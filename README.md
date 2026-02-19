📄 Full README.md
C-130 Vehicle Deployment Script

CTLD Integrated | DCS World

Overview

This script enables players flying the C-130J-30 to spawn ground vehicles using the F10 radio menu.

Vehicle spawning is:

Restricted to CTLD logistics zones

Restricted to CTLD pickup zones

Restricted to C-130J-30 aircraft only

Restricted to when the aircraft is on the ground

Vehicles spawn behind the aircraft with configurable spacing to prevent overlap.

This script does NOT modify CTLD crate logic and does NOT interfere with normal CTLD operations.

Features

F10 menu added automatically when player enters a C-130J-30

Spawn multiple vehicle types

Automatic spacing between vehicles

Multiplayer compatible

CTLD zone validation

Prevents spawning while airborne

Clean, lightweight implementation

Requirements

DCS World (tested in multiplayer and singleplayer)

CTLD script loaded before this script

⚠ Important:
This script depends on CTLD functions:

ctld.isUnitInALogisticZone

ctld.inPickupZone

ctld.inAir

Ensure CTLD is loaded first in the mission trigger list.

Installation

Add CTLD to your mission (if not already present).

Add this script as a DO SCRIPT FILE trigger.

Ensure this script loads AFTER CTLD.

Done.

How It Works

Player enters a C-130J-30.

F10 menu "C-130 Vehicles" appears.

Player must:

Be on the ground

Be inside a CTLD logistics OR pickup zone

Selecting a vehicle will spawn it behind the aircraft.

Each additional vehicle spawns further back to prevent overlap.

Configuration

At the top of the script:

local SPAWN_DISTANCE = 15       -- Distance behind aircraft for first vehicle
local VEHICLE_SPACING = 12      -- Distance between spawned vehicles
local MENU_NAME = "C-130 Vehicles"
local ALLOWED_AIRCRAFT_TYPE = "C-130J-30"


You can adjust:

Spawn distance

Vehicle spacing

Aircraft type restriction

Menu name

Available vehicle list

Custom Vehicle List

Edit the vehicleTypes table:

local vehicleTypes = {
    "M1043 HMMWV Armament",
    "M1045 HMMWV TOW",
    "CHAP_MATV",
    "LAV-25",
    "M-2 Bradley",
    "M978 HEMTT Tanker",
    "M1097 Avenger"
}


Use valid DCS internal unit type names.

Multiplayer Behavior

Spawn tracking is per aircraft unit.

Each C-130 maintains its own vehicle spacing.

No interference between players.

Limitations

Vehicles always spawn directly behind the aircraft.

Heading is currently fixed to 0.

Vehicles do not auto-despawn.

Does not consume CTLD crates (permission only check).

Optional Improvements (Future Expansion)

Possible additions:

Spawn left/right of ramp

Match vehicle heading to aircraft

Auto-despawn menu

Inventory system

Speed check before spawn

Ramp open requirement

Weight-based spawning

CTLD crate consumption integration

License / Usage

Free to modify and use in missions.
Credit appreciated but not required.
