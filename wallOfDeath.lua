WallOfDeath = Entity:extend()


function WallOfDeath:new(x, y)
    images = {}
    table.insert(images, love.graphics.newImage("Tiles/reds.png"))

    WallOfDeath.super.new(self, x, y, images)
    self.deadly = true
end


function WallOfDeath:draw()
    love.graphics.draw(self.images[1], self.x, self.y)
end