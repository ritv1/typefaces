local Typeface = {  }

--[[ Compatibility Check ]] do
	Typeface.Incompatible		= function() Typeface.Denied = true end

	getcustomasset 			= getcustomasset or Typeface.Incompatible()
	base64_decode 			= base64_decode or crypt and crypt.base64decode or Typeface.Incompatible()
end

-- // Variables
local Http = cloneref and cloneref(game:GetService 'HttpService') or game:GetService 'HttpService'

-- // Tables
Typeface.Typefaces = {  }
Typeface.WeightNum = { 
	["Thin"] = 100,

	["ExtraLight"] = 200, 
	["UltraLight"] = 200,

	["Light"] = 300,

	["Normal"] = 400,
	["Regular"] = 400,

	["Medium"] = 500,

	["SemiBold"] = 600,
	["DemiBold"] = 600,

	["Bold"] = 700,

	["ExtraBold"] = 800,

	["UltraBold"] = 900,
	["Heavy"] = 900
}

-- // Functions
function Typeface:Register(Path, Asset)
	if Typeface.Denied then return warn("Executor is Incompatible For Custom Typeface") end

	local Directory = `{ Path or "" }/{ Asset.name }`
	local Name = `{ Asset.name }{ Asset.weight }{ Asset.style }`

    if not isfolder(Directory) then
        makefolder(Directory)
    end

    if not isfile(`{ Directory }/{ Name }.font`) then
		writefile(`{ Directory }/{ Name }.font`, game:HttpGet(Asset.link))
	end

    if not isfile(`{ Directory }/{ Asset.name }Families.json`) then 
		local Data = { 
			name = `{ Asset.weight } { Asset.style }`,
			weight = Typeface.WeightNum[Asset.weight] or Typeface.WeightNum[string.gsub(Asset.weight, "%s+", "")],
			style = string.lower(Asset.style),
			assetId = getcustomasset(`{ Directory }/{ Name }.font`)
		 }
		
		local JSONFile = Http:JSONEncode({ name = Asset.name, faces = { Data } })

		writefile(`{ Directory }/{ Asset.name }Families.json`, JSONFile)
	else
		local JSONFile = Http:JSONDecode(readfile(`{ Directory }/{ Asset.name }Families.json`))

		local Data = { 
			name = `{ Asset.weight } { Asset.style }`,
			weight = Typeface.WeightNum[Asset.weight] or Typeface.WeightNum[string.gsub(Asset.weight, "%s+", "")],
			style = string.lower(Asset.style),
			assetId = getcustomasset(`{ Directory }/{ Name }.font`)
		 }

		table.insert(JSONFile.faces, Data)
		JSONFile = Http:JSONEncode({ name = Asset.name, faces = { Data } })

		writefile(`{ Directory }/{ Asset.name }Families.json`, JSONFile)
	end

	Typeface.Typefaces[Name] = Typeface.Typefaces[Name] or Font.new(getcustomasset(`{ Directory }/{ Asset.name }Families.json`))
    return Typeface.Typefaces[Name]
end

return Typeface
