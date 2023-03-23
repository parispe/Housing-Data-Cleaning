-- Cleaning Data in SQL Queries

Select *
From Projects.dbo.NashvilleHousing 

-- Standarize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From Projects.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE Projects.dbo.NashvilleHousing
Add SaleDateConverted Date;

Update Projects.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-- Populate Property Address data

Select *
From Projects.dbo.NashvilleHousing
-- Where PropertyAddress is null
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Projects.dbo.NashvilleHousing a
JOIN Projects.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Projects.dbo.NashvilleHousing
-- Where PropertyAddress is null
-- Order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From Projects.dbo.NashvilleHousing

ALTER TABLE Projects.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update Projects.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) 

ALTER TABLE Projects.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update Projects.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

Select *
From Projects.dbo.NashvilleHousing

Select OwnerAddress
From Projects.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
, PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From Projects.dbo.NashvilleHousing

ALTER TABLE Projects.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update Projects.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3) 

ALTER TABLE Projects.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update Projects.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE Projects.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update Projects.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Projects.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END
From Projects.dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		Else SoldAsVacant
		END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY 
			UniqueID
			) row_num

From Projects.dbo.NashvilleHousing
-- Order by ParcelID
)

Select *
From RowNumCTE
Where row_num > 1
-- Order by PropertyAddress


Select *
From Projects.dbo.NashvilleHousing

-- Delete Unused Columns

Select *
From Projects.dbo.NashvilleHousing

ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE Projects.dbo.NashvilleHousing
DROP COLUMN SaleDate




