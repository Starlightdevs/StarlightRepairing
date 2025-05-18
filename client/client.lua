local lib = exports.ox_lib
local messages = {
    "You have punched your engine.",
    "You screamed at the engine and it responded.",
    "You gave your car a pep talk.",
    "You gently insulted your vehicle's mother.",
    "You threatened to sell the car."
}

local repairCounts = {}

RegisterCommand("repair", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if vehicle == 0 then
        lib:notify({
            title = "Repair",
            description = "You are not in a vehicle.",
            type = "error"
        })
        return
    end

    local engineHealth = GetVehicleEngineHealth(vehicle)

    if engineHealth >= 650.0 then
        lib:notify({
            title = "Repair",
            description = "Your car doesn't need repairing.",
            type = "inform"
        })
        return
    end

    local vehicleNetId = VehToNet(vehicle)
    repairCounts[vehicleNetId] = repairCounts[vehicleNetId] or 0

    if repairCounts[vehicleNetId] >= 2 then
        lib:notify({
            title = "Repair",
            description = "This car can no longer be repaired.",
            type = "error"
        })
        return
    end

    SetVehicleEngineHealth(vehicle, math.min(engineHealth + 150.0, 1000.0))
    repairCounts[vehicleNetId] = repairCounts[vehicleNetId] + 1

    lib:notify({
        title = "Repair",
        description = messages[math.random(#messages)],
        type = "success"
    })
end, false)
