@IsTest
public class zTest_TFCollectionPartsDocument {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"id\": \"53f568df-61c8-461a-805b-fe04e5f4b689\",'+
		'    \"parts\": ['+
		'        {'+
		'            \"id\": \"e4ccf1fd-3614-4cfd-b225-601bfececd83\",'+
		'            \"type\": \"Chapter\",'+
		'            \"isAccessibleForFree\": false,'+
		'            \"isPartOf\": ['+
		'                {'+
		'                    \"title\": \"Ukrainian Erotomaniac Fictions: First Postindependence Wave\",'+
		'                    \"format\": \"e-Book\",'+
		'                    \"edition\": \"1\",'+
		'                    \"editionId\": \"664493\",'+
		'                    \"doi\": \"10.4324/9781351022187\",'+
		'                    \"isbn\": \"9781351022187\",'+
		'                    \"publishedDate\": \"\",'+
		'                    \"contributors\": ['+
		'                        {'+
		'                            \"roles\": ['+
		'                                \"author\"'+
		'                            ],'+
		'                            \"givenName\": \"Maryna\",'+
		'                            \"familyName\": \"Romanets\",'+
		'                            \"email\": null,'+
		'                            \"bio\": \"Maryna Romanets is a Professor in the Department of English at the University of Northern British Columbia, Canada. She is the author of Anamorphosic Texts and Reconfigured Visions: Improvised Traditions in Contemporary Ukrainian and Irish Literature and coeditor of Beauty, Violence, Representation.\",'+
		'                            \"orcid\": null,'+
		'                            \"affiliation\": [],'+
		'                            \"collab\": null,'+
		'                            \"fullName\": \"Maryna Romanets\",'+
		'                            \"position\": 1'+
		'                        }'+
		'                    ],'+
		'                    \"id\": \"9c43274c-92ee-4347-94a0-1c98e5f76986\",'+
		'                    \"type\": \"Book\"'+
		'                }'+
		'            ],'+
		'            \"openAccess\": false,'+
		'            \"pageEnd\": \"42\",'+
		'            \"pageStart\": \"24\",'+
		'            \"position\": 1,'+
		'            \"title\": \"Nationalist-Masochist Woman, Impotent Man, and Counter-Erotics: Pol′ovi doslidzhennia z ukraïns′koho seksu [Fieldwork in Ukrainian sex]\",'+
		'            \"contributors\": ['+
		'                {'+
		'                    \"roles\": ['+
		'                        \"author\"'+
		'                    ],'+
		'                    \"givenName\": \"Maryna\",'+
		'                    \"familyName\": \"Romanets\",'+
		'                    \"email\": null,'+
		'                    \"bio\": \"Maryna Romanets is a Professor in the Department of English at the University of Northern British Columbia, Canada. She is the author of Anamorphosic Texts and Reconfigured Visions: Improvised Traditions in Contemporary Ukrainian and Irish Literature and coeditor of Beauty, Violence, Representation.\",'+
		'                    \"orcid\": null,'+
		'                    \"affiliation\": [],'+
		'                    \"collab\": null,'+
		'                    \"fullName\": \"Maryna Romanets\",'+
		'                    \"position\": 1'+
		'                }'+
		'            ]'+
		'        }'+
		'    ]'+
		'}';
		TFCollectionPartsDocument obj = TFCollectionPartsDocument.parse(json);
		System.assert(obj != null);
	}
}