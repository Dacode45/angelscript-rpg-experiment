

class UWarriorHeroGameplayAbility : UWarriorGameplayAbility
{
	TWeakObjectPtr<AWarriorHeroCharacter> CachedWarriorHeroCharacter;
	TWeakObjectPtr<AWarriorHeroController> CachedWarriorHeroController;

	UFUNCTION(BlueprintCallable, BlueprintPure, Category = "Warrior|Ability")
	AWarriorHeroCharacter GetHeroCharacterFromActorInfo() {
		if (!CachedWarriorHeroCharacter.IsValid())
		{
			CachedWarriorHeroCharacter = Cast<AWarriorHeroCharacter>(ActorInfo.AvatarActor);
		}

		return CachedWarriorHeroCharacter;
	}

	UFUNCTION(BlueprintCallable, BlueprintPure, Category = "Warrior|Ability")
	AWarriorHeroController GetHeroControllerFromActorInfo(){
		if (!CachedWarriorHeroController.IsValid())
		{
			CachedWarriorHeroController = Cast<AWarriorHeroController>(ActorInfo.PlayerController);
		}

		return CachedWarriorHeroController;
	}

	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	FGameplayEffectSpecHandle MakeHeroDamageEffectSpecHandle(TSubclassOf<UGameplayEffect> EffectClass, float InWeaponDamage, FGameplayTag CurrentAttackTypeTag, int InUsedComboCount) {
		check(EffectClass != nullptr);

		FGameplayEffectContextHandle ContextHandle = GetWarriorAbilitySystemComponentFromActorInfo().MakeEffectContext();
		ContextHandle.SetAbility(this);
		ContextHandle.AddSourceObject(GetAvatarActorFromActorInfo());
		ContextHandle.AddInstigator(GetAvatarActorFromActorInfo(), GetAvatarActorFromActorInfo());

		FGameplayEffectSpecHandle SpecHandle = GetWarriorAbilitySystemComponentFromActorInfo().MakeOutgoingSpec(
			EffectClass,
			GetAbilityLevel(),
			ContextHandle);

		SpecHandle.GetSpec().SetByCallerMagnitude(GameplayTags::Shared_SetByCaller_BaseDamage, InWeaponDamage);

		if (CurrentAttackTypeTag.IsValid())
		{
			SpecHandle.Spec.SetByCallerMagnitude(CurrentAttackTypeTag, InUsedComboCount);
		}

		return SpecHandle;
	}

	// UFUNCTION(BlueprintCallable, Category = "Warrior|Ability")
	// UHeroCombatComponent GetHeroCombatComponentFromActorInfo();
}