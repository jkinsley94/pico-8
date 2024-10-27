pico-8 cartridge // http://www.pico-8.com
version 42
__lua__

score = 0

pipes = {
    items = {},
    spawn_timer = 0,
    interval = 90,
    width = 8,
    gap_size = 12,
    color = 11
}

--game states
state_title=0
state_playing=1

--start game in title screen
current_state = state_title

title_y = 40
title_pulse = 1
pulse_direction = 1



function _init()
    current_state = state_title
 
end

function _update()
    if current_state == state_title then
        update_title_screen()
    elseif current_state == state_playing then
        the_pipes()
        gravity()
        fap()
        
    end
end

function _draw()
    cls()
    if current_state == state_title then
        draw_title_screen()

    elseif current_state == state_playing then
        draw_background()
        draw_pipes()
        spr(fardy.sprite, fardy.x, fardy.y)
        print("score:"..score, 5, 5, 7)
        
    end

end

function draw_background()
    for x = 0, 127, 8 do --iterate through the width of the screen
        for y = 0, 127, 8 do --iterate through the height of screen
            local tile = mget(x/8, y/8) --get the tile at this position
            spr(tile, x, y)
        end
    end            
    
end

--pipe functions go here

function score()
    for pipe in all(pipes.x) do
        if pipe.x<fardy.x then
            score+=1
        end
    end
    
end

function draw_pipes()
    for pipe in all(pipes.items) do
        if pipe.is_top then
            -- Draw top pipe
            rectfill(pipe.x, 0, pipe.x + pipes.width, pipe.y, pipes.color)
        else
            -- Draw bottom pipe
            rectfill(pipe.x, pipe.y, pipe.x + pipes.width, 127, pipes.color)
        end
    end
end

function the_pipes()
    -- Increment timer and check for pipe spawn
    pipes.spawn_timer += 1
    if pipes.spawn_timer >= pipes.interval then
        pipes.spawn_timer = 0
        spawn_pipe()
    end

    -- Update pipe positions
    for i = #pipes.items, 1, -1 do
        local pipe = pipes.items[i]
        pipe.x -= 2  -- Move pipe to the left

        -- Remove pipes that have moved off-screen
        if pipe.x < -pipes.width then
            del(pipes.items, pipe)
        end
    end
end

function spawn_pipe()
    local gap_y = flr(rnd(64) + 32) -- Random gap center y position
    
    -- Top pipe
    add(pipes.items, {x = 128, y = gap_y - pipes.gap_size - 64, is_top = true})
    
    -- Bottom pipe
    add(pipes.items, {x = 128, y = gap_y, is_top = false})
end

--function for handling title screen

function update_title_screen()
        -- Animate title pulse
    title_pulse = title_pulse + pulse_direction * 0.05
    if title_pulse > 2 or title_pulse < 1 then
        pulse_direction = -pulse_direction
    end
    --start game when player presses a button
    if btnp(4) or btnp(5) then
        current_state = state_playing
        fardy.y = 32
        fardy.velocity = 0 --reset birds position
    end

end

function draw_title_screen()
    local title = "FARDY BUB"
    local colors = {8,9,10,11,12} --arcade like bright colors
    for i = 1, #title do
        local c = colors[(i - 1) % #colors + 1]
        --pulse effect to make colors grow and shrink
        local scale = title_pulse
        -- draw each letter in different colors
        print(sub(title, i, i), 32 + (i * 10), title_y, c)
    end

    --instruction text
    print("PRESS Z OR X TO START", 24, 80, 7)
end

--most of fardys stuff goes here


fardy = {
    x=32,
    y=32,
    sprite=1,
    gravity=15,
    fap_h=-3,
    velocity=0
    
}

function gravity()
    fardy.velocity = fardy.velocity +(fardy.gravity * 0.01)
    fardy.y = fardy.y + fardy.velocity
end

function fap()
    if btnp(4) then
        fardy.velocity = fardy.fap_h
    end
    
    --flap sound
    if btnp(4) then
    				sfx(1)
    end

    --ensure bird doesnt go off screen
    if fardy.y > 127 then
        fardy.y = 127
        fardy.velocity = 0 --stop falling
    elseif fardy.y < 0 then
        fardy.y = 0
        fardy.velocity = 0 --stop moving up
    end

end





__gfx__
000000000b0b0b00cccccccccccccccccccccccccccccccccccccccccccc6ccc0000000000000000000000000000000000000000000000000000000000000000
0000000003bbbb00ccccccccccccccccccccccccccccccccccccccccccc66c880000000000000000000000000000000000000000000000000000000000000000
0000000003b711b0cccccccccccccccccccccccccccccccccccccccc165656580000000000000000000000000000000000000000000000000000000000000000
00000000333711b0cccccccccccccccccccccccccccccccccccccccc666666660000000000000000000000000000000000000000000000000000000000000000
0000000033377799ccccccccccccccccc7777777777cccccccccccccccc66ccc0000000000000000000000000000000000000000000000000000000000000000
0000000035353599cccccccccccccc777777777777777ccccccccccccccc66cc0000000000000000000000000000000000000000000000000000000000000000
000000005353533bccccccccccccc77777777777777777ccccccccccccccc6cc0000000000000000000000000000000000000000000000000000000000000000
0000000000a00a00cccccccccccc777777777777777777cccccccccccccccccc0000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccc777777777777777766cccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccc777777777777777766cccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000ccccccc77777777777766ccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccc7777776666cccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000ccccccccccc66666666ccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000cccccccccccccccccccccccccccccccc000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202020206030405060304050623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202021602020216131415161314151623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2324252623240202232425262324252623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3334353633343502333435363334353623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202030405020202020202060304050623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0202131415020202020207161314151623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2324252623240226232425262324252623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
3334353633340202333435363334353623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0304050603040506333435360304050623232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2323232323232323232323232323232323232323232323232323232323232323232323232323232300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200000b2500f25012250182501c250212502325025250272502a2502d250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400000f050170501d0502305028050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002000001895000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000