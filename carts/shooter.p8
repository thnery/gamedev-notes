pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
--main

--called when the game starts
function _init()
	--clears the screen
	--0 is number for black
	cls(0)
	
	--define the game mode
	--start, the initial screen
	mode="start"
end

--test user input and
--events triggered during
--the game
function _update()
	--handle game modes
	if mode=="game" then
		handle_game_updates()
	elseif mode=="start" then
		handle_game_start()
	elseif mode=="over" then
		handle_game_over()
	end
end

--draws the state of the game
--on the screen
function _draw()
	if mode=="game" then
	 draw_basics()
	 draw_muzzle()
		draw_hud()
		draw_starfield()
	elseif mode=="start" then
		draw_start_screen()
	elseif mode=="over" then
		draw_game_over()
	end
end
-->8
--init

--[[
this code loads when the game starts
it is used to setup variables and
initial features
]]
function start_game()
	mode="game"
	
	shipspr=2
	shipsprl=1
	shipsprr=3
	
	shipx=63
	shipy=100
	
	shipsx=0
	shipsy=0
	
	flamespr=4
	
	bulspr=7
	bulx=0
	buly=0
	maxbullets=5
	
	muzzle=0
	
	score=0
	lives=4
	rockets=2
	
	stars={}
	starspd={}
	maxstars=50
	
	for n=1,maxstars do
		local star={}
		star.x=flr(rnd(128))
		star.y=flr(rnd(128))
		star.spd=rnd(1.5)+0.5
		add(stars,star)
	end
	
	bullets={}
end
-->8
--update
function handle_game_updates()
	shipsx=0
	shipsy=0
	shipspr=2
	
	animate()
	animate_starfield()
	
	handle_controls()
	handle_movements()
	handle_edges()
end

function handle_movements()
	--move the ship	
	shipx+=shipsx
	shipy+=shipsy
end

function handle_edges()
	--check edges
	if shipx>120 then
		shipx=120
	end
	if shipx<=0 then
		shipx=0
	end
end

function handle_controls()
	--controls
	if btn(0) then
		shipsx=-2
		shipspr=1
		
		animate_stars("left")
	end
	if btn(1) then
		shipsx=2
		shipspr=3
		
		animate_stars("right")
	end
	if btn(2) then
		shipsy=-2
		animate_stars("up")
	end
	if btn(3) then
		shipsy=2
		animate_stars("down")
	end
	if btnp(5) then
		local bullet={
			x=shipx,
			y=shipy-3
		}
		
		if (#bullets<3) then
			add(bullets,bullet)
		
			--bullet soundeffect
			sfx(0)
			
			muzzle=3
		end
	end
	if btnp(4) then
		mode="over"
	end
end

function handle_game_start()
	if btnp(5) then
		start_game()
	end
end

function handle_game_over()
	if btnp(5) then
		mode="start"
	end
end
-->8
--draw

--[[
clears screen
draw the ship, bullet and
ship flame
]]
function draw_basics()
	cls()
	spr(shipspr,shipx,shipy)
	spr(flamespr,shipx,shipy+6)
	
	for n=1,#bullets do
		local bullet=bullets[n]
		spr(bulspr,bullet.x,bullet.y)
	end
end

--[[
draws a muzzle when
ship shoots
]]
function draw_muzzle()
	if muzzle>0 then	
		circfill(shipx+3,shipy,muzzle,7)
	end
end

--draw game hud: score, lives and bombs
function draw_hud()
	print("score: "..score,52,1,12)

	for n=1,4 do
		if lives>=n then
			spr(10,n*9-8,1)
		else
			spr(9,n*9-8,1)
		end
	end
	
	for n=1,rockets do
		spr(11,120-(n*9),1)
	end
end

--[[
draw the starfield scenario
randomly draws a pixel (star)
starx and stary have the same
size, they are used to position
the stars on the starfield
]]
function draw_starfield()
	for n=1,maxstars do
		local star_color = 7
		local star=stars[n]
		
		--[[
		the logic bellow handles the star
		color based on their velocity.
		the velocity is defined by starspd
		which is a table with the same data
		of starx and stary
		]]
		if star.spd<1.5 then
			star_color=13
		end
		if star.spd<1.0 then
			star_color=1
		end
		pset(star.x,star.y,star_color)
	end
end

--self explanatory
function draw_start_screen()
	cls(1)
	print("press space to start")
end

--self explanatory
function draw_game_over()
	cls(1)
	print("game over...", 34, 40, 12)
end
-->8
--animations

--all animatinos are defined here
function animate()
	--animate flame
	flamespr+=1
	if flamespr>6 then
		flamespr=4
	end
	
	--animate bullets
	for n=#bullets,1,-1 do
	local bullet=bullets[n]
		bulspr+=1
		if bulspr>8 then
			bulspr=7
		end
		
		bullet.y-=4
		
		if bullet.y<-8 then
			del(bullets,bullet)
		end
	end
	
	--animate muzzle flash
	if muzzle>0 then
		muzzle-=1
	end
end

function animate_starfield()
	for n=1,#stars do
		local sy=stars[n].y
		sy=sy+stars[n].spd
		if sy>128 then
			sy=sy-128
		end
		stars[n].y=sy
	end
end

--[[
animates the starfield
when the ship moves right,left and up
the stars move to the opposite direction
]]
function animate_stars(dir)
	for n=1,maxstars do
		local star=stars[n]
		if(dir=="left" and shipx>0) then
			star.x+=1
		end
		if(dir=="right" and shipx<120) then
			star.x-=1
		end
		if(dir=="up") then
			star.y+=1
		end
		if(dir=="down") then
			star.y-=1
		end
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000008800880088008800006600000000000000000000000000000000000
00000000000880000008800000088000000000000000000000000000000000000000000080088008888888880065560000000000000000000000000000000000
00700700000820000008800000028000000aa000000aa000000aa000000330000007700080000008888888880065560000000000000000000000000000000000
00077000000820000008800000028000000aa000000aa000000aa000003bb300007bb70080000008888888880065560000000000000000000000000000000000
0007700000082080800880080802800000099000000aa000000aa00000b00b0000b00b0008000080088888800065560000000000000000000000000000000000
0070070000878820822c7228028878000000000000099000000aa000000000000000000000800800008888000666666000000000000000000000000000000000
00000000008c8820888cc8880288c800000000000000000000099000000000000000000000088000000880000558855000000000000000000000000000000000
00000000000880000008800000088000000000000000000000000000000000000000000000000000000000000009900000000000000000000000000000000000
__sfx__
000000002705027050240501f0501a0501705014050120500f0500d0500a050080500505003050010500005000050000000000000000000000000000000000000000000000000000000000000000000000000000
001000002e5502e5502e5502e5502c5502b55029550235501955016550105500d5500955007550065500d55002550015500055003550035500255005550055500555005550175501855012550000000000000000
001000002a05029050220501e0501b0501905019050190501805018050180501605014050130500d0500905008050060500405003050030500205001050000000000000000000000000000000000000000000000
