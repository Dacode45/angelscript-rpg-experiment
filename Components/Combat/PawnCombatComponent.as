class UPawnCombatComponent : UActorComponent
{
	UPROPERTY()
	TMap<FGameplayTag, AWarriorWeaponBase> CharacterCarriedWeaponMap;
	UPROPERTY()
	FGameplayTag CurrentEquippedWeaponTag;

	UFUNCTION(BlueprintPure)
	AWarriorWeaponBase GetCarriedWeaponByTag(FGameplayTag WeaponTag) {

		if (CharacterCarriedWeaponMap.Contains(WeaponTag))
		{
			return CharacterCarriedWeaponMap[WeaponTag];
		}

		return nullptr;
	}

	UFUNCTION()
	void RegisterWeapon(FGameplayTag WeaponTag, AWarriorWeaponBase Weapon, bool RegisterEquipped) {
		check(Weapon != nullptr);

		CharacterCarriedWeaponMap.Add(WeaponTag, Weapon);

		if (RegisterEquipped)
		{
			CurrentEquippedWeaponTag = WeaponTag;
		}
	}

	UFUNCTION(BlueprintPure)
	AWarriorWeaponBase GetCharacterCurrentEquippedWeapon() {
		if (CurrentEquippedWeaponTag.IsValid())
		{
			return GetCarriedWeaponByTag(CurrentEquippedWeaponTag);
		}
		return nullptr;
	}
};