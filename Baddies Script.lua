
local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

Library.Theme = {
    Primary = Color3.fromRGB(44, 120, 224),
    Secondary = Color3.fromRGB(35, 35, 35),
    Text = Color3.fromRGB(255, 255, 255),
    Accent = Color3.fromRGB(0, 200, 100),
    Dark = Color3.fromRGB(25, 25, 25),
    Light = Color3.fromRGB(200, 200, 200)
}

function Library:CreateScreen(name)
    local screen = Instance.new("ScreenGui")
    screen.Name = name or "UILibrary"
    screen.ResetOnSpawn = false
    screen.IgnoreGuiInset = true
    
    local elements = {}
    
    function screen:CreateWindow(name, size, position)
        local window = Instance.new("Frame")
        window.Name = name
        window.Size = UDim2.new(0, size[1], 0, size[2])
        window.Position = UDim2.new(0, position[1], 0, position[2])
        window.BackgroundColor3 = Library.Theme.Secondary
        window.BorderSizePixel = 0
        window.ClipsDescendants = true
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = window
        
        local shadow = Instance.new("UIStroke")
        shadow.Color = Color3.new(0, 0, 0)
        shadow.Transparency = 0.8
        shadow.Thickness = 2
        shadow.Parent = window
        
        elements[name] = window
        window.Parent = screen
        return window
    end
    
    function screen:CreateButton(name, size, position, parent, text)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(0, size[1], 0, size[2])
        button.Position = UDim2.new(0, position[1], 0, position[2])
        button.BackgroundColor3 = Library.Theme.Primary
        button.TextColor3 = Library.Theme.Text
        button.Text = text or "Button"
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = button
        
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)
        
        button.Parent = parent or screen
        elements[name] = button
        return button
    end
    
    function screen:CreateSlider(name, size, position, parent, min, max, default, callback)
        local slider = Instance.new("Frame")
        slider.Name = name
        slider.Size = UDim2.new(0, size[1], 0, size[2])
        slider.Position = UDim2.new(0, position[1], 0, position[2])
        slider.BackgroundColor3 = Library.Theme.Dark
        slider.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = slider
        
        local fill = Instance.new("Frame")
        fill.Name = "Fill"
        fill.Size = UDim2.new(0, 0, 1, 0)
        fill.Position = UDim2.new(0, 0, 0, 0)
        fill.BackgroundColor3 = Library.Theme.Accent
        fill.BorderSizePixel = 0
        fill.Parent = slider
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(1, 0)
        fillCorner.Parent = fill
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Name = "Value"
        valueLabel.Size = UDim2.new(1, 0, 1, 0)
        valueLabel.Position = UDim2.new(0, 0, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(default or min)
        valueLabel.TextColor3 = Library.Theme.Text
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 12
        valueLabel.Parent = slider
        
        local dragging = false
        
        local function updateSlider(input)
            local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * x)
            fill.Size = UDim2.new(x, 0, 1, 0)
            valueLabel.Text = tostring(value)
            if callback then callback(value) end
        end
        
        slider.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        slider.Parent = parent or screen
        elements[name] = slider
        return slider
    end
    
    function screen:CreateTab(name, size, position, parent)
        local tab = Instance.new("TextButton")
        tab.Name = name
        tab.Size = UDim2.new(0, size[1], 0, size[2])
        tab.Position = UDim2.new(0, position[1], 0, position[2])
        tab.BackgroundColor3 = Library.Theme.Secondary
        tab.TextColor3 = Library.Theme.Text
        tab.Text = name
        tab.Font = Enum.Font.GothamBold
        tab.TextSize = 14
        tab.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = tab
        
        local content = Instance.new("Frame")
        content.Name = name .. "Content"
        content.Size = UDim2.new(1, 0, 1, 0)
        content.Position = UDim2.new(1, 10, 0, 0)
        content.BackgroundTransparency = 1
        content.Visible = false
        content.Parent = parent or screen
        
        tab.MouseButton1Click:Connect(function()
            for _, v in pairs(tab.Parent:GetChildren()) do
                if v:IsA("TextButton") and v ~= tab then
                    v.BackgroundColor3 = Library.Theme.Secondary
                    if v:FindFirstChild(v.Name .. "Content") then
                        v[v.Name .. "Content"].Visible = false
                    end
                end
            end
            tab.BackgroundColor3 = Library.Theme.Primary
            content.Visible = true
        end)
        
        tab.Parent = parent or screen
        elements[name] = {Tab = tab, Content = content}
        return tab, content
    end
    
    function screen:CreateLabel(name, size, position, parent, text)
        local label = Instance.new("TextLabel")
        label.Name = name
        label.Size = UDim2.new(0, size[1], 0, size[2])
        label.Position = UDim2.new(0, position[1], 0, position[2])
        label.BackgroundTransparency = 1
        label.TextColor3 = Library.Theme.Text
        label.Text = text or name
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent or screen
        elements[name] = label
        return label
    end
    
    function screen:Toggle(visible)
        screen.Enabled = visible ~= false
    end
    
    function screen:Destroy()
        for _, v in pairs(elements) do
            if typeof(v) == "table" and v.Destroy then
                v:Destroy()
            end
        end
        screen:Destroy()
    end
    
    return screen
end

return Library
