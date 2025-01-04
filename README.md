# Nashville-Housing-data-cleaning
This project is all about data cleaning by use of Microsoft SQL Server
## Project Preview
The Nashville Housing Data is a dataset from a housing project that needs to be cleaned for the purpose of data analysis.Cleaning the data improves the quality of information used for decision making .The tool used for the data cleaning is microsoft sql server.
Here is a snippet of  what I did for the data cleaning;

  - Standardizing date format
  - Populating null property address
  - Breaking property and owner address into new columns
  - Standardizing ‘Yes’ and ‘No’ category
### Standardizing date format
The SaleDate column contains date and time stamps. The time stamp could be removed because it only contains 00:00:00.000.To remove the time stamp I used the CAST function on sql to get the date part only and altered the table to add another column 'ConvertedSaleDate to accomodate the date part.

```sql
ALTER TABLE Nashvile
ADD ConvertedSaleDate DATE;

UPDATE Nashvile
SET ConvertedSaleDate = CAST(SaleDate as DATE) ;
```
### Populating null property address
There are 29 rows with null property address.
Using self-join, we could populate the null property address with a property address that had the same ParcelID.
```sql
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
WHERE a.PropertyAddress IS NULL;
```
### Standardizing 'Yes' and 'No' Category
There are some inconsistencies in the SoldAsVacant column. We could standardize it to only contain ‘Yes’ and ‘No’ categories.
```sql
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
ORDER BY 2;
```


