local Vii, super = Class(ActorSprite)

function Vii:init(actor, data)
    super:init(self, actor)

    self.data = data

    Utils.hook(Sprite, "init", function(orig, self, texture, x, y, width, height, path)
        orig(self, texture, x, y, width, height, path)
        print(texture)
    end)

    self.parts = {
        hair = Sprite("vii/hair/"..self.data.head.."/down", 8.5, 18),
        head = Sprite("vii/head/"..self.data.head.."/down", 8.5, 18),
        body_in = Sprite("vii/body/"..self.data.body.."/in/walk/down", 9, 28),
        body_out = Sprite("vii/body/"..self.data.body.."/out/walk/down", 9, 28),
        stripes = Sprite("vii/stripes/"..self.data.body.."/down", 9, 28),
        hands = Sprite("vii/hands/"..self.data.body.."/down", 9, 28),
        legs = Sprite("vii/legs/"..(self.data.legs_left and "left" or "right").."/down", 9, 35)
    }
    self.parts_layer = {
        hair = 1,
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
            v:setLayer(self.parts_layer[k])
        end
        v:setOrigin(0.5, 1)
        i = i + 1
        self:addChild(v)
    end
end

return Vii