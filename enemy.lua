Enemy = Entity:extend()


function Enemy:new(x, y, xF, yF)
    local images = {}
    table.insert(images, love.graphics.newImage("Enemy/enemy.png"))

    Enemy.super.new(self, x, y, images, xF, yF)
    self.xF = xF
    self.yF = yF
    self.xS = x
    self.yS = y
    self.speed = 50

    self.isAlive = true
    self.deathTimer = 0
end

function Enemy:update(dt)
    -- Movement
    if self.yS - self.yF == 0 then
        if self.x <= self.xS then
            self.speed = math.abs(self.speed)
        elseif self.x >= self.xF then
            self.speed = math.abs(self.speed) * -1
        end
        self.x = self.x + self.speed * dt
    else
        if self.y <= self.yS then
            self.speed = math.abs(self.speed)
        elseif self.y >= self.yF then
            self.speed = math.abs(self.speed) * -1
        end
        self.y = self.y + self.speed * dt
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


function Enemy:draw()
    love.graphics.draw(self.images[1], self.x, self.y)
end