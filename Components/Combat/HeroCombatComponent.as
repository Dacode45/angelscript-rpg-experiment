class UHeroCombatComponent : UPawnCombatComponent
{
	UFUNCTION(BlueprintPure, Meta = (BlueprintThreadSafe))
	AWarriorHeroWeaponBase GetCarriedHeroWeaponByTag(FGameplayTag WeaponTag) {
		return Cast<AWarriorHeroWeaponBase>(GetCarriedWeaponByTag(WeaponTag));
	}
};
