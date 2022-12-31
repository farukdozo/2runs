Wall = Entity:extend()


function Wall:new(x, y)
    images = {}
    table.insert(images, love.graphics.newImage("Tiles/tile.png"))

    Wall.super.new(self, x, y, images)
    self.deadly = false
end


function Wall:draw()
    love.graphics.draw(self.images[1], self.x, self.y)
end