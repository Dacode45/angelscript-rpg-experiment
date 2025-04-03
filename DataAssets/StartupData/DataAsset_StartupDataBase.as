class UDataAsset_StartupDataBase : UDataAsset
{
	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ActivateOnGivenAbilities;

	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ReactiveAbilities;

	void GiveToAbilitySystemComponent(UWarriorAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel = 1) {
		check(InWarriorAbilitySystem != nullptr);

		GrantAbility(ActivateOnGivenAbilities, InWarriorAbilitySystem, ApplyLevel);
		GrantAbility(ReactiveAbilities, InWarriorAbilitySystem, ApplyLevel);
	}

	void GrantAbility(TArray<TSubclassOf<UWarriorGameplayAbility>> InAbilitiesToGive, UWarriorAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel) {
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