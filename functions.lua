covers = {}

function getmp3s(dir)
	mp3dir = System.listDirectory("ms0:/"..dir)
	
	table.remove(mp3dir,1)
	table.remove(mp3dir,1)
	--[[
	i = 1
	while i < #mp3dir do
		if string.upper(string.sub(mp3dir[i].name,-1,-4)) ~= "MP3" then
			table.remove(mp3dir,i)
			i = i - 1
		end
		i = i + 1
	end
	--]]
	
	return mp3dir
end
function getimg(i,defulticon)
	mem = System.getFreeMemory()
	mem = mem/1024/1024
	if mem < 4 then
		iconlist[i] = defulticon
		return iconlist
	end
	art = false
		artname = string.sub(mp3list[i],1,((string.find(string.lower(mp3list[i]), ".mp3")-1)))
		if (System.doesFileExist("ms0:/Music/"..artname..".jpg") == 1) then
			iconlist = Image.load("ms0:/Music/"..artname..".jpg")
			--Image.resize(50,50,iconlist[i])
			Image.unswizzle(iconlist)
			art = true
			isart = 0
			if (Image.width(iconlist) > 130 or Image.height(iconlist) > 130) or (Image.width(iconlist) < 125 or Image.height(iconlist) < 125) then
				iconlist = scaleImage(128,128,iconlist,128,128)
			end
		end
		if (System.doesFileExist("ms0:/Music/"..artname..".png") == 1) then
			iconlist = Image.load("ms0:/Music/"..artname..".png")
			--Image.resize(50,50,iconlist[i])
			Image.unswizzle(iconlist)
			art = true
			isart = 0
			if (Image.width(iconlist) > 130 or Image.height(iconlist) > 130) or (Image.width(iconlist) < 125 or Image.height(iconlist) < 125) then
				iconlist = scaleImage(128,128,iconlist,128,128)
			end
		end
			if art == false then
				iconlist = defulticon
			end
		return iconlist
end
function getcovers(mp3s,dir,mp3dir,useID3Image,imgs,bg)
	covers = {}
	x = 1
	for n = 1, mp3s do
		screen.startDraw()
		start_gu()
		Image.blit(0,0,bg)
		screen.print(136,174,"CoverFlow PSP",1,white,trans)
		screen.print(0,10,"Loading all Cover Arts",0.6,white,0)
		perc = (n*100)/mp3s
		screen.print(0,20,perc.."%",0.6,white,0)
		Mp3me.info("ms0:/Music/"..mp3list[x])
		covers[x] = {rot = 0, pos = 0, pos2 = 0, img, img2, name = Mp3me.title(), artist = Mp3me.artist()}
		covers[x].img = getimg(x,imgs)
		Image.swizzle(covers[x].img)
		--dp(0,0.3,-3.5,0,0,0,wall,covers[x].img,1)
		screen.endDraw()
		screen.flipscreen()
		x = x + 1
	end
	return covers
end



function start_gu()
	Gu.clearDepth(0);
	Gu.clear(Gu.COLOR_BUFFER_BIT+Gu.DEPTH_BUFFER_BIT)
	Gum.matrixMode(Gu.PROJECTION)
	Gum.loadIdentity()
	Gum.perspective(75, 16/9, 0.5, 1000)
	Gum.matrixMode(Gu.VIEW)
	Gum.loadIdentity()
end

function dp(dx,dy,dz,xrot,yrot,zrot,table,dtextur,filter)
	--Gu.enable(Gu.BLEND)
	--Gu.blendFunc(Gu.ADD, Gu.SRC_ALPHA, Gu.ONE_MINUS_SRC_ALPHA, 0, 0)
	Gu.enable(Gu.TEXTURE_2D);
	Gu.texImage(dtextur)
	Gu.texFunc(Gu.TFX_MODULATE, Gu.TCC_RGBA)
	Gu.texFilter(Gu.LINEAR, Gu.LINEAR)
	Gu.texScale(1, 1)
	Gu.texOffset(0, 0)
	Gum.matrixMode(Gu.MODEL)
	Gum.loadIdentity()
	Gum.translate(dx, dy, dz);
	Gum.rotateXYZ(xrot,yrot,zrot)
	Gum.drawArray(Gu.TRIANGLES, Gu.TEXTURE_32BITF+Gu.COLOR_8888+Gu.VERTEX_32BITF+Gu.TRANSFORM_3D, table)
end
function end_gu()
	
end

function printcentered(y,text,color,font)
	if color == nil then
		color = Color.new(255,255,255)
	end
	if not font then
		--screen:print(240-(string.len(text)/2)*8,y,text,color)
	else
		--screen:fontPrint(font,240-3*string.len(text),y,text,color)
	end
end

function scaleImage(newX, newY, srcimg,wdth,hght) 
resizedImage = Image.createEmpty(wdth, hght)
Image.clear(resizedImage,clear)
	xrel = Image.width(srcimg)/newX
	yrel = Image.height(srcimg)/newY
	for x = 1, newY do
		for y = 1, newX do
			color = Image.getPixel(math.floor(x*xrel),math.floor(y*xrel),srcimg)
			Image.setPixel(resizedImage,x,y,color)
		end
	end
	Image.free(srcimg)
return resizedImage 
end