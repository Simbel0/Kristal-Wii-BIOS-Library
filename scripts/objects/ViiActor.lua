local Vii, super = Class(ActorSprite)

function Vii:init(actor, data)
    super:init(self, actor)

    self.walk_override = true

    self.custom_walk_override = false -- don't ask

    self.frames = {}

    self.data = data

    self.anim = actor.default

    self.fps = 4

    self.parts_offsets = {
        walk = {
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
            }
        }
    }
    if self.actor.offsets then
        Utils.merge(self.parts_offsets, self.actor.offsets, true)
    end

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
    
    for part, sprite in pairs(self.parts) do
        if not sprite then
            print("Error: Failed to initialize sprite for part:", part)
        end
    end
    
    self.parts_layer = {
        walk = {
            hair = {
    			["down"] = -1,
    			["up"] = 1,
    			["left"] = -1,
    			["right"] = -1
    		},
        }
    }
    if self.actor.parts_layers then
        Utils.merge(self.parts_layers, self.actor.parts_layers, true)
    end

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

    self.ready = 1

end

function Vii:setFrame(frame)
    --super.setFrame(self, frame)
    --print(frame)
    if not self.parts then return end
    for part,spr in pairs(self.parts) do
        spr:setFrame(frame)
    end
end

function Vii:_set(sprite)
    self.anim = sprite
    if self:isDirectional(sprite) then
        self.custom_walk_override = true
        print("walkoveride true")
    elseif not self:isDirectional(sprite) then
        self.custom_walk_override = false
        print("walkoveride is false")
    end
end

function Vii:setAnimation(sprite)
    self:_set(sprite)
end

function Vii:setSprite(sprite)
    self:_set(sprite)
end

-- Uhhh???
function Vii:isDirectional(texture)
    if self.ready == 1 then
        local valid = false
        local sep = nil
        for part, spr in pairs(self.parts) do
            local path = self.actor.path.."/"..part.."/"..self.data.head.."/"
            if not Assets.getTexture(path..texture) and not Assets.getFrames(path..texture) then
                if Assets.getTexture(path..texture.."_left") or Assets.getFrames(path..texture.."_left") then
                    if sep ~= nil and sep ~= "_" then
                        return false
                    end
                    sep = "_" 
                elseif Assets.getTexture(path..texture.."/left") or Assets.getFrames(path..texture.."/left") then
                    if sep ~= nil and sep ~= "/" then
                        return false
                    end
                    sep = "/"
                end
            end
        end
        return true, sep
    end
end

--Game.world.player.sprite:setAnimation("battle/idle")
function Vii:updateDirection()
    --print(self.directional, self.facing, self.last_facing)
    if self.custom_walk_override == true then

    elseif self.custom_walk_override == false and self.facing ~= self.last_facing then
        self.parts["hair"]   :setSprite(self.actor.path.."/hair/"..   self.data.head.."/"..self.anim.."/"..self.facing)
        self.parts["head"]   :setSprite(self.actor.path.."/head/"..   self.data.head.."/"..self.anim.."/"..self.facing)
        self.parts["body"]   :setSprite(self.actor.path.."/body/"..   self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["outline"]:setSprite(self.actor.path.."/outline/"..self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["stripes"]:setSprite(self.actor.path.."/stripes/"..self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["hands"]  :setSprite(self.actor.path.."/hands/"..  self.data.body.."/"..self.anim.."/"..self.facing)
        self.parts["legs"]   :setSprite(self.actor.path.."/legs/"..(self.data.legs_left and "left" or "right").."/"..self.anim.."/"..self.facing)
        for part,spr in pairs(self.parts) do
            spr:setPosition(spr.init_x+self.parts_offsets[self.anim][self.facing][part][1], spr.init_y+self.parts_offsets[self.anim][self.facing][part][2])
        end
        self.last_anim = self.anim
        self.last_facing = self.facing
    end
end

function Vii:update()
	super.update(self)
    if self.custom_walk_override == true then 
        if self.anim ~= self.last_anim then
            self.parts["hair"]   :setSprite(self.actor.path.."/hair/"..   self.data.head.."/"..self.anim)
            self.parts["head"]   :setSprite(self.actor.path.."/head/"..   self.data.head.."/"..self.anim)
            self.parts["body"]   :setSprite(self.actor.path.."/body/"..   self.data.body.."/"..self.anim)
            self.parts["outline"]:setSprite(self.actor.path.."/outline/"..self.data.body.."/"..self.anim)
            self.parts["stripes"]:setSprite(self.actor.path.."/stripes/"..self.data.body.."/"..self.anim)
            self.parts["hands"]  :setSprite(self.actor.path.."/hands/"..  self.data.body.."/"..self.anim)
            self.parts["legs"]   :setSprite(self.actor.path.."/legs/"..  (self.data.legs_left and "left" or "right").."/"..self.anim)
            self.elapsedTime = 0
            self.last_anim = self.anim
            self.frameCounts = {}
            for part, _ in pairs(self.parts) do
                local path = self.actor.path

                if part == "hair" or part == "head" then
                    path = self.actor.path .. "/" .. part .. "/" .. self.data.head .. "/" .. self.anim
                elseif part == "legs" then
                    path = self.actor.path .. "/legs/" .. (self.data.legs_left and "left" or "right") .. "/" .. self.anim
                else
                    path = self.actor.path .. "/" .. part .. "/" .. self.data.body .. "/" .. self.anim
                end

                local frames = Assets.getFrames(path)
                if frames then
                    self.frameCounts[part] = #frames
                else
                    -- Handle the case where frames are not found
                    print("Warning: No frames found for part " .. part .. " at path " .. path)
                    self.frameCounts[part] = 1 -- Default to 1 to avoid division by zero
                end
            end
        else
            self.elapsedTime = self.elapsedTime + DT
            local fps = self.fps
        
            for part, spr in pairs(self.parts) do
                local frames = self.frameCounts[part] or 1
                local frameIndex = math.floor((self.elapsedTime * fps) % frames) + 1
        
                if part == "hair" or part == "head" then
                    spr:setSprite(self.actor.path .. "/" .. part .. "/" .. self.data.head .. "/" .. self.anim .. "_" .. frameIndex)
                elseif part == "legs" then
                    spr:setSprite(self.actor.path .. "/legs/" .. (self.data.legs_left and "left" or "right") .. "/" .. self.anim)
                else
                    spr:setSprite(self.actor.path .. "/" .. part .. "/" .. self.data.body .. "/" .. self.anim .. "_" .. frameIndex)
                end
            end
        end
        return 
    else
        for part,spr in pairs(self.parts) do
            local x_offset, y_offset = 0, 0
            if  self.parts_offsets[self.anim] and
                self.parts_offsets[self.anim][self.facing] and
                self.parts_offsets[self.anim][self.facing][part] then
                x_offset = self.parts_offsets[self.anim][self.facing][part][1]
                y_offset = self.parts_offsets[self.anim][self.facing][part][2]
            end
            if (part == "hair" or part == "head") and self.parts["body"].frame%2 == 0 then
                spr:setPosition(spr.init_x+x_offset, spr.init_y+y_offset+1)
            else
                spr:setPosition(spr.init_x+x_offset, spr.init_y+y_offset)
            end
            if  self.parts_layer[self.anim] and
                self.parts_layer[self.anim][part] and -- corrected this line
                self.parts_layer[self.anim][part][self.facing] then
                spr:setLayer(self.parts_layer[self.anim][part][self.facing])
            end
        end
    end
end

return Vii