
if arg[2] == "debug" then
    require("lldebugger").start()
end




-- Load shader --
-- [[]] is just multi line --

local shader_code = [[

    extern float iTime;
    vec2 uvs0;

    vec3 palette(float t) {
        vec3 a = vec3(0.5, 0.5, 0.5);
        vec3 b = vec3(0.5, 0.5, 0.5);
        vec3 c = vec3(1.0, 1.0, 1.0);
        vec3 d = vec3(0.30, 0.20, 0.20);

        return a +b*cos(6.28318*(c*t+d));
    }

    vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
        uvs = (uvs - 0.5) * 2;
        uvs0 = uvs;

        vec3 finalColor = vec3(0.0);
        
        for (float i = 0.0; i < 5.0; i++) {
            uvs *= 1.3;
            uvs = fract(uvs);
            uvs -= 0.5;

            float d = length(uvs);


            vec3 col = palette(length(uvs0) + i*.2 + iTime * .1);

            d = sin(d*8. + iTime)/8.;
            d = abs(d);
            d = pow(0.01 / d, 2.0);
            finalColor += col * d;
        }
        
        
        return vec4(finalColor, 1.0);
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