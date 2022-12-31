EnemyBullet = Entity:extend()

function EnemyBullet:new(x, y, r)
    if r == 90 then
        self.x = x + 37
        self.y = y + 16
        self.speed = 400
    elseif r == 270 then
        self.x = x - 5
        self.y = y + 16
        self.speed = -400
    end

    self.width = 5
    self.height = 5
end

function EnemyBullet:update(dt)
    if self.speed then
        self.x = self.x + self.speed * dt
    end
end

function EnemyBullet:draw()
    love.graphics.setColor(1, 0.1, 0.1, 1)
    love.graphics.circle("fill", self.x, self.y, 5)
    love.graphics.setColor(1, 1, 1, 1)
end