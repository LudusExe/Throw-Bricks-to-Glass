local brick_item = "mcl_core:brick"
local glass_node = "mcl_core:glass"

minetest.register_entity("brick_to_window:thrown_brick", {
    initial_properties = {
        physical = false,
        collide_with_objects = false,
        pointable = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        visual = "wielditem",
        visual_size = {x = 0.3, y = 0.3},
        textures = {brick_item},
        velocity = 15,
    },

    velocity = nil,
    acceleration = {x = 0, y = -9.8, z = 0},
    timer = 0,

    on_activate = function(self)
        self.timer = 0
    end,

    on_step = function(self, dtime)
        self.timer = self.timer + dtime
        local pos = self.object:get_pos()
        if not self.velocity then return end

        -- Calcola la prossima posizione
        local next_pos = vector.add(pos, vector.multiply(self.velocity, dtime))

        -- Raycast tra posizione attuale e futura
        local ray = minetest.raycast(pos, next_pos, true, false)
        for pointed in ray do
            if pointed.type == "node" then
                local node = minetest.get_node(pointed.under)
                if node.name == glass_node then
                    -- Rompe il vetro
                    minetest.set_node(pointed.under, {name = "air"})
                end
                -- In ogni caso, droppa il mattone
                minetest.add_item(pointed.under, brick_item)
                self.object:remove()
                return
            end
        end

        -- Movimento manuale
        self.velocity = vector.add(self.velocity, vector.multiply(self.acceleration, dtime))
        self.object:set_pos(next_pos)

        -- Timeout: droppa il mattone anche se non ha colpito nulla
        if self.timer > 5 then
            minetest.add_item(self.object:get_pos(), brick_item)
            self.object:remove()
        end
    end,

    set_velocity = function(self, vel)
        self.velocity = vel
    end,
})

-- Lancio del mattone con clic sinistro
minetest.register_on_punchnode(function(_, _, puncher)
    if not puncher then return end

    local item = puncher:get_wielded_item()
    if item:get_name() ~= brick_item then return end

    local dir = puncher:get_look_dir()
    local pos = vector.add(puncher:get_pos(), {x = 0, y = 1.5, z = 0})
    local obj = minetest.add_entity(pos, "brick_to_window:thrown_brick")

    if obj then
        obj:get_luaentity():set_velocity(vector.multiply(dir, 15))
        item:take_item()
        puncher:set_wielded_item(item)
    end
end)
