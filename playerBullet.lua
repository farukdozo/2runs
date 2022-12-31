PlayerBullet = Entity:extend()

function PlayerBullet:new(x ,y, dir)
    if dir < 4 then
        self.x = x + 17
        self.y = y + 15
        self.speed = 400
    else
        self.x = x - 1
        self.y = y + 15
        self.speed = -400
    end

    self.width = 2
    self.height = 2
end

function PlayerBullet:update(dt)
    self.x = self.x + self.speed * dt
end

function PlayerBullet:draw()
    love.graphics.circle("fill", self.x, self.y, 2)
end