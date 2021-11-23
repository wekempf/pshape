function GetDynamicParameters {
    param (
        [PShapeTemplate]$PShape
    )

    if ($PShape.Parameters) {
        $paramDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        foreach ($param in $PShape.Parameters) {
            $attribute = [System.Management.Automation.ParameterAttribute]::new()
            $attribute.Mandatory = $param.Mandatory
            $attributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()
            $attributeCollection.Add($attribute)
            $dynamicParam = [System.Management.Automation.RuntimeDefinedParameter]::new($param.Name, $param.Type, $attributeCollection)
            $paramDictionary.Add($param.Name, $dynamicParam)
        }

        return $paramDictionary
    }
}
