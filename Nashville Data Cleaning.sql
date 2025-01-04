CREATE DATABASE Nashville;
USE Nashville;
SELECT *
FROM Nashvile;

--- Standardize Date Format
---The SaleDate column contains date and time stamps. The time stamp could be removed because it only contains 00:00:00.000.
SELECT SaleDate
FROM Nashvile;

ALTER TABLE Nashvile
ADD ConvertedSaleDate DATE;

UPDATE Nashvile
SET ConvertedSaleDate = CAST(SaleDate as DATE) 

SELECT * 
FROM Nashvile;

---Populate Property Address data
---There are 29 rows with null property address.
SELECT *
FROM Nashvile
WHERE PropertyAddress IS NULL
ORDER BY ParcelID

---Using self-join, we could populate the null property address with a property address that had the same ParcelID.
SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
FROM Nashvile a JOIN 
Nashvile b ON 
a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL
ORDER BY a.ParcelID

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Nashvile a JOIN 
Nashvile b ON 
a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

--- Breaking out Address into Individual Columns (Address, City, State)
---The PropertyAddress column contains the address and the city the property is located. 
---We could separate the address and the city into different columns for future analysis purposes.

SELECT
SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress)-1),
SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress) +1,LEN(PropertyAddress))
FROM Nashvile;

ALTER TABLE Nashvile
ADD PropertySplitAddress NVARCHAR(255);

UPDATE Nashvile
SET PropertySplitAddress = SUBSTRING(PropertyAddress ,1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE Nashvile
ADD PropertyCity NVARCHAR(255);

UPDATE Nashvile
SET PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',' ,PropertyAddress) +1,LEN(PropertyAddress))

---We could do the same with the OwnerAddress column which consists of address, 
---city, and state and could be split into new columns that are OwnerSplitAddress, OwnerSplitCity, and OwnerSplitState.

SELECT OwnerAddress
FROM Nashvile;

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Nashvile;

ALTER TABLE Nashvile
ADD OwnerSplitAddress NVARCHAR (255);

UPDATE Nashvile
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

ALTER TABLE Nashvile
ADD OwnerSplitCity NVARCHAR (255);

UPDATE Nashvile
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);

ALTER TABLE Nashvile
ADD OwnerSplitState NVARCHAR (255);

UPDATE Nashvile
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

--- Change Y and N to Yes and No in “Sold as Vacant” field

---There are some inconsistencies in the SoldAsVacant column. We could standardize it to only contain ‘Yes’ and ‘No’ categories.
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Nashvile
GROUP BY SoldAsVacant
ORDER BY 2

UPDATE Nashvile
SET SoldAsVacant=
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
END;
SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
FROM Nashvile
GROUP BY SoldAsVacant
ORDER BY 2



