Shooter = Entity:extend()


function Shooter:new(x, y, rotation)
    local images = {love.graphics.newImage("Shooter_Enemy/shooter_right.png"),
                    love.graphics.newImage("Shooter_Enemy/shooter_left.png")}

    Shooter.super.new(self, x, y, images, rotation)
    self.r = rotation

    self.isAlive = true
    self.deathTimer = 0

    -- Shooting
    self.shoot = false
    self.shootTimer = 0
end

function Shooter:update(dt)
    -- Shooting
    self.shootTimer = self.shootTimer + dt

    if self.shoot == true then
        self.shootTimer = 0
        self.shoot = false
    end

    if self.shootTimer > 2 then
        self.shoot = true
    end

    -- Respawn
    if self.deathTimer > 3 then
        self.isAlive = true
    end
    if self.isAlive == false then
        self.deathTimer = self.deathTimer + dt
    else
        self.deathTimer = 0
    end
end


function Shooter:draw()
    if self.r == 90 then
        love.graphics.draw(self.images[1], self.x, self.y)
    else
        love.graphics.draw(self.images[2], self.x, self.y)
    end
end