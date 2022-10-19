--Data Cleaning Project in SQL 
--Let us create a table and columns in SQl for our data

-- Table: public.nashhousing

-- DROP TABLE IF EXISTS public.nashhousing;

CREATE TABLE IF NOT EXISTS public.nashhousing
(
    "UniqueID " text COLLATE pg_catalog."default" NOT NULL,
    "ParcelID" text COLLATE pg_catalog."default",
    "LandUse" text COLLATE pg_catalog."default",
    "PropertyAddress" text COLLATE pg_catalog."default",
    "SaleDate" date,
    "SalePrice" numeric,
    "LegalReference" text COLLATE pg_catalog."default",
    "SoldAsVacant" text COLLATE pg_catalog."default",
    "OwnerName" text COLLATE pg_catalog."default",
    "OwnerAddress" text COLLATE pg_catalog."default",
    "Acreage" numeric,
    "TaxDistrict" text COLLATE pg_catalog."default",
    "LandValue" numeric,
    "BuildingValue" numeric,
    "TotalValue" numeric,
    "YearBuilt" numeric,
    "Bedrooms" numeric,
    "FullBath" numeric,
    "HalfBath" numeric,
    CONSTRAINT nashhousing_pkey PRIMARY KEY ("UniqueID ")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.nashhousing
    OWNER to postgres;
	
--Let us now import data from the csv file containing the data
--Once finished double check to make sure we imported correctly

Select * from public.nashhousing

--Side note: The column Saleprice gave issues importing - to fix that change the entire column format to numeric before importing to match sql data type.

-- Now let us move onto the next section

--SECTION 1 POPULATE PROPERTY ADDRESS DATA

--Run the above query again 

Select * from public.nashhousing

--If you look at Line 45 and Line 46 (ParcelID and PropertyAddress) you realize that
--the parcel id is unique in the sense that it matches with the propertyaddress
--therefore, if a propertyaddress is NULL we can easily replace the null with an address
--if the same unique ParcelID matches with an address that is already populated

--For example:
	-- Parcel Id			 PropertyAddress
	-- 	  2164			12 Street, New York, New York
	-- 	  2164						NULL

--We can replace the NULL with 12 Street, New York, New York Because 2164 is a unique ID that is "paired" withits own address
--We will now replicate the same bellow:
--1st step

Select *
From public.nashhousing
--Where "PropertyAddress" is null
Order By parcelid

--Let's view the NULL columns
Select *
From public.nashhousing
Where "propertyaddress" is null


--2nd step (A Self Join when to fill in the NULL values)

Select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress,
COALESCE(a.propertyaddress, b.propertyaddress)
From public.nashhousing a
JOIN public.nashhousing b 
	on a.parcelid = b.parcelid
	AND a.uniqueid <> b.uniqueid
Where a.propertyaddress is null

--3rd step
--Side note: Update and From function has to have different aliases in order for the query to run successfully!

Update public.nashhousing 
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
From public.nashhousing a
JOIN public.nashhousing b 
	on a.parcelid = b.parcelid
	AND a.uniqueid <> b.uniqueid
Where a.propertyaddress is null
--The query above will cause an issue. The property address column will be affected where it is replaced by an address but for
--all the columns - which will be disastrous. Instead follow the code below.


UPDATE nashhousing AS a
SET propertyaddress = b.propertyaddress
FROM nashhousing AS b
WHERE a.parcelid = b.parcelid AND a.uniqueid <> b.uniqueid
  AND a.propertyaddress IS NULL AND b.propertyaddress IS NOT NULL
  
--We only need 2 copies of housing so removed the extra join.
--We also just eed to add a condition in the WHERE clause so that the updated value is not null:

--Great! Now that we have fixed the Null issue we can move onto the next section.





--SECTION 2 BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
--1ST Step


Select *
From public.nashhousing


--2nd Step
--We want the name of the city from the propertyaddress column to poulate in a new column and name it city. 
--The SQL code is as follows below:

Select * 
From (
	select propertyaddress, split_part(propertyaddress, ',',2) AS CITY FROM public.nashhousing) AS NEW_TABLE
	
--3rd step
--This is the code to see how the position of the number affects the split_part function

select propertyaddress, split_part(propertyaddress, ',',1) AS streetname FROM public.nashhousing

select propertyaddress, split_part(propertyaddress, ',',2) AS CITY FROM public.nashhousing

--4th step (Now let us combine them together)
	
select
	
	split_part(propertyaddress, ',',1) AS streetname, 
	split_part(propertyaddress, ',',2) AS CITY 
FROM public.nashhousing

--5th Let's Alter and Add new table

Alter Table nashhousing
Add Propertysplitstreetname text

Update nashhousing
SET Propertysplitstreetname =  split_part(propertyaddress, ',',1) 



Alter Table nashhousing
Add Propertysplitcity text

Update nashhousing
SET Propertysplitcity =  split_part(propertyaddress, ',',2)

Select * From nashhousing

--Perfect! Let us do the same to the columnn owneraddress


Select * 
From (
	select owneraddress, split_part(owneraddress, ',',2) AS CITY FROM public.nashhousing) AS NEW_TABLE
	
--Next
	
select
	
	split_part(owneraddress, ',',1) AS streetname, 
	split_part(owneraddress, ',',2) AS city, 
	split_part(owneraddress, ',',3) AS state 

FROM public.nashhousing


--NEXT

Alter Table nashhousing
Add odsplitstreetname text

Update nashhousing
SET odsplitstreetame =  split_part(owneraddress, ',',1) 



Alter Table nashhousing
Add odsplitstreetcity text

Update nashhousing
SET odsplitstreetcity =  split_part(owneraddress, ',',2)


Alter Table nashhousing
Add odsplitstreetstate text

Update nashhousing
SET odsplitstreetstate =  split_part(owneraddress, ',',3)



--LUMP SUM query to save time
Alter Table nashhousing
Add odsplitstreetname text,
ADD odsplitstreetcity text,
add odsplitstreetstate text;


Update nashhousing
SET odsplitstreetname =  split_part(owneraddress, ',',1), 
	odsplitstreetcity =  split_part(owneraddress, ',',2), 
	odsplitstreetstate =  split_part(owneraddress, ',',3);

-- SECTION 3 CHANGING Y AND N TO YES AND NO IN "SOLD AS VACANT FIELD"

Select DISTINCT(soldasvacant), Count(soldasvacant)
From nashhousing
Group by soldasvacant
Order by 2

--Next

Select soldasvacant,
	CASE When soldasvacant = 'Y' then 'Yes'
		 When soldasvacant = 'N' then 'No'
	ELSE soldasvacant
	End
From nashhousing

--Next

Update nashhousing
SET soldasvacant = CASE When soldasvacant = 'Y' then 'Yes'
		 		   When soldasvacant = 'N' then 'No'
				   ELSE soldasvacant
		           End

--Now let us run the same query from before
Select DISTINCT(soldasvacant), Count(soldasvacant)
From nashhousing
Group by soldasvacant
Order by 2


--SECTION 4 REMOVING DUPLICATES

Select *,
	ROW_NUMBER() OVER (
	PARTITION BY parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
			     legalreference
				 ORDER BY 
					uniqueid
					) as rownum
From nashhousing
Order By parcelid
	)


--Next

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY parcelid,
				 propertyaddress,
				 saleprice,
				 saledate,
			     legalreference
				 ORDER BY 
					uniqueid
					) as rownum
From nashhousing
	)
Select *
From RowNumCTE 
Where rownum > 1
Order By propertyaddress
	
--We can now see the duplicate rows that we want to get rid of. 
--Let us delete them


DELETE from public.nashhousing 
USING RowNumCTE cte
WHERE uniqueid = cte.id
AND cte.row_num > 1 


--SECTION 5 DELETE UNUSED COLUMNS
 ALTER TABLE nashhousing
 DROP COLUMN owneraddress, taxdistrict, propertyaddress

