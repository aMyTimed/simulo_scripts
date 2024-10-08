function explosion(point)
    local hash = Scene:add_component({
        code = temp_load_string('./scripts/@amy/characters/explosion.lua')
    });
    local c = Scene:add_circle({
        position = point,
        radius = 0.2,
        color = 0xffffff,
        name = "Light",
        is_static = true;
    });
    c:temp_set_collides(false);
    c:add_component(hash);
end;

function on_collision_start(data)
    if data.other:get_name() ~= "Simulo Planet" then
        for i=1,#data.points do
            explosion(data.points[i]);
        end;
    end;
end;