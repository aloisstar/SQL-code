


select * 
from PortfolioProject..NationalHousing




select SaleDate, convert(Date,SaleDate) 
from PortfolioProject..NationalHousing

Update NationalHousing
set SaleDate= CONVERT(Date, SaleDate)


Alter Table NationalHousing
Add SaleDateConverted Date



select * 
from PortfolioProject..NationalHousing


select PropertyAddress
from PortfolioProject..NationalHousing
where PropertyAddress is null

--Populate Property Address Data
select * from PortfolioProject..NationalHousing
order by ParcelID


select a.ParcelID,a.PropertyAddress,b.ParcelID, b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NationalHousing a
Join PortfolioProject..NationalHousing b
On a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

UPDATE a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NationalHousing a
Join PortfolioProject..NationalHousing b
On a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out Address into individual column(Address, city,state)
Select PropertyAddress
from PortfolioProject..NationalHousing


Select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject..NationalHousing





Alter Table NationalHousing
Add PropertySplitAddress nvarchar(255)

Update NationalHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


Alter Table NationalHousing
Add PropertySplitCity nvarchar(255);

Update NationalHousing
set PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select * 
from PortfolioProject..NationalHousing






select OwnerAddress
from PortfolioProject..NationalHousing


select  PARSENAME(REPLACE(OwnerAddress,',','.'),3),
 PARSENAME(REPLACE(OwnerAddress,',','.'),2),
 PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..NationalHousing



Alter Table NationalHousing
Add OwnerSplitAddress nvarchar(255)

Update NationalHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

Alter Table NationalHousing
Add OwnerSplitCity nvarchar(255)

Update NationalHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

Alter Table NationalHousing
Add OwnerSplitState nvarchar(255)

Update NationalHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select * 
from PortfolioProject..NationalHousing


--Change Y and N to Yes and No in 'sold as vacant' field
select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject..NationalHousing
group by SoldAsVacant
order by 2





select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End
from PortfolioProject..NationalHousing

Update NationalHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	 When SoldAsVacant = 'N' Then 'No'
	 Else SoldAsVacant
	 End



--Remove Duplicates

with RowNumCTE As (
select *,
Row_Number() over (
 Partition By ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID) row_num
from PortfolioProject..NationalHousing
--order by ParcelID
--where row_num>1

)DELETE
From RowNumCTE
where row_num >1
--order by PropertyAddress


with RowNumCTE As (
select *,
Row_Number() over (
 Partition By ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY
			UniqueID) row_num
from PortfolioProject..NationalHousing
--order by ParcelID
--where row_num>1

)select *
From RowNumCTE
where row_num >1
order by PropertyAddress

--------------------------------------------------------------------------------------------

--Delete Unsused Columns



select *
from PortfolioProject..NationalHousing

ALTER Table PortfolioProject..NationalHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER Table PortfolioProject..NationalHousing
DROP COLUMN SaleDate

