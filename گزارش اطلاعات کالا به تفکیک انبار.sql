SELECT
I.Name AS [نام کالا],
IT.ITEMNAME [نام کالا در صندوق],
I.Barcode [بارکد],
I.AllBarcode [بارکدها],
DD.Name  [دپارتمان],
DF.Name [فمیلی] ,
I.DepartmentName [ساب فمیلی],
DSection.Name [سکشن],
DDA.Name [گروه مالیاتی],
I.UnitOfMeasure [واحد اندازه گیری],
LEN(IT.ItemName) [طول کارکتر نام در صندوق],
i.SupplierName [تامین کننده],
U2.DisplayName [کاربر ایجاد کننده],
C2.DATE [تاریخ ایجاد],
U.DisplayName [کاربر ویرایش کننده],
C.Date AS [تاریخ ویرایش],
CAST(CAST(I.ModifyDate AS TIME ) AS nvarchar(8)) [ساعت ویراش ],
Format(IC.BOXCOUNT,'#.##') [تعداد در کارتن],
--SCI.Amount AS N'قیمت خرید',
i.Brand [برند],
S.Name [نام انبار],
I.Status [وضعیت],
--ISS.AllowSale [اجازه فروش],
CASE WHEN ISS.AllowSale = '1'
 THEN N'دارد' 
  ELSE N'ندارد'
   END AS [اجازه فروش],
--ISS.AllowRecieve [اجازه دریافت],
CASE WHEN ISS.AllowRecieve = '1'
 THEN N'دارد'
  ELSE N'ندارد'
   END AS [اجازه دریافت],
--ISS.AllowOrder [اجازه سفارش],
CASE WHEN ISS.AllowOrder = '1'
THEN N'دارد'
ELSE N'ندارد'
END AS [اجازه سفارش],
--ISS.AllowReturn [اجازه مرجوع]
CASE WHEN ISS.AllowReturn ='1'
THEN N'دارد'
ELSE N'ندارد'
END AS [اجازه مرجوع]

FROM dbo.ItemForMobileView I
LEFT JOIN Department DSF
 ON DSF.DepartmentID=I.DepartmentID

LEFT JOIN Department  DF 
 ON DSF.ParentID=DF.DepartmentID

LEFT JOIN Department  DSection 
 ON DF.ParentID=DSection.DepartmentID

LEFT JOIN Department DD
 ON DSection.ParentID=DD.DepartmentID

LEFT JOIN ItemDepartmentAssignment IDA
 ON IDA.ItemID = I.ItemID
  AND IDA.TypeID = 3

LEFT JOIN Department DDA
ON DDA.DepartmentID = IDA.DepartmentID

LEFT JOIN [USER] U
  ON  I.ModifyUser = U.UserID
  
LEFT JOIN [USER] U2
  ON  I.CreationUser = U2.UserID
  
LEFT JOIN Calendar C
  ON C.BusinessDate = CAST(I.ModifyDate AS DATE)
  AND C.LanguageID = I.LanguageID

LEFT JOIN Calendar C2
  ON C2.BusinessDate = CAST(i.creationdate AS DATE)
  AND C2.LanguageID = I.LanguageID

LEFT JOIN ItemTranslations IT
 ON IT.ITEMID=I.ITEMID

LEFT JOIN ItemStockState ISS
 ON ISS.ItemID = I.ItemID

LEFT JOIN Stock S
 ON S.StockID = ISS.StockID

  --INNER JOIN SupplierContractLineItems SCI
 --ON SCI.ItemID = ISS.ItemID

LEFT JOIN ItemCustomField IC
 ON I.ItemID = IC.ItemID

 AND ISNULL(IT.LanguageID,314) = 314
WHERE ISNULL(IT.LanguageID,314) = 314
AND ISNULL(I.LanguageID,314) = 314
--AND DD.DepartmentID='CD26BB7C-9601-42F1-BC3D-15F19D479437'
AND I.ItemID IN ($ItemID)
--AND ISS.StockID IN  ($StockID)
