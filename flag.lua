Flag = Entity:extend()


function Flag:new(x, y)
    images = {}
    table.insert(images, love.graphics.newImage("Flag/flag1.png"))
    table.insert(images, love.graphics.newImage("Flag/flag2.png"))

    Flag.super.new(self, x, y, images)
    self.width = 40
    self.height = 80
end


function Flag:draw()
    love.graphics.draw(self.images[1], self.x, self.y)
    love.graphics.draw(self.images[2], self.x, self.y + 40)
end