class UDataAsset_StartupDataBase : UDataAsset
{
	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ActivateOnGivenAbilities;

	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ReactiveAbilities;

	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UGameplayEffect>> StartupGameplayEffects;

	void GiveToAbilitySystemComponent(UAngelscriptAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel = 1) {
		check(InWarriorAbilitySystem != nullptr);

		GrantAbility(ActivateOnGivenAbilities, InWarriorAbilitySystem, ApplyLevel);
		GrantAbility(ReactiveAbilities, InWarriorAbilitySystem, ApplyLevel);

		if (StartupGameplayEffects.IsEmpty())
			return;

		for (TSubclassOf<UGameplayEffect> EffectClass : StartupGameplayEffects)
		{
			check(EffectClass != nullptr);
			InWarriorAbilitySystem.ApplyGameplayEffectToTarget(EffectClass.DefaultObject.Class, InWarriorAbilitySystem, ApplyLevel, InWarriorAbilitySystem.MakeEffectContext());

			// InWarriorAbilitySystem.ApplyGameplayEffectToSelf(EffectClass, ApplyLevel, InWarriorAbilitySystem.MakeEffectContext());
		}
	}

	void GrantAbility(TArray<TSubclassOf<UWarriorGameplayAbility>> InAbilitiesToGive, UAngelscriptAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel) {
		if (InAbilitiesToGive.IsEmpty())
		{
			return;
		}

		for (auto Ability : InAbilitiesToGive)
		{
			auto d = Ability.GetDefaultObject();
			FGameplayAbilitySpec AbilitySpec = FGameplayAbilitySpec(Ability);

			AbilitySpec.SourceObject = InWarriorAbilitySystem.AbilityActorInfo.AvatarActor;
			AbilitySpec.Level = ApplyLevel;

			if (d.ActivationPolicy == EWarriorAbilityActivationPolicy::OnGiven)
			{
				auto handle = InWarriorAbilitySystem.GiveAbilityAndActivateOnce(AbilitySpec);
			}
			else
			{
				auto handle = InWarriorAbilitySystem.GiveAbility(AbilitySpec);
			}
		}
	}
}