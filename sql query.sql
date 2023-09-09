--Looking at all the data
select *
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

--Standardizing the Date Format

select SaleDate
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set SaleDate = convert(date, SaleDate)

--Working with Property Address data
select *
from [Housing Data]..[Nashville Housing Data for Data Cleaning]
where PropertyAddress is null

select *
from [Housing Data]..[Nashville Housing Data for Data Cleaning]
order by ParcelID

select a.ParcelID, a.PropertyAddress, 
b.ParcelID, b.PropertyAddress
from [Housing Data]..[Nashville Housing Data for Data Cleaning] a
join [Housing Data]..[Nashville Housing Data for Data Cleaning] b
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
--where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from [Housing Data]..[Nashville Housing Data for Data Cleaning] a
join [Housing Data]..[Nashville Housing Data for Data Cleaning] b
on a.ParcelID = b.ParcelID and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Splitting the Property Address Column into Address and City
select PropertyAddress
from [Housing Data]..[Nashville Housing Data for Data Cleaning]
order by ParcelID

select PARSENAME(replace(PropertyAddress, ',', '.'), 2) as Address, 
PARSENAME(replace(PropertyAddress, ',', '.'), 1) as City
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
add Address nvarchar(50)

alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
add City nvarchar(50)

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set Address = PARSENAME(replace(PropertyAddress, ',', '.'), 2)

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set City = PARSENAME(replace(PropertyAddress, ',', '.'), 1)

select Address, City
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

--Splitting the Owner Address Column into Address, City, and State
select OwnerAddress
from [Housing Data]..[Nashville Housing Data for Data Cleaning]
order by ParcelID

select PARSENAME(replace(OwnerAddress, ',', '.'), 3) as Address, 
PARSENAME(replace(OwnerAddress, ',', '.'), 2) as City,
PARSENAME(replace(OwnerAddress, ',', '.'), 1) as State
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
add OwnersAddress nvarchar(50)

alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
add OwnersCity nvarchar(50)

alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
add OwnersState nvarchar(50)

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set OwnersAddress = PARSENAME(replace(OwnerAddress, ',', '.'), 3)

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set OwnersCity = PARSENAME(replace(OwnerAddress, ',', '.'), 2)

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set OwnersState = PARSENAME(replace(OwnerAddress, ',', '.'), 1)

select OwnerAddress, OwnersAddress, OwnersCity, OwnersState
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

--Changing sold as vacant data to have 2 types rather than 4
select distinct(SoldAsVacant)
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

update [Housing Data]..[Nashville Housing Data for Data Cleaning]
set SoldAsVacant = 
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

--Removing duplicate rows
select *
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

with RowNumCTE as (
select *,
ROW_NUMBER() over 
(partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference order by UniqueID) as row_num
from [Housing Data]..[Nashville Housing Data for Data Cleaning]
)
--delete
select *
from RowNumCTE
where row_num > 1
order by PropertyAddress

select *
from [Housing Data]..[Nashville Housing Data for Data Cleaning]

--Deleting non needed columns
alter table [Housing Data]..[Nashville Housing Data for Data Cleaning]
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate