let
    getAmoFn = (domen as text, login as text, hash as text,  limits as nullable number) =>

	let

		authKey = "?USER_LOGIN="&login&"&USER_HASH="&hash,
		authUrl = "https://"&domen&".amocrm.ru/private/api/auth.php",

		generateList = List.Generate(()=>0, each _ < limits, each _ + 500),
		listToTable = Table.FromList(generateList, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
		numberToText = Table.TransformColumnTypes(listToTable,{{"Column1", type text}}),

		getFn = (limitOffset as text) =>
		let
			url =  "https://"&domen&".amocrm.ru/private/api/v2/json/leads/list",
			limits = "&limit_rows=500&limit_offset="&limitOffset,
			getAuth = Xml.Tables(Web.Contents(authUrl&authKey)),
			authTrue = Table.TransformColumnTypes(getAuth,{{"auth", type logical}}),
			getQuery  = Json.Document(Web.Contents(url&authKey&limits))
		in
			getQuery,
			
		getFnToTable = Table.AddColumn(numberToText, "Custom", each Function.InvokeAfter( ()=> getFn([Column1]), #duration(0,0,0,4) ) )
		
	in
		getFnToTable

in
    getAmoFn