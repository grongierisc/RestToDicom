Class Tests.Fw.Mock.CIsNotEqualParamValidator Extends (%RegisteredObject, Tests.Fw.Mock.IMockParamValidator)
{

Property itemToCompare;

Method %OnNew(itemToCompare) As %Status [ Internal ]
{
   set ..itemToCompare = itemToCompare

   quit $$$OK
}

Method Validate(item) As %Status [ Internal ]
{
   #dim status As %Status = $$$ERROR("Equal")
   
   if ($data(item) && $IsObject(item) && $IsObject(..itemToCompare))
   {
      try
      {
         set status = 'item.IsEqual(..itemToCompare)
      }
      catch
      {
         if (item.%Extends("%Collection.AbstractList") && ..itemToCompare.%Extends("%Collection.AbstractList"))
         {
            set:('##class(chs.Fw.EnsExt.Lib.CClassTools).IsEqualList(item, ..itemToCompare)) status = $$$OK
         }
         elseif(..itemToCompare '= item)
         {
            set status = $$$OK
         }
         else
         {
            set status = $$$ERROR("Items are the same.")
         }
      }
   }
   // Else it is a datatype.
   elseif (..itemToCompare '= item)
   {
      set status = $$$OK
   }
   
   quit status
}

Method GetAssertDescription(nIndex As %Integer, strMethodName As %String) As %String [ Internal ]
{
  
   quit "Expected Parameter(" _ nIndex _ ") Not Equal for method: " _ strMethodName _ " Got equal"
}

}
