Config = {}

Config.ForceFirstPerson = true

Config.SpawnModels = true 

Config.NpcModels = {
    AimLab = {
        coords = vector4(-773.4182, 5597.7002, 32.6056, 190.4835), 
        model = "ig_cletus",
        -- animation = {dict = "combat@aim_variations@arrest", name = "cop_med_arrest_01"},
        -- giveweapon = "WEAPON_CARBINERIFLE",
    },
    
}
Config.InteractEnabled = true

Config.NpcInteracts = {
    [1] = {
        coords = vector3(-773.4182, 5597.7002, 32.6056),
        interact_key = 38,
        interact_distance = 1.5,
        label = "Press ~r~E~s~ to go to the ~p~working in hunting",
        event = "central"
    },
}

Config.NeedKnife = true 
Config.WeaponNedKnife = "WEAPON_KNIFE"

Config.ItemsWork = {
    animal_bait = "animal_bait",
}

Config.SpawnAnimals = {
    vector4(-1214.8994, 4457.9590, 30.5692, 264.8363),
    vector4(-1043.5264, 4367.2017, 11.8497, 247.0736),
    vector4(-408.1453, 4371.0142, 53.9167, 274.1182),
    vector4(-751.8250, 5099.8218, 140.2109, 51.4977),
    vector4(-547.4174, 5205.6265, 83.6449, 43.9838),
    vector4(-480.6432, 5557.8384, 73.2676, 357.9544),
}

Config.Animals = {
    "a_c_deer", 
}

Config.AnimalsItems = {
    ["a_c_deer"] = {
        items = {
            {item_name = "animal_meat", item_count = math.random(1, 5), chance= 90},
            {item_name = "animal_leather", item_count = math.random(1, 2), chance= 40},
        }
    },
}