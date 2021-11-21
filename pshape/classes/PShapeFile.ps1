class PShapeFile {
    PShapeFile($data) {
        if ($data -is [string]) {
            $this.Path = Resolve-Path $data
            $this.Copy = $True
            $this.Process = $True
        }
        elseif ($data -is [hashtable]) {
            $this.Path = Resolve-Path $data.Path
            $this.Copy = $data.Copy ?? $True
            $this.Process = $data.Process ?? $True
        }
        else {
            throw "Invalid 'Files' specification in PShape manifest. $data"
        }
    }

    [string]$Path
    [bool]$Copy
    [bool]$Process

    [string]ToString() {
        return $this.Path
    }
}