
This site has been acquired by Toptal
(Attention! API endpoint has changed)

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82
83
84
85
86
87
88
89
90
91


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Terrain = Workspace.Terrain
local LocalPlayer = Players.LocalPlayer
local Beams = {}

local Colours = {
    At = ColorSequence.new(Color3.new(1, 0, 0), Color3.new(1, 0, 0)),
    Away = ColorSequence.new(Color3.new(0, 1, 0), Color3.new(0, 1, 0))
}

local function IsBeamHit(Beam: Beam, MousePos: Vector3)

    local Character = LocalPlayer.Character
    local Attachment = Beam.Attachment1

    local Origin = Beam.Attachment0.WorldPosition
    local Direction = MousePos - Origin

    local raycastParms = RaycastParams.new()
    raycastParms.FilterDescendantsInstances = {Character, Workspace.CurrentCamera}
    local RaycastResult = Workspace:Raycast(Origin, Direction * 2, raycastParms) -- // Multiplied by 2 as ray might fall too short
    if (not RaycastResult) then
        Beam.Color = Colours.Away
        Attachment.WorldPosition = MousePos
        return
    end

    if (Character) then
        Beam.Color = RaycastResult.Instance:IsDescendantOf(Character) and Colours.At or Colours.Away
    end

    Attachment.WorldPosition = RaycastResult.Position
end

local function CreateBeam(Character: Model)
    local Beam = Instance.new("Beam", Character)

    Beam.Attachment0 = Character:WaitForChild("Head"):WaitForChild("FaceCenterAttachment")
    Beam.Enabled = Character:FindFirstChild("GunScript", true) ~= nil

    Beam.Width0 = 0.1
    Beam.Width1 = 0.1

    table.insert(Beams, Beam)

    return Beam
end

local function OnCharacter(Character: Model)
    if (not Character) then
        return
    end

    local MousePos = Character:WaitForChild("BodyEffects"):WaitForChild("MousePos")

    local Beam = CreateBeam(Character)

    local Attachment = Instance.new("Attachment", Terrain)
    Beam.Attachment1 = Attachment

    IsBeamHit(Beam, MousePos.Value)
    MousePos.Changed:Connect(function()
        IsBeamHit(Beam, MousePos.Value)
    end)

    Character.DescendantAdded:Connect(function(Descendant)
        if (Descendant.Name == "GunScript") then
            Beam.Enabled = true
        end
    end)

    Character.DescendantRemoving:Connect(function(Descendant)
        if (Descendant.Name == "GunScript") then
            Beam.Enabled = false
        end
    end)
end

local function OnPlayer(Player: Player)
    OnCharacter(Player.Character)
    Player.CharacterAdded:Connect(OnCharacter)
end

for _, v in ipairs(Players:GetPlayers()) do
    OnPlayer(v)
end

Players.PlayerAdded:Connect(OnPlayer)

