-- Local
local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

local PlayerData                = {}
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil

-- local CurrentActionMsg          = ''

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

AddEventHandler('murker:hasEnteredMarker', function(zone)
	if zone == 'PolisLogg' then
		CurrentAction = 'PoliceLoggMenu'
	end
end)

AddEventHandler('murker:hasExitedMarker', function(zone)
	CurrentAction = nil
end)

-- Display markers
Citizen.CreateThread(function()
	while true do

		Wait(0)

		local coords = GetEntityCoords(GetPlayerPed(-1))

		for k,v in pairs(Config.Zones) do

			if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
				DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z - 0.94, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, v.Opacity, false, true, 2, false, false, false, false)
				ESX.Game.Utils.DrawText3D(v.Pos, v.Text, 0.8)
			end
		end

		local isInMarker  = false
		local currentZone = nil

		for k,v in pairs(Config.Zones) do
			if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
				isInMarker  = true
				currentZone = k
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker = true
			LastZone = currentZone
			TriggerEvent('murker:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('murker:hasExitedMarker', LastZone)
			ESX.UI.Menu.CloseAll()
		end
	end
end)

local count = 0

Citizen.CreateThread(function()
	while true do

		Wait(0)
		if CurrentAction ~= nil then
			SetTextComponentFormat('STRING')
			DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			if IsControlJustReleased(0, Keys['E']) then
				if CurrentAction == 'PoliceLoggMenu' then
					OpenEmployeeList()
				end
			end
		end
	end
end)

function OpenEmployeeList()

  ESX.TriggerServerCallback('ksrp_polislogg:GetList', function (logg)

    local elements = {
      head = {'Datum', 'Tid', 'Händelsen Seriekod', 'Person', 'Kostnad', 'Händelse'},
      rows = {}
    }

    for i=1, #logg, 1 do

      table.insert(elements.rows, {
        cols = {
          logg[i].date,
          logg[i].tid,
          '#' .. logg[i].serie,
          logg[i].firstname .. ' ' .. logg[i].lastname,
          logg[i].kostnad .. 'kr',
          logg[i].story,
          -- '{{' .. 'Ta bort' .. '|remove}}' -- Knapp
        }
      })
    end

    ESX.UI.Menu.Open(
      'list', GetCurrentResourceName(), 'employee_list_',
      elements,
      function(data, menu)

        -- if data.value == 'remove' then
        --   ESX.ShowNotification('Tog bort')
        -- end

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GetRandomNumber(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

RegisterNetEvent('ksrp_polislogg:AddLoggC')
AddEventHandler('ksrp_polislogg:AddLoggC', function(price, story)
	TriggerServerEvent('ksrp_polislogg:AddLogg', GetRandomNumber(2) .. GetRandomLetter(3) .. GetRandomNumber(1), story, price)
end)