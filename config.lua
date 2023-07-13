Config = {}
Config.Settings = {
	CoreObject = "QBCore",
	Triggers = "qb-core"
}

Config.Coords = {
	'vector3(193.28515, -1392.485, 29.315547)',
	'vector3(193.28515, -1392.485, 29.315547)',
	'vector3(193.28515, -1392.485, 29.315547)'
}

Config.Invincible = true -- Is the ped going to be invincible?
Config.Frozen = true -- Is the ped frozen in place?
Config.Stoic = true -- Will the ped react to events around them?
Config.FadeIn = true -- Will the ped fade in and out based on the distance. (Looks a lot better.)
Config.DistanceSpawn = 25.0 -- Distance before spawning/despawning the ped. (GTA Units.)

Config.MinusOne = true -- Leave this enabled if your coordinates grabber does not -1 from the player coords.

Config.GenderNumbers = { -- No reason to touch these.
	['male'] = 4,
	['female'] = 5
}

Config.PedList = {
	{
        model = `s_m_m_lathandy_01`,
        coords = vector4(193.28515, -1392.485, 29.315547, 131.84449),
        gender = 'male', 
		scenario = 'WORLD_HUMAN_CLIPBOARD'
    }
}