Scene:reset();

function spawn_mike(position)
    local hash = Scene:add_component({
        name = "Mike Arm",
        id = "@amy/characters/mike_arm",
        version = "0.1.0",
        code = temp_load_string('./scripts/@amy/characters/mike_arm.lua')
    });

    Scene:add_simulon({
        color = Color:hex(0xd4af7b),
        size = 1,
        density = 1,
        position = position,
    });

    local objs = Scene:get_all_objects();

    local head = nil;
    local body = nil;
    for i=1,#objs do
        local obj = objs[i];
        if obj:get_name() == "Simulon Head" then
            head = obj;
        end;
        if obj:get_name() == "Simulon Body Part 1" then
            body = obj;
        end;
    end;

    local eye1 = Scene:add_circle({
        color = Color:hex(0x3b2b1f),
        radius = 0.05,
        position = position + vec2(-0.054, 0.67),
        is_static = false, 
    });
    eye1:temp_set_collides(false);
    eye1:set_density(0.1);

    local eye2 = Scene:add_circle({
        color = Color:hex(0x3b2b1f),
        radius = 0.05,
        position = position + vec2(0.128, 0.67),
        is_static = false,
    });
    eye2:temp_set_collides(false);
    eye2:set_density(0.1);

    local hinge1 = Scene:add_hinge_at_world_point({
        point = position + vec2(-0.054, 0.67),
        object_a = head,
        object_b = eye1,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
    local hinge2 = Scene:add_hinge_at_world_point({
        point = position + vec2(0.128, 0.67),
        object_a = head,
        object_b = eye2,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });

    local capsule1 = Scene:add_capsule({
        color = Color:hex(0x6f6773),
        radius = 0.061,
        position = position,
        local_point_a = vec2(0.172, 0.284),
        local_point_b = vec2(0.59225, 0.284),
        is_static = false,
    });
    local hinge3 = Scene:add_hinge_at_world_point({
        point = position + vec2(0.172, 0.284),
        object_a = body,
        object_b = capsule1,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
    local capsule2 = Scene:add_capsule({
        color = Color:hex(0x584f5c),
        radius = 0.061,
        position = position,
        local_point_a = vec2(0.59225, 0.284),
        local_point_b = vec2(1.0125, 0.284),
        is_static = false,
    });
    local hinge4 = Scene:add_hinge_at_world_point({
        point = position + vec2(0.59225, 0.284),
        object_a = capsule1,
        object_b = capsule2,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
    local polygon1 = Scene:add_polygon({
        color = Color:hex(0x423847),
        radius = 0,
        position = position + vec2(1.0985 - 0.04, 0.284),
        points = {
            vec2(-0.1, 0.08655154019),
            vec2(0.13, 0.08655154019),
            vec2(0.13 + 0.0966, 0.03),
            vec2(0.13 + 0.0966, -0.03),
            vec2(0.13, -0.08655154019),
            vec2(-0.1, -0.08655154019),
        },
        is_static = false,
    });
    local hinge4 = Scene:add_hinge_at_world_point({
        point = position + vec2(1.0125, 0.284),
        object_a = capsule2,
        object_b = polygon1,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
    local end_box = Scene:add_box({
        size = vec2(0.3266, 0.17310308038),
        position = position + vec2(1.3518, 0.284),
        color = Color:hex(0x423847),
        is_static = false,
    });
    end_box:add_component(hash);

    local hinge5 = Scene:add_hinge_at_world_point({
        point = position + vec2(1.27015, 0.284),
        object_a = polygon1,
        object_b = end_box,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
end;

spawn_mike(vec2(0, -9.7));

function generate_polygon_points(n, size)
    local points = {}
    for i = 0, n - 1 do
        local angle = (2 * math.pi / n) * i
        table.insert(points, vec2(size * math.cos(angle), size * math.sin(angle)))
    end
    return points
end

function add_hexagon(table)
    local hexagon_points = generate_polygon_points(6, table.size);

    local radius = table.radius;
    if table.radius == nil then
        radius = 0;
    end;

    return Scene:add_polygon({
        position = table.position,
        points = hexagon_points,
        color = table.color,
        is_static = table.is_static,
        radius = radius,
    });
end;

function add_empire_icon(position, size, color)
    local gap = 0.2 * size;
    local hexagons = {};
    local hex = add_hexagon({
        position = position,
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position - vec2(0, (size * 1.8) + gap),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position + vec2(0, (size * 1.8) + gap),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position + vec2((size + gap) * 1.47, ((size * 1.8) + gap) / 2),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position - vec2((size + gap) * 1.47, ((size * 1.8) + gap) / 2),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position - vec2((size + gap) * 1.47, -((size * 1.8) + gap) / 2),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    local hex = add_hexagon({
        position = position + vec2((size + gap) * 1.47, -((size * 1.8) + gap) / 2),
        size = size,
        color = color,
    });
    table.insert(hexagons, hex);
    return hexagons;
end;

function spawn_moderizer(position)
    Scene:add_simulon({
        color = Color:hex(0xe55f50),
        size = 1,
        density = 1,
        position = position,
    });

    local objs = Scene:get_all_objects();

    local head = nil;
    local body = nil;
    for i=1,#objs do
        local obj = objs[i];
        if (obj.color.r == 229 and obj.color.g == 95 and obj.color.b == 80) and (obj:get_name() == "Simulon Head") then
            head = obj;
        end;
        if (obj.color.r == 229 and obj.color.g == 95 and obj.color.b == 80) and (obj:get_name() == "Simulon Body Part 1") then
            body = obj;
        end;
    end;

    local eye1 = Scene:add_circle({
        color = Color:hex(0x5e2a28),
        radius = 0.053,
        position = position + vec2(-0.102, 0.6707),
        is_static = false, 
    });
    eye1:temp_set_collides(false);
    eye1:set_density(0.1);

    local eye2 = Scene:add_circle({
        color = Color:hex(0x5e2a28),
        radius = 0.053,
        position = position + vec2(0.102, 0.6707),
        is_static = false,
    });
    eye2:temp_set_collides(false);
    eye2:set_density(0.1);

    local hinge1 = Scene:add_hinge_at_world_point({
        point = position + vec2(-0.102, 0.6707),
        object_a = head,
        object_b = eye1,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });
    local hinge2 = Scene:add_hinge_at_world_point({
        point = position + vec2(0.102, 0.6707),
        object_a = head,
        object_b = eye2,
        motor_enabled = true,
        motor_speed = 0, -- radians per second
        max_motor_torque = 1.25, -- maximum torque for the motor, in newton-meters
    });

    local hexagons = add_empire_icon(position + vec2(-0.115, 0.175), 0.032, Color:hex(0x96352b));
    for i=1,#hexagons do
        hexagons[i]:temp_set_collides(false);
        Scene:add_hinge_at_world_point({
            point = hexagons[i]:get_position() + vec2(-0.05, 0),
            object_a = body,
            object_b = hexagons[i],
            motor_enabled = false,
            motor_speed = 0,
            max_motor_torque = 0.02,
        });
        Scene:add_hinge_at_world_point({
            point = hexagons[i]:get_position() + vec2(0.05, 0),
            object_a = body,
            object_b = hexagons[i],
            motor_enabled = false,
            motor_speed = 0,
            max_motor_torque = 0.02,
        });
    end;
    print("did it for " .. tostring(#hexagons) .. " hexagons")
end;

spawn_moderizer(vec2(4, -9.7));

function spawn_emperor(position)
    Scene:add_simulon({
        color = Color:hex(0xe07641),
        size = 1.536,
        density = 1,
        position = position,
    });

    local objs = Scene:get_all_objects();

    local head = nil;
    local body = nil;
    for i=1,#objs do
        local obj = objs[i];
        if (obj.color.r == 224 and obj.color.g == 118 and obj.color.b == 65) and (obj:get_name() == "Simulon Head") then
            head = obj;
        end;
        if (obj.color.r == 224 and obj.color.g == 118 and obj.color.b == 65) and (obj:get_name() == "Simulon Body Part 1") then
            body = obj;
        end;
    end;

    local hexagons = add_empire_icon(head:get_position(), 0.088, Color:hex(0xb85b37));
    for i=1,#hexagons do
        hexagons[i]:temp_set_collides(false);
        hexagons[i]:set_density(0.1);
        Scene:add_hinge_at_world_point({
            point = hexagons[i]:get_position() + vec2(-0.05, 0),
            object_a = head,
            object_b = hexagons[i],
            motor_enabled = false,
            motor_speed = 0,
            max_motor_torque = 0.02,
        });
        Scene:add_hinge_at_world_point({
            point = hexagons[i]:get_position() + vec2(0.05, 0),
            object_a = head,
            object_b = hexagons[i],
            motor_enabled = false,
            motor_speed = 0,
            max_motor_torque = 0.02,
        });
    end;
    print("did it for " .. tostring(#hexagons) .. " hexagons");
end;

spawn_emperor(vec2(6, -10.9));

function climbable_generator(position, height)
    local block_height = 0.5;
    local y = position.y;
    local colors = {
        Color:hex(0xa0a0a0),
        Color:hex(0xc0c0c0),
    };
    local light_number = 0;
    local light_colors = {
        Color:hex(0xff8080),
        Color:hex(0x80ff80),
        Color:hex(0x8080ff),
    }

    for i=1,height do
        Scene:add_box({
            position = vec2(position.x, y),
            size = vec2(0.1, block_height),
            is_static = true,
            color = colors[(i % 2) + 1]
        });
        if i % 25 == 0 then 
            Scene:add_box({
                position = vec2(position.x - 10, y),
                size = vec2(0.1, block_height),
                is_static = true,
                color = light_colors[(light_number % 3) + 1],
                name = "Light"
            });
            light_number += 1;
        end;
        y += block_height;
    end;
end;

climbable_generator(vec2(80, -9), 100);

--[[
local weapon_item = Scene:add_box({
    position = vec2(44, 0.5) / 2,
    size = vec2(0.7, 0.1),
    color = 0xffffff,
    is_static = false,
    name = "Weapon 1"
});]]
--[[
local detacher = Scene:add_polygon({
    points = {
        [1] = vec2(-2, 0),
        [2] = vec2(2, 0.5),
        [3] = vec2(2, -0.5),
    },
    color = 0x000000,
    is_static = false,
    position = vec2(10, 0),
});
local hash = Scene:add_component({
    name = "detacher",
    id = "@amy/characters/detacher",
    version = "0.1.0",
    code = temp_load_string('./scripts/@amy/characters/detacher.lua')
});

detacher:add_component(hash);

local attacher = Scene:add_polygon({
    points = {
        [1] = vec2(-2, 0),
        [2] = vec2(2, 0.5),
        [3] = vec2(2, -0.5),
    },
    color = 0xffffff,
    is_static = false,
    position = vec2(20, 0),
});
local hash = Scene:add_component({
    name = "attacher",
    id = "@amy/characters/attacher",
    version = "0.1.0",
    code = temp_load_string('./scripts/@amy/characters/attacher.lua')
});

attacher:add_component(hash);]]

-- hiiii

--[[
local image = temp_load_image('./scripts/@amy/characters/weapon.png');

local pixel_size = 1 / 12;
local half_width = (image.width / 2) * pixel_size;
local half_height = (image.height / 2) * pixel_size;

local base = Scene:add_circle({
    position = vec2(0, 0),
    radius = pixel_size,
    is_static = false,
    color = Color:rgba(0, 0, 0, 0),
});

for x=0,(image.width - 1) do
    for y=0,(image.height - 1) do
        local pixel = image:get_pixel(vec2(x, y));

        if pixel.a > 0 then
            local box = Scene:add_box({
                position = vec2((x * pixel_size) - half_width + (pixel_size * 0.5), -(y * pixel_size) + half_height - (pixel_size * 0.5)),
                size = vec2(pixel_size, pixel_size),
                is_static = false,
                color = Color:rgba(pixel.r, pixel.g, pixel.b, pixel.a),
                name = "Pixel"
            });

            box:bolt_to(base);
        end;
    end;
end;]]
--[[
local cannibal = Scene:add_simulon({
    color = 0x8e8371,
    size = 1,
    density = 1,
    position = vec2(-10, 0),
});

local objs = Scene:get_all_objects();

local head = nil;
for i=1,#objs do
    local obj = objs[i];
    if (obj:get_name() == "Simulon Head") and (obj.color.r == 142) and (obj.color.g == 131) and (obj.color.b == 113) then
        head = obj;
    end;
end;
local hash = Scene:add_component({
    name = "cannibal",
    id = "@amy/characters/cannibal",
    version = "0.1.0",
    code = temp_load_string('./scripts/@amy/characters/cannibal.lua')
});

head:add_component(hash);]]

local hammer_1 = Scene:add_box({
    position = vec2(30, 0),
    size = vec2(3, 0.15),
    is_static = false,
    color = 0x98684f,
    name = "hammer_1"
});

local hammer_2 = Scene:add_box({
    position = vec2(31.5, 0),
    size = vec2(0.5, 1),
    is_static = false,
    color = 0xb6abbd,
    name = "hammer_2"
});

hammer_2:bolt_to(hammer_1);

local hash = Scene:add_component({
    name = "hammer",
    id = "@amy/characters/hammer",
    version = "0.1.0",
    code = temp_load_string('./scripts/@amy/characters/hammer.lua')
});

hammer_2:add_component(hash);

--[[
local nuke = Scene:add_box({
    color = 0x565d44,
    position = vec2(40, 0),
    size = vec2(2, 0.9),
    is_static = false,
});

local hash = Scene:add_component({
    name = "nuke",
    id = "@amy/characters/nuke",
    version = "0.1.0",
    code = temp_load_string('./scripts/@amy/characters/nuke.lua')
});

nuke:add_component(hash);]]

local spawn_pylon = require('./scripts/@amy/pylon/spawn.lua');

spawn_pylon(vec2(-2, 0));