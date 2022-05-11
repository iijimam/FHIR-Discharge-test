Class Sample.FHIR.Utils
{

/// in : データ変換後のJSON
ClassMethod Validate(in As %DynamicObject) As %Status
{
	#dim ex As %Exception.AbstractException
	set tSC=$$$OK
	try {
		set schema = ##class(HS.FHIRServer.Schema).LoadSchema("HL7v40")
		set resourceValidator = ##class(HS.FHIRServer.Util.ResourceValidator).%New(schema)
		do resourceValidator.ValidateResource(in) 
	}catch ex {
		set tSC=ex.AsStatus()
	}
	quit tSC
}

ClassMethod PDFBase64Encode(file As %String) As %Status
{
	#dim ex As %Exception.AbstractException
	set st=$$$OK
	try {
		if '##class(%File).Exists(file) {
			throw ##class(%Exception.General).%New(5001,"ファイルが存在しません")
		}
		set fo=##class(%Stream.FileBinary).%New()
		$$$ThrowOnError(fo.LinkToFile(file))
		
		//20000ずつ区切ってReadする
		set cn=(fo.Size\20000)+1
		for i=1:1:cn {
			set ^PDFBase64Encode(i)=fo.Read(20000)
		}
	}
	catch ex {
		set st=ex.AsStatus()
	}
	return st
}

ClassMethod PDFBase64Decode(file As %String) As %Status
{
	#dim ex As %Exception.AbstractException
	set st=$$$OK
	try {
		set fo=##class(%Stream.FileBinary).%New()
		$$$ThrowOnError(fo.LinkToFile(file))
		
		//添え字の分だけRead()してWrite()する
		set sub1=""
		for {
			set sub1=$order(^PDFBase64Encode(sub1))
			if sub1="" {
				quit
			}
			do fo.Write($system.Encryption.Base64Decode($get(^PDFBase64Encode(sub1))))
		}
		$$$ThrowOnError(fo.%Save())
		
	}
	catch ex {
		set st=ex.AsStatus()
	}
	return st
}

}
