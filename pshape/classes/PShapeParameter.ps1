class PShapeParameter
{
    PShapeParameter($Parameter, [Hashtable]$Settings) {
        if ($Parameter -is [hashtable]) {
            $this.Name = $Parameter.Name
            if ($Parameter.ContainsKey('DefaultValue')) {
                $this.DefaultValue = $Parameter.DefaultValue
            }
            if ($Parameter.ContainsKey('Mandatory')) {
                $this.Mandatory = $Parameter.Mandatory
            }
            else {
                $this.Mandatory = $False
            }
            if ($Parameter.ContainsKey('Type')) {
                $this.Type = $Parameter.Type
            }
            else {
                $this.Type = [string]
            }
            if ($Parameter.ContainsKey('ValidateSet')) {
                $this.ValidateSet = $Parameter.ValidateSet -split ',' | ForEach-Object { $_.Trim() }
            }
        }
        else {
            $this.Name = $Parameter.ToString()
            $this.Mandatory = $False
            $this.Type = [string]
        }

        if ($Settings.ContainsKey($this.Name)) {
            $this.DefaultValue = $Settings[$this.Name]
        }
    }

    [string]$Name
    [object]$DefaultValue
    [bool]$Mandatory
    [Type]$Type
    [string[]]$ValidateSet

    [string]ToString() {
        return $this.Name
    }
}
