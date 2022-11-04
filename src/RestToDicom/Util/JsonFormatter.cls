/* Copyright (c) 2019 by InterSystems Corporation.
   Cambridge, Massachusetts, U.S.A.  All rights reserved.
   Confidential property of InterSystems Corporation. */

/// This DataSet ContentHandler outputs the the dataset to the current device as XML
Class RestToDicom.Util.JsonFormatter Extends EnsLib.DICOM.Util.ContentHandler [ Hidden, System = 4 ]
{

Property ElementDataIsLong As %Boolean [ Internal, Private ];

Property ByteOrdering As %Integer [ Internal, Private ];

/// This method is called when the decoding begins
Method StartContent(pTransferSyntax As %String) As %Status
{
	Write "{",!
	
	#; Record the byte-ordering flag
	Set ..ByteOrdering=$Case($$$TRANSFERSYNTAXISLTLENDIAN(pTransferSyntax),1:$$$LTLENDIAN,:$$$BIGENDIAN)
	
	Quit $$$OK
}

/// This method is called when the decoding ends
Method EndContent() As %Status
{
	Write "}",!
	Quit $$$OK
}

/// This method is called when an element starts
Method StartElement(pTag As %Integer, pVR As %String, pItemLength As %Integer) As %Status
{
	#dim tSC As %Status
	#dim tEyeTag,tName,tVR As %String
	
	#; get the tag-info
	Set tSC=##class(EnsLib.DICOM.Util.Encoding).TagInfo(pTag,.tEyeTag,.tVR,.tName)
	$$$ASSERT($$$ISOK(tSC))
	
	do {	
		#; If its pixel data then just write it out
		If pTag=$$$TAGPIXELDATA {
			Write "<element tag="""_tEyeTag_""" vr="""_tVR_""" name="""_tName_""" hidden=""pixel"">",!
		}
		
		#; If its a sequence, write out a sequence start
		If tVR="SQ" Write "<sequence tag="""_tEyeTag_""" name="""_tName_""">",! Quit
		
		#; Set a flag indicatin whether the current data item is long
		Set ..ElementDataIsLong=(pItemLength>$$$ALIGNEDCHUNKLEN)
		
	} while (0)
	
	Quit $$$OK
}

/// This method is called when an element ends
Method EndElement(pTag As %Integer) As %Status
{
	#dim tSC As %Status
	#dim tEyeTag,tName,tVR As %String
	
	do {
	
		#; Get the tag-info
		Set tSC=##class(EnsLib.DICOM.Util.Encoding).TagInfo(pTag,.tEyeTag,.tVR,.tName)
		$$$ASSERT($$$ISOK(tSC))
		
		#; If its pixel data, write out end
		If pTag=$$$TAGPIXELDATA {
        Write "}",!
		}
	
		#; If its a sequence, write out a sequence end
        If tVR="SQ" Write "}",! Quit
		
	} while (0)
	Quit $$$OK
}

/// This method is called when data is seen
Method Data(pTag As %Integer, pChunkNumber As %Integer, pValue As %String) As %Status
{
	#dim tSC As %Status = $$$OK
	#dim tEyeTag,tHandle,tName,tValue,tVR As %String
	
	do {
		
		#; If its pixel data, closed element tag has already been written out
		If pTag=$$$TAGPIXELDATA Quit
		
		#; Only interested in the first chunk because we are not going to write out long data anyway
		If (pChunkNumber=1) {
		
			#; Get the eye-readble tag and name
			Set tSC=##class(EnsLib.DICOM.Util.Encoding).TagInfo(pTag,.tEyeTag,.tVR,.tName)
			$$$ASSERT($$$ISOK(tSC))
	
			#; If the data element is long, indicate so
			If ..ElementDataIsLong {
				Write "<element tag="""_tEyeTag_""" vr="""_tVR_""" name="""_tName_""" hidden=""long""/>",!
			} else {
			
				#; Decode the value to some sort of eye readable format
				Set tSC=##class(EnsLib.DICOM.Util.Encoding).DICOM2CACHE(..ByteOrdering,tVR,pValue,.tValue)
				$$$ASSERT($$$ISOK(tSC))
			
				#; If its binary data then say so
				If '$$$ISTEXTVR(tVR) {
					Write "<element tag="""_tEyeTag_""" vr="""_tVR_""" name="""_tName_""" hidden=""non-textual""/>",!
				} else {
					
					#; Convert and output
					
					Write "<element tag="""_tEyeTag_""" vr="""_tVR_""" name="""_tName_""">"
		
					Set tHandle="" Write $ZCVT(tValue,"O","XML",tHandle)
					While tHandle'="" {
						Write $ZCVT(tHandle,"O","XML",tHandle)
					}
				
					Write "</element>",!
				}	
			}
		}
	} while (0)
	Quit $$$OK
}

Method ShouldStopDecomposition(pTag As %Integer) As %Boolean
{
	#; We don't want to Stop Decomposition
	Quit 0
}

/// This method is called when an item ends
Method EndItem(pTag As %Integer, pItemLength As %Integer) As %Status
{
	If pTag=$$$TAGPIXELDATA {
		Write "</pixel-item>",!
	} else {
		Write "</item>",!
	}
	Quit $$$OK
}

/// This method is called when an item starts
/// pItemLength is passed as $$$UNDEFINEDLENGTH for a delimited item
Method StartItem(pTag As %Integer, pItemLength As %Integer) As %Status
{
	If pItemLength=$$$UNDEFINEDLENGTH Set pItemLength="undefined"
	
	If pTag=$$$TAGPIXELDATA {
		Write "<pixel-item length="""_pItemLength_""">",!
	} else {
		Write "<item length="""_pItemLength_""">",!
	}
	Quit $$$OK
}

}
