
import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "utils.lua"

local gfx <const> = playdate.graphics
local SCREENYMAX <const> = 240
local SCREENXMAX <const> = 400
local TEXTLEFTOFFSET <const> = 30

local w,textHeight = gfx.getTextSize("Roll 9d20")

local sel = 1
local result = nil

--dice data
local dice <const> = {2, 4, 6, 8, 10, 12, 20, "?"} --what dice there can be!
local diceQuantity = {} ; for k,v in ipairs(dice) do diceQuantity[v]=1 end --1 for every die

local dieRowCoords = {} --relative to overall screen
local spriteRowCoords = {}

local heightPerRow = SCREENYMAX/#dice 

for i,d in ipairs(dice) do
	dieRowCoords[d] =  (heightPerRow/2) - (textHeight/2) + (i-1)*heightPerRow
	spriteRowCoords[d] = heightPerRow/2 + (i-1)*heightPerRow
end

-- Pointer sprite
local pointerSprite = gfx.sprite.new()
pointerSprite:setImage(gfx.image.new(20,20,gfx.kColorBlack))
pointerSprite:setZIndex(1000)
pointerSprite:add()
function pointerSprite:moveToSelected()
	pointerSprite:moveTo( TEXTLEFTOFFSET/2, spriteRowCoords[dice[sel]])
end
pointerSprite:moveToSelected()

-- Text sprite
textbox = gfx.sprite.new()
textbox:setSize(SCREENXMAX - TEXTLEFTOFFSET, SCREENYMAX)
textbox:setCenter(0,0)
textbox:moveTo(TEXTLEFTOFFSET,0)
textbox:setZIndex(500)
textbox.text = "AAAAAA\nASDASDASD\nAAAAAGHGHHHH" -- this is blank for now; we can set it at any point
textbox:add()

function textbox:update()
	-- changes needed on update go here!
end


function textbox:draw()
	
	-- pushing context means, limit all the drawing config to JUST this block
	-- that way, the colors we set etc. won't be stuck
	gfx.pushContext()
	
		-- draw the box				
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0,0,SCREENXMAX-TEXTLEFTOFFSET,SCREENYMAX)
		
		-- border
		gfx.setLineWidth(4)
		gfx.setColor(gfx.kColorBlack)
		gfx.drawRect(0,0,SCREENXMAX-TEXTLEFTOFFSET,SCREENYMAX)
		
		-- draw the text!
		for i,d in ipairs(dice) do
			local s = ""
			if d=="?" then
				s = "*Roll d" .. (diceQuantity[d]==1 and "?" or diceQuantity[d])
			else
				s = "*Roll " .. diceQuantity[d] .. "d" .. d
			end
			if result and i == sel then
				s = s .. " Rolled " .. result .. "!"
				print( s )
			end
			s = s .. "*"
			print("drawing this line: " .. s )
			gfx.drawText( s, 10, dieRowCoords[d] )
		end		
			
	gfx.popContext()
	
end

function playdate.AButtonDown()
	if dice[sel] == "?" then --for ?, the die itself is configurable
		if diceQuantity[dice[sel]] > 1 then
			result = math.random(diceQuantity[dice[sel]]) --quantity for this one is actually the number of faces
		end
	else
		result = 0
		for i=1,diceQuantity[dice[sel]] do
			result += math.random(dice[sel])
		end
	end
	if result then textbox:markDirty() end
end
function playdate.downButtonDown()
	sel += 1
	result = nil
	textbox:markDirty()
	if sel > #dice then 
		sel = #dice 
	end	
	pointerSprite:moveToSelected()
end
function playdate.upButtonDown()
	sel -= 1
	result = nil
	textbox:markDirty()
	if sel < 1 then 
		sel = 1
	end	
	pointerSprite:moveToSelected()
end
function playdate.rightButtonDown()
	diceQuantity[dice[sel]] += 1
	print( "Changing quantity for " .. dice[sel] .. " to " .. diceQuantity[dice[sel]] )
	result = nil
	textbox:markDirty()
	pointerSprite:moveToSelected()
end
function playdate.leftButtonDown()
	diceQuantity[dice[sel]] -= 1
	if diceQuantity[dice[sel]] < 1 then
		diceQuantity[dice[sel]] = 1
	end
	print( "Changing quantity for " .. dice[sel] .. " to " .. diceQuantity[dice[sel]] )
	result = nil
	textbox:markDirty()
	pointerSprite:moveToSelected()
end

function playdate.update()

	gfx.sprite.update()
	
end