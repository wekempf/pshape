class PShapeParameter
{
    PShapeParameter($Parameter, [Hashtable]$Settings) {
        if ($Parameter -is [hashtable]) {
            $this.Name = $Parameter.Name
            if ($Parameter.ContainsKey('DefaultValue')) {
                $this.DefaultValue = $Parameter.DefaultValue
            }
            if ($Parameter.ContainsKey('Prompt')) {
                $this.Prompt = $Parameter.Prompt.ToString()
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
    [string]$Prompt
    [bool]$Mandatory
    [Type]$Type

    [string]ToString() {
        return $this.Name
    }
}
