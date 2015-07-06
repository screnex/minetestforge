--[[ Minetest Forge v4.0.1 Dev-Ed for InfinityCraft - Tool Lib ]]--

function ForgeV4.addMaterial(punch_interval, drop_level, damage, speed_pick, speed_axe, speed_shovel, speed_shears, speed_sword, level, durability)
	local material = {
		full_punch_interval = punch_interval,
		max_drop_level = drop_level,
		damage = damage,
		speed_pick = speed_pick,
		speed_shovel = speed_shovel,
		speed_sword = speed_sword,
		speed_axe = speed_axe,
		level = level,
		uses = durability
	}
	return material
end

function ForgeV4.addShovel(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image.."^[transformR90",
		tool_capabilities = {
			full_punch_interval = material.full_punch_interval,
			max_drop_level = material.max_drop_level,
			damage_groups = {fleshy = material.damage + 1},
			groupcaps = {
				tool_shovel = {times = material.speed_shovel, uses = material.uses, maxlevel = material.level},
				crumbly = {times = material.speed_shovel, uses = material.uses, maxlevel = material.level},
			}
		}
	})
end

function ForgeV4.addPickaxe(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image,
		tool_capabilities = {
			full_punch_interval = material.full_punch_interval,
			max_drop_level = material.max_drop_level,
			damage_groups = {fleshy = material.damage + 2},
			groupcaps = {
				tool_pickaxe = {times = material.speed_pick, uses = material.uses, maxlevel = material.level},
				cracky = {times = material.speed_pick, uses = material.uses, maxlevel = material.level},
			}
		}
	})
end

function ForgeV4.addAxe(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image,
		tool_capabilities = {
			full_punch_interval = material.full_punch_interval,
			max_drop_level = material.max_drop_level,
			damage_groups = {fleshy = material.damage + 3},
			groupcaps = {
				tool_axe = {times = material.speed_axe, uses = material.uses, maxlevel = material.level},
				choppy = {times = material.speed_axe, uses = material.uses, maxlevel = material.level},
			}
		}
	})
end

function ForgeV4.addSword(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image,
		tool_capabilities = {
			full_punch_interval = material.full_punch_interval,
			max_drop_level = material.max_drop_level,
			damage_groups = {fleshy = material.damage + 4},
			groupcaps = {
				tool_sword = {times = material.speed_sword, uses = material.uses, maxlevel = material.level},
				snappy = {times = material.speed_sword, uses = material.uses, maxlevel = material.level},
			}
		}
	})
end

function ForgeV4.addShears(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image,
		tool_capabilities = {
			full_punch_interval = material.full_punch_interval,
			max_drop_level = material.max_drop_level,
			damage_groups = {fleshy = material.damage + 3},
			groupcaps = {
				tool_shears = {times = material.speed_shears, uses = material.uses, maxlevel = material.level},
			}
		}
	})
end

function ForgeV4.addHoe(material, name, id, image)
	minetest.register_tool(id, {
		description = name,
		inventory_image = image,
		wield_image = image,
		on_use = function(itemstack, user, pointed_thing)
			return ForgeV4.useHoe(itemstack, user, pointed_thing, material.uses)
		end
	})
end

function ForgeV4.useHoe(stack, user, pt, durability)
	if not pt then return end
	if pt.type ~= "node" then return end
	local under = minetest.get_node(pt.under)
	local above = minetest.get_node({x = pt.under.x, y = pt.under.y+1, z = pt.under.z})
	local regN = minetest.registered_nodes
	if not regN[under] then return end
	if not regN[above] then return end
	if above.name ~= "air" then return end
	if minetest.get_item_group(under.name, "soil") ~= 1 then return end
	if regN[under.name].soil == nil or regN[under.name].soil.wet == nil or regN[under.name].soil.dry == nil then return end
	minetest.set_node(pt.under, {name = regN[under.name].soil.dry})
	minetest.sound_play("digCrumbly", {pos = pt.under, gain = 0.5})
	if not minetest.setting_getbool("creative_mode") then stack:add_wear(65535/(durability - 1)) end
	return stack
end
