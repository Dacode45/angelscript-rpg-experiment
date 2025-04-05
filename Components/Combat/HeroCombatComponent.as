class UHeroCombatComponent : UPawnCombatComponent
{
	UFUNCTION(BlueprintPure, Category = "Warrior|Combat", Meta = (BlueprintThreadSafe))
	AWarriorHeroWeaponBase GetCarriedHeroWeaponByTag(FGameplayTag WeaponTag) {
		return Cast<AWarriorHeroWeaponBase>(GetCarriedWeaponByTag(WeaponTag));
	}

	UFUNCTION(BlueprintPure, Category = "Warrior|Combat")
	AWarriorHeroWeaponBase GetCurrentEquippedHeroWeapon() {
		return Cast<AWarriorHeroWeaponBase>(GetCharacterCurrentEquippedWeapon());
	}

	UFUNCTION(BlueprintPure, Category = "Warrior|Combat")
	float32 GetHeroCurrentEquippedWeaponDmageAtLevel(float InLevel)
	{
		FScalableFloat f = GetCurrentEquippedHeroWeapon().HeroWeaponData.WeaponBaseDamage;
		return f.GetValueAtLevel(InLevel);
	}

	void OnWeaponHitTarget(AActor HitActor) override{
		if (OverlappedActors.Contains(HitActor))
			return;

		OverlappedActors.AddUnique(HitActor);

		FGameplayEventData EventData;
		EventData.Target = HitActor;
		EventData.Instigator = GetOwner();

		AbilitySystem::SendGameplayEventToActor(GetOwner(), GameplayTags::Shared_Event_MeleeHit, EventData);
	}

	void OnWeaponPulledFromTarget(AActor HitActor) override {
	}
};
