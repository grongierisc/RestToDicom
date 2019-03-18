Class Tests.Fw.Mock.CMockResultSet Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter XMLNAME = "Query";

Property strColumnNames As %String(MAXLEN = 1000, XMLNAME = "ColumnsNames", XMLPROJECTION = "ELEMENT") [ Private ];

Property rows As list Of %String(MAXLEN = 5000, XMLNAME = "Row", XMLPROJECTION = "ELEMENT") [ Private ];

Property %ROWCOUNT As %Integer(XMLPROJECTION = "NONE") [ InitialExpression = 0 ];

Method %OnNew(lstRows As %ListOfDataTypes = {##class(%ListOfDataTypes).%New()}) As %Status [ Private, ServerOnly = 1 ]
{
   set ..rows = lstRows
   Quit $$$OK
}

ClassMethod CreateFromXData(xDataName As %String) As Tests.Fw.Mock.CMockResultSet
{
   #Dim customResultSet As Tests.Fw.Mock.CMockResultSet = $$$NULLOREF

   set xData = ##class(%Dictionary.CompiledXData).%OpenId(xDataName)
   set reader = ##class(%XML.Reader).%New()
   if $IsObject(xData) && $$$ISOK(reader.OpenStream(xData.Data))
   {
      do reader.Correlate(..#XMLNAME, ..%ClassName(1))
      do reader.Next(.customResultSet)
   }
   
   quit customResultSet
}

Method Prepare(args...) As %Status
{
   set ..%ROWCOUNT = 0
   quit $$$OK
}

Method Execute(args...) As %Status
{
   set ..%ROWCOUNT = 0
   quit $$$OK
}

/// Advance the result set cursor to the next row. Returns 0 if the cursor is at the end of the 
/// result set.
Method Next(ByRef sc As %Status) As %Integer
{
  
   set ..%ROWCOUNT = ..%ROWCOUNT + 1
   
   quit (..%ROWCOUNT <= ..rows.Count())
}

Method %DispatchGetProperty(pProperty As %String)
{
   #Dim returnValue As %String = ""
   if ((..%ROWCOUNT > 0) && (..%ROWCOUNT <= ..rows.Count()))
   {
      set returnValue = ..GetData($ListFind(..GetColumnNamesList($ZConvert(..strColumnNames, "U")), $ZConvert(pProperty,"U")))
   }
   quit returnValue
}

/// Returns the number of rows in the result set.
Method GetRowCount() As %Integer
{
   quit ..rows.Count()
}

/// Returns the number of columns in the result set.
Method GetColumnCount() As %Integer
{
   quit $ListLength(..GetColumnNamesList(..strColumnNames))
}

/// Returns the name of column <var>nIndex</var> in the result set.
Method GetColumnName(nIndex As %Integer) As %String
{
   #Dim strColumnName As %String = ""
   try 
   {
      set strColumnName = $List(..GetColumnNamesList(..strColumnNames), nIndex)
   }
   catch 
   {
      // $List throws an error if nIndex is 0 or when given an empty list, this is annoying.
   }
   quit strColumnName
}

/// Returns the value of column <var>nIndex</var> in the current row of the result set.
Method GetData(nIndex As %Integer) As %String
{
   #Dim strData As %String = ""
   
   try
   {
      set strData = $List($ListFromString(..rows.GetAt(..%ROWCOUNT), ..GetSeparator()), nIndex)
   }
   catch 
   {
      // $List throws an error if nIndex is 0 or when given an empty list, this is annoying.
   }
   
   quit strData
}

/// Returns the value of column <var>name</var> in the current row of the result set.
Method Get(strName As %String) As %String
{
   #Dim strData As %String = ""
   
   try
   {
      set strData = $List($ListFromString(..rows.GetAt(..%ROWCOUNT), ..GetSeparator()), ..GetIndexByName(strName))
   }
   catch 
   {
      // $List throws an error if nIndex is 0 or when given an empty list, this is annoying.
   }
   
   quit strData
}

// -- Helper --

Method GetSeparator() As %Char [ Private ]
{
   quit $Extract(..strColumnNames, 1, 1)
}

Method GetColumnNamesList(strColumnNames As %String) As %List [ Private ]
{
   quit $ListFromString($Extract(strColumnNames, 2, *), ..GetSeparator())
}

Method GetIndexByName(strName As %String) As %Integer [ Private ]
{
   quit $LISTFIND(..GetColumnNamesList(..strColumnNames),strName)
}

}
