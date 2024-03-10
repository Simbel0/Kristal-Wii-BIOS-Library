local Vii, super = Class(ActorSprite)

function Vii:init(actor, data)
    super:init(self, actor)

    self.walk_override = true
    self.frames = {}

    self.data = data

    self.anim = actor.default

    self.parts_offsets = {
        down = {
            hair = {0, 0},
            head = {0, 0},
            body = {0, 0},
            outline = {0, 0},
            stripes = {0, 0},
            hands = {0, 0},
            legs = {0, 0}
        },
        left = {
            hair = {1, 0},
            head = {-2, -1},
            body = {0, 2},
            outline = {0, 1},
            stripes = {0, 3},
            hands = {-0.5, 0},
            legs = {-1, 0}
        },
        right = {
            hair = {1, 0},
            head = {2, -1},
            body = {0, 2},
            outline = {0, 1},
            stripes = {0, 3},
            hands = {0.5, 0},
            legs = {1, 0}
        },
        up = {
            hair = {0, 1},
            head = {0, 0},
            body = {0, 2},
            outline = {0, 0},
            stripes = {0, 3},
            hands = {0, 1},
            legs = {0, 0}
        },
    }

    -- body/walk/1/in/down
    -- body/1/in/walk/down
    -- hair/walk/1/
    self.parts = {
        hair =    Sprite(self.actor.path.."/hair/"..self.data.head.."/"..self.anim.."/down", 8.5, 17),
        head =    Sprite(self.actor.path.."/head/"..self.data.head.."/"..self.anim.."/down", 8.5, 17),
        body =    Sprite(self.actor.path.."/body/"..self.data.body.."/"..self.anim.."/down", 9, 26),
        outline = Sprite(self.actor.path.."/outline/"..self.data.body.."/"..self.anim.."/down", 9, 28),
        stripes = Sprite(self.actor.path.."/stripes/"..self.data.body.."/"..self.anim.."/down", 9, 25),
        hands =   Sprite(self.actor.path.."/hands/"..self.data.body.."/"..self.anim.."/down", 9, 28),
        legs =    Sprite(self.actor.path.."/legs/"..(self.data.legs_left and "left" or "right").."/"..self.anim.."/down", 9, 35)
    }
    self.parts_layer = {
        hair = {
			["down"] = -1,
			["up"] = 1,
			["left"] = -1,
			["right"] = -1
		},
    }
    self:setOrigin(0, 0)

    self.parts.hair:setColor(self.data.hair_color)
    self.parts.head:setColor(self.data.skin_color)
    self.parts.body:setColor(self.data.shirt_color_1)
    self.parts.outline:setColor(self.data.hair_color)
    self.parts.legs:setColor(self.data.hair_color)
    self.parts.hands:setColor(self.data.skin_color)
    self.parts.stripes:setColor(self.data.shirt_color_2)

    local i = 1
    for k,v in pairs(self.parts) do
        if self.parts_layer[k] then
            v:setLayer(self.parts_layer[k]["down"])
        end
        v:setOrigin(0.5, 1)
        i = i + 1
        self:addChild(v)
    end
end

function Vii:setFrame(frame)
    --super.setFrame(self, frame)
    --print(frame)
    if not self.parts then return end
    for part,spr in pairs(self.parts) do
        spr:setFrame(frame)
    end
end

function Vii:updateDirection()
    --print(self.directional, self.facing, self.last_facing)
    if self.facing ~= self.last_facing then
        self.parts["hair"]   :setSprite(self.actor.path.."/hair/"..   self.data.head.."/"..self.anim.."/"..self.facing)
        self.parts["head"]   :setSprite(self.actor.path.."/head/"..   self.data.head.."/"..self.anim.."/"..self.facing)
        self.parts["body"]   :setSprite(self.actor.path.."/body/"..   self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["outline"]:setSprite(self.actor.path.."/outline/"..self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["stripes"]:setSprite(self.actor.path.."/stripes/"..self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["hands"]  :setSprite(self.actor.path.."/hands/"..  self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["legs"]   :setSprite(self.actor.path.."/legs/"..  (self.data.legs_left and "left" or "right").."/"..self.anim.."/"..self.facing)
        for part,spr in pairs(self.parts) do
            spr:setPosition(spr.init_x+self.parts_offsets[self.facing][part][1], spr.init_y+self.parts_offsets[self.facing][part][2])
        end
    end
    self.last_facing = self.facing
end

function Vii:update()
	super.update(self)
    for part,spr in pairs(self.parts) do
		if (part == "hair" or part == "head") and self.parts["body"].frame%2 == 0 then
			spr:setPosition(spr.init_x+self.parts_offsets[self.facing][part][1], spr.init_y+self.parts_offsets[self.facing][part][2]+1)
		else
			spr:setPosition(spr.init_x+self.parts_offsets[self.facing][part][1], spr.init_y+self.parts_offsets[self.facing][part][2])
		end
        if self.parts_layer[part] and self.parts_layer[part][self.facing] then
            spr:setLayer(self.parts_layer[part][self.facing])
        end
    end
end

return Vii