SELECT * 
FROM [dbo].[housing data]
;

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
FROM [dbo].[housing data];

UPDATE [housing data]
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE [housing data]
ADD SaleDateConverted Date;

UPDATE [housing data]
SET SaleDateConverted =  CONVERT(Date, SaleDate);

SELECT PropertyAddress
FROM [dbo].[housing data]
WHERE PropertyAddress is Null;

SELECT y.ParcelID, y.PropertyAddress, x.ParcelID, x.PropertyAddress, ISNULL(y.PropertyAddress, x.PropertyAddress) 
FROM [dbo].[housing data] y
JOIN [dbo].[housing data] x
	ON y.ParcelID=x.ParcelID
	AND y.[UniqueID ]<>x.[UniqueID ]
WHERE y.PropertyAddress IS NULL;

--SELECT PropertyAddress
--FROM [dbo].[housing data]
--WHERE PropertyAddress IS NULL;

UPDATE y
SET PropertyAddress = ISNULL(y.PropertyAddress, x.PropertyAddress) 
FROM [dbo].[housing data] y
JOIN [dbo].[housing data] x
	ON y.ParcelID=x.ParcelID
	AND y.[UniqueID ]<>x.[UniqueID ]
WHERE y.PropertyAddress IS NULL;

SELECT propertyaddress
FROM [dbo].[housing data];

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',propertyaddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress)) AS Address
FROM [dbo].[housing data];

ALTER TABLE [housing data]
ADD PropsplitAddress NVARCHAR(255);

UPDATE [housing data]
SET PropsplitAddress =  SUBSTRING(PropertyAddress, 1, CHARINDEX(',',propertyaddress)-1);

ALTER TABLE [housing data]
ADD PropsplitCity NVARCHAR(255);

UPDATE [housing data]
SET PropsplitCity =  SUBSTRING(PropertyAddress, CHARINDEX(',',propertyaddress)+1, LEN(PropertyAddress));

SELECT *
FROM [dbo].[housing data];

SELECT OwnerAddress
FROM [dbo].[housing data];

SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
FROM [dbo].[housing data];


ALTER TABLE [housing data]
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE [housing data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3);

ALTER TABLE [housing data]
ADD OwnerSplitCity NVARCHAR(255);

UPDATE [housing data]
SET OwnerSplitCity =  PARSENAME(REPLACE(OwnerAddress, ',', '.'),2);

ALTER TABLE [housing data]
ADD OwnerSplitState NVARCHAR(255);

UPDATE [housing data]
SET OwnerSplitState =  PARSENAME(REPLACE(OwnerAddress, ',', '.'),1);

SELECT DISTINCT(SoldAsVacant), count(SoldAsVacant)
FROM [dbo].[housing data]
GROUP BY SoldAsVacant
ORDER BY 2;


SELECT SoldAsVacant
,CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END
FROM [dbo].[housing data];

UPDATE [housing data]
SET SoldAsVacant= CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE SoldAsVacant
	  END

WITH ROWNUMCTE AS (
SELECT *,
	ROW_NUMBER()OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 Saledate,
				 Legalreference
				 ORDER BY 
					UniqueID
					) row_num				
FROM [dbo].[housing data]
)
SELECT *
FROM ROWNUMCTE
WHERE row_num > 1
--ORDER BY propertyaddress;


ALTER TABLE[dbo].[housing data]
DROP COLUMN owneraddress, taxdistrict, propertyaddress, halfbath

ALTER TABLE[dbo].[housing data]
DROP COLUMN SaleDate;

SELECT *
FROM [dbo].[housing data];





