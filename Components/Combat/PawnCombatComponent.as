UENUM()
enum EToggleDamageType
{
	CurrentEquippedWeapon,
	LeftHand,
	RightHand
}

class UPawnCombatComponent : UActorComponent
{
	UPROPERTY()
	TMap<FGameplayTag, AWarriorWeaponBase> CharacterCarriedWeaponMap;
	UPROPERTY()
	FGameplayTag CurrentEquippedWeaponTag;

	TArray<AActor> OverlappedActors;

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

		Weapon.OnWeaponHitTarget.BindUFunction(this, n"OnWeaponHitTarget");
		Weapon.OnWeaponPulledFromTarget.BindUFunction(this, n"OnWeaponPulledFromTarget");

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

	UFUNCTION()
	void ToggleWeaponCollision(bool bShouldEnable, EToggleDamageType ToggleDamageType) {
		if (ToggleDamageType == EToggleDamageType::CurrentEquippedWeapon)
		{
			AWarriorWeaponBase CurrentWeapon = GetCharacterCurrentEquippedWeapon();

			check(CurrentWeapon != nullptr);

			if (bShouldEnable)
			{
				CurrentWeapon.WeaponCollisionBox.SetCollisionEnabled(ECollisionEnabled::QueryOnly);
			}
			else
			{
				CurrentWeapon.WeaponCollisionBox.SetCollisionEnabled(ECollisionEnabled::NoCollision);
				OverlappedActors.Empty();
			}
		}
	}

	UFUNCTION()
	void OnWeaponHitTarget(AActor OtherActor) {
		check(false, "Failed to override");
	}

	UFUNCTION()
	void OnWeaponPulledFromTarget(AActor OtherActor) {
		check(false, "Failed to override");
	}
};