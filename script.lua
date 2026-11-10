local plr = game:GetService("Players").LocalPlayer;
local rs = game:GetService("ReplicatedStorage");
local run = game:GetService("RunService");
local input = rs:WaitForChild("Remotes"):WaitForChild("SkillCheckInput");
local detect, kill;
local c = 0;
for i, v in pairs(getgc(true)) do
	c += 1
	if ((c % 500) == 0) then
		task.wait();
	end
	if (type(v) == "table") then
		local df = rawget(v, "Detected");
		local kf = rawget(v, "Kill");
		if ((type(df) == "function") and not detect) then
			detect = df;
			hookfunction(detect, function()
				return true;
			end);
		end
		if (rawget(v, "Variables") and rawget(v, "Process") and (type(kf) == "function") and not kill) then
			kill = kf;
			hookfunction(kill, function()
			end);
		end
		if (pcall(function()
			return rawget(v, "indexInstance");
		end) and (type(rawget(v, "indexInstance")) == "table") and (rawget(v, "indexInstance")[1] == "kick")) then
			v.tvk = {"kick",function()
				return workspace:WaitForChild("");
			end};
		end
	end
end
if detect then
	local old = hookfunction(getrenv().debug.info, newcclosure(function(...)
		if ((...) == detect) then
			return coroutine.yield(coroutine.running());
		end
		return old(...);
	end));
end
local flags = {"CHECKER_1","CHECKER","OneMoreTime","checkingSPEED","PERMAIDBAN","BANREMOTE","FORCEFIELD","TeleportDetect"};
local oldNC;
oldNC = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
	local m = getnamecallmethod();
	local a = {...};
	if ((m == "FireServer") and table.find(flags, a[1])) then
		return;
	end
	if ((m == "Kick") and (self == plr)) then
		return;
	end
	if ((m == "FireServer") and (self == input)) then
		if (type(a[2]) == "boolean") then
			a[2] = true;
		end
		return oldNC(self, table.unpack(a));
	end
	return oldNC(self, ...);
end));
local active = true;
local cd = 0;
local btn = nil;
run.RenderStepped:Connect(function()
	if (not active or ((tick() - cd) < 0.05)) then
		return;
	end
	pcall(function()
		local gui = plr:FindFirstChild("PlayerGui");
		if not gui then
			return;
		end
		if (btn and btn.Parent and btn.Parent.Visible) then
			firesignal(btn.MouseButton1Down);
			cd = tick();
			return;
		end
		for _, obj in pairs(gui:GetDescendants()) do
			if (obj:IsA("ImageButton") and obj.Visible) then
				local p = obj.Parent;
				if (p and p:IsA("ImageLabel") and p.Visible) then
					if (p:FindFirstChild("Slider") and p:FindFirstChild("Bar")) then
						btn = obj;
						firesignal(obj.MouseButton1Down);
						cd = tick();
						break;
					end
				end
			end
		end
	end);
end);
