local mapa = {
	0, 0, 0,
	0, 0, 0,
	0, 0, 0
}

do 
	local d = {'AutoShaman', 'AutoNewGame', 'AutoTimeLeft', 'AfkDeath', 'AutoScore'}
  for i=1, #d do
		tfm.exec['disable'..d[i]]()
  end
end

local xml = [[<C><P F="1" G="0,9" P="" MEDATA=";;;;-0;0:::1-"/><Z><S><S T="6" X="400" Y="387" L="800" H="35" P="0,0,0.3,0.2,0,0,0,0"/><S T="20" X="207" Y="499" L="20" H="262" P="0,0,0.1,0.3,0,0,0,0" c="3" col="" m="" friction="2,0.4"/></S><D><P X="0" Y="4" T="117" C="8F9757,424242" P="0,0"/><P X="75" Y="379" T="19" C="ba00da" P="0,0"/><P X="725" Y="379" T="19" C="c2e017" P="0,0"/><P X="767" Y="377" T="44" P="0,0"/><P X="677" Y="369" T="31" P="0,0"/><P X="239" Y="373" T="11" P="0,0"/><P X="169" Y="371" T="11" P="0,0"/><P X="616" Y="374" T="12" P="0,0"/><P X="308" Y="370" T="193" P="0,0"/><P X="208" Y="371" T="287" P="0,0"/><P X="555" Y="374" T="5" P="0,0"/><P X="149" Y="375" T="267" P="0,0"/><P X="128" Y="369" T="3" P="0,0"/><P X="187" Y="371" T="269" P="0,0"/><P X="20" Y="370" T="106" P="0,0"/><DS X="406" Y="359"/></D><O/><L/></Z></C>]]

--[[0 = vazio, 1 = xis, 2 = bolinha]]

local jogadores = {} --são 2 jogadores

setmetatable(jogadores, {__index = function()
   return '<font size="12" color="#BABD2F">[ espaço ]'
end})

--quem começa? aleatório? nem xis nem bolinha deve começar por padrão

--divisão por fases
--[[
1 = escolha de jogadores
2 = jogada
3 = checar jogada
4 = fim
]]

eventPlayerDied = tfm.exec.respawnPlayer

local checarGanhador = function()
	--jogador 1 (x)
	for i=1, #mapa do
		if i/3 == math.abs(i/3) then
			if mapa[i] == 1 and mapa[i+1] == 1 and mapa[i+2] == 1 then
				return 1
			end
		end
		if mapa[i] == 1 and mapa[i+3] == 1 and mapa[i+6] == 1 then
			return 1
		end
		if i == 1 then
			if mapa[i] == 1 and mapa[i+4] == 1 and mapa[i+8] == 1 then
				return 1
			end
		end
		if i == 7 then
			if mapa[i] == 1 and mapa[i-2] == 1 and mapa[i-4] == 1 then
				return 1
			end
		end
	end
	--jogador 2 (o)
	for i=1, #mapa do
		if i/3 == math.abs(i/3) then
			if mapa[i] == 2 and mapa[i+1] == 2 and mapa[i+2] == 2 then
				return 2
			end
		end
		if mapa[i] == 2 and mapa[i+3] == 2 and mapa[i+6] == 2 then
			return 2
		end
		if i == 1 then
			if mapa[i] == 2 and mapa[i+4] == 2 and mapa[i+8] == 2 then
				return 2
			end
		end
		if i == 7 then
			if mapa[i] == 2 and mapa[i-2] == 2 and mapa[i-4] == 2 then
				return 2
			end
		end
	end
	return false
end

local analisarJogador = function(n)
end

ui.addTextArea(-1, '', nil, 400-110, 185-110, 220, 220, -1, -1)

for i=1, 3 do
	ui.addTextArea(i, ('<font size="70"><a href="event:pos%s">⠀</a>'):format(tostring(i)), nil, 400-170+(80*i), 185-130+40, 20, 20, -1, -1)
end
for i=1, 3 do
	ui.addTextArea(i+3, ('<font size="70"><a href="event:pos%s">⠀</a>'):format(tostring(i+3)), nil, 400-170+(80*i), 185-130+120, 20, 20, -1, -1)
end
for i=1, 3 do
	ui.addTextArea(i+6, ('<font size="70"><a href="event:pos%s">⠀</a>'):format(tostring(i+6)), nil, 400-170+(80*i), 185-130+200, 20, 20, -1, -1)
end



local vez = 1

local corDaJogada = function()
	if vez == 1 then
		return 0xFF9999
	else
		return 0x9999FF
	end
end

local u
eventTextAreaCallback = function(id, p, n)
	if p == u or mapa[tonumber(id)] ~= 0 or p ~= jogadores[vez] then return end
	ui.addTextArea(id, '?', nil, 9999, 99999, 20, 20, -1, -1)
	if tonumber(id) < 4 then
		ui.addTextArea(id, (vez == 1 and '<font size="15" color="#000000"><b>X' or '<font size="15" color="#000000"><b>O'), nil, 400-170+(80*id), 185-130+40, 20, 20, corDaJogada(), corDaJogada(), 1)
	elseif tonumber(id) < 7 then
		ui.addTextArea(id, (vez == 1 and '<font size="15" color="#000000"><b>X' or '<font size="15" color="#000000"><b>O'), nil, 400-170+(80*(id-3)), 185-130+120, 20, 20, corDaJogada(), corDaJogada(), 1)
	else
		ui.addTextArea(id, (vez == 1 and '<font size="15" color="#000000"><b>X' or '<font size="15" color="#000000"><b>O'), nil, 400-170+(80*(id-6)), 185-130+200, 20, 20, corDaJogada(), corDaJogada(), 1)
	end
	mapa[tonumber(id)] = vez
	if vez == 1 then
		vez = 2
	else
		vez = 1
	end
	u = p
	print(checarGanhador())
end

tfm.exec.newGame(xml)
ui.setMapName('Velha 2')

corDeEspaco = 'BABD2F'
local makeMap = function(p)
	ui.addTextArea(11, ("<p align='center'><font size='12'><b><font color='#FDFDFE'><b>%s"):format(jogadores[1]), p, 73-50, 360, 100, 20, nil, nil, 0, false)
	ui.addTextArea(12, ("<p align='center'><font size='12'><b><font color='#FDFDFE'><b>%s"):format(jogadores[2]), p, 725-50, 360, 100, 20, nil, nil, 0, false)
end

local analisarJogador = function(p)
	makeMap(p)
	system.bindKeyboard(p, 32, true, true)
end

for k in next, tfm.get.room.playerList do
	analisarJogador(k)
end

makeMap()

eventKeyboard = function(p, k, _, x)
	if x < 103 and x > 47 and jogadores[1] == '<font size="12" color="#BABD2F">[ espaço ]' and p ~= jogadores[2] then
		jogadores[1] = p
		makeMap()
	end
	if x < 758 and x > 688 and jogadores[2] == '<font size="12" color="#BABD2F">[ espaço ]' and p ~= jogadores[1] then
		jogadores[2] = p
		makeMap()
	end
end
