    exports["qb-target"]:AddCircleZone("gh-electrician", vector3(193.28515, -1392.485, 29.315547), 2.0,
        {
            name = "gh-electrician",
            debugPoly = false,
            useZ = true
        },
        {
            options = {
                {
                    event = "gh-electrician:client:startjobs",
                    icon = "fas fa-clock",
                    label = "Toggle Electrician Job",
                    job = "all",
                },
            },
            distance = 1.5
        }
    )

exports["qb-target"]:AddCircleZone("fix1", vector3(-655.2207, -2364.063, 13.779356), 2.0,
    {
        name = "fix1",
        debugPoly = false,
        useZ = true
    },
    {
        options = {
            {
                event = "gh-electrician:client:fixPower",
                icon = "fas fa-clock",
                label = "Fix Ruined Power",
                job = "all",
            },
        },
        distance = 1.5
    }
)

exports["qb-target"]:AddCircleZone("fix2", vector3(-1110.571, -759.502, 18.478544), 2.0,
    {
        name = "fix2",
        debugPoly = false,
        useZ = true
    },
    {
        options = {
            {
                event = "gh-electrician:client:fixPower2",
                icon = "fas fa-clock",
                label = "Fix Ruined Power",
                job = "all",
            },
        },
        distance = 1.5
    }
)

exports["qb-target"]:AddCircleZone("fix3", vector3(1146.9346, -414.1597, 67.322448), 2.0,
    {
        name = "fix3",
        debugPoly = false,
        useZ = true
    },
    {
        options = {
            {
                event = "gh-electrician:client:fixPower3",
                icon = "fas fa-clock",
                label = "Fix Ruined Power",
                job = "all",
            },
        },
        distance = 1.5
    }
)

exports["qb-target"]:AddCircleZone("fix4", vector3(1191.3104, 2656.7163, 37.597339), 2.0,
    {
        name = "fix4",
        debugPoly = false,
        useZ = true
    },
    {
        options = {
            {
                event = "gh-electrician:client:fixPower4",
                icon = "fas fa-clock",
                label = "Fix Ruined Power",
                job = "all",
            },
        },
        distance = 1.5
    }
)

exports["qb-target"]:AddCircleZone("fix5", vector3(-3241.934, 1012.8008, 12.152571), 2.0,
    {
        name = "fix5",
        debugPoly = false,
        useZ = true
    },
    {
        options = {
            {
                event = "gh-electrician:client:fixPower5",
                icon = "fas fa-clock",
                label = "Fix Ruined Power",
                job = "all",
            },
        },
        distance = 1.5
    }
)