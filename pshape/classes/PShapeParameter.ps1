class PShapeParameter
{
    PShapeParameter($Parameter, [Hashtable]$Settings) {
        if ($Parameter -is [hashtable]) {
            $this.Name = $Parameter.Name
            $this.DefaultValue = $Parameter.DefaultValue
            $this.Prompt = $Parameter.Prompt
        }
        else {
            $this.Name = $Parameter.ToString()
        }
        if ($Settings.ContainsKey($this.Name)) {
            $this.DefaultValue = $Settings[$this.Name]
        }
    }

    [string]$Name
    [string]$DefaultValue
    [string]$Prompt

    [string]ToString() {
        return $this.Name
    }
}
