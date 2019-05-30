Select DC.str_BARCODE AS BARCODE, DC.int_CLAIM_ID ,VSP.str_VSP_NAME AS VSPNAME,D.str_DISTRICT_NAME as VSPDistrict, C.str_CLIENT_NAME,DATEDIFF(YY,C.int_CLIENT_BIRTH_DATE,C.dt_CREATED_DATE) AS AGE,
DC.dt_VISIT_DATE AS TreatmentDate,DC.dt_CLAIM_SUBMITTED AS SubmissionDate,


STUFF(REPLACE((select '#!' + LTRIM(RTRIM(SV.str_SERVICES_NAME)) AS 'data()' from tbl_HB_DELIVERY_SERVICES_DETAIL DSD
inner join [dbo].[tbl_SERVICES_MASTER] AS SV on DSD.int_SERVICES_ID=SV.int_SERVICES_ID
where SV.int_SERVICES_ID in (10360188,10360189,10360190,10360281, 10360282, 10360283) and DSD.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS Delivery_Procedure,

PDD.str_RESULT AS UterotonicsUsed,
STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=1 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS DeliveryDate,
STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=37 and int_CHILD_NO=1 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS DeliveryOutcome1,

STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=4 and PED.int_CHILD_NO=1 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS Sex1,
STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=37 and int_CHILD_NO=2 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS DeliveryOutcome2,
STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=4 and PED.int_CHILD_NO=2 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS Sex2,
STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_CHILD_DETAIL AS PED
inner join tbl_CHILD_DETAIL_MASTER AS PEM on PED.int_CHILD_DETAIL_ID=PEM.int_CHILD_DETAIL_ID
where  PEM.int_CHILD_DETAIL_ID=4 and PED.int_CHILD_NO=3 and PED.int_CLAIM_ID = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS Sex3,
DC.str_PARA as PARA,DC.str_GRAVIDA as GRAVIDA,

Case when DC.Asphyxia_Present=1 THen 'Yes' when DC.Asphyxia_Present=0 THen 'No'END AS Is_Asphyxia_Present,
Case When DC.Resuscitation_done=1 Then 'Yes' When DC.Resuscitation_done=0 Then 'No' End as Resuscitation_done,
Case when DC.Is_Baby_Breastfeeding=1 Then 'Yes' when DC.Is_Baby_Breastfeeding=0 Then 'No' END AS Is_Baby_Breastfeeding,
Case when DC.Breast_Attachment_Done=1 Then 'Yes' when DC.Breast_Attachment_Done=0 Then 'No'END AS Breast_Attachment_Done,


STUFF(REPLACE((select '#!' + LTRIM(RTRIM(PED.str_RESULT)) AS 'data()' from tbl_HB_DELIVERY_TEST_DETAIL AS PED
inner join tbl_TEST_MASTER  AS PEM on PED.int_test_id=PEM.int_TEST_ID
where  PEM.int_TEST_ID=10960099  and PED.int_claim_id = DC.int_CLAIM_ID FOR XML PATH('')),' #!',', '), 1, 2, '') AS HIVTest,

case When isHIVPositive=0  Then 'Negative' When isHIVPositive=1  Then 'Positive' Else NULL End as HIVStatus,
case When DC.IsResultReceived=0  Then 'No' When IsResultReceived=1  Then 'Yes' Else NULL End as HIVresultReceived,
case When isEMTCT=0  Then 'Not Inititiated' When isEMTCT=1 Then 'Inititated' ELSE NULL End as ARVStatus,
case when strEMTCTReason=1 then 'Client in denial/shock/depression following HIV test'
when  strEMTCTReason=2 then 'Facility doesnt provide ARVs'
when  strEMTCTReason=3 then 'ARVs out of stock'
when  strEMTCTReason=4 then 'Already on ART'
when  strEMTCTReason=5 then 'Mother in denial/shock/depressiion following HIV test'
when  strEMTCTReason=6 then 'Facility doesnt provide EID services' ELSE NULL End as strEMTCTReason,

case When isSyrupGiven=1  Then 'YES' When isSyrupGiven=0  Then 'NO' Else Null End as NevirapineGiven,
case when strSyrupReason=2 then 'Facility doesntt provide ARVs'
when strSyrupReason=5 then 'Mother in denial/shock/depressiion following HIV test'
when strSyrupReason=7 then 'Nevirapine syrup out of stock' Else Null End as NevirapinReason

from tbl_HB_DELIVERY_CLAIM as DC

left join tbl_CLIENT_MASTER AS C
on DC.int_CLIENT_ID=C.int_CLIENT_ID

left join [dbo].[tbl_VOUCHER_SERVICE_PROVIDER_MASTER] as VSP
on DC.int_VSP_ID= VSP.int_VSP_ID

left join tbl_DISTRICT_MASTER AS D
on VSP.int_DISTRICT_ID=D.int_DISTRICT_ID


left join tbl_HB_DELIVERY_PRESENT_DELIVERY_DETAIL as PDD
on DC.int_CLAIM_ID=PDD.int_CLAIM_ID and PDD.int_PRESENT_DELIVERY_DETAIL_ID=35

where cast (dc.dt_CREATED_DATE as date) between '2019-05-01' and '2019-05-25'
order by DC.int_CLAIM_ID
