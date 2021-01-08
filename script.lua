white = Color.new(255,255,255)
black = Color.new(0,0,0)
red = Color.new(255,0,0)
blue = Color.new(0,0,255)
green = Color.new(0,255,0)
clear = Color.new(0,255,0,0)
trans = Color.new(255,255,255,120)
logo = Image.load("music.png")
Image.unswizzle(logo)
bg = Image.load("BG.png")
--Image.unswizzle(bg)
cpuspeed = 200
cpuspeed2 = 70

workingdir = System.currentDirectory()
mp3list = {}
dirtable = System.listDirectory("ms0:/Music/")
lengthoflist = table.getn(dirtable)
cur = 1
for i = 3,lengthoflist do
	if string.lower(string.sub(dirtable[i].name, -4)) == ".mp3" then
		mp3list[cur] = dirtable[i].name
		cur = cur + 1
	end
end
visview = false
mp3listtotal = cur - 1
iconlist = {}

if relaunch == 0 or not relaunch then
	
	dofile("functions.lua")
		
	mp3folder = "MUSIC/"
	coverfolder = workingdir.."/covers/"
	System.setCpuSpeed(333)
	covers = getcovers(mp3listtotal,coverfolder,mp3folder,1,logo,bg)
	System.setCpuSpeed(222)
	dis = 2
	coverflow_first = 0
	
	playing = false
	
	wall = {
		{0,0,white,-0.5,0.5,dis},
		{1,0,white,0.5,0.5,dis},
		{0.5,0.5,white,0,0,dis},
		
		{1,0,white,0.5,0.5,dis},
		{1,1,white,0.5,-0.5,dis},
		{0.5,0.5,white,0,0,dis},
		
		{1,1,white,0.5,-0.5,dis},
		{0,1,white,-0.5,-0.5,dis},
		{0.5,0.5,white,0,0,dis},
		
		{0,1,white,-0.5,-0.5,dis},
		{0,0,white,-0.5,0.5,dis},
		{0.5,0.5,white,0,0,dis}
	}
	wall2 = {
		{0,0,white,-1,1,dis},
		{1,0,white,1,1,dis},
		{0.5,0.5,white,0,0,dis},
		
		{1,0,white,1,1,dis},
		{1,1,white,1,-1,dis},
		{0.5,0.5,white,0,0,dis},
		
		{1,1,white,1,-1,dis},
		{0,1,white,-1,-1,dis},
		{0.5,0.5,white,0,0,dis},
		
		{0,1,white,-1,-1,dis},
		{0,0,white,-1,1,dis},
		{0.5,0.5,white,0,0,dis}
	}
	plane = {
		{0,0.5,white,-8,3,-4},
		{0,1,white,-8,-3,-4},
		{0.5,0.5,white,8,3,-4},
		
		{0,0.5,white,-8,-3,-4},
		{0,1,white,8,-3,-4},
		{0.5,0.5,white,8,3,-4},
		
		--{0,1,white,0.5,-0.5,dis},
		--{1,1,white,-0.5,-0.5,dis},
		--{0.5,0.5,white,0,0,dis},
		
		--{1,1,white,-0.5,-0.5,dis},
		--{1,0.5,white,-0.5,0,dis},
		--{0.5,0.5,white,0,0,dis}
	}
	xaxis = (4*#covers-4)
	oldx = xaxis-1
	oldoldx = oldx-1
	zaxis = -3.5
	filter = 1
	current = 0
	
	maxxaxis = 4*#covers-4
	
	onestep = ((maxxaxis+4)/#covers)
	currentp = (4*#covers-4)	
	
	cplaying = 0
	
	eos = {fmp3 = 1, f = 1}
end


relaunch = 0

oldpad = Controls.read()
message = false
while true do
	pad = Controls.read()
	newx = 0
	screen.startDraw()
	start_gu()
	Image.blit(0,0,bg)
	if playing == true then
		if Mp3me.eos() == true then
			currentp = currentp - onestep
				Mp3me.stop()
				current = current - 1
				if current < 1 then
					current = mp3listtotal
					currentp = (4*#covers-4)
				end
				Mp3me.load("ms0:/Music/"..mp3list[current])
				Mp3me.play()
		end
		for i = 1,240 do
				color = Color.new(255-i,0,i)
			Image.drawLine(i*2,130,i*2,Mp3me.visR(i*3),color)
		end
	end
	if pad:l() then
		if not oldpad:l() then
			currentp = currentp + onestep
			Mp3me.stop()
			current = current + 1
			if current > mp3listtotal then
				current = mp3listtotal
				currentp = (4*#covers-4)
			end
			Mp3me.load("ms0:/Music/"..mp3list[current])
			Mp3me.play()
			playing = true
		end
	end
	if pad:r() then
		if not oldpad:r() then
			currentp = currentp - onestep
			Mp3me.stop()
			current = current - 1
			if current < 1 then
				current = mp3listtotal
				currentp = (4*#covers-4)
			end
			Mp3me.load("ms0:/Music/"..mp3list[current])
			Mp3me.play()
			playing = true
		end
	end
	if pad:left() and not oldpad:left() then
			currentp = currentp + onestep
	end
	if pad:right() and not oldpad:right() then
			currentp = currentp - onestep
	end
	if xaxis < currentp then
		xaxis = xaxis + 0.5
		newx = 1
	end
	if xaxis > currentp then
		xaxis = xaxis - 0.5
		newx = 1
	end
	--if oldx ~= xaxis or oldx ~= oldoldx or pad:square() or pad:triangle() then
		if xaxis < 0 then
			xaxis = 0
			currentp = 0
		end
		if xaxis > maxxaxis then
			xaxis = maxxaxis
			currentp = maxxaxis
		end
		for i = 1, mp3listtotal do
			covers[i].pos = (i-1)*(-4)+xaxis
			if covers[i].pos > -8.2 and covers[i].pos < 8.2 then
				covers[i].rot = -covers[i].pos/4.1
				dp(covers[i].pos,0.3,zaxis,0,covers[i].rot,covers[i].pos2,wall,covers[i].img,filter)
			end
		end
		current = math.floor((xaxis-2)/4)+2
		screen.print(0,232,covers[current].name,0.6,white,0)
		screen.print(0,252,covers[current].artist,0.6,white,0)
	--end
	if playing == true then
		screen.print(300,232,Mp3me.kbit(),0.6,white,0)
		screen.print(300,244,Mp3me.artist(),0.6,white,0)
		screen.print(300,256,math.floor(Mp3me.percent()).."%",0.6,white,0)
		if Mp3me.eos() ~= true then
			screen.print(300,268,"EOS = FALSE",0.6,white,0)
		else
			screen.print(300,268,"EOS = TRUE",0.6,white,0)
		end
	end
	screen.endDraw()
	--screen.waitVblankStart()
	screen.flipscreen()
	if pad:cross() then
		if not oldpad:cross() then
			Mp3me.stop()
			Mp3me.load("ms0:/Music/"..mp3list[current])
			Mp3me.play()
			playing = true
		end
	end
	if pad:square() then
		if not oldpad:square() then
			Mp3me.pause()
		end
	end
	if pad:circle() then
		if not oldpad:circle() then
			Mp3me.stop()
			playing = false
		end
	end
	oldoldx = oldx
	oldx = xaxis
	oldpad = pad
	if pad:start() then
		message = true
	end
	if message == true then
		help = Image.load(workingdir.."/help.jpg")
		while message == true do
			screen.startDraw()
			Gu.clearDepth(0);
			Gu.clear(Gu.COLOR_BUFFER_BIT+Gu.DEPTH_BUFFER_BIT)
			pad2 = Controls.read()
			Image.blit(0,0,help)
			screen.endDraw()
			screen.flipscreen()
			if pad2:circle() then
				oldpad = pad2
				message = false
			end
		end
		Image.free(help)
	end
end


if relaunch == 1 then
	dofile("index.lua")
else
	Gu.clearDepth(0);
	Gu.clear(Gu.COLOR_BUFFER_BIT+Gu.DEPTH_BUFFER_BIT)
end
