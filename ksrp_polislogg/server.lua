ESX                = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('ksrp_polislogg:GetList', function (source, cb)
	MySQL.Async.fetchAll('SELECT * FROM polis_loggs ORDER BY serie ASC', {}, function (result)
		local logg = {}

		for i=1, #result, 1 do
			table.insert(logg, {
				serie = result[i].serie,
				firstname  = result[i].firstname,
				lastname = result[i].lastname,
				kostnad = result[i].kostnad,
				story = result[i].description,
				date = result[i].date,
				tid = result[i].time
			})
		end

		cb(logg)
	end)
end)

function getIdentity(source, callback)
  local identifier = GetPlayerIdentifiers(source)[1]
  MySQL.Async.fetchAll("SELECT identifier, name, firstname, lastname, dateofbirth, sex, height, lastdigits FROM `users` WHERE `identifier` = @identifier",
  {
    ['@identifier'] = identifier
  },
  function(result)
    if result[1].firstname ~= nil then
      local data = {
        identifier  = result[1].identifier,
        name = result[1].name,
        firstname  = result[1].firstname,
        lastname  = result[1].lastname,
        dateofbirth  = result[1].dateofbirth,
        sex      = result[1].sex,
        height    = result[1].height,
        lastdigits = result[1].lastdigits
      }
      callback(data)
    else
      local data = {
        identifier   = '',
        name = '',
        firstname   = '',
        lastname   = '',
        dateofbirth = '',
        sex     = '',
        height     = ''
      }
      callback(data)
    end
  end)
end

RegisterServerEvent("ksrp_polislogg:AddLogg")
AddEventHandler("ksrp_polislogg:AddLogg", function(serie, story, price)
	local date = os.date("%Y-%m-%d")
	local hour         	 = tonumber(os.date('%H', timestamp))
	local minute         = tonumber(os.date('%M', timestamp))
	local second         = tonumber(os.date('%S', timestamp))
	getIdentity(source, function( data )
	    MySQL.Async.execute('INSERT INTO polis_loggs (serie, firstname, lastname, kostnad, description, date, time) VALUES (@serie, @firstname, @lastname, @kostnad, @description, @date, @time)',
	        {
	        	['@serie']		  = serie,
	            ['@firstname']    = data.firstname,
	            ['@lastname']     = data.lastname,
	            ['@kostnad']	  = price,
	            ['@description']  = story,
	            ['@date']		  = date,
	            ['@time']         = hour .. ':' .. minute .. ':' .. second
	        }
	    )
	        print('[Polismyndighetens loggbok] : Serie = #' .. serie .. ' | Person = ' .. data.firstname .. ' ' .. data.lastname .. ' | Price = ' .. price .. ' | Story = ' .. story .. ' | Date = ' .. date .. ' | Time = ' .. hour .. ':' .. minute .. ':' .. second)
	end)
end)