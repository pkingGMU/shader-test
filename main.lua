
if arg[2] == "debug" then
    require("lldebugger").start()
end




-- Load shader --
-- [[]] is just multi line --

local shader_code = [[

    extern float iTime;

    vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
        uvs = (uvs - 0.5) * 2;
        float d = length(uvs);

        

        d = smoothstep(0, 0.1, d);

        return vec4(d, d, d, 1.0);
    }
]]

function love.load()   
    -- Draw white image --
    -- Draw window
    love.window.setMode(600,600)

    -- White canvas
    Canvas = love.graphics.newCanvas(600,600)
    love.graphics.setCanvas(canvas)
    love.graphics.clear(1,1,1)
    love.graphics.setCanvas()

    -- Load shader
    Shader = love.graphics.newShader(shader_code)
end

-- Send time to shader
function love.update(dt)
    -- Pass the elapsed time to the shader
    Shader:send("iTime", love.timer.getTime())
end




function love.draw()
    -- Draw shader
    love.graphics.setShader(Shader)

    -- Draw images
    love.graphics.draw(Canvas, 0, 0)

    -- Clear shader
    love.graphics.setShader()
end


-- Debugging --

local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
    if lldebugger then
        error(msg, 2)
    else
        return love_errorhandler(msg)
    end
end