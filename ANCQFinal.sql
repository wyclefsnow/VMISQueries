select VSP.str_VSP_NAME AS VSPName,D.str_DISTRICT_NAME as VSPDistrict, C.str_CLIENT_NAME AS CLIENT_NAME,
DATEDIFF(YY,C.int_CLIENT_BIRTH_DATE,C.dt_CREATED_DATE) AS AGE,A.str_BARCODE AS BARCODE,
Case When A.str_BARCODE like '%A01'  Then 'ANC1' when A.str_BARCODE like '%A02' Then 'ANC2' When A.str_BARCODE like '%A03'  Then 'ANC3' When A.str_BARCODE like '%A04'  Then 'ANC4' Else 'Negative' End AS Visit,
A.dt_VISIT_DATE AS TreatmentDate,A.dt_CLAIM_SUBMITTED AS SUBMISSION_DATE,A.str_GRAVIDA as Gravida, A.str_PARA as PARA,
BD.dt_VOUCHER_SALES_DATE as VoucherSalesDate,VSP.str_FACILITY_LEVEL,

STUFF(REPLACE((select '#!' + LTRIM(RTRIM(DSD.str_RESULT)) AS 'data()' from tbl_HB_ANC_PREGNANCY_RELATED_DETAIL DSD
inner join tbl_PREGNANCY_RELATED_MASTER AS SV on DSD.int_PREGNANCY_RELATED_ID=SV.int_PREGNANCY_RELATED_ID
where  SV.int_PREGNANCY_RELATED_ID=1 and DSD.int_CLAIM_ID = A.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS LNMP,


STUFF(REPLACE((select '#!' + LTRIM(RTRIM(DSD.str_RESULT)) AS 'data()' from tbl_HB_ANC_PREGNANCY_RELATED_DETAIL DSD
inner join tbl_PREGNANCY_RELATED_MASTER AS PRM on DSD.int_PREGNANCY_RELATED_ID=PRM.int_PREGNANCY_RELATED_ID
where  PRM.int_PREGNANCY_RELATED_ID=2 and DSD.int_CLAIM_ID = A.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS EDD,

STUFF(REPLACE((select '#!' + LTRIM(RTRIM(DSD.str_RESULT)) AS 'data()' from tbl_HB_ANC_PREGNANCY_RELATED_DETAIL DSD
inner join tbl_PREGNANCY_RELATED_MASTER AS PRM on DSD.int_PREGNANCY_RELATED_ID=PRM.int_PREGNANCY_RELATED_ID
where  PRM.int_PREGNANCY_RELATED_ID=3 and DSD.int_CLAIM_ID = A.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS GestationPeriod,

STUFF(REPLACE((select '#!' + LTRIM(RTRIM(TD.str_RESULT)) AS 'data()' from tbl_HB_ANC_TEST_DETAIL AS TD
inner join tbl_TEST_MASTER AS TM on TD.int_TEST_ID=TM.int_TEST_ID
where  TM.int_TEST_ID=10960099 and TD.int_CLAIM_ID = A.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS HIV_Test,

STUFF(REPLACE((select '#!' + LTRIM(RTRIM(TD.str_RESULT)) AS 'data()' from tbl_HB_ANC_TEST_DETAIL AS TD
inner join tbl_TEST_MASTER AS TM on TD.int_TEST_ID=TM.int_TEST_ID
where  TM.int_TEST_ID=10960112 and TD.int_CLAIM_ID = A.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS HIV_TestWithSpouse,

Case when IsHIVPositive=1 then 'Yes' when IsHIVPositive=0 Then 'No' else NULL END AS IsHIVPositive,
Case when IsResultReceived=1 then 'Yes' when IsResultReceived=0 Then 'No' else NULL END AS IsResultReceived,
case When IsEMTCTInitiated=0  Then 'Not Inititiated' When IsEMTCTInitiated=1 Then 'Inititated' ELSE NULL End as ARVStatus



from
[dbo].[tbl_HB_ANC_CLAIM_MASTER] as A

left join tbl_CLIENT_MASTER AS C
on A.int_CLIENT_ID=C.int_CLIENT_ID

left join [dbo].[tbl_VOUCHER_SERVICE_PROVIDER_MASTER] as VSP
on A.int_VSP_ID= VSP.int_VSP_ID
left join tbl_DISTRICT_MASTER AS D
on VSP.int_DISTRICT_ID=D.int_DISTRICT_ID
left join tbl_BARCODE_DETAIL as BD
on A.int_BARCODE_DETAIL_ID=BD.int_BARCODE_DETAIL_ID
