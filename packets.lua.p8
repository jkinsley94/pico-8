pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- A game by fufferpuffer
--2024

--this one is the test build. Feel free to break it to shit!

function _init()
    player = {
        x = 10,
        y = 10,
        dx = 0,
        dy = 0,
        max_dx=2,
        max_dy=3,
        acc=0.5,
        boost=4,
        health = 3,
        sprite = 0,
        abilities = {
            can_double_jump = false,
            can_dash = false
        },
        has_double_jumped = false,
        frames = {0,2,4},
    }
    gravity=0.3
    friction=0.85
    
end

function _update()
    player.dy+=gravity
    player.dx*=friction
    player_anim()
    player_move()
end

function _draw()
    cls()
    player_anim()

    --temp ground
    rectfill(0,118,127,127,13)
    
end

--all player functions go here

function player_anim()
    if player.sprite<4.9 then
        player.sprite=player.sprite+.4
    else
        player.sprite=0
    end   

    spr(player.frames[flr(player.sprite)], player.x, player.y, 2, 2)
    --this seems like a useless function maybe as it goes along it will make more sense
            
end
function player_states()
    --state machine to handle various things like if the player dies, is running or idle

    
end

function player_move()
    if (btn(0)) then player.dx-=player.acc end -- left
    if (btn(1)) then player.dx+=player.acc end -- right
    if (btnp(5)) then player.dy-=player.boost end -- X

    --limit left/right speed
    player.dx=mid(-player.max_dx,player.dx,player.max_dx)
    --limit fall speed
    if (player.dy>0) then
        player.dy=mid(-player.max_dy,player.dy,player.max_dy)
    end

     --apply dx and dy to player position
     player.x+=player.dx
     player.y+=player.dy
 
     --simple ground collision
     if (player.y>110) then player.y=110 player.dy=0 end
 
     --if run off screen warp to other side
     if (player.x>128) then player.x=-8 end
     if (player.x<-8) then player.x=128 end
    
end
--this build has the animation working correctly... for now.



__gfx__
00333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
003cc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00030080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bab770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00bab000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
03000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
