local BRICK_ITEMS = {
    ["mcl_core:brick"] = true,
    ["mcl_nether:netherbrick"] = true,
    ["default:clay_brick"] = true,
}

local BREAKABLE_GLASS = {
    ["default:glass"] = true,


    ["mcl_amethyst:tinted_glass"] = true,

    ["mcl_core:glass"] = true,
    ["mcl_core:glass_black"] = true,
    ["mcl_core:glass_blue"] = true,
    ["mcl_core:glass_brown"] = true,
    ["mcl_core:glass_cyan"] = true,
    ["mcl_core:glass_gray"] = true,
    ["mcl_core:glass_green"] = true,
    ["mcl_core:glass_light_blue"] = true,
    ["mcl_core:glass_light_gray"] = true,
    ["mcl_core:glass_light_green"] = true,
    ["mcl_core:glass_lime"] = true,
    ["mcl_core:glass_magenta"] = true,
    ["mcl_core:glass_orange"] = true,
    ["mcl_core:glass_pink"] = true,
    ["mcl_core:glass_purple"] = true,
    ["mcl_core:glass_red"] = true,
    ["mcl_core:glass_silver"] = true,
    ["mcl_core:glass_white"] = true,
    ["mcl_core:glass_yellow"] = true,

    ["xpanes:pane_flat"] = true,
    ["xpanes:pane"] = true,
    ["xpanes:pane_natural"] = true,
    ["xpanes:pane_natural_flat"] = true,
    ["xpanes:pane_red"] = true,
    ["xpanes:pane_red_flat"] = true,
    ["xpanes:pane_blue"] = true,
    ["xpanes:pane_blue_flat"] = true,
    ["xpanes:pane_green"] = true,
    ["xpanes:pane_green_flat"] = true,
    ["xpanes:pane_yellow"] = true,
    ["xpanes:pane_yellow_flat"] = true,
    ["xpanes:pane_orange"] = true,
    ["xpanes:pane_orange_flat"] = true,
    ["xpanes:pane_purple"] = true,
    ["xpanes:pane_purple_flat"] = true,
    ["xpanes:pane_black"] = true,
    ["xpanes:pane_black_flat"] = true,
    ["xpanes:pane_brown"] = true,
    ["xpanes:pane_brown_flat"] = true,
    ["xpanes:pane_cyan"] = true,
    ["xpanes:pane_cyan_flat"] = true,
    ["xpanes:pane_magenta"] = true,
    ["xpanes:pane_magenta_flat"] = true,
    ["xpanes:pane_white"] = true,
    ["xpanes:pane_white_flat"] = true,
    ["xpanes:pane_light_blue"] = true,
    ["xpanes:pane_light_blue_flat"] = true,
    ["xpanes:pane_light_gray"] = true,
    ["xpanes:pane_light_gray_flat"] = true,
    ["xpanes:pane_light_green"] = true,
    ["xpanes:pane_light_green_flat"] = true,
    ["xpanes:pane_lime"] = true,
    ["xpanes:pane_lime_flat"] = true,
    ["xpanes:pane_silver"] = true,
    ["xpanes:pane_silver_flat"] = true,

    ["mcl_panes:pane_natural"] = true,
    ["mcl_panes:pane_natural_flat"] = true,
    ["mcl_panes:pane_red"] = true,
    ["mcl_panes:pane_red_flat"] = true,
    ["mcl_panes:pane_blue"] = true,
    ["mcl_panes:pane_blue_flat"] = true,
    ["mcl_panes:pane_green"] = true,
    ["mcl_panes:pane_green_flat"] = true,
    ["mcl_panes:pane_yellow"] = true,
    ["mcl_panes:pane_yellow_flat"] = true,
    ["mcl_panes:pane_orange"] = true,
    ["mcl_panes:pane_orange_flat"] = true,
    ["mcl_panes:pane_purple"] = true,
    ["mcl_panes:pane_purple_flat"] = true,
    ["mcl_panes:pane_black"] = true,
    ["mcl_panes:pane_black_flat"] = true,
    ["mcl_panes:pane_brown"] = true,
    ["mcl_panes:pane_brown_flat"] = true,
    ["mcl_panes:pane_cyan"] = true,
    ["mcl_panes:pane_cyan_flat"] = true,
    ["mcl_panes:pane_magenta"] = true,
    ["mcl_panes:pane_magenta_flat"] = true,
    ["mcl_panes:pane_white"] = true,
    ["mcl_panes:pane_white_flat"] = true,
    ["mcl_panes:pane_light_blue"] = true,
    ["mcl_panes:pane_light_blue_flat"] = true,
    ["mcl_panes:pane_light_gray"] = true,
    ["mcl_panes:pane_light_gray_flat"] = true,
    ["mcl_panes:pane_light_green"] = true,
    ["mcl_panes:pane_light_green_flat"] = true,
    ["mcl_panes:pane_lime"] = true,
    ["mcl_panes:pane_lime_flat"] = true,
}

local ENTITY_NAME = "brick_to_window:thrown_brick"
local GRAVITY = {x = 0, y = -9.8, z = 0}
local THROW_SPEED = 15
local LIFETIME = 5

minetest.register_entity(ENTITY_NAME, {
    initial_properties = {
        physical = false,
        collide_with_objects = false,
        pointable = false,
        collisionbox = {0, 0, 0, 0, 0, 0},
        visual = "wielditem",
        visual_size = {x = 0.3, y = 0.3},
        textures = {"air"},
    },

    velocity = nil,
    timer = 0,
    brick_item = nil,

    on_activate = function(self, staticdata)
        self.timer = 0
        if staticdata and staticdata ~= "" then
            local data = minetest.deserialize(staticdata)
            if data and data.brick_item then
                self.brick_item = data.brick_item
                self.object:set_properties({
                    textures = {self.brick_item}
                })
            end
        end
    end,

    get_staticdata = function(self)
        return minetest.serialize({
            brick_item = self.brick_item,
        })
    end,

    set_velocity = function(self, vel)
        self.velocity = vel
    end,

    on_step = function(self, dtime)
        local pos = self.object:get_pos()
        if not self.velocity or not pos then return end

        self.timer = self.timer + dtime
        local next_pos = vector.add(pos, vector.multiply(self.velocity, dtime))

        local ray = minetest.raycast(pos, next_pos, true, false)
        for pointed in ray do
            if pointed.type == "node" then
                local node = minetest.get_node(pointed.under)
                if BREAKABLE_GLASS[node.name] then
                    minetest.set_node(pointed.under, {name = "air"})
                end
                minetest.add_item(pointed.under, self.brick_item or "mcl_core:brick")
                self.object:remove()
                return
            end
        end

        self.velocity = vector.add(self.velocity, vector.multiply(GRAVITY, dtime))
        self.object:set_pos(next_pos)

        if self.timer > LIFETIME then
            minetest.add_item(pos, self.brick_item or "mcl_core:brick")
            self.object:remove()
        end
    end,
})

minetest.register_on_punchnode(function(pos, node, puncher)
    if not puncher or not puncher:is_player() then return end

    local item = puncher:get_wielded_item()
    local item_name = item:get_name()

    if not BRICK_ITEMS[item_name] then return end

    local dir = puncher:get_look_dir()
    local start_pos = vector.add(puncher:get_pos(), {x = 0, y = 1.5, z = 0})
    local entity = minetest.add_entity(start_pos, ENTITY_NAME)

    if entity then
        local luaentity = entity:get_luaentity()
        if luaentity then
            luaentity:set_velocity(vector.multiply(dir, THROW_SPEED))
            luaentity.brick_item = item_name
            entity:set_properties({ textures = {item_name} })

            item:take_item()
            puncher:set_wielded_item(item)
        end
    end
end)
