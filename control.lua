local pvp = require("pvp")

pvp.add_remote_interface()

local register_events = function()
  for event_name, handler in pairs (pvp.get_events()) do
    script.on_event(event_name, handler)
  end
  for n, handler in pairs (pvp.on_nth_tick) do
    script.on_nth_tick(n, handler)
  end
end

script.on_init(function()
  pvp.on_init()
  register_events()
end)

script.on_load(function()
  pvp.on_load()
  register_events()
end)

script.on_configuration_changed(function()
  pvp.on_configuration_changed()
end)

script.on_event({defines.events.on_player_mined_entity}, 
    function(event) 
        local player = game.players[event.player_index]
        for item, value in pairs (event.buffer.get_contents()) do
            if event.entity.force.name == 'neutral' then
                player.force.item_production_statistics.on_flow(item, value)
            end
        end
    end
)

script.on_event({defines.events.on_robot_mined_entity}, 
    function(event) 
        for item, value in pairs (event.buffer.get_contents()) do
            if event.entity.force.name == 'neutral' then
                event.robot.force.item_production_statistics.on_flow(item, value)
            end
        end
    end
)