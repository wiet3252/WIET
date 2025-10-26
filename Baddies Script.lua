local Library = {}

Library.Theme = {
    Background = Color3.fromRGB(30, 30, 35),
    Header = Color3.fromRGB(35, 35, 40),
    TabBackground = Color3.fromRGB(40, 40, 45),
    TabSelected = Color3.fromRGB(60, 60, 70),
    Text = Color3.fromRGB(240, 240, 245),
    TextSecondary = Color3.fromRGB(180, 180, 190),
    Accent = Color3.fromRGB(0, 170, 255),
    ToggleOn = Color3.fromRGB(0, 200, 100),
    ToggleOff = Color3.fromRGB(100, 100, 110),
    SliderTrack = Color3.fromRGB(50, 50, 60),
    SliderFill = Color3.fromRGB(0, 170, 255),
    Button = Color3.fromRGB(50, 120, 220),
    ButtonHover = Color3.fromRGB(70, 140, 240)
}

function Library:CreateWindow(name, size)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name
    screenGui.ResetOnSpawn = false
    
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, size[1], 0, size[2])
    main.Position = UDim2.new(0.5, -size[1]/2, 0.5, -size[2]/2)
    main.BackgroundColor3 = Library.Theme.Background
    main.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = main
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Library.Theme.Header
    header.BorderSizePixel = 0
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Library.Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local tabs = Instance.new("Frame")
    tabs.Name = "Tabs"
    tabs.Size = UDim2.new(1, -30, 0, 30)
    tabs.Position = UDim2.new(0, 15, 0, 45)
    tabs.BackgroundTransparency = 1
    
    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 5)
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -30, 1, -90)
    content.Position = UDim2.new(0, 15, 0, 85)
    content.BackgroundTransparency = 1
    
    header.Parent = main
    title.Parent = header
    tabs.Parent = main
    tabListLayout.Parent = tabs
    content.Parent = main
    screenGui.Parent = game:GetService("CoreGui")
    
    local tabContents = {}
    local currentTab = nil
    
    local window = {
        ScreenGui = screenGui,
        Main = main,
        Tabs = tabs,
        Content = content,
        TabContents = tabContents
    }
    
    function window:CreateTab(name)
        local tabButton = Instance.new("TextButton")
        tabButton.Name = name .. "Tab"
        tabButton.Size = UDim2.new(0, 80, 1, 0)
        tabButton.BackgroundColor3 = Library.Theme.TabBackground
        tabButton.BorderSizePixel = 0
        tabButton.Text = name
        tabButton.TextColor3 = Library.Theme.Text
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = tabButton
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = name .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110)
        tabContent.Visible = false
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        tabButton.MouseButton1Click:Connect(function()
            if currentTab then
                currentTab.Button.BackgroundColor3 = Library.Theme.TabBackground
                currentTab.Content.Visible = false
            end
            
            tabButton.BackgroundColor3 = Library.Theme.TabSelected
            tabContent.Visible = true
            currentTab = {Button = tabButton, Content = tabContent}
        end)
        
        tabButton.Parent = tabs
        tabContent.Parent = content
        
        local tab = {
            Button = tabButton,
            Content = tabContent,
            Window = self
        }
        
        function tab:CreateSection(name)
            local section = Instance.new("Frame")
            section.Name = name .. "Section"
            section.Size = UDim2.new(1, 0, 0, 0)
            section.BackgroundTransparency = 1
            section.LayoutOrder = #tabContent:GetChildren()
            
            local sectionTitle = Instance.new("TextLabel")
            sectionTitle.Name = "Title"
            sectionTitle.Size = UDim2.new(1, 0, 0, 20)
            sectionTitle.Position = UDim2.new(0, 0, 0, 0)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = name
            sectionTitle.TextColor3 = Library.Theme.Text
            sectionTitle.Font = Enum.Font.GothamBold
            sectionTitle.TextSize = 14
            sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local content = Instance.new("Frame")
            content.Name = "Content"
            content.Size = UDim2.new(1, 0, 0, 0)
            content.Position = UDim2.new(0, 0, 0, 25)
            content.BackgroundTransparency = 1
            
            local contentLayout = Instance.new("UIListLayout")
            contentLayout.Padding = UDim.new(0, 8)
            contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            contentLayout.Parent = content
            
            sectionTitle.Parent = section
            content.Parent = section
            section.Parent = tabContent
            
            return {
                Frame = section,
                Content = content
            }
        end
        
        table.insert(tabContents, tab)
        
        if #tabContents == 1 then
            tabButton.BackgroundColor3 = Library.Theme.TabSelected
            tabContent.Visible = true
            currentTab = {Button = tabButton, Content = tabContent}
        end
        
        return tab
    end
    
    return window
end

function Library:CreateToggle(parent, name, default, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = name .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Library.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(0, 50, 0, 24)
    button.Position = UDim2.new(1, -50, 0.5, 0)
    button.AnchorPoint = Vector2.new(1, 0.5)
    button.BackgroundColor3 = default and Library.Theme.ToggleOn or Library.Theme.ToggleOff
    button.BorderSizePixel = 0
    button.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.5, 0)
    buttonCorner.Parent = button
    
    local toggleButton = Instance.new("Frame")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = default and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    toggleButton.AnchorPoint = Vector2.new(0, 0.5)
    toggleButton.BackgroundColor3 = Color3.new(1, 1, 1)
    toggleButton.BorderSizePixel = 0
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0)
    toggleCorner.Parent = toggleButton
    
    local isOn = default or false
    
    local function updateToggle()
        if isOn then
            button.BackgroundColor3 = Library.Theme.ToggleOn
            game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(1, -22, 0.5, 0)
            }):Play()
        else
            button.BackgroundColor3 = Library.Theme.ToggleOff
            game:GetService("TweenService"):Create(toggleButton, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, 0)
            }):Play()
        end
        if callback then callback(isOn) end
    end
    
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        updateToggle()
    end)
    
    label.Parent = toggle
    button.Parent = toggle
    toggleButton.Parent = button
    toggle.Parent = parent
    
    updateToggle()
    
    return {
        Toggle = toggle,
        Set = function(self, value)
            if isOn ~= value then
                isOn = value
                updateToggle()
            end
        end,
        Get = function(self)
            return isOn
        end
    }
end

function Library:CreateSlider(parent, name, min, max, default, callback)
    local slider = Instance.new("Frame")
    slider.Name = name .. "Slider"
    slider.Size = UDim2.new(1, 0, 0, 60)
    slider.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Library.Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Name = "Value"
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(1, -40, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default or min)
    valueLabel.TextColor3 = Library.Theme.TextSecondary
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextSize = 14
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, 4)
    track.Position = UDim2.new(0, 0, 0, 35)
    track.BackgroundColor3 = Library.Theme.SliderTrack
    track.BorderSizePixel = 0
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0.5, 0)
    trackCorner.Parent = track
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Library.Theme.SliderFill
    fill.BorderSizePixel = 0
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = fill
    
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(0, 16, 0, 16)
    button.Position = UDim2.new(0, 0, 0.5, 0)
    button.AnchorPoint = Vector2.new(0, 0.5)
    button.BackgroundColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 0
    button.Text = ""
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0.5, 0)
    buttonCorner.Parent = button
    
    local isDragging = false
    local currentValue = default or min
    
    local function updateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        local ratio = (value - min) / (max - min)
        fill.Size = UDim2.new(ratio, 0, 1, 0)
        button.Position = UDim2.new(ratio, -8, 0.5, 0)
        valueLabel.Text = tostring(math.floor(value))
        if callback then callback(value) end
    end
    
    button.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            local x = math.clamp(mouse.X - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
            local ratio = x / track.AbsoluteSize.X
            local value = math.floor(min + (max - min) * ratio + 0.5)
            updateSlider(value)
        end
    end)
    
    track.MouseButton1Down:Connect(function(x, y)
        local x = math.clamp(x - track.AbsolutePosition.X, 0, track.AbsoluteSize.X)
        local ratio = x / track.AbsoluteSize.X
        local value = math.floor(min + (max - min) * ratio + 0.5)
        updateSlider(value)
    end)
    
    fill.Parent = track
    label.Parent = slider
    valueLabel.Parent = slider
    track.Parent = slider
    button.Parent = slider
    slider.Parent = parent
    
    updateSlider(default or min)
    
    return {
        Slider = slider,
        Set = function(self, value)
            updateSlider(value)
        end,
        Get = function(self)
            return currentValue
        end
    }
end

function Library:CreateButton(parent, name, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = Library.Theme.Button
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = Library.Theme.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Theme.ButtonHover
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Library.Theme.Button
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    button.Parent = parent
    
    return button
end

return Library
