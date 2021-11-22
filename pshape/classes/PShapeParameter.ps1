class PShapeParameter
{
    PShapeParameter($Parameter, [Hashtable]$Settings) {
        if ($Parameter -is [hashtable]) {
            $this.Name = $Parameter.Name.ToString()
            if ($Parameter.ContainsKey('DefaultValue')) {
                $this.DefaultValue = $Parameter.DefaultValue.ToString()
            }
            if ($Parameter.ContainsKey('Prompt')) {
                $this.Prompt = $Parameter.Prompt.ToString()
            }
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
