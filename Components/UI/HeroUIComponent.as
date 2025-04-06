event void FOnHeroWeaponIconChanged(TSoftObjectPtr<UTexture2D> WeaponIcon);

class UHeroUIComponent : UPawnUIComponent
{
	UPROPERTY()
	FOnPercentChangedEvent OnCurrentRageChanged;

	UPROPERTY()
	FOnHeroWeaponIconChanged OnHeroWeaponIconChanged;
};