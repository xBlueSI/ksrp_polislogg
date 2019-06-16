# ksrp_polislogg

----------------------------- *Swedish* -----------------------------

För att trigga kommandot så måste man lägga in detta

----------------------------- *English* -----------------------------

To add a row in the logg you must add the snippet. The snippet is token from row (ish) 2074.

----------------------------- *Snippet* -----------------------------

Around row 2074 from the new esx_policejob
Runt rad 2074 från det senaste esx_policejob

Exempel:
```lua
      ESX.ShowNotification('~b~Polismyndigheten~w~: Händelse ~g~rapporterad~w~ i loggboken')
      TriggerEvent('ksrp_polislogg:AddLoggC', 'N/A', 'Tog ut en ' .. ESX.GetWeaponLabel(data.current.value))
```

----------------------------- *Info* -----------------------------

I prefer you to write in the forum!

My discord: FiskN#3635
