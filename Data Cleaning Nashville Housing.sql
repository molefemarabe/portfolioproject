select * 
from NashvilleHousing


------------Standardize Date Format
--(removing the time from the date and storing it in a new column)


Alter Table NashvilleHousing
add SaleDate2 date;

update NashvilleHousing
set SaleDate2 = convert(Date, SaleDate)


------------Populate Property Address Data


select a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


------------Breaking out the Addresses into individual columns


Select PropertyAddress
from NashvilleHousing

select 
SUBSTRING(PropertyAddress, 1 ,charindex(',', PropertyAddress) -1 ) as Address,
SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1 ,charindex(',', PropertyAddress) -1 )

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255)

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, charindex(',', PropertyAddress) + 1, LEN(PropertyAddress))


------------Splitting OwnerAddress


select
Parsename(replace(OwnerAddress, ',', '.'), 3),
Parsename(replace(OwnerAddress, ',', '.'), 2),
Parsename(replace(OwnerAddress, ',', '.'), 1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

update NashvilleHousing
set OwnerSplitAddress = Parsename(replace(OwnerAddress, ',', '.'), 3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

update NashvilleHousing
set OwnerSplitCity = Parsename(replace(OwnerAddress, ',', '.'), 2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255)

update NashvilleHousing
set OwnerSplitState = Parsename(replace(OwnerAddress, ',', '.'), 1)


------------Change Y to Yes and N to NO in SoldASVacant


select SoldAsVacant,
case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	else SoldAsVacant
	end
from NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
					end


------------Removing Duplicates

with RowNumberCTE as(select *,
					ROW_NUMBER() over (
					partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
					order by UniqueID) Row_Num

					from NashvilleHousing
					
					)
Delete from RowNumberCTE
where Row_Num > 1


------------Delete Unused Columns
--tables where we split the values


alter table NashvilleHousing
drop column OwnerAddress, PropertyAddress, SaleDate