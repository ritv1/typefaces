local Typeface = {}

--[[ Compatibility Check ]] do
	Typeface.Incompatible 	= function() Typeface.Denied = true end

	getcustomasset 			= getcustomasset or Typeface.Incompatible()
	base64_decode 			= base64_decode or crypt and crypt.base64decode or Typeface.Incompatible()
end

-- // Variables
local Http = cloneref and cloneref(game:GetService 'HttpService') or game:GetService 'HttpService'

-- // Tables
Typeface.Typefaces = {}
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
	["Heavy"] = 900,
}

function Typeface:Register(Path, Asset)
	if Typeface.Denied then return warn("Executor is Incompatible For Custom Typeface") end

	local Directory =  `{Path or ""}/{Asset.name}`

    if not isfile(`{Directory}/{Asset.name}.ttf`) then 
		writefile(`{Directory}/{Asset.name}.ttf`, Asset.ttf)
	end

    if not isfile(`{Directory}/Families.json`) then 
		local Data = {
			name = `{Asset.Weight} {Asset.Style}`,
			weight = Typeface.WeightNum[Asset.Weight] or Typeface.WeightNum[string.gsub(Asset.Weight, "%s+", "")],
			style = string.lower(Asset.Style),
			assetId = getcustomasset(`{Directory}/{Asset.name}.ttf`)
		}
		
		local JSONFile = Http:JSONEncode({name = Asset.real_name, faces = {Data}})

		writefile(`{Directory}/Families.json`, JSONFile)
	else
		local JSONFile = Http:JSONDecode(readfile(`{Directory}/Families.json`))

		local Data = {
			name = `{Asset.Weight} {Asset.Style}`,
			weight = Typeface.WeightNum[Asset.Weight] or Typeface.WeightNum[string.gsub(Asset.Weight, "%s+", "")],
			style = string.lower(Asset.Style),
			assetId = getcustomasset(`{Directory}/{Asset.name}.ttf`)
		}

		table.insert(JSONFile.faces, Data)
		JSONFile = Http:JSONEncode({name = Asset.real_name, faces = {Data}})

		writefile(`{Directory}/Families.json`, JSONFile)
	end

	Typeface.Typefaces[Asset.name] = Typeface.Typefaces[Asset.name] or {}
	Typeface.Typefaces[Asset.name][Asset.weight]

    return Font.new(getcustomasset(`{Directory}/Families.json`))
end

return Typeface
