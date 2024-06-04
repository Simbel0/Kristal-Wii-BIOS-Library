local Vii, super = Class(Actor, "vii")

function Vii:init()
    super:init(self)
    self.width, self.height = 17, 35

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 23, 19, 14}
    self.path = "vii"
    self.default = "walk"

    self.soul_offset = {9, 21}

    self.data = Kristal.callEvent("getVii")
    if not self.data then
        error("[Wii Library] Tried to create Vii Actor without Vii data!")
    end

    self.name = self.data.name
end

function Vii:createSprite()
    return ViiActor(self, self.data)
end

return Vii