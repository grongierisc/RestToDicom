Class Tests.Fw.Mock.CMockBase Extends %RegisteredObject [ StorageStrategy = "" ]
{

Property mockManager As Tests.Fw.Mock.CMockManager [ Private ];

Method %OnNew(mockManager As Tests.Fw.Mock.CMockManager) As %Status [ Internal ]
{
   set ..mockManager = mockManager
   
   quit $$$OK
}

/// Since the return type is unknown we cant't specify %RegisteredObject or %DataType as the return value.
Method %DispatchMethod(strMethod As %String, args...) [ Internal ]
{
   #dim returnValue
   #dim lstparams = ..TransformArgsToList(args...)
   if (..mockManager.IsInReplayMode())
   {
      set returnValue = ..mockManager.MethodCalled($THIS,
                                                   strMethod,
                                                  .lstparams)
                                                  
      #dim nIndex As %Integer = 0
      for nIndex = 1:1:$get(args, 0)
      {
         set args(nIndex) = lstparams.GetAt(nIndex)
      }
   }
   else
   {
      set returnValue = ..mockManager.CreateExpectation($THIS,
                                                        strMethod,
                                                        lstparams)
   }
   
   quit returnValue
}

/// Is used to get the value of an unknown property.
Method %DispatchGetProperty(Property As %String) [ ServerOnly = 1 ]
{
   quit ..%DispatchMethod(Property_"Get")
}

/// is used to set the value of an unknown property.
Method %DispatchSetProperty(Property As %String, Val) [ ServerOnly = 1 ]
{
   quit ..%DispatchMethod(Property_"Set", Val)
}

ClassMethod TransformArgsToList(args...) As %List
{
   // Create a %ListOfDataTypes even though it may contain objects. This has been tested and works.
   #dim listArgs = ##class(%ListOfDataTypes).%New()
   #dim i AS %Integer
   for i = 1 : 1 : $get(args, 0)
   {
      do listArgs.Insert($get(args(i)))
   }
   
   quit listArgs
}

}
