namespace :populate_sys_param18 do
	desc "DWS Local Office to County Mapping"
	task :local_office_to_county_mapping => :environment do
		systemParamCategories = SystemParamCategory.create(description:"DWS Local Office to County Mapping",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"2",value:"1839",description:"Local Office : Arkadelphia and county : Clark",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3",value:"1861",description:"Local Office : Batesville and county : Independence",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3",value:"1862",description:"Local Office : Batesville and county :	Izard",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3",value:"1896",description:"Local Office : Batesville and county :	Sharp",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"3",value:"1898",description:"Local Office : Batesville and county :	Stone",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"4",value:"1891",description:"Local Office : Benton and county :	Saline",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"5",value:"1876",description:"Local Office : Blytheville	and county : Mississippi",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6",value:"1836",description:"Local Office : Camden and county :	Calhoun",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6",value:"1849",description:"Local Office : Camden and county :	Dallas",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6",value:"1881",description:"Local Office : Camden and county :	Ouachita",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"7",value:"1852",description:"Local Office : Conway and county :	Faulkner",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"7",value:"1900",description:"Local Office : Conway and county :	Van Buren",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"8",value:"1899",description:"Local Office : El Dorado and county : Union",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"9",value:"1873",description:"Local Office : Fayetteville and county : Madison",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"9",value:"1901",description:"Local Office : Fayetteville and county : Washington",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"10",value:"1848",description:"Local Office : Forrest City and county : Cross",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"10",value:"1868",description:"Local Office : Forrest City and county : Lee",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"10",value:"1897",description:"Local Office : Forrest City and county : St. Francis",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"11",value:"1846",description:"Local Office : Fort Smith	and county : Crawford",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"11",value:"1853",description:"Local Office : Fort Smith	and county : Franklin",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"11",value:"1871",description:"Local Office : Fort Smith	and county : Logan-1",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"11",value:"1894",description:"Local Office : Fort Smith	and county : Sebastian",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"1834",description:"Local Office : Harrison and county : Boone",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"1837",description:"Local Office : Harrison and county : Carroll",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"1874",description:"Local Office : Harrison and county : Marion",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"1880",description:"Local Office : Harrison and county : Newton",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"12",value:"1893",description:"Local Office : Harrison and county : Searcy",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"13",value:"1877",description:"Local Office : Helena	and county : Monroe",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"13",value:"1883",description:"Local Office : Helena	and county : Phillips",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"13",value:"1888",description:"Local Office : Helena	and county : Prarie",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"14",value:"1858",description:"Local Office : Hope and county : Hempstead",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"14",value:"1860",description:"Local Office : Hope and county : Howard",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"14",value:"1879",description:"Local Office : Hope and county : Nevada",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"15",value:"1855",description:"Local Office : Hot Springs and county : Garland",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"15",value:"1878",description:"Local Office : Hot Springs and county : Montgomery",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"15",value:"1884",description:"Local Office : Hot Springs and county : Pike",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"16",value:"1872",description:"Local Office : Jacksonville and county : Lonoke",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"16",value:"1889",description:"Local Office : Jacksonville and county : Pulaski Jacksonville",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"17",value:"1845",description:"Local Office : Jonesboro and county : Craighead",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"17",value:"1885",description:"Local Office : Jonesboro and county :	Poinsett",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"18",value:"1889",description:"Local Office : Little Rock and county : Pulaski",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"19",value:"1843",description:"Local Office : Magnolia and county : Columbia",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"19",value:"1866",description:"Local Office : Magnolia and county : Lafayette",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"6052",value:"1859",description:"Local Office : Malvern and county :	Hot Spring",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"20",value:"1886",description:"Local Office : Mena and county : Polk",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"20",value:"1892",description:"Local Office : Mena and county : Scott",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"21",value:"1831",description:"Local Office : Monticello	and county : Ashley",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"21",value:"1835",description:"Local Office : Monticello	and county : Bradley",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"21",value:"1838",description:"Local Office : Monticello	and county : Chicot",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"21",value:"1850",description:"Local Office : Monticello	and county : Desha",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"21",value:"1851",description:"Local Office : Monticello	and county : Drew",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"22",value:"1832",description:"Local Office : Mountain Home and county :	Baxter",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"22",value:"1854",description:"Local Office : Mountain Home and county :	Fulton",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"23",value:"1863",description:"Local Office : Newport and county : Jackson",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"23",value:"1903",description:"Local Office : Newport and county : Woodruff",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"24",value:"1840",description:"Local Office : Paragould and county :	Clay",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"24",value:"1857",description:"Local Office : Paragould and county :	Green",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"25",value:"1830",description:"Local Office : Pine Bluff	and county : Arkansas",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"25",value:"1842",description:"Local Office : Pine Bluff	and county : Cleveland",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"25",value:"1856",description:"Local Office : Pine Bluff	and county : Grant",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"25",value:"1864",description:"Local Office : Pine Bluff	and county : Jefferson",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"25",value:"1869",description:"Local Office : Pine Bluff	and county : Lincoln",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"26",value:"1833",description:"Local Office : Rogers	and county : Benton	",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"27",value:"1844",description:"Local Office : Russellville and county : Conway",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"27",value:"1865",description:"Local Office : Russellville and county : Johnson",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"27",value:"1882",description:"Local Office : Russellville and county : Perry",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"27",value:"1887",description:"Local Office : Russellville and county : Pope",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"27",value:"1904",description:"Local Office : Russellville and county : Yell",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"28",value:"1841",description:"Local Office : Searcy	and county : Cleburne",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"28",value:"1902",description:"Local Office : Searcy	and county : White",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"29",value:"1870",description:"Local Office : Texarkana and county :	Little River",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"29",value:"1875",description:"Local Office : Texarkana and county :	Miller",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"29",value:"1895",description:"Local Office : Texarkana and county :	Sevier",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"30",value:"1867",description:"Local Office : Walnut Ridge and county : Lawrence",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"30",value:"1890",description:"Local Office : Walnut Ridge and county : Randolph",created_by: 1,updated_by: 1)
		SystemParam.create(system_param_categories_id:systemParamCategories.id,key:"31",value:"1847",description:"Local Office : West Memphis and county : Crittenden",created_by: 1,updated_by: 1)

	end

end