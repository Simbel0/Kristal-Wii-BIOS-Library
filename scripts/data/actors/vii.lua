local Vii, super = Class(Actor, "vii")

function Vii:init()
    super:init(self)
    self.width, self.height = 17, 35
    self.hitbox = {3, 24, 12, 10}
    self.path = "vii"
    self.default = "walk"

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