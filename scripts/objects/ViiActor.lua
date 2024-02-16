local Vii, super = Class(ActorSprite)

function Vii:init(actor, data)
    super:init(self, actor)

    self.walk_override = true
    self.frames = {}

    self.data = data

    self.parts_offsets = {
        down = {
            hair = {0, 0},
            head = {0, 0},
            body_in = {0, 0},
            body_out = {0, 0},
            stripes = {0, 0},
            hands = {0, 0},
            legs = {0, 0}
        },
        left = {
            hair = {1, 0},
            head = {-2, -1},
            body_in = {0, 2},
            body_out = {0, 1},
            stripes = {0, 3},
            hands = {-0.5, 0},
            legs = {-1, 0}
        },
        right = {
            hair = {1, 0},
            head = {2, -1},
            body_in = {0, 2},
            body_out = {0, 1},
            stripes = {0, 3},
            hands = {0.5, 0},
            legs = {1, 0}
        },
        up = {
            hair = {0, 1},
            head = {0, 0},
            body_in = {0, 2},
            body_out = {0, 0},
            stripes = {0, 3},
            hands = {0, 1},
            legs = {0, 0}
        },
    }

    self.parts = {
        hair = Sprite("vii/hair/"..self.data.head.."/down", 8.5, 17),
        head = Sprite("vii/head/"..self.data.head.."/down", 8.5, 17),
        body_in = Sprite("vii/body/"..self.data.body.."/in/walk/down", 9, 26),
        body_out = Sprite("vii/body/"..self.data.body.."/out/walk/down", 9, 28),
        stripes = Sprite("vii/stripes/"..self.data.body.."/down", 9, 25),
        hands = Sprite("vii/hands/"..self.data.body.."/down", 9, 28),
        legs = Sprite("vii/legs/"..(self.data.legs_left and "left" or "right").."/down", 9, 35)
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
    self.parts.body_in:setColor(self.data.shirt_color_1)
    self.parts.body_out:setColor(self.data.hair_color)
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
        self.parts["hair"]:setSprite("vii/hair/"..self.data.head.."/"..self.facing)
        self.parts["head"]:setSprite("vii/head/"..self.data.head.."/"..self.facing)
        self.parts["body_in"]:setSprite("vii/body/"..self.data.body.."/in/walk/"..self.facing)
        self.parts["body_out"]:setSprite("vii/body/"..self.data.body.."/out/walk/"..self.facing)
        self.parts["stripes"]:setSprite("vii/stripes/"..self.data.body.."/"..self.facing)
        self.parts["hands"]:setSprite("vii/hands/"..self.data.body.."/"..self.facing)
        self.parts["legs"]:setSprite("vii/legs/"..(self.data.legs_left and "left" or "right").."/"..self.facing)
        for part,spr in pairs(self.parts) do
            spr:setPosition(spr.init_x+self.parts_offsets[self.facing][part][1], spr.init_y+self.parts_offsets[self.facing][part][2])
        end
    end
    self.last_facing = self.facing
end

function Vii:update()
	super.update(self)
    for part,spr in pairs(self.parts) do
		if (part == "hair" or part == "head") and self.parts["body_in"].frame%2 == 0 then
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