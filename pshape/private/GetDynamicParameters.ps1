function GetDynamicParameters {
    param (
        [PShapeTemplate]$PShape
    )

    if ($PShape.Parameters) {
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        foreach ($param in $PShape.Parameters) {
            $parameterAttribute = [System.Management.Automation.ParameterAttribute]::new()
            $parameterAttribute.Mandatory = $param.Mandatory
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $attributeCollection.Add($parameterAttribute)
            if ($param.ValidateSet) {
                $validateSetAttribute = [ValidateSet]::new($param.ValidateSet)
                $attributeCollection.Add($validateSetAttribute)
            }
            $dynamicParam = [System.Management.Automation.RuntimeDefinedParameter]::new($param.Name, $param.Type, $attributeCollection)
            $paramDictionary.Add($param.Name, $dynamicParam)
        }

        return $paramDictionary
    }
}
