$script:MockSettings = @{}
Mock -ModuleName PShape ReadSettings { return $script:MockSettings }
Mock -ModuleName PShape SaveSettings { $script:MockSettings = $Settings }
